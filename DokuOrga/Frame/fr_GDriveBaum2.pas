unit fr_GDriveBaum2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fr_Base, Vcl.StdCtrls, Vcl.ExtCtrls, CloudBase, c_Types,
  VirtualTrees;

type
  PZweig = ^RZweig;
  RZweig = record
    Caption: String;
    CloudItem: TCloudItem;
  end;

type
  Tfra_GDriveBaum2 = class(Tfrm_Base)
    vt: TVirtualStringTree;
    Panel1: TPanel;
    Btn_CreateFolder: TButton;
    btn_Delete: TButton;
    procedure vtChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vtInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vtNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
    procedure vtExpanded(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure Btn_CreateFolderClick(Sender: TObject);
    procedure btn_DeleteClick(Sender: TObject);
  private
    FAktOrdner: string;
    FAktCloudItem: TCloudItem;
    FAktNode: PVirtualNode;
    FCancel: Boolean;
    FStartPfad: string;
    FStartItem: TCloudItem;
    function GetFullFolders(aci: TCloudItem): string;
    procedure setStartPfad(const Value: string);
    procedure LoadSubFolder(aParentNode: PVirtualNode; aCloudItem: TCloudItem);
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    property AktOrdner: string read FAktOrdner;
    property StartPfad: string read FStartPfad write setStartPfad;
    procedure Load;
  end;

var
  fra_GDriveBaum2: Tfra_GDriveBaum2;

implementation

{$R *.dfm}

uses
  o_SysObj;

{ Tfra_GDriveBaum2 }

procedure Tfra_GDriveBaum2.Btn_CreateFolderClick(Sender: TObject);
var
  Ordner: string;
  ct: TCloudItem;
  pNode: PVirtualNode;
  Data: PZweig;
begin
  inherited;
  if InputQuery('Neuer Ordner anlegen', 'Ordner', Ordner) then
  begin
    if (FAktCloudItem = nil) and (FStartItem <> nil) then
    begin
      ct := SysObj.GDrive.GDrive.CreateFolder(FStartItem, Ordner);
      if (ct <> nil) then
      begin
        pNode := vt.InsertNode(nil, amInsertAfter);
        Data := vt.GetNodeData(pNode);
        Data^.Caption := Ordner;
        Data^.CloudItem := ct;
      end;
    end
    else
    begin
      ct := SysObj.GDrive.GDrive.CreateFolder(FAktCloudItem, Ordner);
      if (ct <> nil) and (FAktNode <> nil) then
      begin
        pNode := vt.InsertNode(FAktNode, amAddChildLast);
        Data := vt.GetNodeData(pNode);
        Data^.Caption := Ordner;
        Data^.CloudItem := ct;
      end;
    end;
    //CloudTreeViewAdapter.InitFolder(FAktCloudItem);
  end;
end;

procedure Tfra_GDriveBaum2.btn_DeleteClick(Sender: TObject);
begin
  if FAktCloudItem = nil then
    exit;
  if MessageDlg('Möchten Sie wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
   if SysObj.GDrive.GDrive.Delete(FAktCloudItem) then
   begin
     vt.DeleteNode(FAktNode);
   end;
end;


constructor Tfra_GDriveBaum2.Create(AOwner: TComponent; AMode: TModus);
var
  Cur: TCursor;
begin
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    inherited;
    FAktOrdner := '';
    FStartItem := nil;
    FAktNode := nil;
    vt.NodeDataSize  := SizeOf(RZweig);
    vt.RootNodeCount := 0;
  finally
    Screen.Cursor := Cur;
  end;
end;

destructor Tfra_GDriveBaum2.Destroy;
begin

  inherited;
end;

procedure Tfra_GDriveBaum2.Load;
var
  FolderItems: TCloudItems;
  i1: Integer;
  pNode: PVirtualNode;
  Data: PZweig;
  SortList: TStringList;
  Cur: TCursor;
begin
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    if not SysObj.GDrive.GDrive.Connect then
      exit;
    if FStartItem = nil then
      FolderItems := SysObj.GDrive.GDrive.GetFolderList(nil)
    else
      FolderItems := SysObj.GDrive.GDrive.GetFolderListHierarchical(FStartItem);
    if FolderItems = nil then
      exit;
    //exit;
    SortList := TStringList.Create;
    try
      SortList.Duplicates := dupIgnore;
      SortList.Sorted := true;
      for i1 := 0 to FolderItems.Count -1 do
      begin
        if SameText('Untitled', FolderItems.Items[i1].FileName) then
          continue;
        SortList.AddObject(FolderItems.Items[i1].FileName, FolderItems.Items[i1]);
      end;
      for i1 := 0 to SortList.Count -1 do
      begin
        pNode := vt.InsertNode(nil, amInsertAfter);
        Data := vt.GetNodeData(pNode);
        Data^.Caption := SortList.Strings[i1];
        Data^.CloudItem := TCloudItem(SortList.Objects[i1]);
        LoadSubFolder(pNode, TCloudItem(SortList.Objects[i1]));
      end;
    finally
      FreeAndNil(SortList);
    end;
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure Tfra_GDriveBaum2.LoadSubFolder(aParentNode: PVirtualNode;
  aCloudItem: TCloudItem);
var
  FolderItems: TCloudItems;
  i1: Integer;
  pNode: PVirtualNode;
  Data: PZweig;
  SortList: TStringList;
  Cur: TCursor;
begin
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    FolderItems := SysObj.GDrive.GDrive.GetFolderListHierarchical(aCloudItem);
    if FolderItems = nil then
      exit;
    SortList := TStringList.Create;
    try
      SortList.Duplicates := dupIgnore;
      SortList.Sorted := true;
      for i1 := 0 to FolderItems.Count -1 do
      begin
        if SameText('Untitled', FolderItems.Items[i1].FileName) then
          continue;
        SortList.AddObject(FolderItems.Items[i1].FileName, FolderItems.Items[i1]);
      end;
      for i1 := 0 to SortList.Count -1 do
      begin
        pNode := vt.InsertNode(aParentNode, amAddChildLast);
        Data := vt.GetNodeData(pNode);
        Data^.Caption := SortList.Strings[i1];
        Data^.CloudItem := TCloudItem(SortList.Objects[i1]);
        //LoadSubFolder(pNode, TCloudItem(SortList.Objects[i1]));
      end;
    finally
      FreeAndNil(SortList);
    end;
  finally
    Screen.Cursor := Cur;
  end;
end;


function Tfra_GDriveBaum2.GetFullFolders(aci: TCloudItem): string;
var
  ci: TCloudItem;
begin
  ci     := aci;
  while ci <> nil do
  begin
    if ci.ItemType = ciFolder then
      Result := ci.FileName + '\' + Result;
    ci := ci.ParentFolder;
  end;
end;

procedure Tfra_GDriveBaum2.setStartPfad(const Value: string);
begin
  if not SysObj.GDrive.Connected then
    SysObj.GDrive.Connect;
  FStartPfad := Value;
  FStartItem := SysObj.GDrive.GetFolder(FStartPfad);
end;

//************************************************************************
procedure Tfra_GDriveBaum2.vtChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  ci: TCloudItem;
  Data: PZweig;
begin
  FAktCloudItem := nil;
  FAktNode := nil;
  FAktOrdner := '';
  if Node = nil then
    exit;
  Data := vt.GetNodeData(Node);
  ci := TCloudItem(Data.CloudItem);
  FAktCloudItem := ci;
  FAktOrdner := GetFullFolders(ci);
  FAktNode := Node;
end;

procedure Tfra_GDriveBaum2.vtExpanded(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PZweig;
  pNode: PVirtualNode;
begin
  pNode := vt.GetFirstChild(Node);
  while pNode <> nil do
  begin
    Data := vt.GetNodeData(pNode);
    if not vt.HasChildren[pNode] then
      LoadSubFolder(pNode, Data^.CloudItem);
    pNode := vt.GetNextSibling(pNode);
  end;
end;

procedure Tfra_GDriveBaum2.vtFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  Finalize(Data^);
end;

procedure Tfra_GDriveBaum2.vtGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    CellText := Data.Caption;
end;

procedure Tfra_GDriveBaum2.vtInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  Data.Caption := '';
end;

procedure Tfra_GDriveBaum2.vtNodeClick(Sender: TBaseVirtualTree;
  const HitInfo: THitInfo);
var
  Data: PZweig;
begin
  vt.SetFocus;
  vt.FocusedNode := HitInfo.HitNode;
  vt.Selected[HitInfo.HitNode] := true;
  Data := vt.GetNodeData(vt.FocusedNode);
  vt.Refresh;
end;


end.
