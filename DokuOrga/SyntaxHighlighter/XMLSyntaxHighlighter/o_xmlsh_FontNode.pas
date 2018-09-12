unit o_xmlsh_FontNode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, xml.xmldoc, xml.xmlintf, o_fontobj;

type
  TxmlSh_FontNode = class
  private
    FXMLNode: IXMLNode;
    FFontStr: string;
    FFontObj: TFontObj;
    procedure setFontStr(const Value: string);
  public
    constructor Create(aXMLNode: IXMLNode);
    destructor Destroy; override;
    property FontStr: string read FFontStr write setFontStr;
  end;

implementation

{ TxmlSh_FontNode }

constructor TxmlSh_FontNode.Create(aXMLNode: IXMLNode);
begin
  FFontStr := '';
  FXMLNode := aXMLNode;
  if (FXMLNode <> nil) and (FXMLNode.Attributes['Style'] <> null) then
    FFontStr := FXMLNode.Attributes['Style'];
end;

destructor TxmlSh_FontNode.Destroy;
begin

  inherited;
end;

procedure TxmlSh_FontNode.setFontStr(const Value: string);
begin
  FFontStr := Value;
  if FXMLNode <> nil then
    FXMLNode.Attributes['Style'] := FFontstr;
end;

end.
