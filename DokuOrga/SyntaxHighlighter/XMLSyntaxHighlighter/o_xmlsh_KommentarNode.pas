unit o_xmlsh_KommentarNode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, xml.xmldoc, xml.xmlintf, o_fontobj,
  o_xmlsh_FontNode;

type
  RXMLNode = record
    Kommentar: IXMLNode;
    Kommando: IXMLNode;
  end;

type
  TxmlSh_KommentarNode = class
  private
    FXMLNode: RXMLNode;
    FFontStr: string;
    FFontNode: TxmlSh_FontNode;
    FKommando: string;
    FPosNr: Integer;
    procedure setKommando(const Value: string);
    procedure setPosnr(const Value: Integer);
    function getFontStr: string;
    procedure setFontStr(const Value: string);
    function getEndeZeichen: string;
    function getStartZeichen: string;
    procedure setEndeZeichen(const Value: string);
    procedure setStartZeichen(const Value: string);
  public
    constructor Create(aXMLNode: IXMLNode);
    destructor Destroy; override;
    property FontStr: string read getFontStr write setFontStr;
    property Kommando: string read FKommando write setKommando;
    property PosNr: Integer read FPosNr write setPosnr;
    function PosNrToStr: string;
    property StartZeichen: string read getStartZeichen write setStartZeichen;
    property EndeZeichen: string read getEndeZeichen write setEndeZeichen;
    procedure Delete;
  end;

implementation

{ TxmlSh_KommentarNode }

constructor TxmlSh_KommentarNode.Create(aXMLNode: IXMLNode);
var
  Node: IXMLNode;
begin
  FFontNode := nil;
  FKommando := '';
  FXMLNode.Kommentar := aXMLNode;
  if FXMLNode.Kommentar.Attributes['PosNr'] = NULL then
    FPosNr := 1
  else
    if not TryStrToInt(FXMLNode.Kommentar.Attributes['PosNr'], FPosNr) then
      FPosNr := 1;
  Node := FXMLNode.Kommentar.ChildNodes.FindNode('Font');
  if Node <> nil then
    FFontNode := TxmlSh_FontNode.Create(Node)
  else
  begin
    Node := FXMLNode.Kommentar.AddChild('Font');
    FFontNode := TxmlSh_FontNode.Create(Node);
  end;
  FXMLNode.Kommando := FXMLNode.Kommentar.ChildNodes.FindNode('Kommando');
  if FXMLNode.Kommando <> nil then
    FKommando := FXMLNode.Kommando.Text
  else
    FXMLNode.Kommando := FXMLNode.Kommentar.AddChild('Kommando');
end;



destructor TxmlSh_KommentarNode.Destroy;
begin
  if FFontNode <> nil then
    FreeAndNil(FFontNode);
  inherited;
end;

function TxmlSh_KommentarNode.getEndeZeichen: string;
var
  iPos: Integer;
begin
  Result := '';
  iPos := Pos(' ', FKommando);
  if iPos <= 0 then
    exit;
  Result := copy(FKommando, iPos+1, Length(FKommando));
end;

function TxmlSh_KommentarNode.getFontStr: string;
begin
  Result := '';
  if FFontNode = nil then
    exit;
  Result := FFontNode.FontStr;
end;

function TxmlSh_KommentarNode.getStartZeichen: string;
var
  iPos: Integer;
begin
  Result := FKommando;
  iPos := Pos(' ', FKommando);
  if iPos <= 0 then
    exit;
  Result := copy(FKommando, 1, iPos-1);
end;

function TxmlSh_KommentarNode.PosNrToStr: string;
begin
  Result := IntToStr(FPosNr);
  while Length(Result) < 10 do
    Result := '0' + Result;
end;

procedure TxmlSh_KommentarNode.setEndeZeichen(const Value: string);
var
  StartZeichen: string;
begin
  StartZeichen := getStartZeichen;
  setKommando(StartZeichen + ' ' + Value);
end;

procedure TxmlSh_KommentarNode.setFontStr(const Value: string);
begin
  if FFontNode = nil then
    exit;
  FFontNode.FontStr := Value;
end;

procedure TxmlSh_KommentarNode.setKommando(const Value: string);
begin
  FKommando := Value;
  FXMLNode.Kommando.Text := Value;
end;

procedure TxmlSh_KommentarNode.setPosnr(const Value: Integer);
begin
  FPosNr := Value;
  FXMLNode.Kommentar.Attributes['PosNr'] := IntToStr(Value);
end;

procedure TxmlSh_KommentarNode.setStartZeichen(const Value: string);
var
  EndeZeichen: string;
begin
  EndeZeichen := getEndeZeichen;
  setKommando(Value + ' ' + EndeZeichen);
end;

procedure TxmlSh_KommentarNode.Delete;
begin
  if FXMLNode.Kommentar = nil then
    exit;
  if FXMLNode.Kommentar.ParentNode = nil then
    exit;
  FXMLNode.Kommentar.ParentNode.ChildNodes.Remove(FxmlNode.Kommentar);
end;


end.
