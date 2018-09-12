unit o_Trike;

interface

uses
  SysUtils, Classes, o_Einheit;

type
  TTrike = class(TEinheit)
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

{ TBiker }

constructor TTrike.Create;
begin
  inherited;
end;

destructor TTrike.Destroy;
begin

  inherited;
end;


function TTrike.GeschwFaktor(aIndex: Integer): Integer;
begin
  Result := 0;
  if aIndex = 0 then
    Result := FGeschwindigkeit.Langsam.Trike;
  if aIndex = 1 then
    Result := FGeschwindigkeit.Mittel.Trike;
  if aIndex = 2 then
    Result := FGeschwindigkeit.Schnell.Trike;
end;


function TTrike.getBezeichnung: string;
begin
  Result := 'Trike';
end;

function TTrike.getKurzbezeichnung: string;
begin
  Result := 'Tr';
end;

end.
