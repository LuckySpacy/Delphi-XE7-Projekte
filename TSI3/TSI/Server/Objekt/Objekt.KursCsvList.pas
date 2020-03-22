unit Objekt.KursCsvList;

interface

uses
  SysUtils, Classes, Contnrs, Objekt.BasisList, Objekt.KursCsv;

type
  TKursCsvList = class(TBaseList)
  private
    function getItem(Index: Integer): TKursCsv;
    function AddYahooRow(aValue: String): TKursCsv;
    function AddOnVistaRow(aValue: String): TKursCsv;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Item[Index:Integer]: TKursCsv read getItem;
    function AddRow(aValue: string): TKursCsv;
    procedure SaveToFile(aFilename: string);
  end;

implementation

{ TKursCsvList }

uses
  Allgemein.Funktionen;

constructor TKursCsvList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TKursCsvList.Destroy;
begin

  inherited;
end;



function TKursCsvList.AddRow(aValue: string): TKursCsv;
begin
  //Result := AddYahooRow(aValue);
  Result := AddOnVistaRow(aValue);
end;

function TKursCsvList.AddYahooRow(aValue: String): TKursCsv;
var
  List: TStringList;
  i1: Integer;
  Datum: string;
  Jahr: string;
  Monat: string;
  Tag: string;
  Schlusskurs: string;
  KursCsv: TKursCsv;
begin
  Result := nil;
  List := TStringList.Create;
  try
    List.Delimiter := ',';
    List.StrictDelimiter := true;

    List.DelimitedText := aValue;

    if List.Count < 7 then
      exit;

    Datum := List.Strings[0];
    if Datum = 'Date' then
      exit;

    Jahr  := copy(Datum, 1, 4);
    Monat := copy(Datum, 6, 2);
    Tag   := copy(Datum, 9, 2);
    Datum := Tag + '.' + Monat + '.' + Jahr;
    Schlusskurs := List.Strings[4];
    Schlusskurs := StringReplace(Schlusskurs, '.', ',', [rfReplaceAll]);
    KursCsv := TKursCsv.Create(nil);
    KursCsv.Datum := Datum;
    KursCsv.Schlusskurs := Schlusskurs;
    fList.Add(KursCsv);

      {
    for i1 := 0 to List.Count -1 do
    begin
      Datum := List.Strings[0];
      Jahr  := copy(Datum, 1, 4);
      Monat := copy(Datum, 6, 2);
      Tag   := copy(Datum, 9, 2);
      Datum := Tag + '.' + Monat + '.' + Jahr;
      Schlusskurs := List.Strings[6];
      Schlusskurs := StringReplace(Schlusskurs, '.', ',', [rfReplaceAll]);
      KursCsv := TKursCsv.Create(nil);
      KursCsv.Datum := Datum;
      KursCsv.Schlusskurs := Schlusskurs;
      fList.Add(KursCsv);

    end;
       }

  finally
    FreeAndNil(List);
  end;
end;

function TKursCsvList.AddOnVistaRow(aValue: String): TKursCsv;
var
  List: TStringList;
  i1: Integer;
  Datum: string;
  Jahr: string;
  Monat: string;
  Tag: string;
  Schlusskurs: string;
  KursCsv: TKursCsv;
begin
  Result := nil;
  List := TStringList.Create;
  try
    List.Delimiter := ';';
    List.StrictDelimiter := true;

    List.DelimitedText := aValue;

    if List.Count < 6 then
      exit;

    Datum := List.Strings[0];
    if Datum = 'Datum' then
      exit;

    Schlusskurs := List.Strings[4];
    SchlussKurs := MakeValidFloat(Schlusskurs);
    //Schlusskurs := StringReplace(Schlusskurs, '.', ',', [rfReplaceAll]);
    KursCsv := TKursCsv.Create(nil);
    KursCsv.Datum := Datum;
    KursCsv.Schlusskurs := Schlusskurs;
    fList.Add(KursCsv);
    Result := KursCsv;

  finally
    FreeAndNil(List);
  end;
end;



function TKursCsvList.getItem(Index: Integer): TKursCsv;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TKursCsv(fList.Items[Index]);
end;

procedure TKursCsvList.SaveToFile(aFilename: string);
var
  List: TStringList;
  i1: Integer;
  s: string;
  Kurs: TKursCsv;
begin
  List := TStringList.Create;
  try
    for i1 := 0 to fList.Count -1 do
    begin
      Kurs := TKursCsv(fList.Items[i1]);
      s := Kurs.Datum + ';' + Kurs.Schlusskurs;
      List.Add(s);
    end;
    List.SaveToFile(aFilename);
  finally
    FreeAndNil(List);
  end;

end;

end.
