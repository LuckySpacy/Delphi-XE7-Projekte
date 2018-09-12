unit Frame.Kurse;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBOBj.BoersenindexList, DBObj.Boersenindex,
  DBObj.Aktie, DBObj.AktieList, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Frame.KursListe,
  Frame.ChartVariabel, Frame.TSIChart;

type
  Tfra_Kurse = class(TFrame)
    Panel1: TPanel;
    lsb_Aktie: TListBox;
    Börsenindex: TLabel;
    cbo_Boersenindex: TComboBox;
    PageControl1: TPageControl;
    tbs_Kursliste: TTabSheet;
    tbs_Chart_Zeitraum: TTabSheet;
    tbs_TSIChart: TTabSheet;
    procedure cbo_BoersenindexChange(Sender: TObject);
    procedure lsb_AktieClick(Sender: TObject);
    procedure lsb_AktieDblClick(Sender: TObject);
  private
    fBoersenindexList: TBoersenindexList;
    fAktieList: TAktieList;
    fFrameKursListe: Tfra_Kursliste;
    fFrameChartVariable: Tfra_ChartVariable;
    fFrameTSIChart: Tfra_TSIChart;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{ TFrame1 }

uses
  Datamodul.TSI, Objekt.Global;



constructor Tfra_Kurse.Create(AOwner: TComponent);
begin
  inherited;
  fBoersenindexList := TBoersenindexList.Create(nil);
  fBoersenindexList.Trans := dm.IBT;
  fBoersenindexList.LadeCombobox(cbo_Boersenindex.Items);
  fAktieList := TAktieList.Create(nil);
  fAktieList.Trans := dm.IBT;

  fFrameKursListe := Tfra_Kursliste.Create(nil);
  fFrameKursListe.Parent := tbs_Kursliste;
  fFrameKursListe.Align  := alClient;

  fFrameChartVariable := Tfra_ChartVariable.Create(nil);
  fFrameChartVariable.Parent := tbs_Chart_Zeitraum;
  fFrameChartVariable.Align  := alClient;

  fFrameTSIChart := Tfra_TSIChart.Create(nil);
  fFrameTSIChart.Parent := tbs_TSIChart;
  fFrameTSIChart.Align  := alClient;


end;

destructor Tfra_Kurse.Destroy;
begin
  FreeAndNil(fAktieList);
  FreeAndNil(fBoersenindexList);
  FreeAndNil(fFrameKursListe);
  FreeAndNil(fFrameChartVariable);
  FreeAndNil(fFrameTSIChart);
  inherited;
end;


procedure Tfra_Kurse.lsb_AktieClick(Sender: TObject);
begin
  if lsb_Aktie.ItemIndex < 0 then
    exit;

  if PageControl1.ActivePage = tbs_Kursliste then
    fFrameKursListe.LadeGrid(Integer(lsb_Aktie.Items.Objects[lsb_Aktie.ItemIndex]));

  fFrameChartVariable.AK_Id := Integer(lsb_Aktie.Items.Objects[lsb_Aktie.ItemIndex]);

end;

procedure Tfra_Kurse.lsb_AktieDblClick(Sender: TObject);
begin
  if (lsb_Aktie.Count > 0) then
  begin
    fFrameTSIChart.LoadAktienChart(Integer(lsb_Aktie.Items.Objects[lsb_Aktie.ItemIndex]));
    fFrameChartVariable.ChartLaden;
  end;
end;

procedure Tfra_Kurse.cbo_BoersenindexChange(Sender: TObject);
var
  BiId: Integer;
  i1: Integer;
begin
  if cbo_Boersenindex.ItemIndex < 0 then
    exit;
  BiId := Integer(cbo_Boersenindex.Items.Objects[cbo_Boersenindex.ItemIndex]);

  fAktieList.ReadAllInBoersenindex(BiId);

  lsb_Aktie.Clear;

  for i1 := 0 to fAktieList.Count -1 do
  begin
    lsb_Aktie.AddItem(fAktieList.Item[i1].Aktie + ' [' + fAktieList.Item[i1].WKN + '] ', TObject(fAktieList.Item[i1].Id));
  end;

  fFrameTSIChart.AktienListbox := lsb_Aktie;

end;





end.
