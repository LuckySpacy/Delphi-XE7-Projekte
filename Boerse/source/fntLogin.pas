unit fntLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, o_field, o_benutzer;

type
  Tfrm_Login = class(TForm)
    edt_Benutzer: TEdit;
    edt_Passwort: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    cmd_Login: TButton;
    edt_Passwort2: TEdit;
    lbl_Passwort2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmd_LoginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt_PasswortKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FCancel: Boolean;
    FField : TTBField;
    FBenutzer: TBenutzer;
  public
    property Cancel: Boolean read FCancel;
  end;

var
  frm_Login: Tfrm_Login;

implementation

{$R *.dfm}

uses
  untDM, md5;



procedure Tfrm_Login.FormCreate(Sender: TObject);
begin
  FCancel := true;
  FField  := TTBField.Create;
  //FField.AsString := '90.12';
  FField.AsCurrency := 90.12;
  FBenutzer := TBenutzer.Create(Self, dm.IBT);
  FBenutzer.Login.AsString := '20.10';
  FBenutzer.Login.AsString := '20.11';
  edt_Benutzer.Text := 'bachmann';
  edt_Passwort.Text := 'lukastimo';
  edt_Passwort2.Text := '';
end;

procedure Tfrm_Login.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FBenutzer);
  FreeAndNil(FField);
end;

procedure Tfrm_Login.FormShow(Sender: TObject);
begin
  edt_Benutzer.SetFocus;
  if FBenutzer.getAllRecordCount = 0 then
  begin
    lbl_Passwort2.Visible := true;
    edt_Passwort2.Visible := true;
  end;
end;

procedure Tfrm_Login.edt_PasswortKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then
    cmd_Loginclick(nil);
end;


procedure Tfrm_Login.cmd_LoginClick(Sender: TObject);
var
  s: string;
begin
  if lbl_Passwort2.Visible then
  begin
    if edt_Passwort.Text <> edt_Passwort2.Text then
    begin
      ShowMessage('Das Passwort stimmt nicht überein.');
      edt_Passwort.Text  := '';
      edt_Passwort2.Text := '';
      edt_Passwort.SetFocus;
      exit;
    end;
    FBenutzer.Login.AsString    := edt_Benutzer.Text;
    FBenutzer.Passwort.AsString := MD5Print(MD5String(edt_Passwort.Text));
    FBenutzer.Name.AsString     := '';
    if not FBenutzer.Save then
    begin
      FBenutzer.Rollback;
      ShowMessage('Fehler beim Speichern');
      exit;
    end;
    FBenutzer.Commit;
    FCancel := false;
    Close;
    exit;
  end;
  FBenutzer.ReadBenutzer(edt_Benutzer.Text,  MD5Print(MD5String(edt_Passwort.Text)));
  if not SameText(edt_Benutzer.Text, FBenutzer.Login.AsString) then
  begin
    ShowMessage('Benutzername oder Passwort stimmt nicht überein.');
    edt_Benutzer.SetFocus;
    exit;
  end;
  s := MD5Print(MD5String(edt_Passwort.Text));
  if s <> FBenutzer.Passwort.AsString then
  begin
    ShowMessage('Benutzername oder Passwort stimmt nicht überein.');
    edt_Benutzer.SetFocus;
    exit;
  end;
  FCancel := false;
  close;
end;


end.
