unit o_Mortar;

interface

uses
  SysUtils, Classes, o_Einheit;

type
  TMortar = class(TEinheit)
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

{ TKnocker }

constructor TMortar.Create;
begin
  inherited;
end;

destructor TMortar.destroy;
begin

  inherited;
end;


function TMortar.GeschwFaktor(aIndex: Integer): Integer;
begin
  Result := 0;
  if aIndex = 0 then
    Result := FGeschwindigkeit.Langsam.Mortar;
  if aIndex = 1 then
    Result := FGeschwindigkeit.Mittel.Mortar;
  if aIndex = 2 then
    Result := FGeschwindigkeit.Schnell.Mortar;
end;


function TMortar.getBezeichnung: string;
begin
  Result := 'Mortar';
end;

function TMortar.getKurzbezeichnung: string;
begin
  Result := 'Mo';
end;

end.
