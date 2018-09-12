unit Frame.Kursliste;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, tbStringGrid, DBObj.KursList;


type
  RCol = Record const
    Indicator = 0;
    Datum = 1;
    Kurs = 2;
  End;


type
  Tfra_Kursliste = class(TFrame)
    Panel1: TPanel;
    Label1: TLabel;
    edt_Datumvon: TDateTimePicker;
    Label2: TLabel;
    edt_Datumbis: TDateTimePicker;
    grd: TtbStringGrid;
    procedure edt_DatumvonExit(Sender: TObject);
    procedure edt_DatumbisExit(Sender: TObject);
  private
    fCol: RCol;
    fKursList: TKursList;
  public
    procedure LadeGrid(aAK_Id: Integer);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{ Tfra_Kursliste }

uses
  Datamodul.TSI, Objekt.Global;


constructor Tfra_Kursliste.Create(AOwner: TComponent);
begin
  inherited;
  edt_Datumvon.Date := Global.StartKursliste;
  edt_Datumbis.Date := Global.EndeKursliste;

  grd.ColCount := 3;
  grd.ColWidths[0] := 10;
  grd.Cells[fCol.Datum,0] := 'Datum';
  grd.Cells[fCol.Kurs,0] := 'Kurs';

  fKursList := TKursList.Create(nil);
  fKursList.Trans := dm.IBT;



end;

destructor Tfra_Kursliste.Destroy;
begin
  FreeAndNil(fKursList);
  inherited;
end;

procedure Tfra_Kursliste.edt_DatumbisExit(Sender: TObject);
begin
  Global.EndeKursliste := edt_Datumbis.Date;
end;

procedure Tfra_Kursliste.edt_DatumvonExit(Sender: TObject);
begin
  Global.StartKursliste := edt_DatumVon.Date;
end;

procedure Tfra_Kursliste.LadeGrid(aAK_Id: Integer);
var
  i1: Integer;
begin
  grd.Clear;
  fKursList.ReadAll(aAK_ID, edt_Datumvon.Date, edt_Datumbis.Date);
  grd.RowCount := fKursList.Count +1;
  for i1 := 0 to fKursList.Count -1 do
  begin
    grd.Cells[fCol.Datum,i1+1] := FormatDateTime('dd.mm.yyyy', fKursList.Item[i1].Datum);
    grd.Cells[fCol.Kurs,i1+1] := FloatToStr(fKursList.Item[i1].Kurs);
  end;
end;

end.
