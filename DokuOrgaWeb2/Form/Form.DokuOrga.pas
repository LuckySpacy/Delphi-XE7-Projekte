unit Form.DokuOrga;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Objekt.DokuOrga, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Menus, Form.Ordner, tbButton;

type
  Tfrm_DokuOrga = class(TForm)
    MainMenu: TMainMenu;
    Datei1: TMenuItem;
    Neu1: TMenuItem;
    Speichern1: TMenuItem;
    PageControl1: TPageControl;
    tbs_Ordner: TTabSheet;
    TabSheet2: TTabSheet;
    Splitter1: TSplitter;
    TBButton1: TTBButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fFormOrdner: Tfrm_Ordner;
    fPfad: string;
    procedure WebserverConnectError(Sender: TObject);
    procedure WebserverNotAutorisiert(Sender: TObject);
    procedure ShowEinstellung;
  public
  end;

var
  frm_DokuOrga: Tfrm_DokuOrga;

implementation

{$R *.dfm}

uses
  System.UITypes, Form.Einstellung;

procedure Tfrm_DokuOrga.FormCreate(Sender: TObject);
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
end;

procedure Tfrm_DokuOrga.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fFormOrdner);
end;

procedure Tfrm_DokuOrga.FormShow(Sender: TObject);
begin
  DokuOrga.Logger.Info('DokuOrga gestartet');
  if (DokuOrga.IniEinstellung.Datenbankname = '') or (DokuOrga.IniEinstellung.Host = '') or (DokuOrga.IniEinstellung.Datenbankpfad = '') then
    ShowEinstellung;
    ShowEinstellung;
end;

procedure Tfrm_DokuOrga.ShowEinstellung;
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

procedure Tfrm_DokuOrga.WebserverConnectError(Sender: TObject);
begin
  MessageDlg('Webserver ist nicht erreichbar.', mtError, [mbOk], 0);
end;

procedure Tfrm_DokuOrga.WebserverNotAutorisiert(Sender: TObject);
begin
  MessageDlg('Username und/oder Passwort wird vom Webserver nicht akzeptiert.', mtError, [mbOk], 0);
end;

end.
