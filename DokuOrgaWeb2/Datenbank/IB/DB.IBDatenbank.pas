unit DB.IBDatenbank;

interface

uses
  SysUtils, Classes, IBX.IBDatabase;


//{$R DokuOrgares.res}


type
  TIBDatenbank = class
  private
    FDatabase: TIBDatabase;
  public
    constructor Create;
    destructor Destroy; override;
    function DataBase: TIBDatabase;
  end;

implementation

{ TIBDatenbank }

constructor TIBDatenbank.Create;
begin
  fDatabase := TIBDatabase.Create(nil);
end;

destructor TIBDatenbank.Destroy;
begin

  inherited;
end;

function TIBDatenbank.DataBase: TIBDatabase;
begin
  Result := fDatabase;
end;


end.
