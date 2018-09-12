unit u_Allgfunc;

interface

uses
  sysUtils, Classes, vcl.Graphics, RvStyle;

function tbStrToInt(aValue: string; aDefault: Integer): Integer;
function tbStrToFontStyles(aValue: string): TFontStyles;
function tbStrToRvAlignment(aValue: string): TRVAlignment;
function tbRvAlignmentToStr(aRVAlignment: TRVAlignment): string;
function tbsetFontStylesToStr(aFontStyles: TFontStyles): string;
function tbBoolToStr(const Value: Boolean): string;
function tbEntschluesseln(aText, aPW: string): string;
function tbVerschluesseln(aText, aPW: string): string;
procedure tbLoadIconFromRes(aResType, aResName: string; aIcon: vcl.Graphics.TIcon);

implementation


function tbStrToInt(aValue: string; aDefault: Integer): Integer;
begin
  if not TryStrToInt(aValue, Result) then
    Result := aDefault;
end;

function tbStrToFontStyles(aValue: string): TFontStyles;
begin
  Result := [];
  if Pos('fsBold', aValue) > 0 then
    Result := Result + [fsBold];
  if Pos('fsItalic', aValue) > 0 then
    Result := Result + [fsItalic];
  if Pos('fsUnderline', aValue) > 0 then
    Result := Result + [fsUnderline];
end;

function tbStrToRvAlignment(aValue: string): TRVAlignment;
begin
  Result := rvaLeft;
  if Pos('rvaCenter', aValue) > 0 then
    Result := rvaCenter;
  if Pos('rvaLeft', aValue) > 0 then
    Result := rvaLeft;
  if Pos('rvaRight', aValue) > 0 then
    Result := rvaRight;
  if Pos('rvaJustify', aValue) > 0 then
    Result := rvaJustify;
end;

function tbRvAlignmentToStr(aRVAlignment: TRVAlignment): string;
begin
  if aRVAlignment = rvaLeft then
    Result := 'rvaLeft';
  if aRVAlignment = rvaRight then
    Result := 'rvaRight';
  if aRVAlignment = rvaCenter then
    Result := 'rvaCenter';
  if aRVAlignment = rvaJustify then
    Result := 'rvaJustify';
end;



function tbsetFontStylesToStr(aFontStyles: TFontStyles): string;
begin
  Result := '';
  if fsBold in aFontStyles then
    Result := Result + '[fsBold]';
  if fsItalic in aFontStyles then
    Result := Result + '[fsItalic]';
  if fsUnderline in aFontStyles then
    Result := Result + '[fsUnderline]';
end;

function tbBoolToStr(const Value: Boolean): string;
begin
  if Value then
    Result := 'T'
  else
    Result := 'F';
end;


function tbEntschluesseln(aText, aPW: string): string;
var
//  i1: Integer;
  i2: Integer;
  iPW: Integer;
  sHex: string;
  sText: string;
begin
  Result := '';
  if aPW = '' then
    exit;
  i2 := 1;
  while Length(aText) > 0 do
  begin
    sText := copy(aText, 1, 4);
    Delete(aText, 1, 4);
    inc(i2);
    if i2 > Length(aPW) then
      i2 := 1;
    sHex := '$' + sText;
    iPW  := StrToInt(sHex) - ord(aPW[i2]);
    Result := Result + chr(iPW);
  end;
end;

function tbVerschluesseln(aText, aPW: string): string;
var
  i1, i2: Integer;
  iPW: Integer;
  sHex: string;
begin
  Result := '';
  if aPW = '' then
    exit;
  i2 := 1;
  for i1 := 1 to Length(aText) do
  begin
    inc(i2);
    if i2 > Length(aPW) then
      i2 := 1;
    iPW := Ord(aText[i1]) + ord(aPW[i2]);
    sHex := IntToHex(iPW, 4);
    Result := Result + sHex;
  end;
end;


procedure tbLoadIconFromRes(aResType, aResName: string; aIcon: vcl.Graphics.TIcon);
var
  Res: TResourceStream;
begin
  Res := TResourceStream.Create(Hinstance, aResname, PChar(aResType));
  try
    aIcon.LoadFromStream(Res);
  finally
    FreeAndNil(Res);
  end;
end;



end.
