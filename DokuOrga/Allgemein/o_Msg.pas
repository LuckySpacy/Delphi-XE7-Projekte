unit o_Msg;

interface

uses
  SysUtils, Classes, fntMessageDialog, Dialogs, o_syssprache;

type
  TMsg = class
  private
    FSysSprache: TSysSprache;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function Msg(AOwner: TComponent; aMessageText: string; DlgType: TMsgDlgType; Buttons: Array of TMsgDlgBtn): Integer; overload;
    function Msg(AOwner: TComponent; aMessageText: string; DlgType: TMsgDlgType; Buttons: Array of TMsgDlgBtn; aDefaultButton: TMsgDlgBtn): Integer; overload;
    function Msg(AOwner: TComponent; aMessageText: string; DlgType: TMsgDlgType; Buttons: Array of TMsgDlgBtn; aDefaultButton: TMsgDlgBtn; aButtontext: Array of String): Integer; overload; //
    function Msg(AOwner: TComponent; aMessageText: string; DlgType: TMsgDlgType; Buttons: Array of TMsgDlgBtn; aHelpctx: Integer): Integer; overload;
    function MsgConfirm(AOwner: TComponent; aMessageText: string; DlgType: TMsgDlgType; Buttons: Array of Integer; aDefaultButton: TMsgDlgBtn): Integer;
  end;


implementation

{ TMsg }

uses
  c_DBTypes;

constructor TMsg.Create;
begin
  FSysSprache := TSysSprache.Create(nil);
end;

destructor TMsg.Destroy;
begin
  FreeAndNil(FSysSprache);
  inherited;
end;

function TMsg.Msg(AOwner: TComponent; aMessageText: string;
  DlgType: TMsgDlgType; Buttons: array of TMsgDlgBtn;
  aDefaultButton: TMsgDlgBtn): Integer;
begin
  FSysSprache.ReadByGuid(aMessageText);
  if FSysSprache.Id > 0 then
    aMessageText := FSysSprache.Feld(SysSP_Msg).AsString;
  Result := Tfrm_MessageDialog.Msg(AOwner, aMessageText, DlgType, Buttons, aDefaultButton);
end;

function TMsg.Msg(AOwner: TComponent; aMessageText: string;
  DlgType: TMsgDlgType; Buttons: array of TMsgDlgBtn): Integer;
begin
  FSysSprache.ReadByGuid(aMessageText);
  if FSysSprache.Id > 0 then
    aMessageText := FSysSprache.Feld(SysSP_Msg).AsString;
  Result := Tfrm_MessageDialog.Msg(AOwner, aMessageText, DlgType, Buttons);
end;

function TMsg.Msg(AOwner: TComponent; aMessageText: string;
  DlgType: TMsgDlgType; Buttons: array of TMsgDlgBtn;
  aDefaultButton: TMsgDlgBtn; aButtontext: array of String): Integer;
begin
  Result := Tfrm_MessageDialog.Msg(AOwner, aMessageText, DlgType, Buttons, aDefaultButton, aButtontext);
end;

function TMsg.Msg(AOwner: TComponent; aMessageText: string;
  DlgType: TMsgDlgType; Buttons: array of TMsgDlgBtn;
  aHelpctx: Integer): Integer;
begin
  Result := Tfrm_MessageDialog.Msg(AOwner, aMessageText, DlgType, Buttons, aHelpctx);
end;

function TMsg.MsgConfirm(AOwner: TComponent; aMessageText: string;
  DlgType: TMsgDlgType; Buttons: array of Integer;
  aDefaultButton: TMsgDlgBtn): Integer;
begin
  Result := MsgConfirm(AOwner, aMessageText, DlgType, Buttons, aDefaultButton);
end;

end.
