unit Objekt.System;

interface

uses
  sysutils, classes, Data.DB, IBX.IBDatabase, IBX.IBQuery;

type
  TSysObj = class(TComponent)
  private
    fRuntimePfad: string;
    fIniPfad: string;
    fIniFilename: string;
    fIniConnect: string;
    fDatabase: TIBDatabase;
  public
    property RuntimePfad: string read fRuntimePfad;
    property IniPfad: string read fIniPfad;
    property IniFilename: string read fIniFilename;
    property IniConnect: string read fIniConnect;
    function Database: TIBDatabase;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect;
  end;

var
  SysObj: TSysObj;

implementation

{ TSysObj }

uses
  u_RegIni, u_system, c_AllgTypes;


constructor TSysObj.Create(AOwner: TComponent);
begin
  inherited;
  fRuntimePfad := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)));
  fIniPfad := IncludeTrailingPathDelimiter(GetShellFolder(cCSIDL_APPDATA)) + 'Syntaxhighlighter\';
  if DirExist(FIniPfad) < 0 then
    ForceDirectories(FIniPfad);
  fIniPfad := IncludeTrailingPathDelimiter(fIniPfad);
  fIniFilename := fIniPfad + 'Syntaxhighlighter.ini';
  fIniConnect  := fIniPfad + 'DBConnect.Ini';
  fDatabase := nil;
end;


destructor TSysObj.Destroy;
begin
  if fDatabase <> nil then
    FreeAndNil(fDatabase);
  inherited;
end;

procedure TSysObj.Connect;
var
  Username: string;
  Password: string;
  Server: string;
begin
  if not FileExists(FIniConnect) then
    exit;
  Username := ReadIni(FIniConnect, 'Highlighter', 'Username', '');
  Password := ReadIni(FIniConnect, 'Highlighter', 'Passwort', '');
  Server   := ReadIni(FIniConnect, 'Highlighter', 'Server', '');
  Database.Connected    := false;
  Database.LoginPrompt  := false;
  if Server = '' then
    Database.DatabaseName := ReadIni(FIniConnect, 'Highlighter', 'Datei', '')
  else
    Database.DatabaseName := Server + ':' + ReadIni(FIniConnect, 'Highlighter', 'Datei', '');
  Database.Params.Clear;
  Database.Params.Add('user_name=sysdba');
  Database.Params.Add('password=masterkey');
  Database.Connected := true;
end;


function TSysObj.Database: TIBDatabase;
begin
  if fDatabase = nil then
    fDatabase := TIBDatabase.Create(nil);
  Result := fDatabase;
end;


end.
