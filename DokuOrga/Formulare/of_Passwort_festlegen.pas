unit of_Passwort_festlegen;

interface

uses
  SysUtils, Classes, Forms, StdCtrls, Buttons, of_Base, c_Types,
  ExtCtrls, Dialogs, o_sysObj, Controls, obBusinessClasses, obServerClient,
  tbButton, IBDatabase, System.UITypes;

type
  Tof_Passwort_festlegen = class(Tof_Base, IObServerClient)
  private
    Fedt_PW: TEdit;
    Fedt_PW2: TEdit;
    FBtn_Ok: TTBButton;
    FBtn_Cancel: TTBButton;
    FOwner: TForm;
    FPasswortOk: Boolean;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure edt_PWKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edt_PW2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    property PasswortOk: Boolean read FPasswortOk;
  end;

implementation

{ Tof_Passwort_festlegen }

uses
  c_DBTypes;

constructor Tof_Passwort_festlegen.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fedt_PW := TEdit(getCustomEdit('edt_pw'));
  Fedt_PW2 := TEdit(getCustomEdit('edt_pw2'));
  FBtn_Ok := gettbButton('btn_ok');
  FBtn_Cancel := gettbButton('btn_cancel');
  FBtn_Ok.OnClick := BtnOkClick;
  FBtn_Cancel.OnClick := BtnCancelClick;
  FOwner := TForm(AOwner);
  FPasswortOk := false;
  Fedt_PW.Text := '';
  Fedt_PW2.Text := '';
  Fedt_PW.OnKeyDown := edt_PWKeyDown;
  Fedt_PW2.OnKeyDown := edt_PW2KeyDown;
end;

destructor Tof_Passwort_festlegen.Destroy;
begin

  inherited;
end;


procedure Tof_Passwort_festlegen.BtnCancelClick(Sender: TObject);
begin
  FOwner.Close;
end;

procedure Tof_Passwort_festlegen.BtnOkClick(Sender: TObject);
begin
  if Fedt_PW.Text <> Fedt_PW2.Text then
  begin
    MessageDlg('Die Eingaben stimmen nicht überein!', mtError, [mbOk], 0);
    Fedt_PW.SetFocus;
    exit;
  end;
  FPasswortOk := true;
  FOwner.Close;
end;


procedure Tof_Passwort_festlegen.edt_PW2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    BtnOkClick(nil);
end;

procedure Tof_Passwort_festlegen.edt_PWKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    Fedt_PW2.SetFocus;
end;

procedure Tof_Passwort_festlegen.ObServerNotification(AType: TNotificationType;
  Action, Data: Integer);
begin

end;

end.
