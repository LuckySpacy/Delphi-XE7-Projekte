unit fnt_DialogBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, u_DM, tbButton, obBusinessClasses, obServerClient, c_Types,
  c_TypesEvent;


type
  Tfrm_DialogBase = class(TForm, IObServerClient)
    pnl_Bottom: TPanel;
    btn_Ok: TTBButton;
    btn_Cancel: TTBButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
  private
    FCancel: Boolean;
    FBearbArt: TBearbart;
    FOnChangeBearbArt: TChangeBearbArtEvent;
    FObjectId: Integer;
    FOnChangeObjectId: TChangeObjectIdEvent;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure setBearbArt(const Value: TBearbart);
    procedure setObjectId(const Value: Integer);
  public
    property Cancel: Boolean read FCancel;
    property BearbArt: TBearbart read FBearbArt write setBearbArt;
    property ObjectId: Integer read FObjectId write setObjectId;
    property OnChangeBearbArt: TChangeBearbArtEvent read FOnChangeBearbArt write FOnChangeBearbArt;
    property OnChangeObjectId: TChangeObjectIdEvent read FOnChangeObjectId write FOnChangeObjectId;
  end;

var
  frm_DialogBase: Tfrm_DialogBase;

implementation

{$R *.dfm}

procedure Tfrm_DialogBase.FormCreate(Sender: TObject);
begin
  FCancel := true;
  FBearbart := cUndefiniert;
  FObjectId := -1;
end;

procedure Tfrm_DialogBase.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
begin

end;


procedure Tfrm_DialogBase.setBearbArt(const Value: TBearbart);
begin
  FBearbArt := Value;
  if Assigned(FOnChangeBearbArt) then
    FOnChangeBearbArt(self, Value);
end;

procedure Tfrm_DialogBase.setObjectId(const Value: Integer);
begin
  FObjectId := Value;
  if Assigned(FOnChangeObjectId) then
    FOnChangeObjectId(Self, Value);
end;

procedure Tfrm_DialogBase.btn_CancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_DialogBase.btn_OkClick(Sender: TObject);
begin
  FCancel := false;
  Close;
end;


end.
