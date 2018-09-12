unit o_Koordinate;

interface

uses
  SysUtils, Classes;

type
  TKoordinate = class(TObject)
  private
    Fx: Integer;
    Fy: Integer;
    FAsString: string;
    procedure setAsString(const Value: string);
    procedure setFX(const Value: Integer);
    procedure setFY(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    property AsString: string read FAsString write setAsString;
    property X: Integer read Fx write setFX;
    property Y: Integer read Fy write setFY;
  end;



implementation

{ TKoordinate }

constructor TKoordinate.Create;
begin
  inherited;
  init;
end;

destructor TKoordinate.Destroy;
begin

  inherited;
end;

procedure TKoordinate.Init;
begin
  Fx := 0;
  Fy := 0;
  FAsString := '';
end;

procedure TKoordinate.setAsString(const Value: string);
var
  x: Integer;
  y: Integer;
  iPos: Integer;
  s: string;
begin
  FAsString := Value;
  iPos := Pos(',', FAsString);
  if iPos <= 0 then
  begin
    Init;
    exit;
  end;
  s := Trim(copy(FAsString, 1, iPos-1));
  if not TryStrToInt(s, x) then
  begin
    Init;
    exit;
  end;
  s := Trim(copy(FAsString, iPos+1, Length(s)));
  if not TryStrToInt(s, y) then
  begin
    Init;
    exit;
  end;

  Fx := x;
  Fy := y;

end;

procedure TKoordinate.setFX(const Value: Integer);
begin
  Fx := Value;
  FAsString := IntToStr(FX) + ',' + IntToStr(FY);
end;

procedure TKoordinate.setFY(const Value: Integer);
begin
  Fy := Value;
  FAsString := IntToStr(FX) + ',' + IntToStr(FY);
end;

end.
