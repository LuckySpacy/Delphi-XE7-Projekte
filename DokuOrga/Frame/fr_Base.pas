unit fr_Base;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, of_Base, obBusinessClasses, obServerClient, c_types;

type
  Tfrm_Base = class(TFrame, IObServerClient)
  private
    procedure setBaseObj(const Value: Tof_Base);
  protected
    FOnShow: TNotifyEvent;
    FOnVisible: TNotifyEvent;
    FOnVisibleChanged: TNotifyEvent;
    FOnHide: TNotifyEvent;
    FofBase: Tof_Base;
    FModus: TModus;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure CMVISIBLECHANGED(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer); virtual;
  public
    constructor Create(AOwner: TComponent); reintroduce; overload;
    constructor Create(AOwner: TComponent; AMode: TModus); reintroduce; overload; virtual;
    destructor Destroy; override;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnVisible: TNotifyEvent read FOnVisible write FOnVisible;
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
    property OnVisibleChanged: TNotifyEvent Read FOnVisibleChanged write FOnVisibleChanged;
    property BaseObj: Tof_Base read FofBase write setBaseObj;
  end;

implementation

{$R *.dfm}

{ Tfrm_Base }

uses
  o_sysobj;


constructor Tfrm_Base.Create(AOwner: TComponent);
begin
  {
  inherited Create(AOwner);
  FofBase := nil;
  ShowMessage('Falsche Frame Constructor');
  }
  Create(AOwner, sysobj.Akt.Modus);
end;

constructor Tfrm_Base.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner);
  FofBase := nil;
  FModus := AMode;
end;


destructor Tfrm_Base.Destroy;
begin

  inherited;
end;



procedure Tfrm_Base.setBaseObj(const Value: Tof_Base);
begin
  FofBase := Value;
end;

procedure Tfrm_Base.CMShowingChanged(var Message: TMessage);
begin
  inherited;
  if Showing then
    if Assigned(FOnShow) then
      FOnShow(Self);
end;

procedure Tfrm_Base.CMVISIBLECHANGED(var Message: TMessage);
begin
  inherited;
  if Assigned(FOnVisibleChanged) then
    FOnVisibleChanged(Self);
  if Visible then
  begin
    if Assigned(FOnVisible) then
      FOnVisible(Self);
    if FofBase <> nil then
      fofBase.VisibleChanged(true);
  end
  else
  begin
    if Assigned(FOnHide) then
      FOnHide(Self);
    if FofBase <> nil then
      fofBase.VisibleChanged(false);
  end;
end;


procedure Tfrm_Base.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
begin

end;


end.
