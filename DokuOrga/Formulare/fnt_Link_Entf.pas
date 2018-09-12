unit fnt_Link_Entf;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, tbButton, Vcl.ExtCtrls, Vcl.Grids,
  tbStringGrid, o_seiteverbinden, o_seite, o_seitelink, o_seitelinklist,
  VirtualTrees, o_seitedokumentlinklist, o_dokument, o_seitedokumentlist,
  System.UITypes, obBusinessClasses, o_buttonprop, o_seitedokumentlink;


type
  PZweig = ^RZweig;
  RZweig = record
    Caption: String;
    Dateiname: string;
    ImageIndex: Integer;
    Id: Integer;
    DoId: Integer;
    Verlinkt: Boolean;
  end;

type
  Tfrm_Link_Entf = class(TForm)
    Panel1: TPanel;
    btn_LinkEntfernen: TTBButton;
    Grid_Link_Entf: TtbStringGrid;
    vt: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure vtInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vtFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vtFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure vtGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: TImageIndex);
    procedure vtDrawText(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; const Text: string;
      const CellRect: TRect; var DefaultDraw: Boolean);
    procedure btn_LinkEntfernenClick(Sender: TObject);
  private
    FSeiteverbinden : TSeiteverbinden;
    FSeite: TSeite;
    FSeiteLink: TSeiteLink;
    FSeiteLinkList: TSeiteLinkList;
    FSeiteDokumentLinkList: TSeiteDokumentLinkList;
    FSeiteDokumentList : TSeiteDokumentList;
    FSeiteDokumentLink: TSeiteDokumentLink;
    FQuellBaumZweigId: Integer;
    FQuellBaumButtonEbene: Integer;
    FSelectedNode: PVirtualNode;
    FButtonprop: TButtonProp;
    procedure LadeGrid;
    procedure LoadTree;
  public
    property QuellBaumButtonEbene: Integer read FQuellBaumButtonEbene write FQuellBaumButtonEbene;
    property QuellBaumZweigId: Integer read FQuellBaumZweigId write FQuellBaumZweigId;
  end;

var
  frm_Link_Entf: Tfrm_Link_Entf;

implementation

{$R *.dfm}

uses
  c_DBTypes, o_sysobj, o_fileicon, c_Types;



procedure Tfrm_Link_Entf.FormCreate(Sender: TObject);
begin
  FSelectedNode := nil;

  FSeiteverbinden := TSeiteverbinden.Create(Self);
  FSeite := TSeite.Create(Self);
  FSeiteLink := TSeiteLink.Create(Self);
  FSeiteLinkList := TSeiteLinkList.Create(Self);
  FSeiteDokumentLinkList := TSeiteDokumentLinkList.Create(Self);
  FSeiteDokumentList := TSeiteDokumentList.Create(Self);
  FButtonprop := TButtonProp.Create(Self);
  FSeiteDokumentLink := TSeiteDokumentLink.Create(Self);


  Grid_Link_Entf.FixedCols := 0;
  Grid_Link_Entf.ColCount := 2;
  Grid_Link_Entf.Clear;
  Grid_Link_Entf.AddColList('Ordner');
  Grid_Link_Entf.AddColList('Seite');
  Grid_Link_Entf.RowCount := 2;
  Grid_Link_Entf.Options := Grid_Link_Entf.Options + [goRowSelect];
  Grid_Link_Entf.Options := Grid_Link_Entf.Options + [goColSizing];
  Grid_Link_Entf.Cell['Seite', 0] := 'Seite';
  Grid_Link_Entf.Cell['Ordner', 0] := 'Ordner';

  vt.NodeDataSize  := SizeOf(RZweig);
  vt.RootNodeCount := 0;

  vt.Images := SysObj.FileIconList.ImgList;


end;

procedure Tfrm_Link_Entf.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FSeiteverbinden);
  FreeAndNil(FSeite);
  FreeAndNil(FSeiteLink);
  FreeAndNil(FSeiteLinkList);
  FreeAndNil(FSeiteDokumentLinkList);
  FreeAndNil(FSeiteDokumentList);
  FreeAndNil(FSeiteDokumentLink);
  FreeAndNil(FButtonProp);
end;

procedure Tfrm_Link_Entf.FormShow(Sender: TObject);
begin
  FSeiteverbinden.Read(FQuellBaumButtonEbene, FQuellBaumZweigId);
  if not FSeiteverbinden.Found then
  begin
    ShowMessage('Seite nicht gefunden');
    exit;
  end;
  FSeite.Read(FSeiteVerbinden.Feld(VS_SE_ID).AsInteger);
  if not FSeite.Found then
  begin
    ShowMessage('Seite nicht gefunden');
    exit;
  end;

  LadeGrid;

end;

procedure Tfrm_Link_Entf.LadeGrid;
var
  i1: Integer;
begin
  LoadTree;
  exit;
  FSeiteLinkList.ReadAllFromSeite(FSeite.Id);
  Grid_Link_Entf.RowCount := FSeiteLinkList.Count + 1;
  for i1 := 0 to FSeiteLinkList.Count -1 do
  begin
    Grid_Link_Entf.Cell['Seite', i1 + 1] := FSeiteLinkList.Item[i1].Seite.HeaderPlainText;
    Grid_Link_Entf.Obj['Seite', i1 + 1] := FSeiteLinkList.Item[i1].Seite;
  end;
  Grid_Link_Entf.AutosizeCol := 1;
  Grid_Link_Entf.GotoRow(1);
end;

procedure Tfrm_Link_Entf.LoadTree;
  procedure SetData(aNode: PVirtualNode; aSeite: TSeite; aDokument: TDokument);
  var
    Data: PZweig;
    Ext: string;
    FileIcon: TtbFileIcon;
    ButtonCaption: string;
  begin
    if FSeiteverbinden.ReadSeite(aSeite.Id) then
    begin
      if FSeiteverbinden.Baumbutton <> nil then
      begin
        FButtonprop.Read(FSeiteverbinden.Baumbutton.Feld(BB_BP_ID).AsInteger);
        if FButtonprop.Found then
          ButtonCaption := FButtonprop.Feld(BP_TEXT).AsString;
      end;
    end;
    Data := vt.GetNodeData(aNode);
    if aSeite.HeaderPlainText > '' then
      Data^.Caption := aSeite.HeaderPlainText
    else
      Data^.Caption := ButtonCaption;
    if aDokument = nil then
      Data^.Dateiname := ''
    else
    begin
      Data^.Caption   := aDokument.Feld(DO_BEZ).AsString;
      Data^.Dateiname := aDokument.FullFilename;
      Data^.DoId      := aDokument.Id;
      Ext := ExtractFileExt(aDokument.FullFilename);
      FileIcon := SysObj.FileIconList.FileIcon(ext);
      Data^.ImageIndex := FileIcon.Tag;
      FSeiteDokumentLink.Read(FSeite.Id, aSeite.Id, aDokument.id);
      if FSeiteDokumentLink.Found then
        Data^.Verlinkt := FSeiteDokumentLink.Feld(SK_VERLINKT).AsBoolean;
    end;
    Data^.Id := aSeite.Id;
  end;
var
  pNodeHeader: PVirtualNode;
  pNode: PVirtualNode;
  i1, i2: Integer;
begin
  FSeiteLinkList.ReadAllFromSeite(FSeite.Id);
  Grid_Link_Entf.RowCount := FSeiteLinkList.Count + 1;
  for i1 := 0 to FSeiteLinkList.Count -1 do
  begin
    pNodeHeader := vt.InsertNode(nil, amInsertAfter);
    SetData(pNodeHeader, FSeiteLinkList.Item[i1].Seite, nil);
    FSeiteDokumentList.ReadAll(FSeiteLinkList.Item[i1].Seite.Id);
    for i2 := 0 to FSeiteDokumentList.Count -1 do
    begin
      pNode := vt.InsertNode(pNodeHeader, amAddChildLast);
      SetData(pNode, FSeiteLinkList.Item[i1].Seite, FSeiteDokumentList.Item[i2].Dokument);
    end;
  end;
end;

procedure Tfrm_Link_Entf.vtDrawText(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  if (Assigned(Data)) and (Data^.Dateiname = '') then
    TargetCanvas.Font.Color := clBlue;
  if (Assigned(Data)) and (Data^.DoId > 0) and (not Data^.Verlinkt) then
    TargetCanvas.Font.Color := clRed;

    //TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold];
end;

procedure Tfrm_Link_Entf.vtFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  Data: PZweig;
begin
  FSelectedNode := nil;
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
  begin
    //btn_LinkEntfernen.Enabled := Data^.Dateiname = '';
    FSelectedNode := Node;
  end;
end;

procedure Tfrm_Link_Entf.vtFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  Finalize(Data^);
end;

procedure Tfrm_Link_Entf.vtGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: TImageIndex);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  if (Column = 1) and Assigned(Data) then
    ImageIndex := Data^.ImageIndex;
end;

procedure Tfrm_Link_Entf.vtGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
  begin
    if Column = 0 then
      CellText := Data.Caption;
    if Column = 1 then
      CellText := Data.Dateiname;
  end;
end;

procedure Tfrm_Link_Entf.vtInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Data: PZweig;
begin
  Data := Sender.GetNodeData(Node);
  Data.Caption := '';
  Data.Dateiname := '';
  Data.Id := -1;
  Data.ImageIndex := -1;
  Data.DoId := -1;
  Data.Verlinkt := true;
end;


procedure Tfrm_Link_Entf.btn_LinkEntfernenClick(Sender: TObject);
var
  Data: PZweig;
  i1: Integer;
begin
  if FSelectedNode = nil then
    exit;
  Data := vt.GetNodeData(FSelectedNode);
  if not Assigned(Data) then
    exit;
  //ShowMessage(IntToStr(Data^.Id));
  FSeiteLink.Read(FSeite.Id, Data^.Id, csl_Dokument);
  if not FSeiteLink.Found then
  begin
    MessageDlg('Eintrag in der Datenbank konnte nicht gefunden werden', mtError, [mbOk], 0);
    exit;
  end;


  if Data^.DoId < 0 then
  begin
    if MessageDlg('Möchten Sie wirklich die komplette Seite entfernen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      exit;
  end
  else
  begin
    if MessageDlg('Möchten Sie wirklich diesen Link entfernen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      exit;
  end;

  if Data^.DoId < 0 then
  begin
    FSeiteDokumentLinkList.ReadAllSourceLinks(FSeite.Id, Data^.Id);
    for i1 := FSeiteDokumentLinkList.Count -1 downto 0 do
      FSeiteDokumentLinkList.Item[i1].Delete;

    FSeiteLink.Delete;
  end;

  if Data^.DoId > 0 then
  begin
    FSeiteDokumentLink.Read(FSeite.Id, Data^.Id, Data^.DoId);
    if FSeiteDokumentLink.Found then
    begin
      FSeiteDokumentLink.Feld(SK_VERLINKT).AsBoolean := false;
      FSeiteDokumentLink.Save;
      ShowMessage('Link wurde entfernt');
    end;
  end;

  if Data^.DoId < 0 then
    vt.DeleteNode(FSelectedNode);
  FSelectedNode := nil;

  sysobj.ObServer.Notify(ntobBearb, NTA_DOKUMENTREFRESH);

end;


end.
