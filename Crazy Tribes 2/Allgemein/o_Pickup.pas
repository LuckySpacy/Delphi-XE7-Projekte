unit o_Pickup;

interface

uses
  SysUtils, Classes, o_Einheit;

type
  TPickup = class(TEinheit)
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

{ TPickup }

constructor TPickup.Create;
begin
  inherited;
end;

destructor TPickup.Destroy;
begin

  inherited;
end;


function TPickup.GeschwFaktor(aIndex: Integer): Integer;
begin
  Result := 0;
  if aIndex = 0 then
    Result := FGeschwindigkeit.Langsam.Pickup;
  if aIndex = 1 then
    Result := FGeschwindigkeit.Mittel.Pickup;
  if aIndex = 2 then
    Result := FGeschwindigkeit.Schnell.Pickup;
end;


function TPickup.getBezeichnung: string;
begin
  Result := 'Pickup';
end;

function TPickup.getKurzbezeichnung: string;
begin
  Result := 'Pi';
end;

end.
