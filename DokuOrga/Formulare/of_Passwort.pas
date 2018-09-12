unit of_Passwort;

interface

uses
  SysUtils, Classes, Forms, StdCtrls, Buttons, of_Base, c_Types,
  ExtCtrls, Dialogs, o_sysObj, Controls, obBusinessClasses, obServerClient,
  tbButton, IBDatabase, System.UITypes;

type
  Tof_Passwort = class(Tof_Base, IObServerClient)
  private
    Fedt_PW: TEdit;
    FBtn_Ok: TTBButton;
    FBtn_Cancel: TTBButton;
    FOwner: TForm;
    FPasswortOk: Boolean;
    FCheckPasswort: string;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure edt_PWKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    property PasswortOk: Boolean read FPasswortOk;
    property CheckPasswort: string read FCheckPasswort write FCheckPasswort;
  end;

implementation

{ Tof_Passwort }

uses
  c_DBTypes;

constructor Tof_Passwort.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fedt_PW := TEdit(getCustomEdit('edt_pw'));
  FBtn_Ok := gettbButton('btn_ok');
  FBtn_Cancel := gettbButton('btn_cancel');
  FBtn_Ok.OnClick := BtnOkClick;
  FBtn_Cancel.OnClick := BtnCancelClick;
  FOwner := TForm(AOwner);
  FPasswortOk := false;
  Fedt_PW.Text := '';
  Fedt_PW.OnKeyDown := edt_PWKeyUp;
  FCheckPasswort := '';
end;

destructor Tof_Passwort.Destroy;
begin

  inherited;
end;


procedure Tof_Passwort.BtnCancelClick(Sender: TObject);
begin
  FOwner.Close;
end;

procedure Tof_Passwort.BtnOkClick(Sender: TObject);
var
  PW: string;
begin
  if FCheckPasswort > '' then
  begin
    PW := SysObj.Entschluesseln(FCheckPasswort, Fedt_PW.Text);
    if Fedt_PW.Text <> PW then
    begin
      MessageDlg('Das Passwort ist falsch', mtError, [mbOk], 0);
      exit;
    end;
    FPasswortOk := true;
    FOwner.Close;
    exit;
  end;

  if Trim(Fedt_PW.Text) = '' then
  begin
    MessageDlg('Das Passwort ist falsch', mtError, [mbOk], 0);
    exit;
  end;
  if Fedt_PW.Text <> SysObj.Entschluesseln(SysObj.Benutzer.Feld(BE_PW).AsString, Fedt_PW.Text) then
  begin
    MessageDlg('Das Passwort ist falsch', mtError, [mbOk], 0);
    exit;
  end;
  FPasswortOk := true;
  FOwner.Close;
end;


procedure Tof_Passwort.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
begin

end;

procedure Tof_Passwort.edt_PWKeyUp(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Key = 13 then
    BtnOkClick(nil);
end;

end.
