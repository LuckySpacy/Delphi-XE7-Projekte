unit Form.DokuOrgaWeb;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, tbButton, Objekt.DokuOrga, Vcl.ComCtrls, Vcl.ExtCtrls,
  Form.Ordner, Form.Login, Form.Zweig;

type
  Tfrm_DokuOrgaWeb = class(TForm)
    pg_Ordner: TPageControl;
    tbs_Ordner: TTabSheet;
    TabSheet2: TTabSheet;
    Splitter1: TSplitter;
    pg_Details: TPageControl;
    tbs_Seite: TTabSheet;
    tbs_Dokument: TTabSheet;
    tbs_Einstellung: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    fFormOrdner: Tfrm_Ordner;
    fFormZweig: Tfrm_Zweig;
    fPfad: string;
    procedure WebserverConnectError(Sender: TObject);
    procedure WebserverNotAutorisiert(Sender: TObject);
  public
    procedure ShowEinstellung;
    function ShowLogin: Boolean;
  end;

var
  frm_DokuOrgaWeb: Tfrm_DokuOrgaWeb;

implementation

{$R *.dfm}

uses
  System.UITypes, Form.Einstellung;


procedure Tfrm_DokuOrgaWeb.FormCreate(Sender: TObject);
begin
  fFormOrdner := Tfrm_Ordner.Create(nil);
  fFormOrdner.Parent := tbs_Ordner;
  fFormOrdner.Align  := alClient;
  fPfad := DokuOrga.ProgrammPfad;
  if not FileExists(DokuOrga.WebServerIni.FullFileName) then
  begin
    MessageDlg('Datei: "' + DokuOrga.WebServerIni.FullFileName + '" fehlt. Programm kann nicht gestartet werden.', mtError, [mbOk], 0);
    Application.Terminate;
  end;
  DokuOrga.WebClient.OnWebserverConnectError   := WebserverConnectError;
  DokuOrga.WebClient.OnWebserverNotAutorisiert := WebserverNotAutorisiert;
  DokuOrga.WebClient.Username := DokuOrga.Verschluesseln.Entschluesseln(DokuOrga.WebServerIni.Username);
  DokuOrga.WebClient.Port     := StrToInt(DokuOrga.WebServerIni.Port);
  DokuOrga.WebClient.Passwort := DokuOrga.Verschluesseln.Entschluesseln(DokuOrga.WebServerIni.Passwort);
  DokuOrga.WebClient.Url      := DokuOrga.Verschluesseln.Entschluesseln(DokuOrga.WebServerIni.Url);
  pg_Details.ActivePageIndex := 0;

  fFormZweig := Tfrm_Zweig.Create;
  fFormZweig.Parent := tbs_Ordner;
  fFormZweig.Align  := alClient;
  fFormZweig.Visible := false;

end;

procedure Tfrm_DokuOrgaWeb.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fFormOrdner);
end;

procedure Tfrm_DokuOrgaWeb.FormShow(Sender: TObject);
var
  ConnectError: string;
begin
  DokuOrga.Logger.Info('DokuOrga gestartet');
  if (DokuOrga.IniEinstellung.Datenbankname = '') or (DokuOrga.IniEinstellung.Host = '') or (DokuOrga.IniEinstellung.Datenbankpfad = '') then
    ShowEinstellung;
  DokuOrga.IBDatenbank.UseInterbase := true;
  ConnectError := DokuOrga.IBDatenbank.Connect;
  if ConnectError > '' then
  begin
    MessageDlg(ConnectError, mtError, [mbOk], 0);
    Application.Terminate;
  end;
  if not ShowLogin then
  begin
    Application.Terminate;
  end;
  fFormOrdner.Show;
  fFormOrdner.LadeEbene(0);
end;

procedure Tfrm_DokuOrgaWeb.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DokuOrga.IBDatenbank.Disconnect;
end;


procedure Tfrm_DokuOrgaWeb.ShowEinstellung;
var
  Form: Tfrm_Einstellung;
begin
  Form := Tfrm_Einstellung.Create(nil);
  try
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;
end;

function Tfrm_DokuOrgaWeb.ShowLogin: Boolean;
var
  Form: Tfrm_Login;
begin
  Result := true;
  exit;
  Form := Tfrm_Login.Create(nil);
  try
    Form.ShowModal;
    Result := Form.Ok;
  finally
    FreeAndNil(Form);
  end;
end;

procedure Tfrm_DokuOrgaWeb.WebserverConnectError(Sender: TObject);
begin
  MessageDlg('Webserver ist nicht erreichbar.', mtError, [mbOk], 0);
end;

procedure Tfrm_DokuOrgaWeb.WebserverNotAutorisiert(Sender: TObject);
begin
  MessageDlg('Username und/oder Passwort wird vom Webserver nicht akzeptiert.', mtError, [mbOk], 0);
end;

end.
