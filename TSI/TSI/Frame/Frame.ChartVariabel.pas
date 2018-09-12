unit Frame.ChartVariabel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus,
  VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, VCLTee.Series, DBObj.KursList, DBObj.Aktie, DBObj.TSIList, DBObj.TSI;

type
  Tfra_ChartVariable = class(TFrame)
    Panel1: TPanel;
    Label1: TLabel;
    edt_Datumvon: TDateTimePicker;
    Label2: TLabel;
    edt_Datumbis: TDateTimePicker;
    Chart1: TChart;
    Series1: TLineSeries;
    btn_Aktual: TButton;
    Series2: TFastLineSeries;
    Chart_TSI: TChart;
    Splitter1: TSplitter;
    Series3: TLineSeries;
    procedure edt_DatumvonExit(Sender: TObject);
    procedure edt_DatumbisExit(Sender: TObject);
    procedure btn_AktualClick(Sender: TObject);
  private
    fKursList: TKursList;
    fTSIList : TTSIList;
    fAK_Id: Integer;
    fAktie: TAktie;
    procedure setAK_Id(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChartLaden;
    property AK_Id: Integer read fAK_Id write setAK_Id;
  end;

implementation

{$R *.dfm}

{ Tfra_ChartVariable }

uses
  Datamodul.TSI, Objekt.Global;




constructor Tfra_ChartVariable.Create(AOwner: TComponent);
begin
  inherited;
  fKursList := TKursList.Create(nil);
  fKursList.Trans := dm.IBT;
  edt_Datumvon.DateTime := Global.StartChartVariable;
  edt_Datumbis.DateTime := Global.EndeChartVariable;
  fAktie := TAktie.Create(nil);
  fAktie.Trans := dm.IBT;

  fTSIList := TTSIList.Create(nil);
  fTSIList.Trans := dm.IBT;

end;

destructor Tfra_ChartVariable.Destroy;
begin
  FreeAndNil(fKursList);
  FreeAndNil(fAktie);
  FreeAndNil(fTSIList);
  inherited;
end;

procedure Tfra_ChartVariable.edt_DatumbisExit(Sender: TObject);
begin
  Global.EndeChartVariable := edt_Datumbis.DateTime;
end;

procedure Tfra_ChartVariable.edt_DatumvonExit(Sender: TObject);
begin
  Global.StartChartVariable := edt_Datumvon.DateTime;
end;

procedure Tfra_ChartVariable.setAK_Id(const Value: Integer);
begin
  fAK_Id := Value;
  fAktie.Read(fAK_Id);
  Chart1.Title.Text.Text := fAktie.Aktie;
  Chart1.Series[0].Title := fAktie.Aktie;
  Chart_TSI.Series[0].Title := 'TSI';
  Chart_TSI.Title.Text.Text := 'TSI';
end;

procedure Tfra_ChartVariable.btn_AktualClick(Sender: TObject);
begin
  ChartLaden;
end;


procedure Tfra_ChartVariable.ChartLaden;
var
  i1: Integer;
begin
  Chart1.Series[0].Clear;
  fKursList.ReadAll(fAK_ID, edt_Datumvon.Date, edt_Datumbis.Date);
  for i1 := 0 to fKursList.Count -1 do
  begin
    //Chart1.Series[0].AddXY(i1, fKursList.Item[i1].Kurs);
    Chart1.Series[0].AddY(fKursList.Item[i1].Kurs, DateToStr(fKursList.Item[i1].Datum))
  end;

  Chart_TSI.Series[0].Clear;
  fTSIList.ReadAll(fAK_ID, 27, edt_Datumvon.Date, edt_Datumbis.Date);
  for i1 := 0 to fTSIList.Count -1 do
  begin
    //Chart1.Series[0].AddXY(i1, fKursList.Item[i1].Kurs);
    Chart_TSI.Series[0].AddY(fTSIList.Item[i1].TSIWert, DateToStr(fTSIList.Item[i1].Datum))
  end;


end;


end.
