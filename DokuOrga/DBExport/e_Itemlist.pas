unit e_Itemlist;

interface

uses
  SysUtils, Classes, o_ItemListList, o_DBGuid, Forms, Controls;

type
  TeItemList = class(TDBItemListList)
  private
    FExportPath: string;
    FGuidHelper: TDBGuid;
    FImportZipFile: string;
    FDatum: TDateTime;
    FTabname: string;
    FSpaltentrenner: string;
    FZeilentrenner: string;
    procedure ExportItemlist;
    procedure ImportItemlist(aFileName: string);
  protected
  public
    constructor Create(AOwner: TComponent; aSpaltentrenner, aZeilentrenner, aTabname: string; aDatum: TDateTime); reintroduce; overload;
    destructor Destroy; override;
    procedure Init; override;
    procedure doExport;
    procedure doImport;
    property ExportPath: string read FExportPath write FExportPath;
    property ImportZipFile: string read FImportZipFile write FImportZipFile;
  end;

implementation

{ TeItemList }

uses
  o_itemlist, o_DBField, tbStringList, c_Types, c_DBTypes, u_system, o_sysObj;

constructor TeItemList.Create(AOwner: TComponent; aSpaltentrenner,
  aZeilentrenner, aTabname: string; aDatum: TDateTime);
begin
  inherited Create(AOwner);
  FDatum   := aDatum;
  FTabname := aTabname;
  FSpaltentrenner := aSpaltentrenner;
  FZeilentrenner  := aZeilentrenner;
  FExportPath := '';
  FGuidHelper := TDBGuid.Create(Self);
  Init;
end;

destructor TeItemList.Destroy;
begin
  FreeAndNil(FGuidHelper);
  inherited;
end;

procedure TeItemList.doExport;
var
  Cur: TCursor;
  ZipFileName: string;
  FileList: TStringList;
begin
  if FExportPath = '' then
    exit;
  Cur := Screen.Cursor;
  try
    ExportItemList;
    ZipFileName := FExportPath + FTabname + '.zip';
    FileList := TStringList.Create;
    try
      GetAllFiles(FExportPath + FTabname + '\', FileList, true);
      SysObj.Zip(ZipFileName, FileList);
      ForceDelDirectory(FExportPath + FTabname + '\');
    finally
      FreeAndNil(FileList);
    end;
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure TeItemList.doImport;
var
  Pfad: string;
  Filename: string;
  Cur: TCursor;
begin
  if FileExist(FImportZipFile) < 0 then
    exit;
  Pfad := IncludeTrailingPathDelimiter(ExtractFilePath(FImportZipFile)) + FTabname + '\';
  //if not ForceDelDirectory(Pfad) then
  //  exit;
  ForceDelDirectory(Pfad);
  ForceDirectories(Pfad);

  SysObj.Unzip(FImportZipFile, Pfad);
  FileName := Pfad + FTabname + '.exp';
  if FileExist(FileName) < 0 then
    exit;

  Cur := Screen.Cursor;
  try
    ImportItemList(FileName);
    ForceDelDirectory(Pfad);
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure TeItemList.ExportItemlist;
var
  Filename: string;
  myFile: TextFile;
  i1, i2: Integer;
  s: string;
  ItemList: TDBItemList;
  DBFeld: TDBFeld;
  Feldname: string;
  Cur: TCursor;
  Pfad: string;
begin
  Pfad := FExportPath + FTabname + '\';
  //if not ForceDelDirectory(Pfad) then
  //  exit;
  ForceDelDirectory(Pfad);
  ForceDirectories(Pfad);
  FileName := Pfad + FTabname + '.exp';
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    AssignFile(myFile, Filename);
    ReWrite(myFile);
    ReadAllForExport(FDatum, 'asc');
    for i1 := 0 to FList.Count - 1 do
    begin
      s := '';
      ItemList := Item[i1];
      s := s + ItemList.GuidExportString;
      for i2 := 0 to ItemList.DBList.Count - 1 do
      begin
        DBFeld := ItemList.DBList.Item[i2];
        FeldName := DBFeld.Name;
        if DBFeld.BitmapField then
        begin
          DBFeld.Ico.SaveToFile(Pfad + ItemList.Guid);
          s := s + FSpaltentrenner;
          continue;
        end;
        s := s + ItemList.Feld(Feldname).AsString + FSpaltentrenner;
      end;
      s := s + FZeilentrenner;
      Write(myFile, s);
    end;
    CloseFile(myFile);
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure TeItemList.ImportItemlist(aFileName: string);
var
  myFile: TFileStream;
  Filename: string;
//  Letter: Char;
  s: string;
  sl: TTBStringList;
  Itemlist: TDBItemlist;
  i1: Integer;
  DBGuid: TDBGuid;
  Pfad: string;
  Buffer: byte;
begin
  if aFileName = '' then
    exit;
  Filename := aFileName;
  if not FileExists(Filename) then
    exit;
  Pfad := IncludeTrailingPathDelimiter(ExtractFilePath(FileName));
  Itemlist := TDBItemlist.Create(nil);
  sl := TTBStringList.Create;
  try
    //AssignFile(myFile, Filename);
    //Reset(myFile);
    myFile := TFileStream.Create(FileName, fmOpenRead);
    sl.Deli := FSpaltentrenner;
    //while not Eof(myFile) do
    while myFile.Position < myFile.Size do
    begin
      myFile.Read(Buffer, 1);
      s := s + chr(Buffer);
      if Pos(FZeilentrenner, s) > 0 then
      begin
        s := copy(s, 1, Length(s)-3);
        sl.Cut(s);
        s := '';
        FGuidHelper.LoadImportValues(sl);
        Itemlist.ReadByGuid(FGuidHelper.Feld(GU_GUID).AsString);
        if (Itemlist.Id > 0) and (Itemlist.UpdateAsDateTime >= FGuidHelper.Feld('GU_Update').AsDateTime) then
          continue;

        for i1 := 1 to sl.Count - 1 do
        begin
          Itemlist.DBList.Item[i1].AsString := sl.Strings[i1];
          if Itemlist.DBList.Item[i1].BitmapField then
          begin
            Itemlist.DBList.Item[i1].Ico.LoadFromFile(Pfad + FGuidHelper.Feld(GU_GUID).AsString);
            continue;
          end;
        end;
        Itemlist.Save;
        DBGuid := Itemlist.DBGuid;
        DBGuid.ImportingData := true;
        DBGuid.Feld(GU_GUID).AsString := FGuidHelper.Feld(GU_GUID).AsString;
        DBGuid.Feld(GU_INSERT).AsString := FGuidHelper.Feld(GU_INSERT).AsString;
        DBGuid.Feld(GU_UPDATE).AsString := FGuidHelper.Feld(GU_UPDATE).AsString;
        DBGuid.Feld(GU_USERID_INSERT).AsString := FGuidHelper.Feld(GU_USERID_INSERT).AsString;
        DBGuid.Feld(GU_USERID_UPDATE).AsString := FGuidHelper.Feld(GU_USERID_UPDATE).AsString;
        DBGuid.Feld(GU_DELETE).AsString := FGuidHelper.Feld(GU_DELETE).AsString;
        DBGuid.Save;
      end;
    end;
  finally
    FreeAndNil(sl);
    FreeAndNil(Itemlist);
    try
      FreeAndNil(myFile);
    except
    end;
  end;
end;

procedure TeItemList.Init;
begin
  inherited;

end;

end.
