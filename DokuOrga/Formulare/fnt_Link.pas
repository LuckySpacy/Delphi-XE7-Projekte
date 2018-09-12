unit fnt_Link;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, of_link, fr_Ordner, obBusinessClasses, obServerClient,
  fr_Seite, fr_Zweig, fr_DashToolbar;

type
  Tfrm_Link = class(TForm, IObServerClient)
    pnl_Left: TPanel;
    pnl_client: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Fof_Link: Tof_Link;
    FOrdner: Tfra_Ordner;
    FZweig : Tfra_Zweig;
    FSeite : Tfra_Seite;
    FDashToolbar: Tfra_DashToolbar;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure CreateZweig;
  public
    property Link: Tof_Link read Fof_Link write Fof_Link;
  end;

var
  frm_Link: Tfrm_Link;

implementation

{$R *.dfm}

uses
  o_sysobj;

procedure Tfrm_Link.FormCreate(Sender: TObject);
begin

  FDashToolbar := Tfra_DashToolbar.Create(Self);
  FDashToolbar.Parent := Self;
  FDashToolbar.Align  := alTop;
  FDashToolbar.btn_Neu.Visible := false;
  FDashToolbar.btn_Save.Visible := false;
  FDashToolbar.btn_Export.Visible := false;
  FDashToolbar.btn_Import.Visible := false;
  FDashToolbar.btn_Eigenschaften.Visible := false;

  Fof_Link := Tof_Link.Create(Self, SysObj.Akt.Modus);
  FOrdner := Tfra_Ordner.Create(Self, SysObj.Akt.Modus);
  FOrdner.Parent := pnl_Left;
  FOrdner.Align  := alClient;
  FOrdner.Visible := true;

  FSeite := Tfra_Seite.Create(Self, SysObj.Akt.Modus);
  FSeite.Parent := Self;
  FSeite.Align  := alClient;

  CreateZweig;

  SysObj.Akt.BaumButtonEbene := 0;
  SysObj.ObServer.Notify(ntobBearb, NTA_BAUMEBENE_CHANGED, 1);
  SysObj.ObServer.RegisterNotifications(Self, [ntobBearb, ntobFrames, ntobForms]);


end;

procedure Tfrm_Link.FormDestroy(Sender: TObject);
begin
  if SysObj <> nil then
    SysObj.ObServer.UnregisterNotifications(Self);
  FreeAndNil(FOrdner);
  FreeAndNil(FSeite);
  if FZweig <> nil then
    FreeAndNil(FZweig);
  FreeAndNil(Fof_Link);
end;

procedure Tfrm_Link.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
begin
  if AType = ntobBearb then
  begin
    if Action = NTA_BAUM_VISIBLE then
    begin
      if Data = 0 then
      begin
        FOrdner.Visible := true;
        FZweig.Visible  := false;
      end;
      if Data = 1 then
      begin
        FOrdner.Visible := false;
        FZweig.Visible  := true;
        SysObj.Akt.BaumZweigEbene := SysObj.Akt.BaumButtonEbene;
        FZweig.Zweig.Aktual(0);
        FZweig.vt.SetFocus;
      end;
    end;
  end;
end;


procedure Tfrm_Link.CreateZweig;
begin
  if FZweig <> nil then
    FreeAndNil(FZweig);
  FZweig := Tfra_Zweig.Create(Self);
  FZweig.Parent := pnl_Left;
  FZweig.Align  := alClient;
  FZweig.Name := 'fr_Zweig';
  FZweig.Visible := false;
end;


end.
