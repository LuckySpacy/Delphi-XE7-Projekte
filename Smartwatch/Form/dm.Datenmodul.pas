unit dm.Datenmodul;

interface

uses
  System.SysUtils, System.Classes, Data.DB, mySQLDbTables;

type
  Tdam = class(TDataModule)
    db: TMySQLDatabase;
    qry: TMySQLQuery;
    ds: TDataSource;
  private
  public
    procedure Connect;
  end;

var
  dam: Tdam;

implementation

{$R *.dfm}

{ Tdm }

procedure Tdam.Connect;
begin
  db.DatabaseName := 'Shop';
  db.Host := 'localhost';
  db.UserName := 'thomas';
  db.UserPassword := 'thomas1';
  db.Connect;
end;

end.
