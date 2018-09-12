unit o_Timeline;

interface

uses
  Classes, SysUtils, DateUtils, o_Koordinate;

type
  TTimeline = class(TObject)
  private
    FTrike: Integer;
    FAnkunftsort: string;
    FBiker: Integer;
    FBuggy: Integer;
    FMolotov: Integer;
    FCarrack: Integer;
    FKnocker: Integer;
    FGunner: Integer;
    FRanger: Integer;
    FAnkunft: string;
    FPickup: Integer;
    FMortar: Integer;
    FScout: Integer;
    FFelderOk: Boolean;
    FBasename: string;
    FKoordinate: TKoordinate;
    function getGesamt: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    property Basename: string read FBasename write FBasename;
    property Scout: Integer read FScout write FScout;
    property Ranger: Integer read FRanger write FRanger;
    property Gunner: Integer read FGunner write FGunner;
    property Knocker: Integer read FKnocker write FKnocker;
    property Mortar: Integer read FMortar write FMortar;
    property Molotov: Integer read FMolotov write FMolotov;
    property Biker: Integer read FBiker write FBiker;
    property Trike: Integer read FTrike write FTrike;
    property Buggy: Integer read FBuggy write FBuggy;
    property Pickup: Integer read FPickup write FPickup;
    property Carrack: Integer read FCarrack write FCarrack;
    property Ankunftsort: string read FAnkunftsort write FAnkunftsort;
    property Ankunft: string read FAnkunft write FAnkunft;
    property FelderOk: Boolean read FFelderOk write FFelderOk;
    property Gesamt: Integer read getGesamt;
    property Koordinate: TKoordinate read FKoordinate write FKoordinate;
    procedure Init;
  end;


implementation

{ TTimeline }

constructor TTimeline.Create;
begin
  inherited;
  FKoordinate := TKoordinate.Create;
  init;
end;

destructor TTimeline.Destroy;
begin
  FreeAndNil(FKoordinate);
  inherited;
end;

function TTimeline.getGesamt: Integer;
begin
  Result := FTrike + FBiker + FBuggy + FMolotov + FCarrack + FKnocker + FGunner +
            FRanger + FPickup + FMortar + FScout;
end;

procedure TTimeline.Init;
begin
  FTrike := 0;
  FAnkunftsort := '';
  FBiker := 0;
  FBuggy := 0;
  FMolotov := 0;
  FCarrack := 0;
  FKnocker := 0;
  FGunner := 0;
  FRanger := 0;
  FAnkunft := '';
  FPickup := 0;
  FMortar := 0;
  FScout := 0;
  FFelderOk := false;
  FBasename := '';
  FKoordinate.AsString := '';
end;

end.
