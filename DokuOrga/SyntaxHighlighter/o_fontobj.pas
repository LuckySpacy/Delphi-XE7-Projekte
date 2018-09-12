unit o_fontobj;

interface

uses
  SysUtils, Classes, Vcl.Graphics;

type
  TFontObj = class
  private
    FColor: TColor;
    FFontname: string;
    FAlignment: TAlignment;
    FSize: Integer;
    FStyle: TFontStyles;
    function getFontStr: string;
    procedure setFontStr(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    property Fontname: string read FFontname write FFontname;
    property Color: TColor read FColor write FColor;
    property Size: Integer read FSize write FSize;
    property Style: TFontStyles read FStyle write FStyle;
    property Alignment: TAlignment read FAlignment write FAlignment;
    property FontStr: string read getFontStr write setFontStr;
  end;



implementation

{ TFontObj }


constructor TFontObj.Create;
begin

end;

destructor TFontObj.Destroy;
begin

  inherited;
end;

function TFontObj.getFontStr: string;
var
  AlignmentStr: string;
  StyleStr: string;
begin
  if Alignment = taLeftJustify  then
    AlignmentStr := 'Left';
  if Alignment = taCenter  then
    AlignmentStr := 'Center';
  if Alignment = taRightJustify  then
    AlignmentStr := 'Right';

  StyleStr := '';
  if fsBold in FStyle then
    StyleStr := StyleStr + 'Bold=1~'
  else
    StyleStr := StyleStr + 'Bold=0~';

  if fsItalic in FStyle then
    StyleStr := StyleStr + 'Italic=1~'
  else
    StyleStr := StyleStr + 'Italic=0~';

  if fsUnderline in FStyle then
    StyleStr := StyleStr + 'Underline=1~'
  else
    StyleStr := StyleStr + 'Underline=0~';

  if fsStrikeOut in FStyle then
    StyleStr := StyleStr + 'StrikeOut=1'
  else
    StyleStr := StyleStr + 'StrikeOut=0';

  Result := FFontname + ';' + IntToStr(FSize) + ';' + ColorToString(FColor) + ';' +
            AlignmentStr + ';' + StyleStr;
end;

procedure TFontObj.setFontStr(const Value: string);
var
  List: TStringList;
  StyleList: TStringList;
begin
  StyleList := TStringList.Create;
  List := TStringList.Create;
  try
    List.Delimiter := ';';
    List.StrictDelimiter := true;
    List.DelimitedText := Value;
    if List.Count < 5 then
      exit;
    FFontname := List.Strings[0];
    TryStrToInt(List.Strings[1], FSize);
    FColor := StringToColor(List.Strings[2]);
    if List.Strings[3] = 'Left' then
      FAlignment := taLeftJustify;
    if List.Strings[3] = 'Right' then
      FAlignment := taRightJustify;
    if List.Strings[3] = 'Center' then
      FAlignment := taCenter;
    StyleList.Delimiter := '~';
    StyleList.StrictDelimiter := true;
    StyleList.DelimitedText := List.Strings[4];
    if StyleList.Count < 4 then
      exit;
    FStyle := [];
    if StyleList.Values['Bold'] = '1' then
      FStyle := FStyle + [fsBold];
    if StyleList.Values['Italic'] = '1' then
      FStyle := FStyle + [fsItalic];
    if StyleList.Values['Underline'] = '1' then
      FStyle := FStyle + [fsUnderline];
    if StyleList.Values['StrikeOut'] = '1' then
      FStyle := FStyle + [fsStrikeOut];
  finally
    FreeAndNil(List);
    FreeAndNil(StyleList);
  end;

end;



end.
