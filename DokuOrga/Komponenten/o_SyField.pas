unit o_SyField;

interface

uses
  SysUtils, Classes, variants, Graphics, db, pngimage, o_Systemeinstellung;

type
  TSyFeld = class(TComponent)
  private
    FPW: string;
    FValue: string;
    FBlob: string;
    FBlob2: string;
    FBlob3: string;
    FSystemeinstellung: TSystemeinstellung;
    FVerschluesselt: Boolean;
    function getAsString: string;
    procedure setAsString(const Value: string);
    function getInteger: Integer;
    procedure setInteger(const Value: Integer);
    function getAsBoolean: Boolean;
    procedure setAsBoolean(const Value: Boolean);
    function getAsDateTime: TDateTime;
    procedure setAsDateTime(const Value: TDateTime);
    function getAsBlob: string;
    procedure setAsBlob(const Value: string);
    function getAsBlob2: string;
    procedure setAsBlob2(const Value: string);
    function getAsBlob3: string;
    procedure setAsBlob3(const Value: string);
  protected
  public
    constructor Create(AOwner: TComponent; aBez: string; aKey: Integer; aStandard: string); reintroduce; overload;
    destructor Destroy; override;
    procedure InitValue;
    property AsString: string read getAsString write setAsString;
    property AsInteger: Integer read getInteger write setInteger;
    property AsBoolean: Boolean read getAsBoolean write setAsBoolean;
    property AsDateTime: TDateTime read getAsDateTime write setAsDateTime;
    property AsBlob: string read getAsBlob write setAsBlob;
    property AsBlob2: string read getAsBlob2 write setAsBlob2;
    property AsBlob3: string read getAsBlob3 write setAsBlob3;
    property Verschluesselt: Boolean read FVerschluesselt write FVerschluesselt;
  end;


implementation

{ TDBFeld }

uses
  c_DBTypes, u_allgfunc;




constructor TSyFeld.Create(AOwner: TComponent; aBez: string; aKey: Integer;
  aStandard: string);
begin
  Inherited Create(AOwner);
  FVerschluesselt := false;
  InitValue;
  FSystemeinstellung := TSystemeinstellung.Create(self);
  FSystemeinstellung.Read(aKey);
  if not FSystemeinstellung.Found then
  begin
    FSystemeinstellung.Feld(SY_KEY).AsInteger := aKey;
    FSystemeinstellung.Feld(SY_BEZ).AsString  := aBez;
    FSystemeinstellung.Feld(SY_VALUE1).AsString := aStandard;
    FSystemeinstellung.Save;
  end;
  FValue := FSystemeinstellung.Feld(SY_VALUE1).AsString;
  FBlob  := FSystemeinstellung.Feld(SY_BLOB1).AsString;
  FBlob2 := FSystemeinstellung.Feld(SY_BLOB2).AsString;
end;

destructor TSyFeld.Destroy;
begin
  FreeAndNil(FSystemeinstellung);
  inherited;
end;

function TSyFeld.getAsBlob: string;
begin
  Result := FBlob;
end;

function TSyFeld.getAsBlob2: string;
begin
  Result := FBlob2;
end;

function TSyFeld.getAsBlob3: string;
begin
  Result := FBlob3;
end;

function TSyFeld.getAsBoolean: Boolean;
begin
  Result := FValue = 'T';
end;

function TSyFeld.getAsDateTime: TDateTime;
begin
  if not TryStrToDateTime(FValue, Result) then
    Result := 0;
end;

function TSyFeld.getAsString: string;
begin
  Result := FValue;
  if FVerschluesselt then
    Result := tbEntschluesseln(Result, FPW);
end;

function TSyFeld.getInteger: Integer;
begin
  if not TryStrToInt(FValue, Result) then
    Result := 0;
end;

procedure TSyFeld.InitValue;
begin
  FValue := '';
  FPW := 'Rg5u/g!ﬂ%$X(J)@Ä<>!‰A‹÷ˆZ';
end;

procedure TSyFeld.setAsBlob(const Value: string);
begin
  FBlob := Value;
  FSystemeinstellung.Feld(SY_BLOB1).AsString := FBlob;
  FSystemeinstellung.Save;
end;

procedure TSyFeld.setAsBlob2(const Value: string);
begin
  FBlob2 := Value;
  FSystemeinstellung.Feld(SY_BLOB2).AsString := FBlob2;
  FSystemeinstellung.Save;
end;

procedure TSyFeld.setAsBlob3(const Value: string);
begin
  FBlob3 := Value;
  FSystemeinstellung.Feld(SY_BLOB3).AsString := FBlob3;
  FSystemeinstellung.Save;
end;

procedure TSyFeld.setAsBoolean(const Value: Boolean);
begin
  if Value then
    setAsString('T')
  else
    setAsString('F');
end;

procedure TSyFeld.setAsDateTime(const Value: TDateTime);
begin
  setAsString(DateTimeToStr(Value));
end;

procedure TSyFeld.setAsString(const Value: string);
begin
  FValue := Value;
  if FVerschluesselt then
    FValue := tbVerschluesseln(FValue, FPW);
  FSystemeinstellung.Feld(SY_VALUE1).AsString := FValue;
  FSystemeinstellung.Save;
end;


procedure TSyFeld.setInteger(const Value: Integer);
begin
  setAsString(IntToStr(Value));
end;

end.
