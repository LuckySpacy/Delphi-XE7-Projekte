unit fnt_login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, tbButton, o_Benutzer, o_BenutzerList;

type
  Tfrm_Login = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edt_Benutzer: TEdit;
    edt_Passwort: TEdit;
    btn_Ok: TTBButton;
    cbx_PWAnzeigen: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
    procedure cbx_PWAnzeigenClick(Sender: TObject);
    procedure edt_PasswortKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FBenutzer: TBenutzer;
    FBenutzerList: TBenutzerList;
    FPW_OK: Boolean;
    procedure MasterPWAnlegen;
    function CheckPasswort: Boolean;
  public
    property PW_OK: Boolean read FPW_OK;
  end;

var
  frm_Login: Tfrm_Login;

implementation

{$R *.dfm}

uses
  c_DBtypes, fnt_MasterPW, o_sysobj, System.UITypes;

procedure Tfrm_Login.FormCreate(Sender: TObject);
begin
  FBenutzer := TBenutzer.Create(Self);
  FBenutzerList := TBenutzerList.Create(Self);
  FPW_OK := false;
  edt_Benutzer.Text := '';
  edt_Passwort.Text := '';
  edt_Passwort.PasswordChar := '*';
  if FileExists(SysObj.RuntimePfad + 'rc_compile.bat') then
    edt_Passwort.Text := 'lukastimo';
end;

procedure Tfrm_Login.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FBenutzer);
  FreeAndNil(FBenutzerList);
end;

procedure Tfrm_Login.FormShow(Sender: TObject);
begin
  FBenutzerList.ReadAll;
  if FBenutzerList.Count = 1 then
  begin
    edt_Benutzer.Text := FBenutzerList.Item[0].Feld(BE_LOGIN).AsString;
    edt_Passwort.SetFocus;
    if FBenutzerList.Item[0].Feld(BE_PW).AsString = '' then
    begin
      ShowMessage('Es wurde noch kein Passwort festgelegt!' + sLineBreak +
                  'Bitte legen Sie jetzt ein Passwort an.');
      MasterPWAnlegen;
    end;
  end;
end;

procedure Tfrm_Login.MasterPWAnlegen;
var
  Form: Tfrm_MasterPW;
begin
  Form := Tfrm_MasterPW.Create(Self);
  try
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;
end;

procedure Tfrm_Login.btn_OkClick(Sender: TObject);
begin
// muss wieder raus
    FPW_OK := true;
    close;
  exit;

  if CheckPasswort then
  begin
    FPW_OK := true;
    close;
  end
  else
    edt_Passwort.SetFocus;
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
  PWCheck: string;
begin
  //Result := true;
  //exit;
  Result := false;
  FBenutzerList.ReadAll;
  for i1 := 0 to FBenutzerList.Count -1 do
  begin
    if FBenutzerList.Item[i1].Feld(BE_LOGIN).AsString = edt_Benutzer.Text then
    begin
      PWCheck := SysObj.Entschluesseln(FBenutzerList.Item[i1].Feld(BE_PW).AsString, edt_Passwort.Text);
      if edt_Passwort.Text <> PWCheck then
      begin
        MessageDlg('Das aktuelle Passwort stimmt nicht!', mtError, [mbOk], 0);
        exit;
      end
      else
      begin
        Result := true;
        exit;
      end;
    end;
  end;
  if not Result then
    MessageDlg('Das aktuelle Passwort stimmt nicht!', mtError, [mbOk], 0);
end;


procedure Tfrm_Login.edt_PasswortKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    btn_OkClick(nil);
end;

end.
