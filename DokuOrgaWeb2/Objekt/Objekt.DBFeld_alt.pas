unit Objekt.DBFeld;

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
    fAlwaysTrim: Boolean;
    fDataType: TFieldType;
    function getAsString: string;
    procedure setAsString(const Value: string);
    function getInteger: Integer;
    procedure setInteger(const Value: Integer);
    function getAsBoolean: Boolean;
    procedure setAsBoolean(const Value: Boolean);
    function getAsDateTime: TDateTime;
    procedure setAsDateTime(const Value: TDateTime);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitValue;
    property AsString: string read getAsString write setAsString;
    property AsInteger: Integer read getInteger write setInteger;
    property Changed: Boolean read FChanged write FChanged;
    property Feldname: string read FFeldName write FFeldName;
    property AsBoolean: Boolean read getAsBoolean write setAsBoolean;
    property AsDateTime: TDateTime read getAsDateTime write setAsDateTime;
    property AlwaysTrim: Boolean read fAlwaysTrim write fAlwaysTrim;
    property DataType: TFieldType read fDataType write fDataType;
  end;

implementation

{ TDBFeld }

constructor TDBFeld.Create(AOwner: TComponent);
begin
  inherited;
  InitValue;
end;

destructor TDBFeld.Destroy;
begin

  inherited;
end;

function TDBFeld.getAsBoolean: Boolean;
begin
  Result := fValue = 'T';
end;

function TDBFeld.getAsDateTime: TDateTime;
begin
  if not TryStrToDateTime(fValue, Result) then
    Result := 0;
end;

function TDBFeld.getAsString: string;
begin
  Result := fValue;
  if fAlwaysTrim then
    Result := Trim(fValue);
end;

function TDBFeld.getInteger: Integer;
begin
  if not TryStrToInt(fValue, Result) then
    Result := 0;
end;

procedure TDBFeld.InitValue;
begin
  fChanged := false;
  fValue := '';
  fNewInit := true;
  fAlwaysTrim := false;
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

procedure TDBFeld.setAsString(const Value: string);
begin
  if (not fNewInit) and (Value <> fValue) then
    fChanged := true;

  fValue := Value;
  if fAlwaysTrim then
    fValue := Trim(Value);
  fNewInit := false;
end;


procedure TDBFeld.setInteger(const Value: Integer);
begin
  setAsString(IntToStr(Value));
end;

end.
