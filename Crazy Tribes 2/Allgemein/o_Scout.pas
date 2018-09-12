unit o_Scout;

interface

uses
  SysUtils, Classes, o_Einheit;

type
  TScout = class(TEinheit)
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

{ TScout }

constructor TScout.Create;
begin
  inherited;
end;

destructor TScout.destroy;
begin

  inherited;
end;

function TScout.GeschwFaktor(aIndex: Integer): Integer;
begin
  Result := 0;
  if aIndex = 0 then
    Result := FGeschwindigkeit.Langsam.Scout;
  if aIndex = 1 then
    Result := FGeschwindigkeit.Mittel.Scout;
  if aIndex = 2 then
    Result := FGeschwindigkeit.Schnell.Scout;
end;

function TScout.getBezeichnung: string;
begin
  Result := 'Scout';
end;

function TScout.getKurzbezeichnung: string;
begin
  Result := 'Sc';
end;

end.
