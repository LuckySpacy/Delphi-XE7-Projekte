unit e_SysSpracheList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_SysSprache,
  o_SysSprache_BaseStrukList, o_SysSpracheList, Dialogs, o_DBGuid;

type
  TeSysSpracheList = class(TSysSpracheList)
  private
    FExportPath: string;
    FGuidHelper: TDBGuid;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure doExport;
    procedure doImport;
    property ExportPath: string read FExportPath write FExportPath;
  end;



implementation

{ TeSysSpracheList }

uses
  o_DBField, tbStringList, c_DBTypes, Windows;

constructor TeSysSpracheList.Create(AOwner: TComponent);
begin
  inherited;
  FExportPath := '';
  FGuidHelper := TDBGuid.Create(Self);
  Init;
end;

destructor TeSysSpracheList.Destroy;
begin
  FreeAndNil(FGuidHelper);
  inherited;
end;

{
procedure TeSysSpracheList.doExport;
var
  i1, i2: Integer;
  sl : TStringList;
  FileName: string;
  SysSprache: TSysSprache;
  DBFeld: TDBFeld;
  Feldname: string;
  s: string;
begin
  doImport;
  exit;
  if FExportPath = '' then
    exit;
  Filename := IncludeTrailingPathDelimiter(FExportPath) + 'SysSprache.exp';
  sl := TStringList.Create;
  try
    ReadAll;
    for i1 := 0 to FList.Count - 1 do
    begin
      s := '';
      SysSprache := Item[i1];
      for i2 := 0 to SysSprache.DBList.Count - 1 do
      begin
        DBFeld := SysSprache.DBList.Item[i2];
        FeldName := DBFeld.Name;
        s := s + SysSprache.Feld(Feldname).AsString + '# #';
      end;
      s := copy(s, 1, length(s) -3);
      s := s + '~ ~';
      sl.Add(s);
    end;
    DeleteFile(Filename);
    sl.SaveToFile(Filename);
  finally
    FreeAndNil(sl);
  end;
end;
}


procedure TeSysSpracheList.doExport;
var
  i1, i2: Integer;
  Filename: string;
  myFile: TextFile;
  SysSprache: TSysSprache;
  s: string;
  DBFeld: TDBFeld;
  Feldname: string;
begin
  if FExportPath = '' then
    exit;
  Filename := IncludeTrailingPathDelimiter(FExportPath) + 'SysSprache.exp';
  SysUtils.DeleteFile(Filename);
  AssignFile(myFile, Filename);
  ReWrite(myFile);
  ReadAll('asc');
  for i1 := 0 to FList.Count - 1 do
  begin
    s := '';
    SysSprache := Item[i1];
    s := s + SysSprache.GuidExportString;
    for i2 := 0 to SysSprache.DBList.Count - 1 do
    begin
      DBFeld := SysSprache.DBList.Item[i2];
      FeldName := DBFeld.Name;
      s := s + SysSprache.Feld(Feldname).AsString + '# #';
    end;
    s := s + '~ ~';
    Write(myFile, s);
  end;
  CloseFile(myFile);
end;

procedure TeSysSpracheList.doImport;
var
  myFile: TextFile;
  Filename: string;
  Letter: Char;
  s: string;
  sl: TTBStringList;
  SysSprache: TSysSprache;
  i1: Integer;
  DBGuid: TDBGuid;
begin
  if FExportPath = '' then
    exit;
  Filename := IncludeTrailingPathDelimiter(FExportPath) + 'SysSprache.exp';
  if not FileExists(Filename) then
    exit;
  SysSprache := TSysSprache.Create(nil);
  sl := TTBStringList.Create;
  try
    AssignFile(myFile, Filename);
    Reset(myFile);
    sl.Deli := '# #';
    while not Eof(myFile) do
    begin
      system.Read(myFile, Letter);
      s := s + Letter;
      if Pos('~ ~', s) > 0 then
      begin
        s := copy(s, 1, Length(s)-3);
        sl.Cut(s);
        s := '';
        FGuidHelper.LoadImportValues(sl);
        SysSprache.ReadByGuid(FGuidHelper.Feld(GU_GUID).AsString);
        if (SysSprache.Id > 0) and (SysSprache.UpdateAsDateTime >= FGuidHelper.Feld('GU_Update').AsDateTime) then
          continue;

        for i1 := 1 to sl.Count - 1 do
          SysSprache.DBList.Item[i1].AsString := sl.Strings[i1];
        SysSprache.Save;
        DBGuid := SysSprache.DBGuid;
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
    FreeAndNil(SysSprache);
    try
      CloseFile(myFile);
    except
    end;
  end;
end;

procedure TeSysSpracheList.Init;
begin
  inherited;

end;

end.
