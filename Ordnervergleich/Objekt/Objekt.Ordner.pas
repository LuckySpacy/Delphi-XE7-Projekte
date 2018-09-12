unit Objekt.Ordner;

interface

uses
  SysUtils, Classes;


type
  TOrdner = class
  private
    fPfad: string;
    fTitel: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    property Titel: string read fTitel write fTitel;
    property Pfad: string read fPfad write fPfad;
  end;

{ TOrdner }

implementation


{ TOrdner }

constructor TOrdner.Create;
begin
  Init;
end;

destructor TOrdner.Destroy;
begin

  inherited;
end;

procedure TOrdner.Init;
begin
  fTitel := '';
  fPfad  := '';
end;

end.
