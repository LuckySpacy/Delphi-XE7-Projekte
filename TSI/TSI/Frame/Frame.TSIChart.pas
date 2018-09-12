unit Frame.TSIChart;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus,
  VCLTee.TeEngine, VCLTee.Series, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart,
  Vcl.StdCtrls, Vcl.ComCtrls, DBOBj.Aktie, DBOBj.TSIList;

type
  Tfra_TSIChart = class(TFrame)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edt_Datumvon: TDateTimePicker;
    edt_Datumbis: TDateTimePicker;
    btn_Aktual: TButton;
    Chart_TSI: TChart;
    procedure edt_DatumvonExit(Sender: TObject);
    procedure edt_DatumbisExit(Sender: TObject);
    procedure btn_AktualClick(Sender: TObject);
  private
    fAK_Id: Integer;
    fAktienListbox: TListbox;
    fTSIList: TTSIList;
    fAktie: TAktie;
    fLoadedChartList: TStringList;
    procedure setAK_Id(const Value: Integer);
    procedure LadeChart;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property AK_Id: Integer read fAK_Id write setAK_Id;
    property AktienListbox: TListbox read fAktienListbox write fAktienListbox;
    procedure ChartLaden;
    procedure LoadAktienChart(aAkId: Integer);
  end;

implementation

{$R *.dfm}

{ Tfrm_TSIChart }

uses
  Datamodul.TSI, Objekt.Global;



constructor Tfra_TSIChart.Create(AOwner: TComponent);
begin
  inherited;
  fAktienListbox := nil;
  edt_Datumvon.DateTime := Global.StartChartVariable;
  edt_Datumbis.DateTime := Global.EndeChartVariable;

  fAktie := TAktie.Create(nil);
  fAktie.Trans := dm.IBT;

  fTSIList := TTSIList.Create(nil);
  fTSIList.Trans := dm.IBT;

  fLoadedChartList := TStringList.Create;
  fLoadedChartList.Sorted := true;
  fLoadedChartList.Duplicates := dupIgnore;

end;

destructor Tfra_TSIChart.Destroy;
begin
  FreeAndNil(fTSIList);
  FreeAndNil(fAktie);
  FreeAndNil(fLoadedChartList);
  inherited;
end;

procedure Tfra_TSIChart.edt_DatumbisExit(Sender: TObject);
begin
  Global.EndeChartVariable := edt_Datumbis.DateTime;
end;

procedure Tfra_TSIChart.edt_DatumvonExit(Sender: TObject);
begin
  Global.StartChartVariable := edt_Datumvon.DateTime;
end;



procedure Tfra_TSIChart.LoadAktienChart(aAkId: Integer);
var
  i1: Integer;
begin
  i1 := fLoadedChartList.IndexOf(IntToStr(aAkId));
  if i1 > -1 then
    fLoadedChartList.Delete(i1)
  else
    fLoadedChartList.Add(IntToStr(aAkId));

  LadeChart;
end;

procedure Tfra_TSIChart.setAK_Id(const Value: Integer);
begin
  fAK_Id := Value;
  {
  fAktie.Read(fAK_Id);
  Chart1.Title.Text.Text := fAktie.Aktie;
  Chart1.Series[0].Title := fAktie.Aktie;
  Chart_TSI.Series[0].Title := 'TSI';
  Chart_TSI.Title.Text.Text := 'TSI';
  }
end;

procedure Tfra_TSIChart.btn_AktualClick(Sender: TObject);
begin
  ChartLaden;
end;


procedure Tfra_TSIChart.LadeChart;
var
  i1, i2: Integer;
  AkId: Integer;
  s : TLineSeries;
begin
  for i1 := Chart_TSI.SeriesList.Count -1 downto 0 do
    Chart_TSI.SeriesList.Delete(i1);

  Chart_TSI.Title.Text.Clear;
  Chart_TSI.Title.Text.Add('TSI - Werte');
  Chart_TSI.View3D := false;

  for i1 := 0 to fLoadedChartList.Count -1 do
  begin
    AkId := StrToInt(fLoadedChartList.Strings[i1]);
    fAktie.Read(AkId);
    fTSIList.ReadAll(AkId, 27, edt_Datumvon.DateTime, edt_Datumbis.DateTime);

    s := TLineSeries.Create(nil);
    s.Clear;
    s.Title := fAktie.Aktie;
    s.ParentChart := Chart_TSI;
    s.XValues.DateTime := true;

    for i2 := 0 to fTSIList.Count -1 do
    begin
      s.AddXY(fTSIList.Item[i2].Datum, fTSIList.Item[i2].TSIWert);
    end;

  end;


end;

procedure Tfra_TSIChart.ChartLaden;
var
i, j, kum: Integer;
  i1, i2: Integer;
  AkId: Integer;
  Sr: TChartSeries;
  s, t: TLineSeries;
begin
  if fAktienListbox = nil then
    exit;


  Chart_TSI.Title.Text.Clear;
  Chart_TSI.Title.Text.Add('TSI - Werte');
  Chart_TSI.View3D := false;
  {
  s := TLineSeries.Create(nil);
  s.Clear;

  s.Title := 'Chart Line 1';
  s.ParentChart := Chart_TSI;
  s.XValues.DateTime := true;

  t := TLineSeries.Create(nil);
  t.Clear;
  t.Title := s.Title + ' kum';
  t.ParentChart := Chart_TSI;
  t.XValues.DateTime := true;
  t.VertAxis := aRightAxis;

    for i := 0 to 364 do
    begin
      j := Random(100);
      s.AddXY(Date + i, j);
      kum := kum + j;
      t.AddXY(Date + i, kum);
    end;

    exit;
   }
  for i1 := 0 to fAktienListbox.Count -1 do
  begin
    //if i1 = 2 then
    //  exit;
    AkId := Integer(fAktienListbox.Items.Objects[i1]);
    fAktie.Read(AkId);
    fTSIList.ReadAll(AkId, 27, edt_Datumvon.DateTime, edt_Datumbis.DateTime);

    s := TLineSeries.Create(nil);
    s.Clear;
    s.Title := fAktie.Aktie;
    s.ParentChart := Chart_TSI;
    s.XValues.DateTime := true;


    for i2 := 0 to fTSIList.Count -1 do
    begin
      s.AddXY(fTSIList.Item[i2].Datum, fTSIList.Item[i2].TSIWert);
      //Sr.Add(fTSIList.Item[i2].TSIWert, DateToStr(fTSIList.Item[i2].Datum));
    end;
    //Chart_TSI.AddSeries(Chart_TSi.Series[0]).
    //exit;
  end;
end;




end.
