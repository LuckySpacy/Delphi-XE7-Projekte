unit o_CustomBase;

interface

uses
  SysUtils, Classes, o_Scout, o_Ranger, o_Gunner, o_Knocker, o_Mortar, o_Molotov,
  o_Biker, o_Trike, o_Buggy, o_Pickup, o_Carrack, Contnrs, o_Einheit, o_Koordinate;

type
  TCustomBase = class(TObject)
  private
    procedure setRauchsignal(const Value: Boolean);
    procedure setSprechfunk(const Value: Boolean);
  protected
    FScout: TScout;
    FRanger: TRanger;
    FGunner: TGunner;
    FTrike: TTrike;
    FBiker: TBiker;
    FBuggy: TBuggy;
    FMolotov: TMolotov;
    FKnocker: TKnocker;
    FMortar: TMortar;
    FBasename: string;
    FCarrack: TCarrack;
    FPickup: TPickup;
    FKoordinate: TKoordinate;
    FEinheitenList: TObjectList;
    FRauchsignal: Boolean;
    FPunkte: Integer;
    FSprechfunk: Boolean;
    procedure setLaufstufe;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property Scout: TScout read FScout write FScout;
    property Ranger: TRanger read FRanger write FRanger;
    property Gunner: TGunner read FGunner write FGunner;
    property Knocker: TKnocker read FKnocker write FKnocker;
    property Mortar: TMortar read FMortar write FMortar;
    property Molotov: TMolotov read FMolotov write FMolotov;
    property Biker: TBiker read FBiker write FBiker;
    property Trike: TTrike read FTrike write FTrike;
    property Buggy: TBuggy read FBuggy write FBuggy;
    property Pickup: TPickup read FPickup write FPickup;
    property Carrack: TCarrack read FCarrack write FCarrack;
    property Basename: string read FBasename write FBasename;
    property Rauchsignal: Boolean read FRauchsignal write setRauchsignal;
    property Sprechfunk: Boolean read FSprechfunk write setSprechfunk;
    property Punkte: Integer read FPunkte write FPunkte;
    property Koordinate: TKoordinate read FKoordinate write FKoordinate;
    function EinheitCount: Integer;
  end;


implementation

{ TCustomBase }

uses
  c_Geschwindigkeit;

constructor TCustomBase.Create;
begin
  inherited;
  FEinheitenList := TObjectList.Create;
  FScout := TScout.Create;
  FRanger := TRanger.Create;
  FGunner := TGunner.Create;
  FKnocker := TKnocker.Create;
  FMortar := TMortar.Create;
  FMolotov := TMolotov.Create;
  FBiker := TBiker.Create;
  FTrike := TTrike.Create;
  FBuggy := TBuggy.Create;
  FPickup := TPickup.Create;
  FCarrack := TCarrack.Create;

  FEinheitenList.Add(FScout);
  FEinheitenList.Add(FRanger);
  FEinheitenList.Add(FGunner);
  FEinheitenList.Add(FKnocker);
  FEinheitenList.Add(FMortar);
  FEinheitenList.Add(FMolotov);
  FEinheitenList.Add(FBiker);
  FEinheitenList.Add(FTrike);
  FEinheitenList.Add(FBuggy);
  FEinheitenList.Add(FPickup);
  FEinheitenList.Add(FCarrack);

  FKoordinate := TKoordinate.Create;
  FKoordinate.AsString := '';
  FRauchsignal := false;
  FSprechfunk := false;
  FPunkte := 0;


end;

destructor TCustomBase.Destroy;
begin
  FreeAndNil(FEinheitenList);
  FreeAndNil(FKoordinate);
  inherited;
end;

function TCustomBase.EinheitCount: Integer;
begin
  Result := FEinheitenList.Count;
end;

procedure TCustomBase.setLaufstufe;
var
  Laufstufe: TLaufstufe;
  i1: Integer;
begin
  Laufstufe := cLangsam;
  if (Rauchsignal) or (Sprechfunk) then
    Laufstufe := cMittel;
  if (Rauchsignal) and (Sprechfunk) then
    Laufstufe := cSchnell;
  for i1 := 0 to FEinheitenList.Count - 1 do
  begin
    TEinheit(FEinheitenList.Items[i1]).Laufstufe := Laufstufe;
  end;

end;

procedure TCustomBase.setRauchsignal(const Value: Boolean);
begin
  FRauchsignal := Value;
  setLaufstufe;
end;

procedure TCustomBase.setSprechfunk(const Value: Boolean);
begin
  FSprechfunk := Value;
  setLaufstufe;
end;

end.
