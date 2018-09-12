unit of_ZweigProp;

interface

uses
  SysUtils, Classes, Forms, StdCtrls, Buttons, of_Base, c_Types,
  ExtCtrls, Dialogs, o_sysObj, Controls, obBusinessClasses, obServerClient,
  tbButton, o_OrdnertypList, o_OrdnerTyp, o_ZweigProp, o_BaumStruk,
  IBDatabase;

type
  Tof_ZweigProp = class(Tof_Base, IObServerClient)
  private
    Fedt_Text: TCustomEdit;
    //FBtn_Bild: TTBButton;
    FTrans: TIBTransaction;
    FBildId: Integer;
    FZweigProp: TZweigProp;
    FBaumStruk: TBaumStruk;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
   // procedure BildClick(Sender: TObject);
    procedure RegisterNotify;
    procedure UnregisterNotify;
  protected
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    procedure Load;
    procedure Save;
  end;


implementation

{ Tof_OrdnerProp }

uses
  c_DBTypes, o_Bilder, o_seite, o_seiteverbinden, u_Allgfunc;

constructor Tof_ZweigProp.Create(AOwner: TComponent; AMode: TModus);
//var
//  i1: Integer;
begin
  inherited Create(AOwner, AMode);
  FTrans := TIBTransaction.Create(Self);
  FTrans.DefaultDatabase := SysObj.Database;
  FTrans.Name := 'Trans_of_ZweigProp';
  FEdt_Text   := getCustomEdit('edt_Text');
  //FBtn_Bild   := gettbButton('btn_Bild');
  //FBtn_Bild.OnClick := BildClick;
  FBildId := -1;
  FZweigProp := TZweigProp.Create(Self);
  FZweigProp.Trans := FTrans;
  FBaumStruk := TBaumStruk.Create(Self);
  FBaumStruk.Trans := FTrans;
  RegisterNotify;
end;

destructor Tof_ZweigProp.Destroy;
begin
  FreeAndNil(FZweigProp);
  FreeAndNil(FBaumStruk);
  FreeAndNil(FTrans);
  UnregisterNotify;
  inherited;
end;

procedure Tof_ZweigProp.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
begin

end;


procedure Tof_ZweigProp.RegisterNotify;
begin
  SysObj.ObServer.RegisterNotifications(Self, [ntObFrames, ntObChangeItems]);
end;

procedure Tof_ZweigProp.UnregisterNotify;
begin
  SysObj.ObServer.UnregisterNotifications(Self);
end;


procedure Tof_ZweigProp.Load;
begin
  Fedt_Text.Text :=  '';
  FBildId := -1;
  FZweigProp.Init;
  FBaumStruk.Init;
  if FObjectId <= -1 then
    exit;
  if BearbArt = cNeu then
    exit;
  FBaumStruk.Read(FObjectId);
  if not FBaumstruk.Found then
    exit;
  FZweigProp.Read(FBaumStruk.Feld(BS_ZP_ID).AsInteger);
  if not FZweigProp.Found then
    exit;
  Fedt_Text.Text := FZweigProp.Feld(ZP_TEXT).AsString;
end;


procedure Tof_ZweigProp.Save;
var
  EbeneId: Integer;
  Seite: TSeite;
  Seiteverbinden: TSeiteverbinden;
  KonfList: TStringList;
begin
  if not FTrans.InTransaction then
    FTrans.StartTransaction;
  try
    if BearbArt = cNeu then
    begin
      FBaumStruk.Init;
      FZweigProp.Init;
      EbeneId := FObjectId;
      if (FObjectId <= -1) then
        EbeneId := 0;

      FZweigProp.Feld(ZP_TEXT).AsString   := Trim(Fedt_Text.Text);
      FZweigProp.Feld(ZP_BI_ID).AsInteger := -1;
      FZweigProp.Save;
      FBaumStruk.Feld(BS_EBENE).AsInteger := EbeneId;
      FBaumStruk.Feld(BS_ZP_ID).AsInteger := FZweigProp.Id;
      FBaumStruk.Feld(BS_BB_ID).AsInteger := sysObj.Akt.BaumButtonEbene;
      FBaumStruk.Save;

      KonfList := TStringList.Create;
      Seite := TSeite.Create(nil);
      Seiteverbinden := TSeiteverbinden.Create(nil);
      try
        KonfList.Delimiter := ';';
        KonfList.DelimitedText := SysObj.Einstellung.KonfSeite.AsBlob;
        Seite.Feld(SE_HEADERHEIGHT).AsInteger := 42;
        if SysObj.Einstellung.KonfSeite.AsBlob > '' then
        begin
          Seite.Feld(SE_HEADERHEIGHT).AsInteger := tbStrToInt(KonfList.Values['HEADERHEIGHT'], 42);
          Seite.Feld(SE_HEADER_ANZEIGEN).AsBoolean := KonfList.Values['KOPFAUSBLENDEN'] <> 'T';
          Seite.Feld(SE_HEADER).AsString := SysObj.Einstellung.KonfSeite.AsBlob2;
          Seite.Feld(SE_BODY).AsString   := SysObj.Einstellung.KonfSeite.AsBlob3;
        end;

        Seite.Save;
        Seiteverbinden.Feld(VS_SE_ID).AsInteger := Seite.Id;
        Seiteverbinden.Feld(VS_EBENE).AsInteger := SysObj.Akt.BaumButtonEbene;
        Seiteverbinden.Feld(VS_BS_ID).AsInteger := FBaumStruk.Id;
        Seiteverbinden.Save;
      finally
        FreeAndNil(KonfList);
        FreeAndNil(Seite);
        FreeAndNil(Seiteverbinden);
      end;

    end;
    if BearbArt = cBearb then
    begin
      FZweigProp.Feld(ZP_TEXT).AsString   := Trim(Fedt_Text.Text);
      FZweigProp.Feld(ZP_BI_ID).AsInteger := -1;
      FZweigProp.Save;
    end;
    if FTrans.InTransaction then
      FTrans.Commit;
  except
    if FTrans.InTransaction then
      FTrans.Rollback;
  end;
end;




end.
