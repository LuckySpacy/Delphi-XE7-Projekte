unit Global.Ini;

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
  public
    constructor Create;
    destructor Destroy; override;
    property UserPfad: string read getUserPfad;
    property IniFilename: string read getIniFilename;
    property Host: string read getHost;
  end;

implementation

{ TIni }

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


function TIni.getHost: string;
begin
  Result := ReadIni(IniFilename, 'MySql', 'Host', 'localhost');
end;


end.
