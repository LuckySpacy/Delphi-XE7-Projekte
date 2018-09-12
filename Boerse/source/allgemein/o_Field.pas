unit o_Field;

interface

uses
  Classes, SysUtils, variants;

  type TTBField = class(TObject)
  private
    FValue: Variant;
    FVarValue: Integer;
    FChangedValue: Boolean;
    function GetCurr: Currency;
    function GetInt: Integer;
    function GetString: string;
    function GetVariant: Variant;
    procedure SetCurr(const Value: Currency);
    procedure SetInt(const Value: Integer);
    procedure SetString(const Value: string);
    procedure SetVariant(const Value: Variant);
    function GetDateTime: TDateTime;
    procedure SetDateTime(const Value: TDateTime);
  public
    constructor Create;
    destructor Destroy; override;
    property AsString: string read GetString write SetString;
    property AsInteger: Integer read GetInt write SetInt;
    property AsCurrency: Currency read GetCurr write SetCurr;
    property AsDateTime: TDateTime read GetDateTime write SetDateTime;
    property AsValue: Variant read GetVariant write SetVariant;
    procedure SetValueEmpty;

  end;


implementation

{ TTBField }

constructor TTBField.Create;
begin
  FVarValue := -1;
  FChangedValue := false;
end;

destructor TTBField.Destroy;
begin

  inherited;
end;

function TTBField.GetCurr: Currency;
var
  s: string;
begin
  Result := 0;
  case FVarValue of
      varSmallInt  : Result := FValue;
      varInteger   : Result := FValue;
      varSingle    : Result := FValue;
      varDouble    : Result := FValue;
      varCurrency  : Result := FValue;
      varByte      : Result := FValue;
      varWord      : Result := FValue;
      varLongWord  : Result := FValue;
      varInt64     : Result := FValue;
      varString    : begin
                       s := StringReplace(FValue, '.', ',', [rfReplaceAll]);
                       if not TryStrToCurr(s, Result) then
                         Result := 0;
                     end;
  end;
end;

function TTBField.GetDateTime: TDateTime;
begin
  Result := 0;
  case FVarValue of
    varDate      : Result := FValue;
  end;
end;

function TTBField.GetInt: Integer;
begin
  case FVarValue of
    varSmallInt  : Result := FValue;
    varInteger   : Result := FValue;
    varSingle    : Result := FValue;
    varByte      : Result := FValue;
    varWord      : Result := FValue;
    varLongWord  : Result := FValue;
    varString    : begin
                     if not TryStrToInt(FValue, Result) then
                       Result := 0;
                     end;
  end;
end;

function TTBField.GetString: string;
begin
  Result := '';
  case FVarValue of
    varSmallInt  : Result := IntToStr(FValue);
    varInteger   : Result := IntToStr(FValue);
    varSingle    : Result := IntToStr(FValue);
    varDouble    : Result := FloatToStr(FValue);
    varCurrency  : Result := CurrToStr(FValue);
    varDate      : Result := DateToStr(FValue);
    varByte      : Result := IntToStr(FValue);
    varWord      : Result := IntToStr(FValue);
    varLongWord  : Result := IntToStr(FValue);
    varInt64     : Result := IntToStr(FValue);
    varString    : Result := FValue;
  end;
end;

function TTBField.GetVariant: Variant;
begin
  Result := FValue;
end;

procedure TTBField.SetCurr(const Value: Currency);
begin
  FVarValue := varCurrency;
  SetVariant(Value);
end;

procedure TTBField.SetDateTime(const Value: TDateTime);
begin
  FVarValue := varDate;
  SetVariant(Value);
end;

procedure TTBField.SetValueEmpty;
begin
  FValue        := null;
  FVarValue     := varEmpty;
  FChangedValue := false;
end;

procedure TTBField.SetInt(const Value: Integer);
begin
  FVarValue := varInteger;
  SetVariant(Value);
end;

procedure TTBField.SetString(const Value: string);
begin
  FVarValue := varString;
  SetVariant(Value);
end;

procedure TTBField.SetVariant(const Value: Variant);
begin
  FChangedValue := true;
  if FValue = Null then
    FChangedValue := false;
    {
  try
    if FValue = varEmpty then
      FChangedValue := false;
  except
  end;
  }
  FValue := Value;
end;

end.
