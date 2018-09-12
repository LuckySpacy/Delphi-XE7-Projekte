unit o_xmlsh_BereichList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, xml.xmldoc, xml.xmlintf,
  o_xmlsh_bereichnode, contnrs;

type
  TxmlSh_BereichList = class
  private
    FXMLNodeList: TObjectList;
  public
    constructor Create(aXMLNodeList: IXMLNodeList);
    destructor Destroy; override;
    procedure LadeNodeList(aXMLNodeList: IXMLNodeList);
    procedure LadeBereiche(aList: TStrings);
    function getBereich(aBereichName: string): Txmlsh_BereichNode; overload;
    function getBereich(aBereichName: string; var aItemIndex: Integer): Txmlsh_BereichNode; overload;
    procedure Delete(aBereichname: string);
    function Add(aXMLNode: IXMLNode): Txmlsh_BereichNode;
  end;

implementation

{ TxmlSh_BereichList }


constructor TxmlSh_BereichList.Create(aXMLNodeList: IXMLNodeList);
begin
  FXMLNodeList := TObjectList.Create;
  LadeNodeList(aXMLNodeList);
end;


destructor TxmlSh_BereichList.Destroy;
begin
  FreeAndNil(FXMLNodeList);
  inherited;
end;


procedure TxmlSh_BereichList.LadeBereiche(aList: TStrings);
var
  BereichNode : TxmlSh_BereichNode;
  i1: Integer;
begin
  aList.Clear;
  for i1 := 0 to FXMLNodeList.Count -1 do
  begin
    BereichNode := TxmlSh_BereichNode(FXMLNodeList.Items[i1]);
    aList.Add(BereichNode.Bereichname);
  end;
end;

procedure TxmlSh_BereichList.LadeNodeList(aXMLNodeList: IXMLNodeList);
var
  i1: Integer;
  BereichNode: TxmlSh_BereichNode;
begin
  FXMLNodeList.Clear;
  for i1 := 0 to aXMLNodeList.Count -1 do
  begin
    if aXMLNodeList[i1].NodeName <> 'Bereich' then
      continue;
    BereichNode := TxmlSh_BereichNode.Create(aXMLNodeList[i1]);
    FXMLNodeList.Add(BereichNode);
  end;
end;

function TxmlSh_BereichList.getBereich(aBereichName: string): Txmlsh_BereichNode;
var
  i1: Integer;
  BereichNode: TxmlSh_BereichNode;
begin
  Result := nil;
  for i1 := 0 to FXMLNodeList.Count -1 do
  begin
    BereichNode := TxmlSh_BereichNode(FXMLNodeList.Items[i1]);
    if SameText(BereichNode.Bereichname, aBereichName) then
    begin
      Result := BereichNode;
      exit;
    end;
  end;
end;

function TxmlSh_BereichList.getBereich(aBereichName: string; var aItemIndex: Integer): Txmlsh_BereichNode;
var
  i1: Integer;
  BereichNode: TxmlSh_BereichNode;
begin
  Result := nil;
  aItemIndex := -1;
  for i1 := 0 to FXMLNodeList.Count -1 do
  begin
    BereichNode := TxmlSh_BereichNode(FXMLNodeList.Items[i1]);
    if SameText(BereichNode.Bereichname, aBereichName) then
    begin
      Result := BereichNode;
      aItemIndex := i1;
      exit;
    end;
  end;
end;



procedure TxmlSh_BereichList.Delete(aBereichname: string);
var
  ItemIndex: Integer;
  BereichNode: TxmlSh_BereichNode;
begin
  BereichNode := getBereich(aBereichname, ItemIndex);
  if BereichNode = nil then
    exit;
  BereichNode.Delete;
  FXMLNodeList.Delete(ItemIndex);
end;

function TxmlSh_BereichList.Add(aXMLNode: IXMLNode): Txmlsh_BereichNode;
var
  Node: IXMLNode;
begin
  Node := aXMLNode.AddChild('Bereich');
  Result := Txmlsh_BereichNode.Create(Node);
  FXMLNodeList.Add(Result);
end;




end.
