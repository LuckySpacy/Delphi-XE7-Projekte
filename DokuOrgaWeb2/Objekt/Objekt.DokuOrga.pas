unit Objekt.DokuOrga;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Objekt.Verschluesseln, Objekt.Logger,
  Objekt.WebClient, Objekt.WebserverIni, DB.IBDatenbank, Objekt.IniEinstellung;

type
  TDokuOrga = class
  private
    fVerschluesseln: TVerschluesseln;
    fLogger: TLogger;
    fWebClient: TWebClient;
    fWebserverIni: TWebServerIni;
    fIBDatenbank: TIBDatenbank;
    fIniEinstellung: TIniEinstellung;
  public
    constructor Create;
    destructor Destroy; override;
    property Verschluesseln: TVerschluesseln read fVerschluesseln write fVerschluesseln;
    property Logger: TLogger read fLogger write fLogger;
    property WebClient: TWebClient read fWebClient write fWebClient;
    property WebServerIni: TWebServerIni read fWebserverIni write fWebServerIni;
    property IniEinstellung: TIniEinstellung read fIniEinstellung write fIniEinstellung;
    function ProgrammPfad: string;
    function IBDatenbank: TIBDatenbank;
  end;

var
  DokuOrga: TDokuOrga;

implementation

{ TDokuOrga }

constructor TDokuOrga.Create;
begin
  fVerschluesseln := TVerschluesseln.Create;
  fLogger := TLogger.Create;
  fWebClient := TWebClient.Create(nil);
  fWebserverIni := TWebServerIni.Create;
  fIBDatenbank  := TIBDatenbank.Create;
  fIniEinstellung := TIniEinstellung.Create;
end;

destructor TDokuOrga.Destroy;
begin
  FreeAndNil(fWebserverIni);
  FreeAndNil(fVerschluesseln);
  FreeAndNil(fLogger);
  FreeAndNil(fWebClient);
  FreeAndNil(fIBDatenbank);
  FreeAndNil(fIniEinstellung);
  inherited;
end;



function TDokuOrga.IBDatenbank: TIBDatenbank;
begin
  Result := fIBDatenbank;
end;

function TDokuOrga.ProgrammPfad: string;
begin
  Result :=  IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
end;

initialization
  DokuOrga := TDokuOrga.Create;

finalization
 if DokuOrga <> nil then
   FreeAndNil(DokuOrga);




end.
