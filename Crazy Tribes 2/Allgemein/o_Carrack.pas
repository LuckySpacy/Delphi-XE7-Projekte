unit o_Carrack;

interface

uses
  SysUtils, Classes, o_Einheit;

type
  TCarrack = class(TEinheit)
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

{ TCarrack }

constructor TCarrack.Create;
begin
  inherited;
end;

destructor TCarrack.Destroy;
begin
  inherited;
end;


function TCarrack.GeschwFaktor(aIndex: Integer): Integer;
begin
  Result := 0;
  if aIndex = 0 then
    Result := FGeschwindigkeit.Langsam.Carrack;
  if aIndex = 1 then
    Result := FGeschwindigkeit.Mittel.Carrack;
  if aIndex = 2 then
    Result := FGeschwindigkeit.Schnell.Carrack;
end;



function TCarrack.getBezeichnung: string;
begin
  Result := 'Carrack';
end;

function TCarrack.getKurzbezeichnung: string;
begin
  Result := 'Ca';
end;

end.
