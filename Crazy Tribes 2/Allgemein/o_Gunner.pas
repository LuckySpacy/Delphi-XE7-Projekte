unit o_Gunner;

interface

uses
  SysUtils, Classes, o_Einheit;

type
  TGunner = class(TEinheit)
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

{ TGunner }

constructor TGunner.Create;
begin
  inherited;
end;

destructor TGunner.destroy;
begin

  inherited;
end;


function TGunner.GeschwFaktor(aIndex: Integer): Integer;
begin
  Result := 0;
  if aIndex = 0 then
    Result := FGeschwindigkeit.Langsam.Gunner;
  if aIndex = 1 then
    Result := FGeschwindigkeit.Mittel.Gunner;
  if aIndex = 2 then
    Result := FGeschwindigkeit.Schnell.Gunner;
end;


function TGunner.getBezeichnung: string;
begin
  Result := 'Gunner';
end;

function TGunner.getKurzbezeichnung: string;
begin
  Result := 'Gu';
end;

end.
