unit Objekt.Global;

interface

uses
  SysUtils, Classes, variants, IBX.IBDatabase;

type
  TGlobal = class(TComponent)
  private
    fUserPfad: string;
    fTrans: TIBTransaction;
    function getUserPfad: string;
    function getIniFilename: string;
    function getDatenbankfilename: string;
    procedure setDatenbankfilename(const Value: string);
    function getDatenbankserver: string;
    procedure setDatenbankserver(const Value: string);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Userpfad: string read getUserPfad;
    property IniFilename: string read getIniFilename;
    property DatenbankFilename: string read getDatenbankfilename write setDatenbankfilename;
    property DatenbankServer: string read getDatenbankserver write setDatenbankserver;
    property Trans: TIBTransaction read fTrans write fTrans;
    function ProgrammPfad: string;
  end;

var
  Global: TGlobal;

implementation

{ TGlobal }

uses
  Allgemein.SysFolderlocation, Allgemein.Types, Allgemein.RegIni, shellapi,
  Winapi.Windows, Vcl.dialogs;


constructor TGlobal.Create(AOwner: TComponent);
begin
  inherited;
  fUserPfad := '';
end;

destructor TGlobal.Destroy;
begin

  inherited;
end;

function TGlobal.getDatenbankfilename: string;
begin
  Result := ReadIni(IniFilename, 'Datenbank', 'Datenbankfilename', '');
  if (Result = '') or (not FileExists(Result)) then
  begin
    if FileExists(ProgrammPfad + 'TSIKURSE.FDB') then
    begin
      WriteIni(IniFilename, 'Datenbank', 'Datenbankfilename', ProgrammPfad + 'TSIKURSE.FDB');
      Result := ProgrammPfad + 'TSIKURSE.FDB';
      exit;
    end;
    if FileExists(ProgrammPfad + 'Datenbank\TSIKURSE.FDB') then
    begin
      WriteIni(IniFilename, 'Datenbank', 'Datenbankfilename', ProgrammPfad + 'Datenbank\TSIKURSE.FDB');
      Result := ProgrammPfad + 'Datenbank\TSIKURSE.FDB';
      exit;
    end;
  end;
end;

function TGlobal.getDatenbankserver: string;
begin
  Result := ReadIni(IniFilename, 'Datenbank', 'Server', '');
end;


function TGlobal.getIniFilename: string;
begin
  Result := getUserPfad + 'TSIKurse.ini';
end;


function TGlobal.getUserPfad: string;
begin
  Result := fUserPfad;
  if Result = '' then
  begin
    Result := IncludeTrailingPathDelimiter(TSysFolderLocation.GetFolder(cCSIDL_APPDATA)) + 'TSI\Kurse\';
    fUserPfad := Result;
    if not DirectoryExists(fUserPfad) then
      ForceDirectories(fUserPfad);
  end;
end;

function TGlobal.ProgrammPfad: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
end;

procedure TGlobal.setDatenbankfilename(const Value: string);
begin
  WriteIni(IniFilename, 'Datenbank', 'Datenbankfilename', Value);
end;

procedure TGlobal.setDatenbankserver(const Value: string);
begin
  WriteIni(IniFilename, 'Datenbank', 'Server', Value);
end;

end.
