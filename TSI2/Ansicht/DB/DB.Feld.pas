unit DB.Feld;

interface

uses
  SysUtils, Classes, variants, Data.DB;

type
  TDBFeld = class(TComponent)
  private
    fValue: string;
    fChanged: Boolean;
    fFeldName: string;
    fNewInit: Boolean;
    fDataType: TFieldType;
    fAlwaysTrim: Boolean;
    fCalcField: Boolean;
    function getAsString: string;
    procedure setAsString(const Value: string);
    function getInteger: Integer;
    procedure setInteger(const Value: Integer);
    function getAsBoolean: Boolean;
    procedure setAsBoolean(const Value: Boolean);
    function getAsDateTime: TDateTime;
    procedure setAsDateTime(const Value: TDateTime);
    function getAsFloat: real;
    procedure setAsFloat(const Value: real);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitValue;
    property AsString: string read getAsString write setAsString;
    property AsInteger: Integer read getInteger write setInteger;
    property Changed: Boolean read FChanged write FChanged;
    property Feldname: string read fFeldName write fFeldName;
    property AsBoolean: Boolean read getAsBoolean write setAsBoolean;
    property AsDateTime: TDateTime read getAsDateTime write setAsDateTime;
    property AsFloat: real read getAsFloat write setAsFloat;
    property AlwaysTrim: Boolean read fAlwaysTrim write fAlwaysTrim;
    property DataType: TFieldType read fDataType write fDataType;
    property CalcField: Boolean read fCalcField write fCalcField;
    function AsMySqlDateTime: string;
  end;

implementation

{ TDBFeld }

uses
  DateUtils;


constructor TDBFeld.Create(AOwner: TComponent);
begin
  inherited;
  InitValue;
end;

destructor TDBFeld.Destroy;
begin

  inherited;
end;


procedure TDBFeld.InitValue;
begin
  fChanged := false;
  fValue := '';
  fNewInit := true;
  fAlwaysTrim := false;
  fCalcField := false;
end;


function TDBFeld.getAsBoolean: Boolean;
begin
  Result := FValue = 'T';
end;

function TDBFeld.getAsDateTime: TDateTime;
begin
  if not TryStrToDateTime(FValue, Result) then
    Result := 0;
end;

function TDBFeld.AsMySqlDateTime: string;
var
  Datum: TDateTime;
begin
  Datum := getAsDateTime;
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Datum);
end;


function TDBFeld.getAsFloat: real;
var
  e: Extended;
begin
  if not TryStrToFloat(FValue, e) then
    Result := 0
  else
    Result := e;
end;

function TDBFeld.getAsString: string;
begin
  Result := FValue;
  if fAlwaysTrim then
    Result := Trim(FValue);
end;

function TDBFeld.getInteger: Integer;
begin
  if not TryStrToInt(FValue, Result) then
    Result := 0;
end;


procedure TDBFeld.setAsBoolean(const Value: Boolean);
begin
  if Value then
    setAsString('T')
  else
    setAsString('F');
end;

procedure TDBFeld.setAsDateTime(const Value: TDateTime);
begin
  setAsString(DateTimeToStr(Value));
end;



procedure TDBFeld.setAsFloat(const Value: real);
begin
  setAsString(FloatToStr(Value));
end;

procedure TDBFeld.setAsString(const Value: string);
begin
  if (not FNewInit) and (Value <> FValue) then
    FChanged := true;

  FValue := Value;
  if fAlwaysTrim then
    FValue := Trim(Value);
  FNewInit := false;
end;

procedure TDBFeld.setInteger(const Value: Integer);
begin
  setAsString(IntToStr(Value));
end;


end.
