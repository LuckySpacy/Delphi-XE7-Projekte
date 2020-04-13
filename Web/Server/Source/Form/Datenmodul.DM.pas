unit Datenmodul.DM;

interface

uses
  System.SysUtils, System.Classes, IBX.IBDatabase, Data.DB, IBX.IBCustomDataSet,
  IBX.IBQuery;

type
  TDM = class(TDataModule)
    IBD_OptimaChangeLog: TIBDatabase;
    IBT_OptimaChangeLog: TIBTransaction;
    qry_OptimaChangeLog: TIBQuery;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
