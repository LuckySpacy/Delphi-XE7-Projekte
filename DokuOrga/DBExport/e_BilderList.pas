unit e_BilderList;

interface

uses
  SysUtils, Classes, o_BilderList, o_DBGuid, Forms, Controls;

type
  TeBilderList = class(TBilderList)
  private
    FExportPath: string;
    FGuidHelper: TDBGuid;
    FImportZipFile: string;
    FTabname: string;
    FSpaltentrenner: string;
    FZeilentrenner: string;
    FDatum: TDateTime;
    procedure ExportBilder;
    procedure ImportBilder(aFileName: string);
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

{ TeBilderList }

uses
  o_Bilder, o_DBField, tbStringList, c_Types, c_DBTypes, u_system, o_sysObj;

constructor TeBilderList.Create(AOwner: TComponent; aSpaltentrenner, aZeilentrenner, aTabname: string; aDatum: TDateTime);
begin
  inherited Create(AOwner);
  FTabname := aTabname;
  FSpaltentrenner := aSpaltentrenner;
  FZeilentrenner  := aZeilentrenner;
  FDatum := aDatum;
  FExportPath := '';
  FGuidHelper := TDBGuid.Create(Self);
  Init;
end;

procedure TeBilderList.Init;
begin
  inherited;

end;


destructor TeBilderList.Destroy;
begin
  FreeAndNil(FGuidHelper);
  inherited;
end;

procedure TeBilderList.doExport;
var
  Cur: TCursor;
 // Feldname: string;
 // Pfad: string;
  ZipFileName: string;
  FileList: TStringList;
begin
  if FExportPath = '' then
    exit;
  Cur := Screen.Cursor;
  try
    ExportBilder;
    ZipFileName := FExportPath + 'Bilder.zip';
    FileList := TStringList.Create;
    try
      GetAllFiles(FExportPath + 'Bilder\', FileList, true);
      SysObj.Zip(ZipFileName, FileList);
      ForceDelDirectory(FExportPath + 'Bilder\');
    finally
      FreeAndNil(FileList);
    end;
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure TeBilderList.ExportBilder;
var
  Filename: string;
  myFile: TextFile;
  i1, i2: Integer;
  s: string;
  Bilder: TBilder;
  DBFeld: TDBFeld;
  Feldname: string;
  Cur: TCursor;
  Pfad: string;
begin
  Pfad := FExportPath + 'Bilder\';
  //if not ForceDelDirectory(Pfad) then
  //  exit;
  ForceDelDirectory(Pfad);
  ForceDirectories(Pfad);
  FileName := Pfad + 'Bilder.exp';
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    AssignFile(myFile, Filename);
    ReWrite(myFile);
    ReadAllForExport(FDatum, 'asc');
    for i1 := 0 to FList.Count - 1 do
    begin
      s := '';
      Bilder := Item[i1];
      s := s + Bilder.GuidExportString;
      for i2 := 0 to Bilder.DBList.Count - 1 do
      begin
        DBFeld := Bilder.DBList.Item[i2];
        FeldName := DBFeld.Name;
        if DBFeld.BitmapField then
        begin
          DBFeld.Ico.SaveToFile(Pfad + Bilder.Guid);
          s := s + FSpaltentrenner;
          continue;
        end;
        s := s + Bilder.Feld(Feldname).AsString + FSpaltentrenner;
      end;
      s := s + FZeilentrenner;
      Write(myFile, s);
    end;
    CloseFile(myFile);
  finally
    Screen.Cursor := Cur;
  end;
end;



procedure TeBilderList.doImport;
var
  Pfad: string;
  Filename: string;
  Cur: TCursor;
begin
  if FileExist(FImportZipFile) < 0 then
    exit;
  Pfad := IncludeTrailingPathDelimiter(ExtractFilePath(FImportZipFile)) + 'Bilder\';
  //if not ForceDelDirectory(Pfad) then
  //  exit;
  ForceDelDirectory(Pfad);
  ForceDirectories(Pfad);

  SysObj.Unzip(FImportZipFile, Pfad);
  FileName := Pfad + 'Bilder.exp';
  if FileExist(FileName) < 0 then
    exit;

  Cur := Screen.Cursor;
  try
    ImportBilder(FileName);
    ForceDelDirectory(Pfad);
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure TeBilderList.ImportBilder(aFileName: string);
var
  myFile: TFileStream;
  Filename: string;
//  Letter: Char;
  s: string;
  sl: TTBStringList;
  Bilder: TBilder;
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
  Bilder := TBilder.Create(nil);
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
        Bilder.ReadByGuid(FGuidHelper.Feld(GU_GUID).AsString);
        if (Bilder.Id > 0) and (Bilder.UpdateAsDateTime >= FGuidHelper.Feld('GU_Update').AsDateTime) then
          continue;

        for i1 := 1 to sl.Count - 1 do
        begin
          Bilder.DBList.Item[i1].AsString := sl.Strings[i1];
          if Bilder.DBList.Item[i1].BitmapField then
          begin
            Bilder.DBList.Item[i1].Ico.LoadFromFile(Pfad + FGuidHelper.Feld(GU_GUID).AsString);
            continue;
          end;
        end;
        Bilder.Save;
        DBGuid := Bilder.DBGuid;
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
    FreeAndNil(Bilder);
    try
      FreeAndNil(myFile);
    except
    end;
  end;
end;





end.
