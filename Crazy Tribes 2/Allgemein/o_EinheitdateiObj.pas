unit o_EinheitdateiObj;

interface

uses
  SysUtils, Classes, o_Koordinate;


type
  TEinheitdateiObj = class(TObject)
  private
    FList: TStringList;
    FKoordinate: TKoordinate;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure setValue(aZeile: string);
    property Koordinate: TKoordinate read FKoordinate write FKoordinate;
    function GetValue(aItemIndex: Integer): Integer;
  end;


implementation

{ TEinheitdateiObj }

constructor TEinheitdateiObj.Create;
begin
  inherited;
  FList := TStringList.Create;
  FKoordinate := TKoordinate.Create;
end;

destructor TEinheitdateiObj.Destroy;
begin
  FreeAndNil(FKoordinate);
  FreeAndNil(FList);
  inherited;
end;


procedure TEinheitdateiObj.setValue(aZeile: string);
var
  SplittList: TStringList;
  i1: Integer;
begin
  FList.Clear;
  SplittList := TStringList.Create;
  try
    SplittList.Delimiter := ';';
    SplittList.StrictDelimiter := true;
    SplittList.DelimitedText := aZeile;
    Koordinate.AsString := SplittList.Strings[0];
    for i1 := 1 to SplittList.Count - 1 do
      FList.Add(SplittList.Strings[i1]);
  finally
    FreeAndNil(SplittList);
  end;

end;

function TEinheitdateiObj.GetValue(aItemIndex: Integer): Integer;
var
  iResult: Integer;
begin
  Result := 0;
  if aItemIndex > FList.Count -1 then
    exit;
  if not TryStrToInt(FList.ValueFromIndex[aItemIndex], iResult) then
    iResult := 0;

  Result := iResult;
end;


end.
