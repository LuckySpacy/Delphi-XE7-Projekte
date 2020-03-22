unit Allgemein.Funktionen;

interface

uses
  Windows, Classes, System.SysUtils;


function isValidEmail(const aValue: string; var aFehlermeldung: string): Boolean;
function Runden(aValue: real; aAnzahlStellen: Integer): real;
function MakeValidFloat(aValue: string): string;

implementation

uses
  math;




function isValidEmail(const aValue: string; var aFehlermeldung: string): Boolean;
var
  iPos: Integer;
  s: string;
  s1: string;
  i1, i2: Integer;
  List: TStringList;
begin
  Result := false;
  List := TStringList.Create;
  try
    s := aValue;
    if Trim(s) = '' then
    begin
      aFehlermeldung := 'EMail-Adresse ist leer';
      exit;
    end;
    if s[Length(s)] = ';' then
      s := Copy(s, 1, Length(s)-1);

    List.StrictDelimiter := true;
    List.Delimiter := ';';
    List.DelimitedText := s;

    for i2 := 0 to List.Count -1 do
    begin
      s := List.Strings[i2];
      aFehlermeldung := '';
      if Trim(s) = '' then
      begin
        aFehlermeldung := 'EMail-Adresse ist leer';
        exit;
      end;
      iPos := Pos('@', s);
      if iPos <= 0 then
      begin
        aFehlermeldung := 'Das @-Zeichen fehlt.';
        exit;
      end;
      s := StringReplace(s, '@', '', []);
      s := LowerCase(s);
      iPos := Pos('@', s);
      if iPos > 0 then
      begin
        aFehlermeldung := 'Mehr als ein @-Zeichen gefunden.';
        exit;
      end;
      iPos := Pos('@', List.Strings[i2]);
      s1 := copy(List.Strings[i2], iPos+1, Length(List.Strings[i2]));
      iPos := Pos('.', s1);
      if iPos <=0  then
      begin
        aFehlermeldung := 'String hinter dem @-Zeichen "' + s1 + '" fehlt irgendwo ein Punkt';
        exit;
      end;

      for i1 := 1 to Length(s) do
      begin
        if not CharInSet(s[i1], ['a'..'z', '0'..'9', '-', '_', '.']) then
        begin
          aFehlermeldung := 'Dieses Zeichen "' + s[i1] + '" ist in einer EMail-Adresse ungültig';
          exit;
        end;
      end;
    end;
    Result := true;
  finally
    FreeAndNil(List);
  end;
end;


function Runden(aValue: real; aAnzahlStellen: Integer): real;
var
  r: real;
begin
  // SimpleRoundTo liefert nicht immer das gewünschte Ergebnis
  // Bitte einmal in eine Extended, Double oder Real Variable den Wert 87.285 versuchen
  // Das Ergebnis was SimpleRoundTo zurückliefert wird 87.28 sein.
  // Siehe dazu http://pages.cs.wisc.edu/~rkennedy/exact-float?number=87.285
  r := IntPower(10, -(aAnzahlStellen+2));
  aValue := aValue + r;
  Result := SimpleRoundTo(aValue, aAnzahlStellen*-1);
end;


function MakeValidFloat(aValue: string): string;
var
  iPosKomma: Integer;
  iPosPunkt: Integer;
begin
  Result := aValue;
  iPosKomma := LastDelimiter(',', aValue);
  iPosPunkt := LastDelimiter('.', aValue);

  if (iPosKomma = 0) and (iPosPunkt = 0) then
    exit;

  if iPosKomma > iPosPunkt then
  begin
    Result := StringReplace(aValue, '.', '', [rfReplaceAll]);
    exit;
  end;

  Result := StringReplace(aValue, ',', '', [rfReplaceAll]);
  Result := StringReplace(Result, '.', ',', [rfReplaceAll]);

end;



end.
