unit o_TimeObj;

interface

uses
  Classes, SysUtils, DateUtils;

type
  TTimeObj = class(TObject)
  private
    FSplittTime: TStringList;
    FTimeStr: string;
    FMilli: Int64;
    function getMilli: Integer;
    procedure setMilli(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    property Mili: Integer read getMilli write setMilli;
    property TimeStr: string read FTimeStr write FTimeStr;
    procedure setTimeToTimeStr(aTime: TDateTime);
    function Ankunftsort: string;
    function Ankunft: string;
  end;



implementation

{ TTimeObj }


constructor TTimeObj.Create;
begin
  inherited;
  FSplittTime := TStringList.Create;
  FSplittTime.Delimiter := ':';
  FSplittTime.StrictDelimiter := true;
end;

destructor TTimeObj.Destroy;
begin
  FreeAndNil(FSplittTime);
  inherited;
end;

function TTimeObj.getMilli: Integer;
begin
  Result := FMilli;
end;

procedure TTimeObj.setMilli(const Value: Integer);
var
  t: TDateTime;
begin
  FMilli := Value;
  t := 0;
  t := IncMilliSecond(t, Value);
  setTimeToTimeStr(t);
end;

procedure TTimeObj.setTimeToTimeStr(aTime: TDateTime);
  function getIntToTstr(aValue: Int64): string;
  begin
    Result := IntToStr(aValue);
    if Length(Result) = 1 then
      Result := '0' + Result;
  end;
var
  t: TDateTime;
  Hour, Min, Sec, m: Word;
  Stunden: Int64;
  Minuten: Int64;
  Sekunden: Int64;
begin
  t := 0;
  Stunden := HoursBetween(aTime, t);

  DecodeTime(aTime, Hour, min, sec, m);
  Minuten  := Min;
  Sekunden := Sec;
  FTimeStr := getIntToTstr(Stunden) + ':' + getIntToTstr(Minuten) + ':' + getIntToTstr(Sekunden);

end;


function TTimeObj.Ankunft: string;
var
  t: TDatetime;
begin
  t := IncMilliSecond(now, FMilli);
  //Result := FormatDateTime('dd.mm.yy hh:nn:ss', t);
  Result := FormatDateTime('hh:nn:ss', t);
end;

function TTimeObj.Ankunftsort: string;
var
  t: TDatetime;
begin
  t := IncMilliSecond(now, FMilli);
  Result := FormatDateTime('yyyymmddhhnnss', t);
end;


end.
