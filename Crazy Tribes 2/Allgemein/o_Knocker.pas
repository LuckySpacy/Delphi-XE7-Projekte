unit o_Knocker;

interface

uses
  SysUtils, Classes, o_Einheit;

type
  TKnocker = class(TEinheit)
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

constructor TKnocker.Create;
begin
  inherited;
end;

destructor TKnocker.destroy;
begin

  inherited;
end;


function TKnocker.GeschwFaktor(aIndex: Integer): Integer;
begin
  Result := 0;
  if aIndex = 0 then
    Result := FGeschwindigkeit.Langsam.Knocker;
  if aIndex = 1 then
    Result := FGeschwindigkeit.Mittel.Knocker;
  if aIndex = 2 then
    Result := FGeschwindigkeit.Schnell.Knocker;
end;


function TKnocker.getBezeichnung: string;
begin
  Result := 'Knocker';
end;

function TKnocker.getKurzbezeichnung: string;
begin
  Result := 'Kn';
end;

end.
