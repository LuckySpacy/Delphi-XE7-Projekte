unit o_xmlsh_BereichNode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, xml.xmldoc, xml.xmlintf, o_fontobj,
  o_xmlsh_FontNode;


type
  RXMLNode = record
    Bereich: IXMLNode;
    Font: IXMLNode;
    WortListe: IXMLNode;
    WortendeListe: IXMLNode;
    WortanfangListe: IXMLNode;
    WortendeBeachten: IXMLNode;
  end;

type
  TxmlSh_BereichNode = class
  private
    FBereichname: string;
    FXMLNode: RXMLNode;
    FFontNode: TxmlSh_FontNode;
    FWortListe: string;
    FWortendeListe: string;
    FWortendeBeachten: Boolean;
    FWortanfangListe: string;
    procedure setWortListe(const Value: string);
    procedure setWortendeListe(const Value: string);
    procedure setWortendeBeachten(const Value: Boolean);
    procedure setFontStr(const Value: string);
    function getFontStr: string;
    procedure setBereichname(const Value: string);
    procedure setWortanfangListe(const Value: string);
  public
    constructor Create(aXMLNode: IXMLNode);
    destructor Destroy; override;
    property Bereichname: string read FBereichname write setBereichname;
    property FontStr: string read getFontStr write setFontStr;
    property WortListe: string read FWortListe write setWortListe;
    property WortendeListe: string read FWortendeListe write setWortendeListe;
    property WortanfangListe: string read FWortanfangListe write setWortanfangListe;
    property WortendeBeachten: Boolean read FWortendeBeachten write setWortendeBeachten;
    procedure Delete;
  end;

implementation

{ TxmlSh_BereichNode }

constructor TxmlSh_BereichNode.Create(aXMLNode: IXMLNode);
var
  Node: IXMLNode;
begin
  FFontNode := nil;
  FXMLNode.Bereich := aXMLNode;
  FBereichname := '';
  FWortListe := '';
  FWortendeListe := '';
  FWortanfangListe := '';
  if aXMLNode.Attributes['Name'] <> Null  then
    FBereichname := aXMLNode.Attributes['Name'];
  if aXMLNode.Attributes['Wortende'] = Null then
    FWortendeBeachten := false
  else
    FWortendeBeachten := StrToBool(aXMLNode.Attributes['Wortende']);

  FXMLNode.Font := FXMLNode.Bereich.ChildNodes.FindNode('Font');
  if FXMLNode.Font <> nil then
    FFontNode := TxmlSh_FontNode.Create(FXMLNode.Font)
  else
  begin
    FXMLNode.Font := FXMLNode.Bereich.AddChild('Font');
    FFontNode := TxmlSh_FontNode.Create(FXMLNode.Font)
  end;

  FXMLNode.WortListe := FXMLNode.Bereich.ChildNodes.FindNode('Wortliste');
  if FXMLNode.WortListe <> nil then
    FWortListe := FXMLNode.WortListe.Text
  else
    FXMLNode.WortListe := FXMLNode.Bereich.AddChild('Wortliste');

  FXMLNode.WortendeListe := FXMLNode.Bereich.ChildNodes.FindNode('Wortendeliste');
  if FXMLNode.WortendeListe <> nil then
    FWortendeListe := FXMLNode.WortendeListe.Text
  else
    FXMLNode.WortendeListe := FXMLNode.Bereich.AddChild('Wortendeliste');

  FXMLNode.WortanfangListe := FXMLNode.Bereich.ChildNodes.FindNode('Wortanfangliste');
  if FXMLNode.WortanfangListe <> nil then
    FWortanfangListe := FXMLNode.WortanfangListe.Text
  else
    FXMLNode.WortanfangListe := FXMLNode.Bereich.AddChild('Wortanfangliste');


end;


destructor TxmlSh_BereichNode.Destroy;
begin
  if FFontNode <> nil then
    FreeAndNil(FFontNode);
  inherited;
end;

function TxmlSh_BereichNode.getFontStr: string;
begin
  Result := FFontNode.FontStr;
end;

procedure TxmlSh_BereichNode.setBereichname(const Value: string);
begin
  FBereichname := Value;
  FXMLNode.Bereich.Attributes['Name'] := Value;
end;

procedure TxmlSh_BereichNode.setFontStr(const Value: string);
begin
  FFontNode.FontStr := Value;
end;

procedure TxmlSh_BereichNode.setWortanfangListe(const Value: string);
begin
  FWortanfangListe := Value;
  if FXMLNode.WortanfangListe <> nil then
    FXMLNode.WortanfangListe.Text := Value;
end;

procedure TxmlSh_BereichNode.setWortendeBeachten(const Value: Boolean);
begin
  FWortendeBeachten := Value;
  if FXMLNode.Bereich <> nil then
    FXMLNode.Bereich.Attributes['Wortende'] := BoolToStr(Value);
end;

procedure TxmlSh_BereichNode.setWortendeListe(const Value: string);
begin
  FWortendeListe := Value;
  if FXMLNode.WortendeListe <> nil then
    FXMLNode.WortendeListe.Text := Value;
end;

procedure TxmlSh_BereichNode.setWortListe(const Value: string);
begin
  FWortListe := Value;
  if FXMLNode.WortListe <> nil then
    FXMLNode.WortListe.Text := Value;
end;


procedure TxmlSh_BereichNode.Delete;
begin
  if FXMLNode.Bereich = nil then
    exit;
  if FXMLNode.Bereich.ParentNode = nil then
    exit;
  FXMLNode.Bereich.ParentNode.ChildNodes.Remove(FXMLNode.Bereich);
end;


end.
