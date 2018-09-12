unit of_OrdnerProp;

interface

uses
  SysUtils, Classes, Forms, StdCtrls, Buttons, of_Base, c_Types,
  ExtCtrls, Dialogs, o_sysObj, Controls, obBusinessClasses, obServerClient,
  tbButton, o_OrdnertypList, o_OrdnerTyp, o_ButtonProp, o_BaumButton,
  IBDatabase;

type
  Tof_OrdnerProp = class(Tof_Base, IObServerClient)
  private
    Fedt_Text: TCustomEdit;
    Fcmb_Typ : TCombobox;
    Fchb_PW  : TCheckBox;
    FOrdnerTypList: TOrdnerTypList;
    FButtonProp: TButtonProp;
    FBaumButton: TBaumButton;
    FBtn_Bild: TTBButton;
    FTrans: TIBTransaction;
    FBildId: Integer;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure BildClick(Sender: TObject);
    procedure CheckBoxPWClick(Sender: TObject);
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
  c_DBTypes, o_Bilder, fnt_MasterPW;



constructor Tof_OrdnerProp.Create(AOwner: TComponent; AMode: TModus);
var
  i1: Integer;
begin
  inherited Create(AOwner, AMode);
  FTrans := TIBTransaction.Create(Self);
  FTrans.DefaultDatabase := SysObj.Database;
  FTrans.Name := 'Trans_of_OrdnerProp';
  FButtonProp := TButtonProp.Create(Self);
  FBaumButton := TBaumButton.Create(Self);
  FBtn_Bild   := gettbButton('btn_Bild');
  FBtn_Bild.OnClick := BildClick;
  FButtonProp.Trans := FTrans;
  FBaumButton.Trans := FTrans;
  FEdt_Text := getCustomEdit('edt_Text');
  Fcmb_Typ  := getCombobox('cmb_Typ');
  FEdt_Text.Text := '';
  FOrdnerTypList := TOrdnerTypList.Create(Self);
  Fchb_PW := getCheckBox('chb_PW');
  Fchb_PW.OnClick := CheckBoxPWClick;
  Fcmb_Typ.Clear;
  for i1 := 0 to FOrdnerTypList.Count - 1 do
  begin
    Fcmb_Typ.AddItem(FOrdnerTypList.Item[i1].Text, TOrdnerTyp(FOrdnerTypList.Item[i1]));
  end;
  if Fcmb_Typ.Items.Count > 0 then
    Fcmb_Typ.ItemIndex := 0;

  Fcmb_Typ.Enabled := true;
  if SysObj.Akt.BaumButtonEbene = 0 then
    Fcmb_Typ.Enabled := false;


  FBildId := -1;

  RegisterNotify;

end;


destructor Tof_OrdnerProp.Destroy;
begin
  FreeAndNil(FBaumButton);
  FreeAndNil(FButtonProp);
  FreeAndNil(FOrdnerTypList);
  FreeAndNil(FTrans);
  UnregisterNotify;
  inherited;
end;

procedure Tof_OrdnerProp.RegisterNotify;
begin
  SysObj.ObServer.RegisterNotifications(Self, [ntObFrames, ntObChangeItems]);
end;

procedure Tof_OrdnerProp.UnregisterNotify;
begin
  SysObj.ObServer.UnregisterNotifications(Self);
end;




{
procedure Tof_OrdnerProp.Load(aObjectId: Integer);
begin
  FButtonProp.Read(aObjectId);
  FEdt_Text.Text := FButtonProp.Feld(BP_TEXT).AsString;
  if FButtonProp.ItemList.Feld(IT_INDEX).asInteger > -1 then
    Fcmb_Typ.ItemIndex := FButtonProp.ItemList.Feld(IT_INDEX).AsInteger;
end;
}

procedure Tof_OrdnerProp.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
var
  Bild: TBilder;
begin
  if FMode <> sysobj.Akt.Modus then
    exit;
  if AType = ntObFrames then
  begin
    if Action = NTA_EIGENSCHAFTENCLICK then
      FObjectId := Data;
  end;
  if AType = ntObChangeItems then
  begin
    if Action = NTA_CLICK_BILD then
    begin
      Bild := TBilder.Create(Self);
      try
        Bild.Read(Data);
        Fbtn_Bild.setIcon(Bild.Feld(BI_BILD).Ico.AsIcon);
        FBildId := Bild.Id;
      finally
        FreeAndNil(Bild);
      end;
    end;
  end;
end;





procedure Tof_OrdnerProp.Save;
begin
  if not FTrans.InTransaction then
    FTrans.StartTransaction;
  try
    FButtonProp.Init;
    if FObjectId > 0 then
      FButtonProp.Read(FObjectId);
    FButtonProp.Feld(BP_TEXT).AsString   := FEdt_Text.Text;
    FButtonProp.Feld(BP_IT_ID).AsInteger := TOrdnerTyp(Fcmb_Typ.Items.Objects[Fcmb_Typ.ItemIndex]).Id;
    FButtonProp.Feld(BP_BI_ID).AsInteger := FBildId;
    FButtonProp.Feld(BP_USEPW).AsBoolean := Fchb_PW.Checked;
    FButtonProp.Save;
    if FObjectId <= 0 then
    begin
      FBaumButton.Init;
      FBaumButton.Feld(BB_EBENE).AsInteger  := SysObj.Akt.BaumButtonEbene;
      FBaumButton.Feld(BB_BP_ID).AsInteger  := FButtonProp.Id;
      FBaumButton.Save;
    end;
    if FTrans.InTransaction then
      FTrans.Commit;
  except
    if FTrans.InTransaction then
      FTrans.Rollback;
  end;
end;



procedure Tof_OrdnerProp.BildClick(Sender: TObject);
begin
  sysobj.ObServer.Notify(ntobForms, NTA_SHOW_BILDER, 0);
end;



procedure Tof_OrdnerProp.Load;
begin
  FBildId := -1;
  FButtonProp.Init;
  if FObjectId <= -1 then
    exit;
  FButtonProp.Read(FObjectId);
  if not FButtonProp.Found then
    exit;
  Fedt_Text.Text := FButtonProp.Feld(BP_TEXT).AsString;
  Fchb_PW.Checked := FButtonProp.Feld(BP_USEPW).AsBoolean;
  if (FButtonProp.ItemList.Id > 0) and (FButtonProp.ItemList.Feld(IT_INDEX).AsInteger <= Fcmb_Typ.Items.Count -1) then
    Fcmb_Typ.ItemIndex := FButtonProp.ItemList.Feld(IT_INDEX).AsInteger;

  if FButtonProp.Icon <> nil then
  begin
    FBtn_Bild.setIcon(FButtonProp.Icon);
    FBildId := FButtonProp.Bilder.Id;
  end;
end;


procedure Tof_OrdnerProp.CheckBoxPWClick(Sender: TObject);
var
  Form: Tfrm_MasterPW;
begin
  if not TCheckBox(Sender).Checked then
    exit;
  if SysObj.Benutzer.Feld(BE_PW).AsString = '' then
  begin
    ShowMessage('Es wurde noch kein Passwort festgelegt!' + sLineBreak +
                'Bitte legen Sie jetzt ein Passwort an.');
    Form := Tfrm_MasterPW.Create(Self);
    try
      Form.ShowModal;
    finally
      FreeAndNil(Form);
    end;
  end;
  if SysObj.Benutzer.Feld(BE_PW).AsString = '' then
  begin
    TCheckBox(Sender).Checked := false;
    exit;
  end;
end;


end.
