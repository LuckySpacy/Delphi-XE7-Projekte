unit o_Ranger;

interface

uses
  SysUtils, Classes, o_Einheit;

type
  TRanger = class(TEinheit)
  private
    FKurzbezeichnung: string;
  protected
    function getKurzbezeichnung: string; override;
    function getBezeichnung: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Kurzbezeichnung: string read FKurzbezeichnung;
    property Bezeichnung: string read getBezeichnung;
    function GeschwFaktor(aIndex: Integer): Integer; override;
  end;


implementation

{ TRanger }

constructor TRanger.Create;
begin
  inherited;
end;

destructor TRanger.destroy;
begin

  inherited;
end;

function TRanger.GeschwFaktor(aIndex: Integer): Integer;
begin
  Result := 0;
  if aIndex = 0 then
    Result := FGeschwindigkeit.Langsam.Ranger;
  if aIndex = 1 then
    Result := FGeschwindigkeit.Mittel.Ranger;
  if aIndex = 2 then
    Result := FGeschwindigkeit.Schnell.Ranger;
end;


function TRanger.getBezeichnung: string;
begin
  Result := 'Ranger';
end;

function TRanger.getKurzbezeichnung: string;
begin
  Result := 'Ra';
end;

end.
