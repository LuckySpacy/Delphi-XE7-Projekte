unit of_Link;

interface

uses
  SysUtils, Classes, Forms, StdCtrls, Buttons, of_Base, c_Types,
  ExtCtrls, Dialogs, o_sysObj, Controls, obBusinessClasses, obServerClient,
  tbButton, Contnrs, IBDatabase, fr_Base, Menus, o_seite, o_seiteverbinden,
  o_seitedokumentlink, o_seitedokument, o_seitedokumentlist, o_seitelink;


type
  Tof_Link = class(Tof_Base, IObServerClient)
  private
    FQuellSeite: TSeite;
    FLinkSeite: TSeite;
    FQuellBaumButtonEbene: Integer;
    FQuellBaumZweigId: Integer;
    FQuellSeiteVerbinden: TSeiteverbinden;
    FSeiteDokumentLink: TSeiteDokumentLink;
    FSeiteDokument: TSeiteDokument;
    FSeiteDokumentList: TSeiteDokumentList;
    FSeiteLink: TSeiteLink;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure RegisterNotify;
    procedure UnregisterNotify;
  protected
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    property QuellBaumButtonEbene: Integer read FQuellBaumButtonEbene write FQuellBaumButtonEbene;
    property QuellBaumZweigId: Integer read FQuellBaumZweigId write FQuellBaumZweigId;
  end;


implementation

{ Tof_Link }

uses
  c_DBTypes;

constructor Tof_Link.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  FQuellSeite := nil;
  FQuellSeiteVerbinden := nil;
  FQuellBaumButtonEbene := 0;
  FQuellBaumZweigId := 0;
  RegisterNotify;
  FQuellSeite := TSeite.Create(nil);
  FQuellSeiteVerbinden := TSeiteverbinden.Create(nil);
  FLinkSeite := TSeite.Create(nil);
  FSeiteDokumentLink := TSeiteDokumentLink.Create(nil);
  FSeiteDokument := TSeiteDokument.Create(nil);
  FSeiteDokumentList := TSeiteDokumentList.Create(nil);
  FSeiteLink := TSeiteLink.Create(nil);
end;

destructor Tof_Link.Destroy;
begin
  FreeAndNil(FQuellSeite);
  FreeAndNil(FQuellSeiteVerbinden);
  FreeAndNil(FLinkSeite);
  FreeAndNil(FSeiteDokumentLink);
  FreeAndNil(FSeiteDokument);
  FreeAndNil(FSeiteDokumentList);
  FreeAndNil(FSeiteLink);
  UnregisterNotify;
  inherited;
end;

procedure Tof_Link.RegisterNotify;
begin
  SysObj.ObServer.RegisterNotifications(Self, [ntobBearb]);
end;

procedure Tof_Link.UnregisterNotify;
begin
  if SysObj <> nil then
    SysObj.ObServer.UnregisterNotifications(Self);
end;


procedure Tof_Link.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
var
  i1: Integer;
begin
  if AType = ntobBearb then
  begin
    if (Action = NTA_LINK_ADD) then
    begin
      FQuellSeiteVerbinden.Read(FQuellBaumButtonEbene, FQuellBaumZweigId);
      if not FQuellSeiteVerbinden.Found then
        exit;
      FQuellSeite.Read(FQuellSeiteVerbinden.Feld(VS_SE_ID).AsInteger);
      if not FQuellSeite.Found then
        exit;
      FQuellSeiteVerbinden.Read(SysObj.Akt.BaumButtonEbene, SysObj.Akt.BaumZweigId);
      if not FQuellSeiteVerbinden.Found then
        exit;

      FLinkSeite.Read(FQuellSeiteVerbinden.Feld(VS_SE_ID).AsInteger);
      if not FLinkSeite.Found then
        exit;

      FSeiteLink.Read(FQuellSeite.Id, FLinkSeite.Id, csl_Dokument);
      if FSeiteLink.Found then
      begin
        ShowMessage('Seite wurde bereits mit dieser Seite verlinkt');
        exit;
      end;


      FSeiteLink.Init;
      FSeiteLink.Feld(KS_SE_ID).AsInteger := FQuellSeite.Id;
      FSeiteLink.Feld(KS_SE_ID_LINK).AsInteger := FQuellSeiteVerbinden.Seite.Id;
      FSeiteLink.Feld(KS_TYP).AsInteger        := ord(csl_Dokument);
      FSeiteLink.Save;

      FSeiteDokumentList.ReadAll(FLinkSeite.Id);
      for i1 := 0 to FSeiteDokumentList.Count -1 do
      begin
        FSeiteDokumentLink.Read(FQuellSeite.Id, FSeiteDokumentList.Item[i1].Dokument.Id);
        if (FSeiteDokumentLink.Found) and (FSeiteDokumentLink.Feld(SK_VERLINKT).AsBoolean) then
          continue;
        if (FSeiteDokumentLink.Found) and (not FSeiteDokumentLink.Feld(SK_VERLINKT).AsBoolean) then
        begin
          FSeiteDokumentLink.Feld(SK_VERLINKT).AsBoolean := true;
          FSeiteDokumentLink.Save;
          continue;
        end;
        FSeiteDokumentLink.Init;
        FSeiteDokumentLink.Feld(SK_SE_ID).AsInteger := FQuellSeite.Id;
        FSeiteDokumentLink.Feld(SK_SE_ID_LINK).AsInteger := FSeiteDokumentList.Item[i1].Seite.id;
        FSeiteDokumentLink.Feld(SK_DO_ID).AsInteger := FSeiteDokumentList.Item[i1].Dokument.Id;
        FSeiteDokumentLink.Feld(SK_VERLINKT).AsBoolean := true;
        FSeiteDokumentLink.Save;
      end;
      ShowMessage('Seite verlinkt');
    end;
  end;
  if (Action = NTA_LINK_ADD_DOK) then
  begin
    FQuellSeiteVerbinden.Read(FQuellBaumButtonEbene, FQuellBaumZweigId);
    if not FQuellSeiteVerbinden.Found then
      exit;
    FQuellSeite.Read(FQuellSeiteVerbinden.Feld(VS_SE_ID).AsInteger);
    if not FQuellSeite.Found then
      exit;
    FQuellSeiteVerbinden.Read(SysObj.Akt.BaumButtonEbene, SysObj.Akt.BaumZweigId);
    if not FQuellSeiteVerbinden.Found then
      exit;

    FLinkSeite.Read(FQuellSeiteVerbinden.Feld(VS_SE_ID).AsInteger);
    if not FLinkSeite.Found then
      exit;

    FSeiteLink.Read(FQuellSeite.Id, FLinkSeite.Id, csl_Dokument);
    {
    if FSeiteLink.Found then
    begin
      ShowMessage('Seite wurde bereits mit dieser Seite verlinkt');
      exit;
    end;
     }

    FSeiteDokumentLink.Read(FQuellSeite.Id, Data);
    if (FSeiteDokumentLink.Found) and (FSeiteDokumentLink.Feld(SK_VERLINKT).AsBoolean) then
    begin
      ShowMessage('Dokument ist bereits verlinkt');
      exit;
    end;

    if (FSeiteDokumentLink.Found) and (not FSeiteDokumentLink.Feld(SK_VERLINKT).AsBoolean) then
    begin
      FSeiteDokumentLink.Feld(SK_VERLINKT).AsBoolean := true;
      FSeiteDokumentLink.Save;
      ShowMessage('Dokument wurde verlinkt');
      exit;
    end;

    FSeiteDokumentLink.Init;
    FSeiteDokumentLink.Feld(SK_SE_ID).AsInteger      := FQuellSeite.Id;
    FSeiteDokumentLink.Feld(SK_SE_ID_LINK).AsInteger := FLinkSeite.Id;
    FSeiteDokumentLink.Feld(SK_DO_ID).AsInteger      := Data;
    FSeiteDokumentLink.Feld(SK_VERLINKT).AsBoolean   := true;
    FSeiteDokumentLink.Save;
    ShowMessage('Dokument wurde verlinkt');

  end;

end;

end.
