unit frame_bestand;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, o_aktielist, DBGrids, DB, IBCustomDataSet, IBQuery, IBDatabase,
  StdCtrls, ExtCtrls;

type
  Tfra_Bestand = class(TFrame)
    ds_Bestand: TDataSource;
    ibt_Bestand: TIBTransaction;
    qry_Bestand: TIBQuery;
    Grid: TDBGrid;
    pnl_Right: TPanel;
    Label1: TLabel;
    edt_Summe: TEdit;
    qry_Summe: TIBQuery;
    ibt_summe: TIBTransaction;
  private
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LadeListe;
  end;

implementation

{$R *.dfm}

{ TFrame1 }


constructor Tfra_Bestand.Create(AOwner: TComponent);
begin
  inherited;
  LadeListe;
end;

destructor Tfra_Bestand.Destroy;
begin
  inherited;
end;



procedure Tfra_Bestand.LadeListe;
begin
  if ibt_Bestand.InTransaction then
    ibt_Bestand.Rollback;

  if ibt_Summe.InTransaction then
    ibt_Summe.Rollback;

  qry_Bestand.SQL.Text := ' select ak_wkn, ak_name, bs_datum, bs_stueck, bs_wert, bs_kurs ' +
                          ' from aktie, bestand' +
                          ' where ak_id = bs_ak_id' +
                          ' and bs_stueck > 0' +
                          ' order by ak_name';
  qry_Bestand.Open;

  qry_Summe.Close;
  qry_Summe.SQL.Text := ' select sum(bs_wert) from bestand';
  qry_Summe.Open;

  edt_Summe.Text := FormatCurr('#,0.00', qry_Summe.Fields[0].asCurrency);

  Grid.Columns[0].Title.Caption := 'WKN';
  Grid.Columns[1].Title.Caption := 'Name';
  Grid.Columns[2].Title.Caption := 'Datum';
  Grid.Columns[3].Title.Caption := 'Stück';
  Grid.Columns[4].Title.Caption := 'Kaufwert';
  Grid.Columns[5].Title.Caption := 'Kaufkurs';

end;

end.
