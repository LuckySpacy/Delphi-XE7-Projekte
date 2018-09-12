unit o_Base;

interface

uses
  SysUtils, Classes, o_Scout, o_Ranger, o_Gunner, o_Knocker, o_Mortar, o_Molotov,
  o_Biker, o_Trike, o_Buggy, o_Pickup, o_Carrack, Contnrs, o_Einheit, o_Koordinate,
  o_CustomBase, o_EntfernungList, o_Entfernung, o_pathfinder;

type
  TBase = class(TCustomBase)
  private
    FEntfernungPfad: string;
    FEntfernungList: TEntfernungList;
    FFelder: Integer;
    FZielbase: TBase;
    FPathFinder: TPathFinder;
    FFelderOk: Boolean;
    function GetEinheit(Index: Integer): TEinheit;
    procedure setEntfernungPfad(const Value: string);
    procedure setZielbase(const Value: TBase);
    function AnzahlFelder: Integer;
    procedure setFelder(const Value: Integer);
  public
    constructor Create; override;
    destructor Destroy; override;
    property Einheit[Index: Integer]: TEinheit read GetEinheit;
    property EntfernungPfad: string read FEntfernungPfad write setEntfernungPfad;
    property Felder: Integer read FFelder write setFelder;
    property Zielbase: TBase read FZielbase write setZielbase;
    property EntfernungList: TEntfernungList read FEntfernungList write FEntfernungList;
    property FelderOk: Boolean read FFelderOk write FFelderOk;
    procedure SaveEntfernung;
  end;


implementation

{ TBase }

uses
  Dialogs;




constructor TBase.Create;
begin
  inherited;
  FPathFinder := TPathFinder.Create;
  FEntfernungList := TEntfernungList.Create;
  FFelderOk := false;
end;

destructor TBase.Destroy;
begin
  FreeAndNil(FPathFinder);
  FreeAndNil(FEntfernungList);
  inherited;
end;

function TBase.GetEinheit(Index: Integer): TEinheit;
begin
  Result := nil;
  if Index > FEinheitenList.Count -1 then
    exit;
  Result := TEinheit(FEinheitenList.Items[Index]);
end;



procedure TBase.setEntfernungPfad(const Value: string);
var
  Filename: string;
begin
  FEntfernungPfad := Value;
  if FBasename = '' then
    exit;
  if FKoordinate.AsString = '' then
    exit;
  FileName := FKoordinate.AsString + '-' + FBasename;
  Filename := FEntfernungPfad + Filename + '.txt';
  FEntfernungList.Load(Filename);
end;



procedure TBase.setFelder(const Value: Integer);
var
  Entfernung: TEntfernung;
  i1: Integer;
begin
  FFelder := Value;
  if FZielbase = nil then
    exit;
  Entfernung := FEntfernungList.Add(FZielbase.Koordinate);
  if Entfernung <> nil then
  begin
    Entfernung.Basename := FZielbase.Basename;
    Entfernung.Felder := Value;
    Entfernung := FZielbase.EntfernungList.Add(Koordinate);
    Entfernung.Basename := Basename;
    Entfernung.Felder := Value;
    FelderOk := true;
    FZielbase.FelderOk := true;
  end;
  for i1 := 0 to FEinheitenList.Count - 1 do
    TEinheit(FEinheitenList.Items[i1]).Felder := Value;
end;

procedure TBase.setZielbase(const Value: TBase);
var
  Entfernung: TEntfernung;
  i1: Integer;
begin
  FFelderOk := false;
  FZielbase := Value;
  Entfernung := FEntfernungList.GetEntfernungFromKoordinate(FZielbase.Koordinate);
  if Entfernung <> nil then
  begin
    FFelder := Entfernung.Felder;
    FFelderOk := true;
    for i1 := 0 to FEinheitenList.Count - 1 do
      TEinheit(FEinheitenList.Items[i1]).Felder := FFelder;
    exit;
  end;
  FFelder := AnzahlFelder;
  for i1 := 0 to FEinheitenList.Count - 1 do
    TEinheit(FEinheitenList.Items[i1]).Felder := FFelder;
end;


function TBase.AnzahlFelder: Integer;
var
  xFelder: Integer;
  yFelder: Integer;
begin
  Result := 0;
  if FZielbase = nil then
    exit;

  FPathFinder.Start.X := Koordinate.X;
  FPathFinder.Start.Y := Koordinate.Y;
  FPathFinder.Ende.Y  := FZielbase.Koordinate.Y;
  FPathFinder.Ende.X  := FZielbase.Koordinate.X;
  FPathFinder.Calc;
  Result := FPathFinder.AnzahlFelder;
  exit;

  xFelder := FZielbase.Koordinate.X - Koordinate.X;
  if xFelder < 0 then
    xFelder := xFelder * -1;

  yFelder := FZielbase.Koordinate.Y - Koordinate.y;
  if yFelder < 0 then
    yFelder := yFelder * -1;

  if xFelder > yFelder then
    Result := xFelder
  else
    Result := yFelder;

end;


procedure TBase.SaveEntfernung;
var
  Filename: string;
begin
  if FEntfernungPfad = '' then
    exit;
  if not DirectoryExists(FEntfernungPfad) then
    exit;
  if FBasename = '' then
    exit;
  if FKoordinate.AsString = '' then
    exit;
  FileName := FKoordinate.AsString + '-' + FBasename;
  Filename := FEntfernungPfad + Filename + '.txt';
  FEntfernungList.Save(Filename);
end;



end.
