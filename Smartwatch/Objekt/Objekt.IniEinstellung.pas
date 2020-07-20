unit Objekt.IniEinstellung;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Objekt.Ini, Objekt.Filefunction, Objekt.Folderlocation,
  Objekt.Verschluesseln;


type
  TIniEinstellung = class
  private
    fIni: TIni;
    fRuntimePfad: string;
    FIniPfad: string;
    FFilefunction: TFileFunction;
    FIniFileName: string;
    FIniGridFileName: string;
    FIniFormFileName: string;
    FIniConnect: string;
    fVerschluesseln: TVerschluesseln;
    function getDatenbankname: string;
    procedure setDatenbankname(const Value: string);
    function getHost: string;
    procedure setHost(const Value: string);
    function getDatenbankpfad: string;
    procedure setDatenbankpfad(const Value: string);
    function getUsername: string;
    procedure setUsername(const Value: string);
    function getPasswort: string;
    procedure setPasswort(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    property Datenbankname: string read getDatenbankname write setDatenbankname;
    property Host: string read getHost write setHost;
    property Datenbankpfad: string read getDatenbankpfad write setDatenbankpfad;
    property Username: string read getUsername write setUsername;
    property Passwort: string read getPasswort write setPasswort;
    function GridIni: string;
    function FormIni: string;
  end;

implementation

{ TIniEinstellung }

uses
  c.Folder;

constructor TIniEinstellung.Create;
var
  Folderlocation : TFolderLocation;
begin
  fVerschluesseln := TVerschluesseln.Create;
  fIni := TIni.Create;
  FFilefunction := TFileFunction.Create;
  Folderlocation := TFolderLocation.Create(cCSIDL_APPDATA);
  try
    fRuntimePfad := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
    FIniPfad := IncludeTrailingPathDelimiter(Folderlocation.GetShellFolder) + 'Smartwatch\';
  finally
    FreeAndNil(Folderlocation);
  end;

  if FFilefunction.DirExist(FIniPfad) < 0 then
    ForceDirectories(FIniPfad);
  FIniFileName     := FIniPfad + 'Smartwatch.ini';
  FIniGridFileName := FIniPfad + 'SmartwatchGrid.ini';
  fIniFormFilename := FIniPfad + 'Form.Ini';
  FIniConnect      := FIniPfad + 'Smartwatch_Connect.ini';

  //Einstellungsform bauchen Sie dazu auch o_sysobj

end;

destructor TIniEinstellung.Destroy;
begin
  FreeAndNil(fIni);
  FreeAndNil(FFilefunction);
  FreeAndNil(fVerschluesseln);
  inherited;
end;

function TIniEinstellung.getDatenbankname: string;
begin
  Result := fIni.ReadIni(FIniConnect, 'Datenbank', 'DatenbankName', '');
  if Result > '' then
    Result := fVerschluesseln.Entschluesseln(Result);
end;

function TIniEinstellung.getDatenbankpfad: string;
begin
  Result := fIni.ReadIni(FIniConnect, 'Datenbank', 'Datenbankpfad', '');
  if Result > '' then
    Result := fVerschluesseln.Entschluesseln(Result);
end;

function TIniEinstellung.getHost: string;
begin
  Result := fIni.ReadIni(FIniConnect, 'Datenbank', 'Host', '');
  if Result > '' then
    Result := fVerschluesseln.Entschluesseln(Result);
end;

function TIniEinstellung.getPasswort: string;
begin
  Result := fIni.ReadIni(FIniConnect, 'Datenbank', 'Passwort', '');
  if Result > '' then
    Result := fVerschluesseln.Entschluesseln(Result);
end;

function TIniEinstellung.getUsername: string;
begin
  Result := fIni.ReadIni(FIniConnect, 'Datenbank', 'Username', '');
  if Result > '' then
    Result := fVerschluesseln.Entschluesseln(Result);
end;

function TIniEinstellung.GridIni: string;
begin
  Result := FIniGridFileName;
end;

function TIniEinstellung.FormIni: string;
begin
  Result := FIniFormFileName;
end;



procedure TIniEinstellung.setDatenbankname(const Value: string);
begin
  fIni.WriteIni(FIniConnect, 'Datenbank', 'Datenbankname', fVerschluesseln.Verschluesseln(Value));
end;

procedure TIniEinstellung.setDatenbankpfad(const Value: string);
begin
  fIni.WriteIni(FIniConnect, 'Datenbank', 'Datenbankpfad', fVerschluesseln.Verschluesseln(Value));
end;

procedure TIniEinstellung.setHost(const Value: string);
begin
  fIni.WriteIni(FIniConnect, 'Datenbank', 'Host', fVerschluesseln.Verschluesseln(Value));
end;

procedure TIniEinstellung.setPasswort(const Value: string);
begin
  fIni.WriteIni(FIniConnect, 'Datenbank', 'Passwort', fVerschluesseln.Verschluesseln(Value));
end;

procedure TIniEinstellung.setUsername(const Value: string);
begin
  fIni.WriteIni(FIniConnect, 'Datenbank', 'Username', fVerschluesseln.Verschluesseln(Value));
end;

end.
