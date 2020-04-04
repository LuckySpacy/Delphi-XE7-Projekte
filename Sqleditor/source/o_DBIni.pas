unit o_DBIni;

interface

uses
  SysUtils, Classes, o_DBIniObj;

type
  TDBIni = class
    private
      FDBIniObjList: TDBIniObjList;
      FPath: string;
      FDBListName: string;
      FIniFile: string;
      FDBList: TStringList;
      FCurDBIni: TDBIniObj;
      FCurSectionName: string;
      procedure setCurSectionname(const Value: string);
    public
      constructor Create;
      destructor Destroy; override;
      procedure Load;
      function getSection(aSectionname: string): TDBIniObj;
      property CurSectionName: string read FCurSectionName write setCurSectionname;
      procedure LoadDatabasenamelist(aStrings: TStrings);
      procedure Save(aDBIniObj: TDBIniObj);
      procedure Delete(aDBIniObj: TDBIniObj);
      procedure AddNewDatabasename(aName: string);
      function AddDBIniObj: TDBIniObj;
      function CurDBIni: TDBIniObj;
  end;

implementation

{ TDBIni }

uses
  nf_System, nf_RegIni, u_allgfunc, c_Types;

constructor TDBIni.Create;
begin
  FCurSectionName := '';
  FDBIniObjList := TDBIniObjList.Create;
  FPath := IncludeTrailingPathDelimiter(nf_GetShellFolder(26)) + 'SqlEditor\';
  FDBListName := FPath + 'DatabaseList.txt';
  FIniFile := FPath + 'SqlEditor.ini';
  FDBList := TStringList.Create;
  FDBList.Duplicates := dupIgnore;
  FDBList.Sorted := true;
  FCurDBIni := nil;
end;


destructor TDBIni.Destroy;
begin
  FreeAndNil(FDBList);
  FreeAndNil(FDBIniObjList);
  inherited;
end;

procedure TDBIni.Load;
var
  i1: Integer;
  IniObj: TDBIniObj;
  NewIniObj: TDBIniObj;
  Datenbank: string;
begin
  FDBList.Clear;
  FDBList.LoadFromFile(FDBListName);
  FDBIniObjList.Clear;
  IniObj := TDBIniObj.Create;
  try
    for i1 := 0 to FDBList.Count - 1 do
    begin
      IniObj.Init;
      IniObj.Section := FDBList.Strings[i1];
      IniObj.LaufwerkIndex := nf_ReadIniToInt(FIniFile, IniObj.Section, 'Laufwerk', '-1');
      IniObj.Server := nf_ReadIni(FIniFile, IniObj.Section, 'Server', '');
      IniObj.Verzeichnis := nf_ReadIni(FIniFile, FDBList.Strings[i1], 'Verzeichnis', '');
      IniObj.Datenbankname := nf_ReadIni(FIniFile, FDBList.Strings[i1], 'Datenbankname', '');
      Datenbank := nf_ReadIni(FIniFile, FDBList.Strings[i1], 'Datenbank', '');
      if (Datenbank = '') or (Datenbank = '0') then
        if (IniObj.Section = '') or (IniObj.Server = '') or (IniObj.Laufwerk = '') or (IniObj.Verzeichnis = '') or (IniObj.Datenbankname = '') then
          continue;
      IniObj.Benutzer := nf_ReadIni(FIniFile, FDBList.Strings[i1], 'Benutzer', '');
      IniObj.Passwort := tbEntschluesseln(nf_ReadIni(FIniFile, FDBList.Strings[i1], 'Passwort', ''), cPW);
      IniObj.Port := StrToInt(nf_ReadIni(FIniFile, FDBList.Strings[i1], 'Port', '-1'));

      if (Datenbank = '') or (Datenbank = '0') then
        IniObj.Datenbank := cFirebird;
      if (Datenbank = '1') then
        IniObj.Datenbank := cMsSql;
      if (Datenbank = '2') then
      begin
        IniObj.Datenbank := cMySql;
        if IniObj.Port < 0 then
          IniObj.Port := 3306;
      end;

      NewIniObj := FDBIniObjList.Add;
      NewIniObj.CopyFrom(IniObj);
    end;
  finally
    FreeAndNil(IniObj);
  end;
end;

procedure TDBIni.LoadDatabasenamelist(aStrings: TStrings);
begin
  aStrings.Clear;
  aStrings.AddStrings(FDBList);
end;

procedure TDBIni.Save(aDBIniObj: TDBIniObj);
begin
  if aDBIniObj = nil then
    exit;
  nf_WriteIni(FIniFile, aDBIniObj.Section, 'Server', aDBIniObj.Server);
  nf_WriteIni(FIniFile, aDBIniObj.Section, 'Laufwerk', IntToStr(aDBIniObj.LaufwerkIndex));
  nf_WriteIni(FIniFile, aDBIniObj.Section, 'Verzeichnis', aDBIniObj.Verzeichnis);
  nf_WriteIni(FIniFile, aDBIniObj.Section, 'Datenbankname', aDBIniObj.Datenbankname);
  nf_WriteIni(FIniFile, aDBIniObj.Section, 'Datenbank', IntToStr(Ord(aDBIniObj.Datenbank)));
  nf_WriteIni(FIniFile, aDBIniObj.Section, 'Benutzer', aDBIniObj.Benutzer);
  nf_WriteIni(FIniFile, aDBIniObj.Section, 'Passwort', tbVerschluesseln(aDBIniObj.Passwort, cPW));
  nf_WriteIni(FIniFile, aDBIniObj.Section, 'Port', IntToStr(aDBIniObj.Port));
end;

procedure TDBIni.Delete(aDBIniObj: TDBIniObj);
var
  i1: Integer;
begin
  nf_DeleteIniSection(FIniFile, aDBIniObj.Section);
  for i1 := 0 to FDBList.Count - 1 do
  begin
    if SameText(FDBList.Strings[i1], aDBIniObj.Section) then
    begin
      FDBList.Delete(i1);
      break;
    end;
  end;
  FDBList.SaveToFile(FDBListName);
  Load;
end;

procedure TDBIni.setCurSectionname(const Value: string);
begin
  if SameText(Value, FCurSectionName) then
    exit;
  FCurSectionName := Value;
  nf_WriteIni(FIniFile, 'LastConnection', 'Tablename', FCurSectionName);
  FCurDBIni := getSection(FCurSectionName);
end;

function TDBIni.getSection(aSectionname: string): TDBIniObj;
begin
  Result := FDBIniObjList.getSection(aSectionname);
end;

function TDBIni.AddDBIniObj: TDBIniObj;
begin
  Result := FDBIniObjList.Add;
end;

procedure TDBIni.AddNewDatabasename(aName: string);
begin
  FDBList.Add(aName);
  FDBList.SaveToFile(FDBListName);
  Load;
end;

function TDBIni.CurDBIni: TDBIniObj;
begin
  Result := FCurDBIni;
end;


end.
