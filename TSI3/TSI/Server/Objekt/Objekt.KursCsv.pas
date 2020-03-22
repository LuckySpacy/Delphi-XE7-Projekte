unit Objekt.KursCsv;

interface

uses
  SysUtils, Classes, Contnrs;

type
  TKursCsv = class(TComponent)
  private
    fWKN: string;
    fAktie: string;
    fSchlusskurs: string;
    fDatum: string;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init;
    property WKN: string read fWKN write fWKN;
    property Aktie: string read fAktie write fAktie;
    property Datum: string read fDatum write fDatum;
    property Schlusskurs: string read fSchlusskurs write fSchlusskurs;
  end;

implementation

{ TKursCsv }

constructor TKursCsv.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TKursCsv.Destroy;
begin

  inherited;
end;

procedure TKursCsv.Init;
begin
  fWKN := '';
  fAktie := '';
  fDatum := '';
  fSchlusskurs := '';
end;

end.
