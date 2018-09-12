unit Frame.ChartKurs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus,
  VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, MySql.Kurslist, MySql.KurseList, MySql.Kurs, Vcltee.Series;

type
  TLoadKursEvent=procedure(Sender: TObject; aAK_ID: Integer; aWKN, aAktie: string) of object;


type
  Tfra_ChartKurs = class(TFrame)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edt_Datumvon: TDateTimePicker;
    edt_Datumbis: TDateTimePicker;
    btn_Aktual: TButton;
    Chart: TChart;
    procedure btn_AktualClick(Sender: TObject);
    procedure edt_DatumvonExit(Sender: TObject);
    procedure edt_DatumbisExit(Sender: TObject);
  private
    fKurseList: TMySqlKurseList;
    fAK_Id: Integer;
    fWkn: string;
    fAktie: string;
    fOnLoadKurs: TLoadKursEvent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Aktual(aAK_ID: Integer; aWKN, aAktie: string);
    property OnLoadKurs: TLoadKursEvent read fOnLoadKurs write fOnLoadKurs;
  end;

implementation

{$R *.dfm}

uses
  Objekt.Global;


constructor Tfra_ChartKurs.Create(AOwner: TComponent);
begin
  inherited;
  fKurseList := TMySqlKurseList.Create(nil);
  fAk_Id := 0;
  edt_Datumvon.Date := Global.Ini.Kursdatumvon;
  edt_Datumbis.Date := Global.Ini.Kursdatumbis;
end;

destructor Tfra_ChartKurs.Destroy;
begin
  FreeAndNil(fKurseList);
  inherited;
end;


procedure Tfra_ChartKurs.edt_DatumbisExit(Sender: TObject);
begin
  Global.Ini.Kursdatumbis := edt_Datumbis.Date;
end;

procedure Tfra_ChartKurs.edt_DatumvonExit(Sender: TObject);
begin
  Global.Ini.Kursdatumvon := edt_Datumvon.Date;
end;

procedure Tfra_ChartKurs.Aktual(aAK_ID: Integer; aWKN, aAktie: string);
var
  KursList: TMySqlKursList;
  Kurs: TMySqlKurs;
  i1: Integer;
  s : TLineSeries;
begin
  KursList := fKurseList.KursList(aAK_ID);
  fAk_Id := aAK_Id;
  fWkn := aWKN;
  fAktie := aAktie;

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

  for i1 := 0 to KursList.Count -1 do
  begin
    Kurs := KursList.Item[i1];
    if Kurs.FieldByName('datum').AsDateTime < edt_Datumvon.DateTime then
      continue;
    if Kurs.FieldByName('datum').AsDateTime > edt_Datumbis.DateTime then
      continue;
    s.AddXY(Kurs.FieldByName('datum').AsDateTime, Kurs.FieldByName('kurs').AsFloat);
  end;

end;


procedure Tfra_ChartKurs.btn_AktualClick(Sender: TObject);
begin
  if fAk_Id > 0 then
  begin
    Aktual(fAk_Id, fWkn, fAktie);
    if Assigned(fOnLoadKurs) then
      fOnLoadKurs(Self, fAk_Id, fWKN, fAktie);
  end;

end;


end.
