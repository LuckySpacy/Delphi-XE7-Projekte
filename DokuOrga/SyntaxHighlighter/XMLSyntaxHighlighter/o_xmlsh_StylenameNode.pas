unit o_xmlsh_StylenameNode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, xml.xmldoc, xml.xmlintf, o_fontobj,
  o_xmlsh_FontNode, o_xmlsh_BereichList, o_xmlsh_KommentarList, o_xmlsh_Bereichnode, o_xmlsh_KommentarNode;

type
  RXMLNode = Record
    Style: IXMLNode;
    Font : IXMLNode;
  End;

type
  TxmlSh_StylenameNode = class
  private
    FStylename: string;
    FXMLNode: RXMLNode;
    FFontNode: TxmlSh_FontNode;
    FXMLBereichList: TxmlSh_BereichList;
    FXMLKommentarList: TxmlSh_KommentarList;
    FXMLBereichNode: TxmlSh_BereichNode;
    function getFontStr: string;
    procedure setFontStr(const Value: string);
    procedure setStylename(const Value: string);
    function getStyleNode: IXMLNode;
  public
    constructor Create(aXMLNode: IXMLNode);
    destructor Destroy; override;
    property Stylename: string read FStylename write setStylename;
    property FontStr: string read getFontStr write setFontStr;
    property Node: IXMLNode read getStyleNode;
    procedure LadeBereiche(aList: TStrings);
    procedure LadeKommentar(aList: TStrings);
    procedure setBereich(aBereichname: string);
    property XMLBereichNode: Txmlsh_BereichNode read FXMLBereichNode write FXMLBereichNode;
    procedure AddKommentar(aStartzeichen, aEndezeichen, aFontStr: string; aPosNr: Integer);
    procedure ChangeKommentarPos(aList: TStrings);
    procedure DeleteKommentar(aKommando: string);
    procedure DeleteBereich(aBereichname: string);
    procedure AddBereich(aBereichname, aFontStr: string; aWortendebeachten: Boolean);
    function XMLKommentarNode(aKommando: string): TxmlSh_KommentarNode;
  end;


implementation

{ TxmlSh_StylenameNode }



constructor TxmlSh_StylenameNode.Create(aXMLNode: IXMLNode);
var
  Node: IXMLNode;
begin
  FFontNode := nil;
  FXMLNode.Style := aXMLNode;
  FStylename := '';
  if FXMLNode.Style.Attributes['Name'] <> Null  then
    FStyleName := FXMLNode.Style.Attributes['Name'];
  FXMLNode.Font := FXMLNode.Style.ChildNodes.FindNode('Font');
  if FXMLNode.Font <> nil then
    FFontNode := TxmlSh_FontNode.Create(FXMLNode.Font);
  FXMLBereichList := TxmlSh_BereichList.Create(aXMLNode.ChildNodes);
  FXMLKommentarList := TxmlSh_KommentarList.Create(aXMLNode.ChildNodes);
  FXMLBereichNode := nil;
end;


destructor TxmlSh_StylenameNode.Destroy;
begin
  if FFontNode <> nil then
    FreeAndNil(FFontNode);
  FreeAndNil(FXMLBereichList);
  FreeAndNil(FXMLKommentarList);
  inherited;
end;

function TxmlSh_StylenameNode.getFontStr: string;
begin
  Result := '';
  if FFontNode = nil then
    exit;
  Result := FFontNode.FontStr;
end;

function TxmlSh_StylenameNode.getStyleNode: IXMLNode;
begin
  Result := FXMLNode.Style;
end;

procedure TxmlSh_StylenameNode.LadeBereiche(aList: TStrings);
begin
  FXMLBereichList.LadeBereiche(aList);
end;

procedure TxmlSh_StylenameNode.LadeKommentar(aList: TStrings);
begin
  FXMLKommentarList.LadeKommentar(aList);
end;

procedure TxmlSh_StylenameNode.setBereich(aBereichname: string);
begin
  FXMLBereichNode := FXMLBereichList.getBereich(aBereichname);
end;

procedure TxmlSh_StylenameNode.setFontStr(const Value: string);
begin
  if FFontNode = nil then
  begin
    FXMLNode.Font := FXMLNode.Style.AddChild('Font');
    FFontNode := TxmlSh_FontNode.Create(FXMLNode.Font)
  end;
  FFontNode.FontStr := Value;
end;

procedure TxmlSh_StylenameNode.setStylename(const Value: string);
begin
  FStylename := Value;
  FXMLNode.Style.Attributes['Name'] := Value;
end;


function TxmlSh_StylenameNode.XMLKommentarNode(
  aKommando: string): TxmlSh_KommentarNode;
begin
  Result := FXMLKommentarList.KommentarNode(aKommando);
end;

procedure TxmlSh_StylenameNode.AddBereich(aBereichname, aFontStr: string;
  aWortendebeachten: Boolean);
var
  NodeBereich: TxmlSh_BereichNode;
begin
  NodeBereich := FXMLBereichList.Add(FXMLNode.Style);
  NodeBereich.Bereichname := aBereichname;
  NodeBereich.FontStr := aFontStr;
  NodeBereich.WortendeBeachten := aWortendebeachten;
end;

procedure TxmlSh_StylenameNode.AddKommentar(aStartzeichen, aEndezeichen, aFontStr: string; aPosNr: Integer);
var
  NodeKommentar: TxmlSh_KommentarNode;
begin
  NodeKommentar := FXMLKommentarList.Add(FXMLNode.Style);
  if aEndezeichen > '' then
    NodeKommentar.Kommando := aStartzeichen + ' ' + aEndezeichen
  else
    NodeKommentar.Kommando := aStartzeichen;

  NodeKommentar.FontStr := aFontStr;
  NodeKommentar.PosNr   := aPosNr;

end;

procedure TxmlSh_StylenameNode.ChangeKommentarPos(aList: TStrings);
var
  i1: Integer;
  Kommando: string;
  KommandoNode: TxmlSh_KommentarNode;
begin
  for i1 := 0 to aList.Count -1 do
  begin
    Kommando := aList.Strings[i1];
    KommandoNode := FXMLKommentarList.KommentarNode(Kommando);
    if KommandoNode = nil then
      exit;
    KommandoNode.PosNr := i1 +1;
  end;
end;


procedure TxmlSh_StylenameNode.DeleteBereich(aBereichname: string);
begin
  FXMLBereichList.Delete(aBereichname);
end;

procedure TxmlSh_StylenameNode.DeleteKommentar(aKommando: string);
begin
  FXMLKommentarList.Delete(aKommando);
end;



end.
