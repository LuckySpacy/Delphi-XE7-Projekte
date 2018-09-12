unit of_Zweig;

interface

{$WARN SYMBOL_DEPRECATED OFF}

uses
  SysUtils, Classes, Forms, StdCtrls, Buttons, of_Base, c_Types,
  ExtCtrls, Dialogs, o_sysObj, Controls, obBusinessClasses, obServerClient,
  tbButton, o_BaumButtonList, Contnrs, o_ZweigProp, IBDatabase, VirtualTrees,
  o_BaumstrukList, o_BaumStruk, fr_Base, Menus, ImgList;

type
  PZweig = ^RZweig;
  RZweig = record
    Caption: String;
    Id: Integer;
    Ebene: Integer;
  end;

type
  Tof_Zweig = class(Tof_Base, IObServerClient)
  private
    Fvt:  TVirtualStringTree;
    FZweigProp: TZweigProp;
    FTrans: TIBTransaction;
    FBaumStrukList: TBaumStrukList;
    FBaumStruk: TBaumStruk;
    FBaseFrame: Tfrm_Base;
    FFindNode: PVirtualNode;
    FPopUp: TPopUpMenu;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure vtGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
                        Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vtFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtInitNode(Sender: TBaseVirtualTree; ParentNode,
                         Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vtGetImageIndex(Sender: TBaseVirtualTree;
                         Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
                         var Ghosted: Boolean; var ImageIndex: TImageIndex);
    //procedure vtGetImageIndexEx(Sender: TBaseVirtualTree;
    //  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
    //  var Ghosted: Boolean; var ImageIndex: Integer;
    //  var ImageList: TCustomImageList);
    procedure LoadTree(aParentIndex: Integer; aParentNode: PVirtualNode; aStartId: Integer = -1);
    procedure DoVisibleChanged(Sender: TObject);
    //procedure CreateTree;
    procedure vtNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
    procedure LoadTreeId(aList: TStringList; aId: Integer);
    //function FindItem(aId: Integer):PVirtualNode;
    procedure SelectItem(aId: Integer);
    function getPriorNode(aNode: PVirtualNode): PVirtualNode;
    procedure pop_EinfuegenUEbeneClick(Sender: TObject);
    procedure pop_EinfuegenEbeneClick(Sender: TObject);
    procedure pop_DeleteItemClick(Sender: TObject);
    procedure pop_BearbClick(Sender: TObject);
    procedure pop_Popup(Sender: TObject);
    procedure RegisterNotify;
    procedure UnregisterNotify;
    procedure RefreshNode(aNode: PVirtualNode);
  protected
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    procedure VisibleChanged(aValue: Boolean); override;
    procedure Aktual(aEbene: Integer);
    procedure AddNewUItem;
    procedure AddNewItem;
    procedure DeleteItem;
    procedure EditItem;
  end;


implementation

{ Tof_Zweig }

uses
  c_DBTypes, o_deletebaum;


constructor Tof_Zweig.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited;
  FTrans := TIBTransaction.Create(Self);
  FTrans.DefaultDatabase := SysObj.Database;
  Fvt := getVirtualStringTree('vt');
  FPopUp := getPopUpMenu('pop');
  FZweigProp := TZweigProp.Create(Self);
  FBaumStrukList := TBaumStrukList.Create(Self);
  FBaumStruk := TBaumStruk.Create(Self);

  FPopUp.Items[0].OnClick := pop_EinfuegenUEbeneClick;
  FPopUp.Items[1].OnClick := pop_EinfuegenEbeneClick;
  FPopUp.Items[3].OnClick := pop_BearbClick;
  FPopUp.Items[5].OnClick := pop_DeleteItemClick;
  FPopUp.OnPopup := pop_Popup;

  FBaseFrame := nil;
  if AOwner is Tfrm_Base then
  begin
    Tfrm_Base(AOwner).OnVisibleChanged := DoVisibleChanged;
    FBaseFrame := Tfrm_Base(AOwner);
  end;

  Fvt.OnGetText := vtGetText;
  Fvt.OnFreeNode := vtFreeNode;
  Fvt.OnInitNode := vtInitNode;
  Fvt.OnNodeClick := vtNodeClick;
  Fvt.NodeDataSize  := SizeOf(RZweig);
  Fvt.RootNodeCount := 0;
  Fvt.OnGetImageIndex := vtGetImageIndex;
  //Fvt.OnGetImageIndexEx := vtGetImageIndexEx;
  RegisterNotify;

end;

procedure Tof_Zweig.RegisterNotify;
begin
  SysObj.ObServer.RegisterNotifications(Self, [ntobFrames, ntobBearb]);
end;


procedure Tof_Zweig.UnregisterNotify;
begin
  SysObj.ObServer.UnregisterNotifications(Self);
end;



destructor Tof_Zweig.Destroy;
begin
  FreeAndNil(FBaumStrukList);
  FreeAndNil(FZweigProp);
  FreeAndNil(FBaumStruk);
  FreeAndNil(FTrans);
  UnregisterNotify;
  inherited;
end;

{
procedure Tof_Zweig.CreateTree;
begin
  if Fvt <> nil then
    FreeAndNil(Fvt);
  Fvt := TVirtualStringTree.Create(Self);
  Fvt.Parent := FBaseFrame;
  Fvt.Align := alClient;
end;
}

procedure Tof_Zweig.DoVisibleChanged(Sender: TObject);
begin
  exit;
  if not Assigned(FBaseFrame) then
    exit;
  if FBaseFrame.Visible then
    Aktual(0);
end;


procedure Tof_Zweig.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
begin
  if FMode <> sysobj.Akt.Modus then
    exit;
  if AType = ntobFrames then
  begin
    if Action = NTA_AKTUAL then
    begin
      if (FBaseFrame <> nil) and FBaseFrame.Visible then
        Aktual(Data);
    end;
  end;
end;

procedure Tof_Zweig.pop_BearbClick(Sender: TObject);
begin
  EditItem;
end;

procedure Tof_Zweig.pop_DeleteItemClick(Sender: TObject);
begin
  DeleteItem;
end;

procedure Tof_Zweig.pop_EinfuegenEbeneClick(Sender: TObject);
begin
  AddNewItem;
end;

procedure Tof_Zweig.pop_EinfuegenUEbeneClick(Sender: TObject);
begin
  AddNewUItem;
end;

procedure Tof_Zweig.pop_Popup(Sender: TObject);
begin  //
  FPopUp.Items[0].Enabled := true;
  FPopUp.Items[1].Enabled := true;
  FPopUp.Items[3].Enabled := true;
  FPopUp.Items[5].Enabled := true;
  if Fvt.FocusedNode = nil then
  begin
    FPopUp.Items[0].Enabled := false;
    FPopUp.Items[3].Enabled := false;
    FPopUp.Items[5].Enabled := false;
  end;
end;


procedure Tof_Zweig.SelectItem(aId: Integer);
//var
//  Node: PVirtualNode;
begin
  FFindNode := nil;
  //Node := FindItem(aId);
  if Assigned(FFindNode) then
  begin
    Fvt.FocusedNode := FFindNode;
    Fvt.Selected[FFindNode] := true;
    Fvt.Refresh;
  end;
end;


{
function Tof_Zweig.FindItem(aId: Integer):PVirtualNode;
var
  Node: PVirtualNode;
  Data: PZweig;
  procedure SelectSubNodes(ANode: PVirtualNode; aId: Integer; aResultNode: PVirtualNode);
  var
    SubNode: PVirtualNode;
  begin
    SubNode := Fvt.GetFirstChild(ANode);
    while Assigned(SubNode) do
    begin
      Data := Fvt.GetNodeData(SubNode);
      if Data.Id = aId then
        FFindNode := SubNode;
      if FFindNode <> nil then
        exit;
      SelectSubNodes(SubNode, aId, aResultNode);
      //Fvt.Selected[SubNode] := True;
      SubNode := Fvt.GetNextSibling(SubNode);
    end;
  end;
begin
  Result := nil;
  //Node := Fvt.GetFirst;
  Fvt.BeginUpdate;
  try
    Node := Fvt.GetFirst;
    while Assigned(Node) do
    begin
      Data := Fvt.GetNodeData(Node);
      if Data.Id = aId then
        FFindNode := Node;
      if FFindNode <> nil then
        exit;
      SelectSubNodes(Node, aId, Result);
      if FFindNode <> nil then
        exit;
      Node := Fvt.GetNextSibling(Node);
    end;
  finally
    Fvt.EndUpdate;
  end;
end;
}

procedure Tof_Zweig.AddNewUItem;
var
  Data: PZweig;
  Id: Integer;
begin
  Id := -1;
  if Fvt.FocusedNode <> nil then
  begin
    Data := Fvt.GetNodeData(Fvt.FocusedNode);
    Id   := Data.Id;
  end;
  sysobj.ObServer.Notify(ntobForms, NTA_SHOW_ZWEIGPROP_NEU, Id);
end;

procedure Tof_Zweig.AddNewItem;
var
  Data: PZweig;
  Id: Integer;
begin
  Id := -1;
  if Fvt.FocusedNode <> nil then
  begin
    Data := Fvt.GetNodeData(Fvt.FocusedNode);
    Id   := Data.Ebene;
  end;
  sysobj.ObServer.Notify(ntobForms, NTA_SHOW_ZWEIGPROP_NEU, Id);
end;

procedure Tof_Zweig.EditItem;
var
  Data: PZweig;
  Id: Integer;
begin
  if Fvt.FocusedNode = nil then
    exit;
  Data := Fvt.GetNodeData(Fvt.FocusedNode);
  Id   := Data^.Id;
  sysobj.ObServer.Notify(ntobForms, NTA_SHOW_ZWEIGPROP_BEARB, Data^.Id);
  RefreshNode(Fvt.FocusedNode);
  SelectItem(Id);
end;

procedure Tof_Zweig.RefreshNode(aNode: PVirtualNode);
var
  Data: PZweig;
begin
  if aNode = nil then
    exit;
  Data := Fvt.GetNodeData(aNode);
  if Data = nil then
    exit;
  FZweigProp.Read(Data.Id);
  if FZweigProp.Found then
  begin
    Data^.Caption := FZweigProp.Feld(ZP_TEXT).AsString;
    fvt.InvalidateNode(aNode);
  end;
end;


procedure Tof_Zweig.DeleteItem;
var
  Data: PZweig;
  IdList: TStringList;
//  i1: Integer;
  Cur: TCursor;
  Node: PVirtualNode;
  DeleteBaum: TDeleteBaum;
  DeleteOk: Boolean;
begin
  // Achtung das Löschen von Knoten ist noch nicht umgesetzt.
  // Hier müssen auch die darin befindlichen Unterknoten gelöscht werden.
  Node := getPriorNode(Fvt.FocusedNode);
  if Fvt.FocusedNode = nil then
    exit;

  Data := Fvt.GetNodeData(Fvt.FocusedNode);

  if MessageDlg('Möchten Sie den Eintrag' + sLineBreak +
                '"' + Data^.Caption + '"' + sLineBreak +
                'wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;

  //if SysObj.Msg.Msg(Self, '{EF3F72B3-EEC3-49A8-A483-E0E51D0D1452}', mtConfirmation, [mbYes, mbNo]) = mrNo then
  //  exit;

    {
  if Fvt.FocusedNode.ChildCount > 0 then
  begin
    ShowMessage('Das Löschen von Knoten ist noch nicht programmiert');
    exit;
  end;
  }
  Cur := Screen.Cursor;
  IdList := TStringList.Create;
  try
    Screen.Cursor := crHourGlass;
    IdList.Duplicates := dupIgnore;
    IdList.Sorted := true;
    Data := Fvt.GetNodeData(Fvt.FocusedNode);
    IdList.Add(IntToStr(Data^.id));
    LoadTreeId(IdList, Data^.id);
    if FTrans.InTransaction then
      FTrans.Rollback;
    DeleteBaum := TDeleteBaum.Create(nil);
    FTrans.StartTransaction;
    try

      DeleteOk := DeleteBaum.DeleteFromList(IdList, Data^.Ebene, SysObj.Akt.BaumButtonEbene, FTrans);
      if FTrans.InTransaction then
        FTrans.Commit;
      if not DeleteOk then
        exit;
    except
      on E: Exception do
      begin
        if FTrans.InTransaction then
          FTrans.Rollback;
      end;
    end;
  finally
    FreeAndNil(DeleteBaum);
    FreeAndNil(IdList);
    Screen.Cursor := Cur;
  end;
  Fvt.DeleteNode(Fvt.FocusedNode);
  if Assigned(Node) then
  begin
    Data := Fvt.GetNodeData(Node);
    if Assigned(Data) then
      SelectItem(Data.Id);
  end;
  //Aktual;
end;

function Tof_Zweig.getPriorNode(aNode: PVirtualNode): PVirtualNode;
begin
  Result := aNode.PrevSibling;
  if not Assigned(Result) then
    Result := Fvt.GetPrevious(aNode, false);
end;

procedure Tof_Zweig.LoadTreeId(aList: TStringList; aId: Integer);
var
  BaumStrukList: TBaumStrukList;
  i1: Integer;
begin
  aList.Add(IntToStr(aId));
  BaumStrukList := TBaumStrukList.Create(Self);
  try
    BaumStrukList.ReadAll(aId,SysObj.Akt.BaumButtonEbene);
    for i1 := 0 to BaumStrukList.Count - 1 do
    begin
      LoadTreeId(aList, BaumStrukList.Item[i1].Id);
    end;
  finally
    FreeAndNil(BaumStrukList);
  end;
end;


procedure Tof_Zweig.Aktual(aEbene: Integer);
var
  doExpand: Boolean;
begin
  doExpand := false;
  if SysObj.Akt.BaumButtonEbene = 0 then
    exit;
  if aEbene = 0 then
    Fvt.Clear
  else
    if Fvt.FocusedNode <> nil then
    begin
      Fvt.DeleteChildren(Fvt.FocusedNode);
      doExpand := true;
    end;
   LoadTree(aEbene, Fvt.FocusedNode);
   if doExpand then
     Fvt.Expanded[Fvt.FocusedNode] := true;
end;


procedure Tof_Zweig.VisibleChanged(aValue: Boolean);
begin
  inherited;
  exit;
  if aValue then
    Aktual(0);
end;

procedure Tof_Zweig.vtGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    CellText := Data.Caption;
end;

procedure Tof_Zweig.vtFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  Finalize(Data^);
end;

procedure Tof_Zweig.vtInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  Data.Caption := '';
  Data.Id := -1;
  Data.Ebene := -1;
end;



procedure Tof_Zweig.LoadTree(aParentIndex: Integer; aParentNode: PVirtualNode; aStartId: Integer = -1);
  procedure SetData(aNode: PVirtualNode; aZweigProp: TZweigProp; aBaumStruk: TBaumStruk);
  var
    Data: PZweig;
  begin
    Data := Fvt.GetNodeData(aNode);
    Data^.Caption := aZweigProp.Feld(ZP_TEXT).AsString;
    Data^.Id := aBaumStruk.Id;
    Data^.Ebene := aBaumStruk.Feld(BS_EBENE).AsInteger;
  end;
var
  pNode: PVirtualNode;
  //Data: PZweig;
  i1: Integer;
  BaumStrukList: TBaumStrukList;
  ZweigProp: TZweigProp;
  BaumStruk: TBaumStruk;
begin
  //pNode := aParentNode;
  BaumStrukList := TBaumStrukList.Create(Self);
  try
    BaumStrukList.ReadAll(aParentIndex, SysObj.Akt.BaumButtonEbene);
    for i1 := 0 to BaumStrukList.Count - 1 do
    begin
      BaumStruk := BaumStrukList.Item[i1];
      ZweigProp := TZweigProp.Create(self);
      try
        ZweigProp.Read(BaumStruk.Feld(BS_ZP_ID).AsInteger);
        if not ZweigProp.Found then
          continue;
        if not Assigned(aParentNode) then
        begin
          pNode := Fvt.InsertNode(nil, amInsertAfter);
          setData(pNode, ZweigProp, BaumStruk);
          LoadTree(BaumStruk.Id, pNode);
        end;
        if Assigned(aParentNode) then
        begin
          pNode := Fvt.InsertNode(aParentNode, amAddChildLast);
          setData(pNode, ZweigProp, BaumStruk);
          LoadTree(BaumStruk.Id, pNode);
        end;
      finally
        FreeAndNil(ZweigProp);
      end;
    end;
  finally
    FreeAndNil(BaumStrukList);
  end;
end;



procedure Tof_Zweig.vtNodeClick(Sender: TBaseVirtualTree;
  const HitInfo: THitInfo);
var
  Data: PZweig;
begin
  Fvt.SetFocus;
  Fvt.FocusedNode := HitInfo.HitNode;
  Fvt.Selected[HitInfo.HitNode] := true;
  Data := Fvt.GetNodeData(Fvt.FocusedNode);
  Fvt.Refresh;
  SysObj.Akt.BaumZweigId := Data.Id;
end;

procedure Tof_Zweig.vtGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: TImageIndex);
begin
  if Kind in [ikNormal , ikSelected] then
  begin
    ImageIndex := 0;
    if (vsExpanded in Node.States)  then
      ImageIndex := 1;
  end;
end;

{
procedure Tof_Zweig.vtGetImageIndexEx(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer;
  var ImageList: TCustomImageList);
begin
  if Kind in [ikNormal , ikSelected] then
  begin
    ImageIndex := 0;
    if (vsExpanded in Node.States)  then
      ImageIndex := 1;
  end;
end;
}



end.
