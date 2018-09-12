unit o_Buggy;

interface

uses
  SysUtils, Classes, o_Einheit;

type
  TBuggy = class(TEinheit)
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

{ TBuggy }

constructor TBuggy.Create;
begin
  inherited;
end;

destructor TBuggy.Destroy;
begin

  inherited;
end;

function TBuggy.GeschwFaktor(aIndex: Integer): Integer;
begin
  Result := 0;
  if aIndex = 0 then
    Result := FGeschwindigkeit.Langsam.Buggy;
  if aIndex = 1 then
    Result := FGeschwindigkeit.Mittel.Buggy;
  if aIndex = 2 then
    Result := FGeschwindigkeit.Schnell.Buggy;
end;

function TBuggy.getBezeichnung: string;
begin
  Result := 'Buggy';
end;

function TBuggy.getKurzbezeichnung: string;
begin
  Result := 'Bu';
end;

end.
