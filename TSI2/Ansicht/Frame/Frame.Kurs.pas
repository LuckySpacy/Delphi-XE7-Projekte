unit Frame.Kurs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Frame.Aktie, MySql.Kurslist,
  MySql.KurseList, MySql.Kurs, Frame.ChartKurs, Frame.ChartTSI;

type
  Tfra_Kurs = class(TFrame)
    pnl_Aktie: TPanel;
    pnl_Client: TPanel;
    pnl_TSI: TPanel;
    pnl_Kurs: TPanel;
    Splitter1: TSplitter;
  private
    fAktie: Tfra_Aktie;
    fChartKurs: Tfra_ChartKurs;
    fChartTSI: Tfra_ChartTSI;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LadeDaten;
    procedure LoadKurs(Sender: TObject; aAK_ID:Integer; aWKN, aAktie: string);
    procedure LoadKursTSI(Sender: TObject; aAK_ID:Integer; aWKN, aAktie: string);
  end;

implementation

{$R *.dfm}

{ Tfra_Kurs }

constructor Tfra_Kurs.Create(AOwner: TComponent);
begin
  inherited;
  fAktie := Tfra_Aktie.Create(Self);
  fAktie.Parent := pnl_Aktie;
  fAktie.Align  := alClient;
  fChartKurs := Tfra_ChartKurs.Create(Self);
  fChartKurs.Parent := pnl_Kurs;
  fChartKurs.Align := alClient;
  fChartKurs.OnLoadKurs := LoadKursTSI;
  fAktie.OnLoadKurs := LoadKurs;

  fChartTSI := Tfra_ChartTSI.Create(Self);
  fChartTSI.Parent := pnl_TSI;
  fChartTSI.Align := alClient;



end;

destructor Tfra_Kurs.Destroy;
begin
  inherited;
end;

procedure Tfra_Kurs.LadeDaten;
begin
  fAktie.LadeDaten;
end;

procedure Tfra_Kurs.LoadKurs(Sender: TObject; aAK_ID: Integer; aWKN, aAktie: string);
var
  Cur: TCursor;
begin
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    fChartKurs.Aktual(aAK_Id, aWKN, aAktie);
    fChartTSI.Aktual(aAK_Id, 27, aWKN, aAktie, fChartKurs.edt_Datumvon.Date, fChartKurs.edt_Datumbis.Date);
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure Tfra_Kurs.LoadKursTSI(Sender: TObject; aAK_ID: Integer; aWKN,
  aAktie: string);
begin
  fChartTSI.Aktual(aAK_Id, 27, aWKN, aAktie, fChartKurs.edt_Datumvon.Date, fChartKurs.edt_Datumbis.Date);
end;

end.
