unit e_SprachlistList;

interface

uses
  SysUtils, Classes, o_SprachListList, o_DBGuid, Forms, Controls;

type
  TeSprachlistList = class(TSprachlistList)
  private
    FExportPath: string;
    FGuidHelper: TDBGuid;
    FImportZipFile: string;
    FDatum: TDateTime;
    FTabname: string;
    FSpaltentrenner: string;
    FZeilentrenner: string;
    procedure ExportSprachlist;
    procedure ImportSprachlist(aFileName: string);
  protected
    function getNotifyIndex: Integer; override;
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
  o_sprachlist, o_DBField, tbStringList, c_Types, c_DBTypes, u_system, o_sysObj;

constructor TeSprachlistList.Create(AOwner: TComponent; aSpaltentrenner,
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

destructor TeSprachlistList.Destroy;
begin
  FreeAndNil(FGuidHelper);
  inherited;
end;

procedure TeSprachlistList.doExport;
var
  Cur: TCursor;
  ZipFileName: string;
  FileList: TStringList;
begin
  if FExportPath = '' then
    exit;
  Cur := Screen.Cursor;
  try
    ExportSprachList;
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

procedure TeSprachlistList.doImport;
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
    ImportSprachList(FileName);
    ForceDelDirectory(Pfad);
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure TeSprachlistList.ExportSprachlist;
var
  Filename: string;
  myFile: TextFile;
  i1, i2: Integer;
  s: string;
  Sprachlist: TSprachList;
  DBFeld: TDBFeld;
  Feldname: string;
  Cur: TCursor;
  Pfad: string;
begin
  Pfad := FExportPath + FTabname + '\';
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
      Sprachlist := Item[i1];
      s := s + Sprachlist.GuidExportString;
      for i2 := 0 to Sprachlist.DBList.Count - 1 do
      begin
        DBFeld := Sprachlist.DBList.Item[i2];
        FeldName := DBFeld.Name;
        s := s + Sprachlist.Feld(Feldname).AsString + FSpaltentrenner;
      end;
      s := s + FZeilentrenner;
      Write(myFile, s);
    end;
    CloseFile(myFile);
  finally
    Screen.Cursor := Cur;
  end;
end;

function TeSprachlistList.getNotifyIndex: Integer;
begin
  Result := 0;
end;

procedure TeSprachlistList.ImportSprachlist(aFileName: string);
var
  myFile: TFileStream;
  Filename: string;
//  Letter: Char;
  s: string;
  sl: TTBStringList;
  Sprachlist: TSprachlist;
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
  Sprachlist := TSprachlist.Create(nil);
  sl := TTBStringList.Create;
  try
    myFile := TFileStream.Create(FileName, fmOpenRead);
    sl.Deli := FSpaltentrenner;
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
        Sprachlist.ReadByGuid(FGuidHelper.Feld(GU_GUID).AsString);
        if (Sprachlist.Id > 0) and (Sprachlist.UpdateAsDateTime >= FGuidHelper.Feld('GU_Update').AsDateTime) then
          continue;

        for i1 := 1 to sl.Count - 1 do
        begin
          Sprachlist.DBList.Item[i1].AsString := sl.Strings[i1];
        end;
        Sprachlist.Save;
        DBGuid := Sprachlist.DBGuid;
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
    FreeAndNil(Sprachlist);
    try
      FreeAndNil(myFile);
    except
    end;
  end;
end;

procedure TeSprachlistList.Init;
begin
  inherited;

end;
end.
