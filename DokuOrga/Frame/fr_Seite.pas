unit fr_Seite;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fr_Base, ComCtrls, obBusinessClasses, obServerClient, fr_SeiteInhalt,
  fr_Dokumente, fr_SeiteEinstellung, c_types;

type
  Tfra_Seite = class(Tfrm_Base, IObServerClient)
    PageControl: TPageControl;
    tbs_Seite: TTabSheet;
    tbs_Dokument: TTabSheet;
    tbs_Einstellung: TTabSheet;
  private
    FInhalt: Tfra_SeiteInhalt;
    FDoku: Tfra_Dokumente;
    FSeiteEinstellung: Tfra_SeiteEinstellung;
    FGesperrt_Ebene: Integer;
    FGesperrt_Zweig: Integer;
  protected
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer); override;
  public
    procedure RegisterNotify;
    procedure UnregisterNotify;
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;

var
  fra_Seite: Tfra_Seite;

implementation

{$R *.dfm}

{ Tfra_Seite }

uses
  o_sysobj;


constructor Tfra_Seite.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  FInhalt := Tfra_SeiteInhalt.Create(Self, AMode);
  FInhalt.Parent := tbs_Seite;
  FInhalt.Align  := alClient;
  FDoku := Tfra_Dokumente.Create(Self, AMode);
  FDoku.Parent := tbs_Dokument;
  FDoku.Align  := alClient;
  FSeiteEinstellung := Tfra_SeiteEinstellung.Create(Self);
  FSeiteEinstellung.Parent := tbs_Einstellung;
  FSeiteEinstellung.Align  := alClient;

  if SysObj.Akt.Modus = cLink then
    tbs_Einstellung.TabVisible := false;

  RegisterNotify;
end;

destructor Tfra_Seite.Destroy;
begin
  FreeAndNil(FInhalt);
  FreeAndNil(FDoku);
  FreeAndNil(FSeiteEinstellung);
  UnregisterNotify;
  inherited;
end;

procedure Tfra_Seite.RegisterNotify;
begin
  SysObj.ObServer.RegisterNotifications(Self, [ntobBearb]);
end;

procedure Tfra_Seite.UnregisterNotify;
begin
  if SysObj <> nil then
    SysObj.ObServer.UnregisterNotifications(Self);
end;


procedure Tfra_Seite.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
begin
  inherited;
  if FModus <> sysobj.Akt.Modus then
    exit;
  if AType = ntobBearb then
  begin
    if (Action = NTA_BAUMEBENE_CHANGED) or (Action = NTA_BAUMZWEIG_CHANGED) then
    begin
      if  (FGesperrt_Ebene = SysObj.Akt.BaumButtonEbene)
      and (FGesperrt_Zweig = SysObj.Akt.BaumZweigId) then
        exit;
      PageControl.Enabled := true;
    end;
    if (Action = NTA_SEITE_SPERREN) then
    begin
      PageControl.Enabled := false;
      FGesperrt_Ebene := SysObj.Akt.BaumButtonEbene;
      FGesperrt_Zweig := SysObj.Akt.BaumZweigId;
    end;
  end;
end;


end.
