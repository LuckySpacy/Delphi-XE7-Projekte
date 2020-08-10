unit Objekt.TextEinlesenWort;

interface

uses
  SysUtils, Types, Windows, Classes;


type
  TTextEinlesenWort = class
  private
    fEnId: Integer;
    fWort: String;
    fEiId: Integer;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Wort: String read fWort write fWort;
    property EnId: Integer read fEnId write fEnId;
    property EiId: Integer read fEiId write fEiId;
    procedure Init;
  end;


implementation

{ TTextEinlesenWort }

constructor TTextEinlesenWort.Create;
begin
  Init;
end;

destructor TTextEinlesenWort.Destroy;
begin

  inherited;
end;

procedure TTextEinlesenWort.Init;
begin
  fEnId := 0;
  fWort := '';
  fEiId := 0;
end;

end.
