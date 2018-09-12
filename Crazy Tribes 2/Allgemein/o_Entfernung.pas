unit o_Entfernung;

interface

uses
  Classes, SysUtils, o_Koordinate;

type
  TEntfernung = class(TObject)
  private
    FKoordinate: TKoordinate;
    FBasename: string;
    FFelder: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    property Koordinate: TKoordinate read FKoordinate write FKoordinate;
    property Basename: string read FBasename write FBasename;
    property Felder: Integer read FFelder write FFelder;
  end;


implementation

{ TEntfernung }

constructor TEntfernung.Create;
begin
  inherited;
  FKoordinate := TKoordinate.Create;
  Init;
end;

destructor TEntfernung.Destroy;
begin
  FreeAndNil(FKoordinate);
  inherited;
end;

procedure TEntfernung.Init;
begin
  FKoordinate.AsString := '';
  FFelder := 0;
  FBasename := '';
end;

end.
