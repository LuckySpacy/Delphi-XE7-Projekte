unit e_SeitedokumentList;

interface

uses
  SysUtils, Classes, o_SeitedokumentList, o_DBGuid, Forms, Controls;

type
  TeSeitedokumentList = class(TSeitedokumentList)
  private
    FExportPath: string;
    FGuidHelper: TDBGuid;
    FImportZipFile: string;
    FDatum: TDateTime;
    FTabname: string;
    FSpaltentrenner: string;
    FZeilentrenner: string;
    procedure ExportSeitedokument;
    procedure ImportSeitedokument(aFileName: string);
  protected
  public
    constructor Create(AOwner: TComponent; aSpaltentrenner, aZeilentrenner, aTabname: string; aDatum: TDateTime); reintroduce; overload;
    destructor Destroy; override;
    procedure Init; override;
    procedure doExport;
    procedure doImport;
    property ExportPath: string read FExportPath write FExportPath;
    property ImportZipFile: string read FImportZipFile write FImportZipFile;
    function getNotifyIndex: Integer; override;
  end;

implementation

{ TeSeitedokumentList }

uses
  o_Seitedokument, o_DBField, tbStringList, c_Types, c_DBTypes, u_system, o_sysObj,
  o_Seite, o_dokument;

constructor TeSeitedokumentList.Create(AOwner: TComponent; aSpaltentrenner, aZeilentrenner, aTabname: string; aDatum: TDateTime);
begin
  inherited Create(AOwner);
  FDatum := aDatum;
  FTabname := aTabname;
  FSpaltentrenner := aSpaltentrenner;
  FZeilentrenner  := aZeilentrenner;
  FExportPath := '';
  FGuidHelper := TDBGuid.Create(Self);
  Init;
end;

destructor TeSeitedokumentList.Destroy;
begin
  FreeAndNil(FGuidHelper);
  inherited;
end;

procedure TeSeitedokumentList.doExport;
var
  Cur: TCursor;
  ZipFileName: string;
  FileList: TStringList;
begin
  if FExportPath = '' then
    exit;
  Cur := Screen.Cursor;
  try
    ExportSeitedokument;
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

procedure TeSeitedokumentList.doImport;
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
    ImportSeitedokument(FileName);
    ForceDelDirectory(Pfad);
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure TeSeitedokumentList.ExportSeitedokument;
var
  Filename: string;
  myFile: TextFile;
  i1: Integer;
  s: string;
  SeiteDokument: TSeitedokument;
  Seite: TSeite;
  Dokument: TDokument;
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
      SeiteDokument := Item[i1];
      s := s + SeiteDokument.GuidExportString;
      Seite := SeiteDokument.Seite;
      if Seite = nil then
        continue;
      s := s + IntToStr(SeiteDokument.Id) + FSpaltentrenner;
      s := s + Seite.Guid + FSpaltentrenner;
      Dokument := SeiteDokument.Dokument;
      if Dokument = nil then
        continue;
      s := s + Dokument.Guid + FSpaltentrenner;
      s := s + SeiteDokument.Feld(SD_DELETE).AsString + FSpaltentrenner;
      s := s + FZeilentrenner;
      Write(myFile, s);
    end;
    CloseFile(myFile);
  finally
    Screen.Cursor := Cur;
  end;
end;

function TeSeitedokumentList.getNotifyIndex: Integer;
begin
  Result := 0;
end;

procedure TeSeitedokumentList.ImportSeitedokument(aFileName: string);
var
  myFile: TFileStream;
  Filename: string;
//  Letter: Char;
  s: string;
  sl: TTBStringList;
  Seitedokument: TSeitedokument;
  Seite: TSeite;
  Dokument: TDokument;
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
  Seite := TSeite.Create(nil);
  Dokument := TDokument.Create(nil);
  Seitedokument := TSeitedokument.Create(nil);
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
        Seitedokument.ReadByGuid(FGuidHelper.Feld(GU_GUID).AsString);
        if (Seitedokument.Id > 0) and (Seitedokument.UpdateAsDateTime >= FGuidHelper.Feld('GU_Update').AsDateTime) then
          continue;

        Seite.ReadByGuid(sl.Strings[1]);
        if not Seite.Found then
          continue;
        Dokument.ReadByGuid(sl.Strings[2]);
        if not Dokument.Found then
          continue;

        SeiteDokument.Feld(SD_SE_ID).AsInteger := Seite.Id;
        SeiteDokument.Feld(SD_DO_ID).AsInteger := Dokument.Id;
        SeiteDokument.Feld(SD_DELETE).AsString := sl.Strings[3];

        Seitedokument.Save;
        DBGuid := Seitedokument.DBGuid;
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
    FreeAndNil(Dokument);
    FreeAndNil(Seite);
    FreeAndNil(Seitedokument);
    try
      FreeAndNil(myFile);
    except
    end;
  end;
end;

procedure TeSeitedokumentList.Init;
begin
  inherited;

end;

end.
