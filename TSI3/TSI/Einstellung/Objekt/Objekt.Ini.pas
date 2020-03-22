unit Objekt.Ini;

interface

uses
  SysUtils, Classes, variants;


type
  TIni = class(TComponent)
  private
    fUserPfad: string;
    function getUserPfad: string;
    function getIniFilename: string;
    function getDownloadpfad: string;
    procedure setDownloadpfad(const Value: string);
    function getZielpfad: string;
    procedure setZielpfad(const Value: string);
    function getServer: string;
    procedure setServer(const Value: string);
    function getKurseFDB: string;
    function getTSIFDB: string;
    procedure setKurseFDB(const Value: string);
    procedure setTSIFDB(const Value: string);
    function getUhrzeit: string;
    procedure setUhrzeit(const Value: string);
    function getSchnittstelle: Integer;
    procedure setSchnittstelle(const Value: Integer);
  protected
  public
    Protokoll: TStringList;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Userpfad: string read getUserPfad;
    property IniFilename: string read getIniFilename;
    function ProgrammPfad: string;
    property Downloadpfad: string read getDownloadpfad write setDownloadpfad;
    property Zielpfad: string read getZielpfad write setZielpfad;
    property Server: string read getServer write setServer;
    property KurseFDB: string read getKurseFDB write setKurseFDB;
    property TSIFDB: string read getTSIFDB write setTSIFDB;
    property Uhrzeit: string read getUhrzeit write setUhrzeit;
    property Schnittstelle: Integer read getSchnittstelle write setSchnittstelle;
  end;

var
  Ini: TIni;

implementation

{ TIni }


uses
  Allgemein.SysFolderlocation, Allgemein.Types, Allgemein.RegIni, shellapi,
  Winapi.Windows, Vcl.dialogs;

constructor TIni.Create(AOwner: TComponent);
begin
  inherited;
  fUserPfad := '';
  Protokoll := TStringList.Create;
end;

destructor TIni.Destroy;
begin
  FreeAndNil(Protokoll);
  inherited;
end;

function TIni.getDownloadpfad: string;
begin
  Result := ReadIni(IniFilename, 'Pfad', 'Download', '');
end;

function TIni.getIniFilename: string;
begin
  Result := getUserPfad + 'TSI.ini';
end;

function TIni.getKurseFDB: string;
begin
  Result := ReadIni(IniFilename, 'Datenbank', 'KurseFDB', '');
end;

function TIni.getSchnittstelle: Integer;
begin
  Result := StrToInt(ReadIni(IniFilename, 'Allgemein', 'Schnittstelle', '-1'));
end;

function TIni.getServer: string;
begin
  Result := ReadIni(IniFilename, 'Datenbank', 'Server', '');
end;

function TIni.getTSIFDB: string;
begin
  Result := ReadIni(IniFilename, 'Datenbank', 'TSIFDB', '');
end;

function TIni.getUhrzeit: string;
begin
  Result := ReadIni(IniFilename, 'Interval', 'Uhrzeit', '23:59:00');
end;

function TIni.getUserPfad: string;
begin
  Result := fUserPfad;
  if Result = '' then
  begin
    Result := IncludeTrailingPathDelimiter(TSysFolderLocation.GetFolder(cCSIDL_APPDATA)) + 'TSI\';
    fUserPfad := Result;
    if not DirectoryExists(fUserPfad) then
      ForceDirectories(fUserPfad);
  end;
end;

function TIni.getZielpfad: string;
begin
  Result := ReadIni(IniFilename, 'Pfad', 'Ziel', '');
end;

function TIni.ProgrammPfad: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
end;


procedure TIni.setDownloadpfad(const Value: string);
begin
  WriteIni(IniFilename, 'Pfad', 'Download', Value);
end;

procedure TIni.setKurseFDB(const Value: string);
begin
  WriteIni(IniFilename, 'Datenbank', 'KurseFDB', Value);
end;

procedure TIni.setSchnittstelle(const Value: Integer);
begin
  WriteIni(IniFilename, 'Allgemein', 'Schnittstelle', IntToStr(Value));
end;

procedure TIni.setServer(const Value: string);
begin
  WriteIni(IniFilename, 'Datenbank', 'Server', Value);
end;

procedure TIni.setTSIFDB(const Value: string);
begin
  WriteIni(IniFilename, 'Datenbank', 'TSIFDB', Value);
end;

procedure TIni.setUhrzeit(const Value: string);
begin
  WriteIni(IniFilename, 'Interval', 'Uhrzeit', Value);
end;

procedure TIni.setZielpfad(const Value: string);
begin
  WriteIni(IniFilename, 'Pfad', 'Ziel', Value);
end;

end.
