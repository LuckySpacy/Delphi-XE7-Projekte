unit Objekt.WebserverIni;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Objekt.Ini;


type
  TWebserverIni = class
  private
    fIni: TIni;
    fPfad: string;
  public
    constructor Create;
    destructor Destroy; override;
    function FullFileName: string;
    function Username: string;
    function Passwort: string;
    function Url: string;
    function Port: string;
  end;

implementation

{ TWebserverIni }

constructor TWebserverIni.Create;
begin
  fIni := TIni.Create;
  fPfad := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
end;

destructor TWebserverIni.Destroy;
begin
  FreeAndNil(fIni);
  inherited;
end;

function TWebserverIni.FullFileName: string;
begin
  Result := fPfad + 'Webserver.Ini';
end;

function TWebserverIni.Passwort: string;
begin
  Result := fIni.ReadIni(FullFileName, 'Webserver', 'Passwort', '');
end;

function TWebserverIni.Port: string;
begin
  Result := fIni.ReadIni(FullFileName, 'Webserver', 'Port', '');
end;

function TWebserverIni.Url: string;
begin
  Result := fIni.ReadIni(FullFileName, 'Webserver', 'Url', '');
end;

function TWebserverIni.Username: string;
begin
  Result := fIni.ReadIni(FullFileName, 'Webserver', 'Username', '');
end;

end.
