unit o_xmlsh_StylenameList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, xml.xmldoc, xml.xmlintf,
  o_xmlsh_stylenamenode, contnrs;

type
  TxmlSh_StylenameList = class
  private
    FXMLNodeList: TObjectList;
    FIXMLNodeList: IXMLNodeList;
  public
    constructor Create(aXMLNodeList: IXMLNodeList);
    destructor Destroy; override;
    procedure LadeNodeList(aXMLNodeList: IXMLNodeList);
    procedure LadeStyleNames(aList: TStrings);
    procedure Add(aStylenameNode: TxmlSh_StylenameNode);
    function getStyleName(aStyleName: string): TxmlSh_StylenameNode;
    procedure Delete(aStyleNameNode: TxmlSh_StylenameNode);
  end;

implementation

{ TxmlShObj }


constructor TxmlSh_StylenameList.Create(aXMLNodeList: IXMLNodeList);
begin
  FXMLNodeList := TObjectList.Create;
  FIXMLNodeList := aXMLNodeList;
  LadeNodeList(aXMLNodeList);
end;


destructor TxmlSh_StylenameList.Destroy;
begin
  FreeAndNil(FXMLNodeList);
  inherited;
end;


procedure TxmlSh_StylenameList.Add(aStylenameNode: TxmlSh_StylenameNode);
begin
  FXMLNodeList.Add(aStylenameNode);
end;


procedure TxmlSh_StylenameList.LadeNodeList(aXMLNodeList: IXMLNodeList);
var
  i1: Integer;
  StylenameNode: TxmlSh_StylenameNode;
begin
  FXMLNodeList.Clear;
  for i1 := 0 to aXMLNodeList.Count -1 do
  begin
    StylenameNode := TxmlSh_StylenameNode.Create(aXMLNodeList[i1]);
    FXMLNodeList.Add(StylenameNode);
  end;
end;

procedure TxmlSh_StylenameList.Delete(aStyleNameNode: TxmlSh_StylenameNode);
var
  i1: Integer;
  StylenameNode: TxmlSh_StylenameNode;
begin
  for i1 := 0 to FXMLNodeList.Count -1 do
  begin
    StylenameNode := TxmlSh_StylenameNode(FXMLNodeList.Items[i1]);
    if StylenameNode.Stylename = aStyleNameNode.Stylename then
    begin
      FXMLNodeList.Delete(i1);
      break;
    end;
  end;
end;


procedure TxmlSh_StylenameList.LadeStyleNames(aList: TStrings);
var
  i1: Integer;
  StylenameNode: TxmlSh_StylenameNode;
begin
  aList.Clear;
  for i1 := 0 to FXMLNodeList.Count -1 do
  begin
    StylenameNode := TxmlSh_StylenameNode(FXMLNodeList.Items[i1]);
    aList.Add(StylenameNode.Stylename);
  end;
end;


function TxmlSh_StylenameList.getStyleName(aStyleName: string): TxmlSh_StylenameNode;
var
  i1: Integer;
  StylenameNode: TxmlSh_StylenameNode;
begin
  Result := nil;
  for i1 := 0 to FXMLNodeList.Count -1 do
  begin
    StylenameNode := TxmlSh_StylenameNode(FXMLNodeList.Items[i1]);
    if SameText(StylenameNode.Stylename, aStyleName) then
    begin
      Result := StylenameNode;
      exit;
    end;
  end;
end;


end.
