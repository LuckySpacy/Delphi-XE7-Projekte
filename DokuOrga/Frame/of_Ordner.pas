unit of_Ordner;

interface

uses
  SysUtils, Classes, Forms, StdCtrls, Buttons, of_Base, c_Types,
  ExtCtrls, Dialogs, o_sysObj, Controls, obBusinessClasses, obServerClient,
  tbButton, o_BaumButtonList, Contnrs, o_btnOrdner, o_ButtonProp, IBDatabase,
  o_BaumButton, fr_Base, System.UITypes;

type
  Tof_Ordner = class(Tof_Base, IObServerClient)
  private
    FScrollbox: TScrollbox;
    FBaumButtonList: TBaumButtonList;
    FButtonList: TObjectList;
    FButtonProp: TButtonProp;
    FTrans: TIBTransaction;
    FBaumButton: TBaumButton;
    FBaseFrame: Tfrm_Base;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure Aktual;
    procedure ButtonClick(Sender: TObject);
    procedure FolderReturn;
  protected
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    procedure UnregisterNotify;
    procedure RegisterNotify;
  end;



implementation

{ Tof_Ordner }

uses
  c_DBTypes, fnt_Passwort, o_deletebaum;



constructor Tof_Ordner.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  FTrans := TIBTransaction.Create(Self);
  FTrans.DefaultDatabase := SysObj.Database;
  FScrollbox := getScrollbox('Scrollbox');
  FBaumButtonList := TBaumButtonList.Create(Self);
  FButtonProp := TButtonProp.Create(Self);
  RegisterNotify;
  FButtonList := TObjectList.Create;
  FBaumButton := TBaumButton.Create(Self);
  FBaseFrame := nil;
  if AOwner is Tfrm_Base then
  begin
    FBaseFrame := Tfrm_Base(AOwner);
  end;
  Aktual;
end;

destructor Tof_Ordner.Destroy;
begin
  FreeAndNil(FButtonProp);
  FreeAndNil(FButtonList);
  FreeAndNil(FBaumButtonList);
  FreeAndNil(FTrans);
  FreeAndNil(FBaumButton);
  UnregisterNotify;
  inherited;
end;



procedure Tof_Ordner.RegisterNotify;
begin
  SysObj.ObServer.RegisterNotifications(Self, [ntobFrames, ntobBearb]);
end;


procedure Tof_Ordner.UnregisterNotify;
begin
  if SysObj <> nil then
    SysObj.ObServer.UnregisterNotifications(Self)
end;

procedure Tof_Ordner.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
var
  BaumButtonList: TBaumButtonList;
  i1: Integer;
  BaumButton: TBaumButton;
  Buttonprop: TButtonprop;
  DeleteBaum: TDeleteBaum;
begin
  if FMode <> SysObj.Akt.Modus then
    exit;
  if AType = ntobFrames then
  begin
    if Action = NTA_AKTUAL then
    begin
      if (FBaseFrame <> nil) and FBaseFrame.Visible then
        Aktual;
    end;
  end;
  if AType = ntObFrames then
  begin
    if Action = NTA_DELETECLICK then
    begin
      FObjectId := Data;

      if SysObj.Msg.Msg(Self, '{EF3F72B3-EEC3-49A8-A483-E0E51D0D1452}', mtConfirmation, [mbYes, mbNo]) = mrNo then
        exit;

      DeleteBaum := TDeleteBaum.Create(nil);
      try
        DeleteBaum.DeleteBaumButton(FObjectId, nil);
      finally
        FreeAndNil(DeleteBaum);
      end;

      Aktual;
      exit;


      Buttonprop := TButtonprop.Create(nil);
      BaumButtonList := TBaumButtonList.Create(nil);
      try
        BaumButtonList.ReadAllEbenen(FObjectId);
        for i1 := 0 to BaumButtonList.Count -1 do
        begin
          BaumButton := BaumButtonList.Item[i1];
          Buttonprop.Read(BaumButton.Feld(BB_BP_ID).AsInteger);
          ShowMessage(Buttonprop.Feld(BP_TEXT).AsString);
        end;
        if BaumButtonList.Count = 0 then
          exit;
        if BaumButtonList.Count = 1 then
        begin
          if SysObj.Msg.Msg(Self, '{EF3F72B3-EEC3-49A8-A483-E0E51D0D1452}', mtConfirmation, [mbYes, mbNo]) = mrNo then
            exit;
          if MessageDlg('Es werden auch alle Untereinträge gelöscht.' + sLineBreak + 'Möchten Sie wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
            exit;
        end;
      finally
        FreeAndNil(BaumButtonList);
        FreeAndNil(Buttonprop);
      end;
      exit;
      FButtonProp.Read(FObjectId);
      FButtonProp.Delete;
      //FButtonProp.MarkAsDelete;
      Aktual;
    end;
  end;
  if AType = ntobBearb then
  begin
    if Action = NTA_DASH_FOLDERRETURN then
    begin
      FolderReturn;
    end;
  end;
end;



procedure Tof_Ordner.Aktual;
var
  i1: Integer;
  x : TbtnOrdner;
  iTop: Integer;
begin
  iTop := 15;
  FButtonList.Clear;
  FBaumButtonList.ReadAll(SysObj.Akt.BaumButtonEbene);
  for i1 := 0 to FBaumButtonList.Count - 1 do
  begin
    FButtonProp.Read(FBaumButtonList.Item[i1].Feld(BB_BP_ID).AsInteger);
    if not FButtonProp.Found then
      continue;
    x := TbtnOrdner.Create(FScrollbox);
    x.Parent := FScrollbox;
    x.Left := 11;
    x.Top := iTop;
    x.BtnLabel.Caption := FButtonProp.Feld(BP_TEXT).AsString;
    x.Tag := FButtonProp.Id;
    if FButtonProp.Icon <> nil then
      x.setIcon(FButtonProp.Icon);
    x.BtnImage.Margin := 8;
    x.OnClick := ButtonClick;
    FButtonList.Add(x);
    x.Width := x.Parent.Width -20;
    x.Anchors := [akLeft, akTop, akRight];
    iTop := iTop + x.Height + 5;
  end;
end;


procedure Tof_Ordner.ButtonClick(Sender: TObject);
var
  i1: Integer;
  UEbene: Integer;
  Form: Tfrm_Passwort;
  //ShowButtons: Boolean;
begin
  FButtonProp.Read(TTBButton(Sender).Tag);
  if not FButtonProp.Found then
    exit;
  if FButtonProp.Feld(BP_USEPW).AsBoolean then
  begin
    Form := Tfrm_Passwort.Create(nil);
    try
      Form.ShowModal;
      if not Form.Passwort.PasswortOk then
        exit;
    finally
      FreeAndNil(Form);
    end;
  end;
  UEbene := -1;
  //ShowButtons := true;
  for i1 := 0 to FBaumButtonList.Count - 1 do
  begin
    if FBaumButtonList.Item[i1].Feld(BB_BP_ID).AsInteger = TTBButton(Sender).Tag then
    begin
      //UEbene := FBaumButtonList.Item[i1].Feld(BB_UEBENE).AsInteger;
      UEbene := FBaumButtonList.Item[i1].id;
      break;
    end;
  end;
  SysObj.Akt.BaumButtonEbene := UEbene;
  if FButtonProp.Feld(BP_IT_ID).AsInteger = 2 then
  begin
    SysObj.ObServer.Notify(ntobBearb, NTA_BAUM_VISIBLE, 1);
    exit;
  end;
  Aktual;
  //ShowMessage(FButtonProp.Feld(BP_TEXT).AsString);
end;

procedure Tof_Ordner.FolderReturn;
begin
  FBaumButton.Read(SysObj.Akt.BaumButtonEbene);
  if not FBaumButton.Found then
    exit;
  SysObj.Akt.BaumButtonEbene := FBaumButton.Feld(BB_EBENE).AsInteger;
  SysObj.ObServer.Notify(ntobBearb, NTA_BAUM_VISIBLE, 0);
  Aktual;

end;


end.
