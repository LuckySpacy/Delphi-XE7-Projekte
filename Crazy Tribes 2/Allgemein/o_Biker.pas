unit o_Biker;

interface

uses
  SysUtils, Classes, o_Einheit;

type
  TBiker = class(TEinheit)
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


constructor TBiker.Create;
begin
  inherited;
end;

destructor TBiker.Destroy;
begin

  inherited;
end;

function TBiker.GeschwFaktor(aIndex: Integer): Integer;
begin
  Result := 0;
  if aIndex = 0 then
    Result := FGeschwindigkeit.Langsam.Biker;
  if aIndex = 1 then
    Result := FGeschwindigkeit.Mittel.Biker;
  if aIndex = 2 then
    Result := FGeschwindigkeit.Schnell.Biker;
end;


function TBiker.getBezeichnung: string;
begin
  Result := 'Biker';
end;

function TBiker.getKurzbezeichnung: string;
begin
  Result := 'Bi';
end;

end.
