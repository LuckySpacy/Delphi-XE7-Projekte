unit o_Einheit;

interface

uses
  SysUtils, Classes, c_Geschwindigkeit, o_TimeObj;


type
  TEinheit = class(TObject)
  private
    FAnzahl: Integer;
    FFelder: Integer;
    FLaufzeit: TTimeObj;
    FAngriffmode: Boolean;
    procedure setLaufstufe(const Value: TLaufstufe);
    procedure setFelder(const Value: Integer);
    function getLaufFaktor: Integer;
  protected
    FGeschwindigkeit: RGeschwindigkeit;
    FLaufstufe: TLaufstufe;
    function getKurzbezeichnung: string; virtual; abstract;
    function getBezeichnung: string; virtual; abstract;
    function GeschwFaktor(aIndex: Integer): Integer; virtual; abstract;
    procedure BerechneLaufzeit;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property Anzahl: Integer read FAnzahl write FAnzahl;
    property Bezeichnung: string read getBezeichnung;
    property Felder: Integer read FFelder write setFelder;
    property Laufstufe: TLaufstufe read FLaufstufe write setLaufstufe;
    property Laufzeit: TTimeObj read FLaufzeit write FLaufzeit;
    property Angriffmode: Boolean read FAngriffmode write FAngriffmode;
    property LaufFaktor: Integer read getLaufFaktor;
  end;


implementation

{ TEinheit }


constructor TEinheit.Create;
begin
  inherited;
  FAnzahl := 0;
  FLaufzeit := TTimeObj.Create;
  FLaufstufe := cLangsam;
  FFelder := 0;
  Laufzeit.Mili := 0;
  FAngriffmode := false;
end;

destructor TEinheit.destroy;
begin
  FreeAndNil(FLaufzeit);
  inherited;
end;


function TEinheit.getLaufFaktor: Integer;
var
  LaufIndex: Integer;
begin
  LaufIndex := 0;
  if FLaufstufe = cMittel then
    LaufIndex := 1;
  if FLaufstufe = cSchnell then
    LaufIndex := 2;
  Result := GeschwFaktor(LaufIndex);
end;

procedure TEinheit.setFelder(const Value: Integer);
begin
  FFelder := Value;
  BerechneLaufzeit;
end;

procedure TEinheit.setLaufstufe(const Value: TLaufstufe);
begin
  FLaufstufe := Value;
  BerechneLaufzeit;
end;

procedure TEinheit.BerechneLaufzeit;
var
  LaufIndex: Integer;
begin
  Laufzeit.Mili := 0;
  if FFelder = 0 then
    exit;
  LaufIndex := 0;
  if FLaufstufe = cMittel then
    LaufIndex := 1;
  if FLaufstufe = cSchnell then
    LaufIndex := 2;
  FLaufzeit.Mili := GeschwFaktor(LaufIndex) * FFelder;
end;


end.
