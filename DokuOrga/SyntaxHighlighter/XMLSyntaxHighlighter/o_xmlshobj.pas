unit o_xmlshobj;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, xml.xmldoc, xml.xmlintf, o_fontobj,
  o_xmlsh_StylenameList, o_xmlsh_StylenameNode;
type
  TxmlShObj = class
  private
    Fxml: IXMLDocument;
    FxmlStylenameList: TxmlSh_StylenameList;
    FFilename: string;
    FXMLStyleName: TxmlSh_StylenameNode;
  public
    constructor Create(aFilename: string);
    destructor Destroy; override;
    procedure LadeStyleNames(aList: TStrings);
    procedure LadeBereiche(aList: TStrings);
    procedure LadeKommentar(aList: TStrings);
    procedure setStyleName(aStyleName: string);
    property XMLStyleNode: TxmlSh_StylenameNode read FXMLStyleName write FXMLStyleName;
    function AddStyleName: TxmlSh_StylenameNode;
    procedure DeleteStyle;
    procedure save;
    function savetostream: string;
  end;

implementation

{ TxmlShObj }




constructor TxmlShObj.Create(aFilename: string);
begin
  Fxml := NewXMLDocument;
  FFilename := aFilename;
  if FileExists(aFilename) then
    Fxml.LoadFromFile(aFilename)
  else
    Fxml.CreateNode('SyntaxHighlighter', ntElement, '');
  fxml.Active := true;
  FxmlStylenameList := TxmlSh_StylenameList.Create(fxml.ChildNodes['SyntaxHighlighter'].ChildNodes);
  FXMLStyleName := nil;
end;

procedure TxmlShObj.DeleteStyle;
var
  NodeList: IXMLNodeList;
begin
  NodeList := fxml.ChildNodes['SyntaxHighlighter'].ChildNodes;
  if FXMLStyleName.Node <> nil then
  begin
    NodeList.Remove(FXMLStyleName.Node);
    FxmlStylenameList.Delete(FXMLStyleName);
  end;
end;

destructor TxmlShObj.Destroy;
begin

  inherited;
end;

function TxmlShObj.AddStyleName: TxmlSh_StylenameNode;
var
  Node: IXMLNode;
begin
  Node := fxml.ChildNodes['SyntaxHighlighter'];
  Node := Node.addChild('Style');
  Result := TxmlSh_StylenameNode.Create(Node);
  FxmlStylenameList.Add(Result);
end;


procedure TxmlShObj.LadeBereiche(aList: TStrings);
var
  StyleNameNode: TxmlSh_StylenameNode;
begin
  aList.Clear;
  if FXMLStyleName = nil then
    exit;
  FXMLStyleName.LadeBereiche(aList);
end;

procedure TxmlShObj.LadeKommentar(aList: TStrings);
var
  StyleNameNode: TxmlSh_StylenameNode;
begin
  aList.Clear;
  if FXMLStyleName = nil then
    exit;
  FXMLStyleName.LadeKommentar(aList);
end;

procedure TxmlShObj.LadeStyleNames(aList: TStrings);
begin
  FxmlStylenameList.LadeStyleNames(aList);
end;

procedure TxmlShObj.save;
begin
  fxml.SaveToFile(FFilename);
end;

function TxmlShObj.savetostream: string;
var
  m: TMemoryStream;
  List: TStringList;
begin
  save;
  List := TStringList.Create;
  m := TMemoryStream.Create;
  try
    fxml.SaveToStream(m);
    m.Position := 0;
    List.LoadFromStream(m);
    Result := List.Text;
  finally
    FreeAndNil(m);
    FreeAndNil(List);
  end;
end;

procedure TxmlShObj.setStyleName(aStyleName: string);
begin
  FXMLStyleName := FxmlStylenameList.getStyleName(aStyleName);
end;

end.
