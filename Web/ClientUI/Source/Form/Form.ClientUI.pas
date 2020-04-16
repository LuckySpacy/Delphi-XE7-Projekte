unit Form.ClientUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvEdit, Vcl.StdCtrls, Vcl.ExtCtrls,
  Objekt.Verschluesseln, Objekt.ClientUIEinstellung;

type
  Tfrm_ClientUI = class(TForm)
    Panel2: TPanel;
    btn_Schliessen: TButton;
    Panel3: TPanel;
    Panel6: TPanel;
    GroupBox1: TGroupBox;
    Panel7: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel8: TPanel;
    edt_URL: TEdit;
    edt_Port: TAdvEdit;
    edt_Passwort: TEdit;
    edt_Username: TEdit;
    btn_Abbrechen: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt_URLExit(Sender: TObject);
    procedure edt_UsernameExit(Sender: TObject);
    procedure edt_PasswortExit(Sender: TObject);
    procedure btn_AbbrechenClick(Sender: TObject);
    procedure btn_SchliessenClick(Sender: TObject);
  private
    fPfad: string;
    fIniFilename: string;
    fClientUIEinstellung: TClientUIEinstellung;
    fVerschluesseln: TVerschluesseln;
    procedure SaveIni;
  public
  end;

var
  frm_ClientUI: Tfrm_ClientUI;

implementation

{$R *.dfm}

uses
  u_RegIni;



procedure Tfrm_ClientUI.FormCreate(Sender: TObject);
begin //
  fPfad := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  fIniFilename := fPfad + 'ClientUI.ini';
  fClientUIEinstellung := TClientUIEinstellung.Create;
  fVerschluesseln := TVerschluesseln.Create;
end;

procedure Tfrm_ClientUI.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fClientUIEinstellung);
  FreeAndNil(fVerschluesseln);
end;

procedure Tfrm_ClientUI.FormShow(Sender: TObject);
begin
  edt_URL.Text := '';
  edt_Username.Text := '';
  edt_Passwort.Text := '';
  fClientUIEinstellung.URL      := ReadIni(fIniFilename, 'Webserver', 'URL', '');
  fClientUIEinstellung.Username := ReadIni(fIniFilename, 'Webserver', 'Username', '');
  fClientUIEinstellung.Passwort := ReadIni(fIniFilename, 'Webserver', 'Passwort', '');
  edt_Port.Text                 := ReadIni(fIniFilename, 'Webserver', 'Port', '80');
  if fClientUIEinstellung.URL > '' then
  begin
    fClientUIEinstellung.URL := fVerschluesseln.Entschluesseln(fClientUIEinstellung.URL);
    edt_URL.Text := '*****';
  end;
  if fClientUIEinstellung.Username > '' then
  begin
    fClientUIEinstellung.Username := fVerschluesseln.Entschluesseln(fClientUIEinstellung.Username);
    edt_Username.Text := '*****';
  end;
  if fClientUIEinstellung.Passwort > '' then
  begin
    fClientUIEinstellung.Passwort := fVerschluesseln.Entschluesseln(fClientUIEinstellung.Passwort);
    edt_Passwort.Text := '*****';
  end;
end;




procedure Tfrm_ClientUI.edt_PasswortExit(Sender: TObject);
begin
  if Pos('*', edt_Passwort.Text) <= 0 then
    fClientUIEinstellung.Passwort := edt_Passwort.Text;
end;

procedure Tfrm_ClientUI.edt_URLExit(Sender: TObject);
begin
  if Pos('*', edt_URL.Text) <= 0 then
    fClientUIEinstellung.URL := edt_URL.Text;
end;

procedure Tfrm_ClientUI.edt_UsernameExit(Sender: TObject);
begin
  if Pos('*', edt_Username.Text) <= 0 then
    fClientUIEinstellung.Username := edt_Username.Text;
end;


procedure Tfrm_ClientUI.btn_AbbrechenClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_ClientUI.btn_SchliessenClick(Sender: TObject);
begin
  SaveIni;
  close;
end;



procedure Tfrm_ClientUI.SaveIni;
var
  Url: string;
  Username: string;
  Passwort: string;
begin
  Url := fVerschluesseln.Verschluesseln(fClientUIEinstellung.URL);
  Username := fVerschluesseln.Verschluesseln(fClientUIEinstellung.Username);
  Passwort := fVerschluesseln.Verschluesseln(fClientUIEinstellung.Passwort);
  WriteIni(fIniFilename, 'Webserver', 'URL', Url);
  WriteIni(fIniFilename, 'Webserver', 'Username', Username);
  WriteIni(fIniFilename, 'Webserver', 'Passwort', Passwort);
  WriteIni(fIniFilename, 'Webserver', 'Port', edt_Port.Text);
end;





end.
