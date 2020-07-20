unit Form.Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, tbButton, Vcl.StdCtrls, Vcl.ExtCtrls,
  DB.BenutzerList;

type
  Tfrm_Login = class(TForm)
    pnl_Left: TPanel;
    pnl_Button: TPanel;
    pnl_Client: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edt_Benutzer: TEdit;
    edt_Passwort: TEdit;
    cbx_PWAnzeigen: TCheckBox;
    btn_Ok: TTBButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_OkClick(Sender: TObject);
    procedure cbx_PWAnzeigenClick(Sender: TObject);
    procedure edt_BenutzerKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edt_PasswortKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    fOk: Boolean;
    fBenutzerList: TDBBenutzerList;
    function CheckPasswort: Boolean;
  public
    property Ok: Boolean read fOk write fOk;
  end;

var
  frm_Login: Tfrm_Login;

implementation

{$R *.dfm}

uses
  Objekt.DokuOrga, DB.Benutzer, System.UITypes;


procedure Tfrm_Login.FormCreate(Sender: TObject);
begin
  fOk := false;
  fBenutzerList := TDBBenutzerList.Create(nil);
end;

procedure Tfrm_Login.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fBenutzerList);
end;

procedure Tfrm_Login.FormShow(Sender: TObject);
var
  Benutzer: TDBBenutzer;
begin
  edt_Benutzer.Text := DokuOrga.IniDokuOrga.Username;
  edt_Passwort.Text := '';
  fBenutzerList.Trans := DokuOrga.IBDatenbank.Trans;
  fBenutzerList.Read('');
  if fBenutzerList.Count = 0 then
  begin
    Benutzer := TDBBenutzer.Create(nil);
    Benutzer.Trans := DokuOrga.IBDatenbank.Trans;
    Benutzer.Nachname := 'Systemadmin';
    Benutzer.Login := 'Admin';
    Benutzer.Passwort := DokuOrga.Verschluesseln.Verschluesseln('admin');
    Benutzer.SaveToDB;
    FreeAndNil(Benutzer);
    fBenutzerList.Read('');
  end;
end;

procedure Tfrm_Login.btn_OkClick(Sender: TObject);
begin
  fOk := CheckPasswort;
  if not fOk then
  begin
    MessageDlg('Benutzer oder Passwort ist nicht korrekt', mtError, [mbOk], 0);
    exit;
  end;
  Close;
end;

procedure Tfrm_Login.cbx_PWAnzeigenClick(Sender: TObject);
begin
  if cbx_PWAnzeigen.Checked then
    edt_Passwort.PasswordChar := #0
  else
    edt_Passwort.PasswordChar := '*';
end;

function Tfrm_Login.CheckPasswort: Boolean;
var
  i1: Integer;
  PW: string;
begin
  Result := false;
  if fBenutzerList.Count = 0 then
  begin
    if not SameText('Admin', edt_Benutzer.Text) then
      exit;
    if edt_Benutzer.Text = 'admin' then
      Result := true;
    exit;
  end;
  PW := DokuOrga.Verschluesseln.Verschluesseln(edt_Passwort.Text);
  for i1 := 0 to fBenutzerList.Count -1 do
  begin
    if SameText(edt_Benutzer.Text, fBenutzerList.Item[i1].Login) and (PW = fBenutzerList.Item[i1].Passwort) then
    begin
      Result := true;
      exit;
    end;
  end;
end;

procedure Tfrm_Login.edt_BenutzerKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> 13 then
    exit;
  fOk := CheckPasswort;
  if not fOk then
  begin
    MessageDlg('Benutzer oder Passwort ist nicht korrekt', mtError, [mbOk], 0);
    exit;
  end;
  Close;
end;

procedure Tfrm_Login.edt_PasswortKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> 13 then
    exit;
  fOk := CheckPasswort;
  if not fOk then
  begin
    MessageDlg('Benutzer oder Passwort ist nicht korrekt', mtError, [mbOk], 0);
    exit;
  end;
  Close;
end;

procedure Tfrm_Login.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DokuOrga.IniDokuOrga.Username := edt_Benutzer.Text;
end;


end.
