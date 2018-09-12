unit of_Dialog;

interface

uses
  SysUtils, Classes, Dialogs,
  o_sysObj, Controls, obBusinessClasses, obServerClient, of_Base, tbButton, Forms,
  c_types;

type
  Tof_Dialog = class(Tof_Base, IObServerClient)
  private
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
  protected
    FOwner: TForm;
    FBtnOk: TTBButton;
    FBtnCancel: TTBButton;
    FCancel: Boolean;
    procedure OnCancelClick(Sender: TObject);
    procedure OnOkClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    property Cancel: Boolean read FCancel;
  end;

implementation

{ Tof_Dialog }

constructor Tof_Dialog.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  FOwner   := TForm(AOwner);
  FBtnOk := gettbButton('btn_Ok');
  FBtnCancel := gettbButton('btn_Cancel');
  FBtnOk.OnClick := OnOkClick;
  FBtnCancel.OnClick := OnCancelClick;
  FCancel := true;
end;

destructor Tof_Dialog.Destroy;
begin

  inherited;
end;

procedure Tof_Dialog.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
begin

end;

procedure Tof_Dialog.OnCancelClick(Sender: TObject);
begin
  FOwner.close;
end;

procedure Tof_Dialog.OnOkClick(Sender: TObject);
begin
  FCancel := false;
  FOwner.close;
end;

end.
