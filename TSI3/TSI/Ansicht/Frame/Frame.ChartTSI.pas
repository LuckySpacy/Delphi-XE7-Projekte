unit Frame.ChartTSI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus,
  VCLTee.TeEngine, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart, MySql.TSIList,
  MySql.TSI, MySql.TSIListe, Vcltee.Series;

type
  Tfra_ChartTSI = class(TFrame)
    Chart: TChart;
  private
    fAK_Id: Integer;
    fWkn: string;
    fAktie: string;
    fWochen: Integer;
    fTSIListe: TMySqlTSIListe;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Aktual(aAK_ID, aWochen: Integer; aWKN, aAktie: string; aVonDatum, aBisDatum: TDateTime);
  end;

implementation

{$R *.dfm}

{ Tfra_ChartTSI }


constructor Tfra_ChartTSI.Create(AOwner: TComponent);
begin
  inherited;
  fAk_ID := 0;
  fWochen := 0;
  fWkn   := '';
  fAktie := '';
  fTSIListe := TMySqlTSIListe.Create(nil);
end;

destructor Tfra_ChartTSI.Destroy;
begin
  FreeAndNil(fTSIListe);
  inherited;
end;


procedure Tfra_ChartTSI.Aktual(aAK_ID, aWochen: Integer; aWKN, aAktie: string; aVonDatum,
  aBisDatum: TDateTime);
var
  TSIList: TMySqlTSIList;
  TSI: TMySqlTSI;
  i1: Integer;
  s : TLineSeries;
begin
  TSIList := fTSIListe.TSIList(aAK_ID, aWochen);
  fAk_Id := aAK_Id;
  fWkn := aWKN;
  fAktie := aAktie;
  fWochen := aWochen;

  for i1 := Chart.SeriesList.Count -1 downto 0 do
    Chart.SeriesList.Delete(i1);

  Chart.Title.Text.Clear;
  Chart.Title.Text.Add('[' + fWkn + '] ' + fAktie);
  Chart.View3D := false;

  s := TLineSeries.Create(nil);
  s.Clear;
  s.Title := '[' + aWkn + '] ' + aAktie;
  s.ParentChart := Chart;
  s.XValues.DateTime := true;

  for i1 := 0 to TSIList.Count -1 do
  begin
    TSI := TSIList.Item[i1];
    if TSI.FieldByName('datum').AsDateTime < aVonDatum then
      continue;
    if TSI.FieldByName('datum').AsDateTime > aBisDatum then
      continue;
    s.AddXY(TSI.FieldByName('datum').AsDateTime, TSI.FieldByName('wert').AsFloat);
  end;

end;


end.
