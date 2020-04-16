unit Objekt.ClientUIEinstellung;

interface

uses
 System.SysUtils, System.Variants, System.Classes;

type
  TClientUIEinstellung = class
  private
    fPasswort: string;
    fUrl: string;
    fUsername: string;
  public
    constructor Create;
    destructor Destroy; override;
    property URL: string read fUrl write fUrl;
    property Username: string read fUsername write fUsername;
    property Passwort: string read fPasswort write fPasswort;
  end;

implementation

{ TClientUIEinstellung }

constructor TClientUIEinstellung.Create;
begin

end;

destructor TClientUIEinstellung.Destroy;
begin
  inherited;
end;

end.
