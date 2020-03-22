unit Objekt.Ini;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Allgemein.SysFolderlocation, Allgemein.Types, Allgemein.RegIni, shellapi;

type
  TIni = class
  private
    fUserPfad: string;
    fIniFilename: string;
    function getUserPfad: string;
    function getIniFilename: string;
    function getHost: string;
    function getKursDatumVon: TDateTime;
    procedure setKursDatumVon(const Value: TDateTime);
    function getKursDatumBis: TDateTime;
    procedure setKursDatumBis(const Value: TDateTime);
  public
    constructor Create;
    destructor Destroy; override;
    property UserPfad: string read getUserPfad;
    property IniFilename: string read getIniFilename;
    property Host: string read getHost;
    property Kursdatumvon: TDateTime read getKursDatumVon write setKursDatumVon;
    property Kursdatumbis: TDateTime read getKursDatumBis write setKursDatumBis;
  end;

implementation

{ TIni }

uses
  DateUtils;

constructor TIni.Create;
begin
  fUserPfad := '';
  fIniFilename := '';
end;

destructor TIni.Destroy;
begin

  inherited;
end;


function TIni.getIniFilename: string;
begin
  Result := fIniFilename;
  if Result = '' then
    Result := getUserPfad + 'TsiAnsicht.Ini';
  fIniFilename := Result;
end;

function TIni.getKursDatumBis: TDateTime;
var
  s: string;
begin
  s := ReadIni(IniFilename, 'Kurs', 'Datumbis', FormatDateTime('dd.mm.yyyy', now));
  Result := StrToDate(s);
end;

function TIni.getKursDatumVon: TDateTime;
var
  s: string;
begin
  s := ReadIni(IniFilename, 'Kurs', 'Datumvon', FormatDateTime('dd.mm.yyyy', IncDay(now, 30)));
  Result := StrToDate(s);
end;

function TIni.getUserPfad: string;
begin
  Result := fUserPfad;
  if Result = '' then
  begin
    Result := IncludeTrailingPathDelimiter(TSysFolderLocation.GetFolder(cCSIDL_APPDATA)) + 'TSIAnsicht\';
    fUserPfad := Result;
    if not DirectoryExists(fUserPfad) then
      ForceDirectories(fUserPfad);
  end;
end;


procedure TIni.setKursDatumBis(const Value: TDateTime);
begin
  WriteIni(IniFilename, 'Kurs', 'Datumbis', FormatDateTime('dd.mm.yyyy', Value));
end;

procedure TIni.setKursDatumVon(const Value: TDateTime);
begin
  WriteIni(IniFilename, 'Kurs', 'Datumvon', FormatDateTime('dd.mm.yyyy', Value));
end;

function TIni.getHost: string;
begin
  Result := ReadIni(IniFilename, 'MySql', 'Host', '');
  if Result = '' then
  begin
    WriteIni(IniFilename, 'MySql', 'Host', 'localhost/');
    Result := ReadIni(IniFilename, 'MySql', 'Host', '');
  end;
end;


end.
