unit o_Molotov;

interface

uses
  SysUtils, Classes, o_Einheit;

type
  TMolotov = class(TEinheit)
  private
  protected
    function getKurzbezeichnung: string; override;
    function getBezeichnung: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Kurzbezeichnung: string read getKurzbezeichnung;
    property Bezeichnung: string read getBezeichnung;
    function GeschwFaktor(aIndex: Integer): Integer; override;
  end;


implementation

{ TMolotov }

constructor TMolotov.Create;
begin
  inherited;
end;

destructor TMolotov.Destroy;
begin

  inherited;
end;

function TMolotov.GeschwFaktor(aIndex: Integer): Integer;
begin
  Result := 0;
  if aIndex = 0 then
    Result := FGeschwindigkeit.Langsam.Molotov;
  if aIndex = 1 then
    Result := FGeschwindigkeit.Mittel.Molotov;
  if aIndex = 2 then
    Result := FGeschwindigkeit.Schnell.Molotov;
end;


function TMolotov.getBezeichnung: string;
begin
  Result := 'Molotov';
end;

function TMolotov.getKurzbezeichnung: string;
begin
  Result := 'Mv';
end;

end.
