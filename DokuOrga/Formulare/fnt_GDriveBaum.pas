unit fnt_GDriveBaum;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fr_GDriveBaum2, tbButton, Vcl.ExtCtrls,
  VirtualTrees;


type
  PZweig = ^RZweig;
  RZweig = record
    Caption: String;
  end;


type
  Tfrm_GDriveBaum = class(TForm)
    Panel1: TPanel;
    btn_Ok: TTBButton;
    vt: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure vtFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vtInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vtNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
  private
    FGDriveBaum: Tfra_GDriveBaum2;
    FCancel: Boolean;
    FStartPfad: string;
    procedure setStartPfad(const Value: string);
    procedure Load;
  public
    function AktFolder: string;
    property Cancel: Boolean read FCancel;
    property StartPfad: string read FStartPfad write setStartPfad;
  end;

var
  frm_GDriveBaum: Tfrm_GDriveBaum;

implementation

{$R *.dfm}

uses
  o_SysObj, CloudBase;


procedure Tfrm_GDriveBaum.FormCreate(Sender: TObject);
begin
  vt.NodeDataSize  := SizeOf(RZweig);
  vt.RootNodeCount := 0;
  FCancel := true;
  FGDriveBaum := Tfra_GDriveBaum2.Create(Self);
  FGDriveBaum.Parent := Self;
  FGDriveBaum.Align := alClient;
end;

procedure Tfrm_GDriveBaum.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FGDriveBaum);
end;

procedure Tfrm_GDriveBaum.FormShow(Sender: TObject);
begin
  FGDriveBaum.Load;
  Load;
end;


procedure Tfrm_GDriveBaum.setStartPfad(const Value: string);
begin
  FStartPfad := Value;
  FGDriveBaum.StartPfad := FStartPfad;
end;


function Tfrm_GDriveBaum.AktFolder: string;
begin
  Result := FGDriveBaum.AktOrdner;
end;

procedure Tfrm_GDriveBaum.btn_OkClick(Sender: TObject);
begin
  FCancel := false;
  close;
end;


procedure Tfrm_GDriveBaum.Load;
var
  FolderItems: TCloudItems;
  i1: Integer;
  pNode: PVirtualNode;
  Data: PZweig;
begin
  exit;
  if SysObj.GDrive.GDrive.Connect then
  begin
    FolderItems := SysObj.GDrive.GDrive.GetFolderList(nil);
    if FolderItems = nil then
      exit;
    for i1 := 0 to FolderItems.Count -1 do
    begin
      pNode := vt.InsertNode(nil, amInsertAfter);
      Data := vt.GetNodeData(pNode);
      Data^.Caption := FolderItems.Items[i1].FileName;
    end;
  end;
end;


//************************************************************************
procedure Tfrm_GDriveBaum.vtFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  Finalize(Data^);
end;


procedure Tfrm_GDriveBaum.vtGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    CellText := Data.Caption;
end;

procedure Tfrm_GDriveBaum.vtInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  Data.Caption := '';
end;

procedure Tfrm_GDriveBaum.vtNodeClick(Sender: TBaseVirtualTree;
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
