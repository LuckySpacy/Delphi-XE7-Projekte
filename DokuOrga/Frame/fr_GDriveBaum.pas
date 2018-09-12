unit fr_GDriveBaum;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fr_Base, c_Types, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.ImgList, CloudTreeViewAdapter, CloudBase, Vcl.StdCtrls,
  VirtualTrees;


type
  PZweig = ^RZweig;
  RZweig = record
    Caption: String;
    CloudItem: TCloudItem;
  end;


type
  Tfra_GDriveBaum = class(Tfrm_Base)
    trv: TTreeView;
    Panel1: TPanel;
    ImageList1: TImageList;
    CloudTreeViewAdapter: TCloudTreeViewAdapter;
    CreateFolderBtn: TButton;
    DeleteBtn: TButton;
    vt: TVirtualStringTree;
    procedure trvChange(Sender: TObject; Node: TTreeNode);
    procedure CreateFolderBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure vtInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vtFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vtNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
    procedure vtChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    FAktOrdner: string;
    FAktCloudItem: TCloudItem;
    FAktNode: PVirtualNode;
    FCancel: Boolean;
    FStartPfad: string;
    FStartItem: TCloudItem;
    function GetFullFolders(aci: TCloudItem): string;
    procedure ShowItem;
    procedure setStartPfad(const Value: string);
    procedure LoadSubFolder(aParentNode: PVirtualNode; aCloudItem: TCloudItem);
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    procedure Load;
    property AktOrdner: string read FAktOrdner;
    property StartPfad: string read FStartPfad write setStartPfad;
  end;

var
  fra_GDriveBaum: Tfra_GDriveBaum;

implementation

{$R *.dfm}

{ Tfra_GDriveBaum }

uses
  o_SysObj, CloudCustomBoxNet;

constructor Tfra_GDriveBaum.Create(AOwner: TComponent; AMode: TModus);
var
  Cur: TCursor;
begin
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    inherited;
    Trv.Images := ImageList1;
    CloudTreeViewAdapter.TreeView := Trv;
    CloudTreeViewAdapter.CloudStorage := SysObj.GDrive.GDrive;
    FAktOrdner := '';
    FStartItem := nil;
    FAktNode := nil;
    vt.NodeDataSize  := SizeOf(RZweig);
    vt.RootNodeCount := 0;
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure Tfra_GDriveBaum.CreateFolderBtnClick(Sender: TObject);
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

procedure Tfra_GDriveBaum.DeleteBtnClick(Sender: TObject);
begin
  inherited;
  if FAktCloudItem = nil then
    exit;
  if MessageDlg('Möchten Sie wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
   if SysObj.GDrive.GDrive.Delete(FAktCloudItem) then
   begin
     vt.DeleteNode(FAktNode);
   end;
   CloudTreeViewAdapter.InitRoot;
end;

destructor Tfra_GDriveBaum.Destroy;
begin

  inherited;
end;

procedure Tfra_GDriveBaum.Load;
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
    if SysObj.GDrive.GDrive.Connect then
    begin
      //CloudTreeViewAdapter.InitTreeView;
      CloudTreeViewAdapter.InitFolder(FStartItem);
    end;
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


procedure Tfra_GDriveBaum.LoadSubFolder(aParentNode: PVirtualNode;
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
        LoadSubFolder(pNode, TCloudItem(SortList.Objects[i1]));
      end;
    finally
      FreeAndNil(SortList);
    end;
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure Tfra_GDriveBaum.setStartPfad(const Value: string);
begin
  if not SysObj.GDrive.Connected then
    SysObj.GDrive.Connect;
  FStartPfad := Value;
  FStartItem := SysObj.GDrive.GetFolder(FStartPfad);
end;

procedure Tfra_GDriveBaum.trvChange(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  ShowItem;
end;



procedure Tfra_GDriveBaum.ShowItem;
var
  ci: TCloudItem;
begin

  if Assigned(Trv.Selected) then
  begin
    ci := TCloudItem(Trv.Selected.Data);
    if (ci is TBoxNetItem) then
    begin
      (ci as TBoxNetItem).LoadFileInfo;
    end;

    FAktCloudItem := ci;
    FAktOrdner := GetFullFolders(ci);
         {
    //FileName.Caption := ci.FileName;
    FileName.Caption := GetFullFolders(ci);

    if ci.CreationDate <> 0 then
      Created.Caption := FormatDateTime(FormatSettings.ShortDateFormat + ' ' + FormatSettings.ShortTimeFormat,ci.CreationDate)
    else
      Created.Caption := FormatDateTime(FormatSettings.ShortDateFormat + ' ' + FormatSettings.ShortTimeFormat,ci.ModifiedDate);

    Size.Caption := IntToStr(ci.Size);
          }
    //DownloadBtn.Enabled := ci.ItemType = ciFile;
  end;

end;


function Tfra_GDriveBaum.GetFullFolders(aci: TCloudItem): string;
var
  ci: TCloudItem;
begin
  ci     := aci;
  while ci <> nil do
  begin
    Result := ci.FileName + '\' + Result;
    ci := ci.ParentFolder;
  end;
end;



//************************************************************************
procedure Tfra_GDriveBaum.vtChange(Sender: TBaseVirtualTree;
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

procedure Tfra_GDriveBaum.vtFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  Finalize(Data^);
end;

procedure Tfra_GDriveBaum.vtGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    CellText := Data.Caption;
end;

procedure Tfra_GDriveBaum.vtInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  Data.Caption := '';
end;

procedure Tfra_GDriveBaum.vtNodeClick(Sender: TBaseVirtualTree;
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
