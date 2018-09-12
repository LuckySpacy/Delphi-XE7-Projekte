unit o_xmlsh_KommentarList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, xml.xmldoc, xml.xmlintf,
  o_xmlsh_kommentarnode, contnrs;

type
  TxmlSh_KommentarList = class
  private
    FXMLNodeList: TObjectList;
  public
    constructor Create(aXMLNodeList: IXMLNodeList);
    destructor Destroy; override;
    procedure LadeNodeList(aXMLNodeList: IXMLNodeList);
    procedure LadeKommentar(aList: TStrings);
    function Add(aXMLNode: IXMLNode): TxmlSh_KommentarNode;
    function KommentarNode(aKommando: string): TxmlSh_KommentarNode; overload;
    function KommentarNode(aKommando: string; var ItemIndex: Integer): TxmlSh_KommentarNode; overload;
    procedure Delete(aKommando: string);
  end;

implementation

{ TxmlSh_KommentarList }


constructor TxmlSh_KommentarList.Create(aXMLNodeList: IXMLNodeList);
begin
  FXMLNodeList := TObjectList.Create;
  LadeNodeList(aXMLNodeList);
end;


destructor TxmlSh_KommentarList.Destroy;
begin
  FreeAndNil(FXMLNodeList);
  inherited;
end;


procedure TxmlSh_KommentarList.LadeKommentar(aList: TStrings);
var
  KommentarNode : TxmlSh_KommentarNode;
  i1: Integer;
  List: TStringList;
begin
  aList.Clear;
  List := TStringList.Create;
  try
    List.Duplicates := dupIgnore;
    List.Sorted := true;
    for i1 := 0 to FXMLNodeList.Count -1 do
    begin
      KommentarNode := TxmlSh_KommentarNode(FXMLNodeList.Items[i1]);
      List.Add(KommentarNode.PosNrToStr + '=' + KommentarNode.Kommando);
    end;
    for i1 := 0 to List.Count -1 do
    begin
      aList.Add(List.ValueFromIndex[i1]);
    end;
  finally
    FreeAndNil(List);
  end;
end;

procedure TxmlSh_KommentarList.LadeNodeList(aXMLNodeList: IXMLNodeList);
var
  i1: Integer;
  KommentarNode: TxmlSh_KommentarNode;
begin
  FXMLNodeList.Clear;
  for i1 := 0 to aXMLNodeList.Count -1 do
  begin
    if aXMLNodeList[i1].NodeName <> 'Kommentar' then
      continue;
    KommentarNode := TxmlSh_KommentarNode.Create(aXMLNodeList[i1]);
    FXMLNodeList.Add(KommentarNode);
  end;
end;


function TxmlSh_KommentarList.Add(aXMLNode: IXMLNode): TxmlSh_KommentarNode;
var
  Node: IXMLNode;
begin
  Node := aXMLNode.AddChild('Kommentar');
  Result := TxmlSh_KommentarNode.Create(Node);
  FXMLNodeList.Add(Result);
end;


function TxmlSh_KommentarList.KommentarNode(aKommando: string): TxmlSh_KommentarNode;
var
  i1: Integer;
  x: TxmlSh_KommentarNode;
begin
  Result := nil;
  for i1 := 0 to FXMLNodeList.Count -1 do
  begin
    x := TxmlSh_KommentarNode(FXMLNodeList.Items[i1]);
    if SameText(x.Kommando, aKommando) then
    begin
      Result := x;
      exit;
    end;
  end;
end;

function TxmlSh_KommentarList.KommentarNode(aKommando: string; var ItemIndex: Integer): TxmlSh_KommentarNode;
var
  i1: Integer;
  x: TxmlSh_KommentarNode;
begin
  ItemIndex := -1;
  Result := nil;
  for i1 := 0 to FXMLNodeList.Count -1 do
  begin
    x := TxmlSh_KommentarNode(FXMLNodeList.Items[i1]);
    if SameText(x.Kommando, aKommando) then
    begin
      ItemIndex := i1;
      Result := x;
      exit;
    end;
  end;
end;


procedure TxmlSh_KommentarList.Delete(aKommando: string);
var
  KommandoNode: TxmlSh_KommentarNode;
  ItemIndex: Integer;
begin
  KommandoNode := KommentarNode(aKommando, ItemIndex);
  if KommandoNode = nil then
    exit;
  KommandoNode.Delete;
  FXMLNodeList.Delete(ItemIndex);
end;




end.
