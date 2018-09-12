unit u_dm;

interface

uses
  SysUtils, Classes, ImgList, Controls, Menus, obBusinessClasses, obServerClient,
  o_SysObj;

type
  Tdm = class(TDataModule, IObServerClient)
    Img_Small: TImageList;
    Img_32x32: TImageList;
    Pop_Btn: TPopupMenu;
    btn_Eigenschaften: TMenuItem;
    N1: TMenuItem;
    btn_Delete: TMenuItem;
    procedure DataModuleCreate(Sender: TObject);
    procedure btn_EigenschaftenClick(Sender: TObject);
    procedure btn_DeleteClick(Sender: TObject);
  private
    FButtonPropId: Integer;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
  public
  end;

var
  dm: Tdm;

implementation

{$R *.dfm}

{ Tdm }

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  SysObj.ObServer.RegisterNotifications(Self, [ntObChangeItems]);
  FButtonPropId := -1;
end;

procedure Tdm.btn_DeleteClick(Sender: TObject);
begin
  sysobj.ObServer.Notify(ntobFrames, NTA_DELETECLICK, FButtonPropId);
end;

procedure Tdm.btn_EigenschaftenClick(Sender: TObject);
begin
  sysobj.ObServer.Notify(ntobFrames, NTA_EIGENSCHAFTENCLICK, FButtonPropId);
end;

procedure Tdm.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
begin
  if AType = ntObChangeItems then
  begin
    if Action = NTA_CHANGEBUTTONID then
      FButtonPropId := Data;
  end;
end;

end.
