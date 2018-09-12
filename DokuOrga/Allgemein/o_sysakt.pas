unit o_sysakt;

interface

uses
  SysUtils, Classes, IBDatabase, IBQuery, obBusinessClasses, obServerClient, c_types;


type
  TSysAkt = class(TComponent, IObServerClient)
  private
    FSprachId: Integer;
    FBaumButtonEbene: Integer;
    FBaumZweigEbene: Integer;
    FBaumZweigId: Integer;
    FModus: TModus;
    procedure setBaumButtonEbene(const Value: Integer);
    procedure SetBaumZweigId(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SprachId: Integer read FSprachId write FSprachId;
    property BaumButtonEbene: Integer read FBaumButtonEbene write setBaumButtonEbene;
    property BaumZweigEbene: Integer read FBaumZweigEbene write FBaumZweigEbene;
    property BaumZweigId: Integer read FBaumZweigId write SetBaumZweigId;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    property Modus: TModus read FModus write FModus;
  end;


implementation

{ TSysAkt }

uses
  o_SysObj, Dialogs;

constructor TSysAkt.Create(AOwner: TComponent);
begin
  inherited;
  FSprachId := 1;
  FModus := cUnbekannt;
end;

destructor TSysAkt.Destroy;
begin

  inherited;
end;

procedure TSysAkt.ObServerNotification(AType: TNotificationType; Action, Data: Integer);
begin

end;

procedure TSysAkt.setBaumButtonEbene(const Value: Integer);
begin
  if Value = FBaumButtonEbene then
    exit;
  FBaumButtonEbene := Value;
  FBaumZweigId := 0;
  if FModus = cUnbekannt then
    ShowMessage('Modus ist Unbekannt');
  SysObj.ObServer.Notify(ntobBearb, NTA_BAUMEBENE_CHANGED, 1);
end;

procedure TSysAkt.SetBaumZweigId(const Value: Integer);
begin
  if Value = FBaumZweigId then
    exit;
  FBaumZweigId := Value;
  SysObj.ObServer.Notify(ntobBearb, NTA_BAUMEBENE_CHANGED, 0);
end;

end.
