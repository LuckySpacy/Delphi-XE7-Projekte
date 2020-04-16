unit Objekt.Tabellenfeld;

interface

uses
  SysUtils, Classes;

type
  TTabellenfeld = class
  private
    fFeldSize: string;
    fFeldname: string;
    fFeldtyp: string;
    fTabelle: string;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    property Tabelle : string read fTabelle write fTabelle;
    property Feldname: string read fFeldname write fFeldname;
    property Feldsize: string read fFeldSize write fFeldSize;
    property Feldtyp : string read fFeldtyp write fFeldtyp;
  end;

implementation

{ TTabellenfeld }

constructor TTabellenfeld.Create;
begin
  Init;
end;

destructor TTabellenfeld.Destroy;
begin

  inherited;
end;

procedure TTabellenfeld.Init;
begin
  fFeldSize := '';
  fFeldname := '';
  fFeldtyp  := '';
  fTabelle  := '';
end;

end.
