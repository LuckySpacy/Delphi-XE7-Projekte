unit Frame.Aktie;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, tbStringGrid,
  Vcl.StdCtrls, Vcl.ExtCtrls, DBOBj.BoersenindexList, DBObj.Boersenindex,
  DBObj.Aktie, DBObj.AktieList, Vcl.ComCtrls, Vcl.Samples.Spin, DBObj.TSI,
  DBObj.TSIList, Form.TSIWerteLaden, Vcl.Menus;


type
  RCol = Record const
    Indicator = 0;
    WKN = 1;
    Aktie = 2;
    LetztesDatum = 3;
    TSI = 4;
    TSI2 = 5;
  End;


type
  Tfra_Aktie = class(TFrame)
    Panel1: TPanel;
    Börsenindex: TLabel;
    cbo_Boersenindex: TComboBox;
    grd: TtbStringGrid;
    Label1: TLabel;
    edt_Wochen: TSpinEdit;
    edt_LetztesKursdatum: TDateTimePicker;
    Label2: TLabel;
    cbx_LetztesKursdatum: TCheckBox;
    btn_Aktualisieren: TButton;
    btn_AktuellTSI: TButton;
    pop: TPopupMenu;
    mnu_Depot: TMenuItem;
    btn_AlleTSI: TButton;
    procedure cbo_BoersenindexChange(Sender: TObject);
    procedure cbx_LetztesKursdatumClick(Sender: TObject);
    procedure btn_AktuellTSIClick(Sender: TObject);
    procedure popPopup(Sender: TObject);
    procedure mnu_DepotClick(Sender: TObject);
    procedure grdDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure btn_AlleTSIClick(Sender: TObject);
  private
    fBoersenindexList: TBoersenindexList;
    fAktieList: TAktieList;
    fCol: RCol;
    fTSILaden: Boolean;
    procedure LadeGrid;
    procedure AktuellTSILaden;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{ Tfra_Aktie }

uses
  Datamodul.TSI, Objekt.Global;



constructor Tfra_Aktie.Create(AOwner: TComponent);
begin
  inherited;
  fTSILaden := false;
  fBoersenindexList := TBoersenindexList.Create(nil);
  fBoersenindexList.Trans := dm.IBT;
  fBoersenindexList.LadeCombobox(cbo_Boersenindex.Items);
  fAktieList := TAktieList.Create(nil);
  fAktieList.Trans := dm.IBT;

  grd.ColCount := 6;
  grd.ColWidths[0] := 10;
  grd.Cells[fCol.WKN,0] := 'WKN';
  grd.Cells[fCol.Aktie,0] := 'Aktie';
  grd.Cells[fCol.LetztesDatum,0] := 'Letzter Kurs';
  grd.Cells[fCol.TSI,0] := 'TSI';
  grd.Cells[fCol.TSI2,0] := 'TSI2';

  edt_Wochen.Value := Global.Wochen;
  edt_LetztesKursdatum.Date := now;

  grd.LoadGridSpaltenbreite(Global.Userpfad + 'Grid.ini');


end;

destructor Tfra_Aktie.Destroy;
begin
  grd.SaveGridSpaltenbreite(Global.Userpfad + 'Grid.ini');
  FreeAndNil(fAktieList);
  FreeAndNil(fBoersenindexList);
  inherited;
end;




procedure Tfra_Aktie.cbo_BoersenindexChange(Sender: TObject);
begin
  LadeGrid;
end;


procedure Tfra_Aktie.LadeGrid;
var
  i1: Integer;
  BiId: Integer;
  LetztesKursDatum: TDateTime;
  Cur: TCursor;
begin
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    grd.Clear;

    if cbo_Boersenindex.Items.Count = 0 then
      exit;

    BiId := Integer(cbo_Boersenindex.Items.Objects[cbo_Boersenindex.ItemIndex]);

    if cbx_LetztesKursdatum.Checked then
      LetztesKursDatum := trunc(edt_LetztesKursdatum.Date)
    else
      LetztesKursDatum := trunc(now);

    fAktieList.ReadAllInBoersenindex(BiId);

    if fAktieList.Count <= 1 then
      grd.RowCount := 2
    else
      grd.RowCount := fAktieList.Count + 1;

    fAktieList.SortTSI27;

    for i1 := 0 to fAktieList.Count -1 do
    begin
      grd.Cells[fCol.WKN, i1+1] := fAktieList.Item[i1].WKN;
      grd.Cells[fCol.Aktie, i1+1] := fAktieList.Item[i1].Aktie;
      grd.Cells[fCol.TSI, i1+1]   := FloatToStr(fAktieList.Item[i1].LetzterTISWert27);
      grd.Cells[fCol.TSI2, i1+1]   := FloatToStr(fAktieList.Item[i1].LetzterTISWert12);
      //grd.Cells[fCol.TSI, i1+1]   := FloatToStr(fAktieList.Item[i1].LetzterTSIWert(edt_Wochen.Value));
      //grd.Cells[fCol.TSI2, i1+1]  := FloatToStr(fAktieList.Item[i1].LetzterTSIWert(12));
      //grd.Cells[fCol.TSI, i1+1] := FloatToStr(fAktieList.Item[i1].TSI(now, edt_Wochen.Value, LetztesKursDatum));
      //grd.Cells[fCol.LetztesDatum, i1+1] := FormatDateTime('dd.mm.yyyy', fAktieList.Item[i1].LetztesKursdatum);
      grd.Cells[fCol.LetztesDatum, i1+1] := FormatDateTime('dd.mm.yyyy', fAktieList.Item[i1].LetzterTISDatum);
      grd.Objects[0, i1+1] := fAktieList.Item[i1];
    end;
  finally
    Screen.Cursor := Cur;
  end;

end;



procedure Tfra_Aktie.cbx_LetztesKursdatumClick(Sender: TObject);
begin
  if cbx_LetztesKursdatum.Checked then
  begin
    edt_LetztesKursdatum.Enabled := true;
  end
  else
  begin
    edt_LetztesKursdatum.Enabled := false;
    edt_LetztesKursdatum.Date := now;
  end;
  Global.LetztesKursDatumHeute := cbx_LetztesKursdatum.Checked;
end;


procedure Tfra_Aktie.btn_AktuellTSIClick(Sender: TObject);
begin
  if cbo_Boersenindex.ItemIndex < 0 then
    exit;
  fAktieList.ReadAllInBoersenindex(Integer(cbo_Boersenindex.Items.Objects[cbo_Boersenindex.ItemIndex]));
  AktuellTSILaden;
end;

procedure Tfra_Aktie.btn_AlleTSIClick(Sender: TObject);
var
  i1: Integer;
begin
  fAktieList.ReadAllAktien;
  AktuellTSILaden;
  LadeGrid;
end;

procedure Tfra_Aktie.AktuellTSILaden;
var
  Form: Tfrm_TSIWerteLaden;
begin
  if fAktieList.Count = 0 then
  begin
    ShowMessage('Bitte vorher einen Börsenindex auswählen');
    exit;
  end;
  Form := Tfrm_TSIWerteLaden.Create(nil);
  try
    Form.Wochen := edt_Wochen.Value;
    Form.StartDatum := StrToDate('01.01.2017');
    Form.AktieList  := fAktieList;
    fTSILaden := true;
    Form.ShowModal;
  finally
    FreeAndNil(Form);
    fTSILaden := false;
  end;
end;



procedure Tfra_Aktie.popPopup(Sender: TObject);
var
  Aktie: TAktie;
begin //
  if grd.Objects[0, grd.Row] = nil then
    exit;
  Aktie := TAktie(grd.Objects[0, grd.Row]);
  if Aktie.Depot then
    pop.Items[0].Caption := 'Aktie "' + Aktie.Aktie + '" aus dem Depot entfernen'
  else
    pop.Items[0].Caption := 'Aktie "' + Aktie.Aktie + '" dem Depot hinzufügen';
end;


procedure Tfra_Aktie.mnu_DepotClick(Sender: TObject);
var
  Aktie: TAktie;
begin
  if grd.Objects[0, grd.Row] = nil then
    exit;
  Aktie := TAktie(grd.Objects[0, grd.Row]);
  Aktie.Depot := not Aktie.Depot;
  Aktie.SaveToDB;
end;


procedure Tfra_Aktie.grdDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Aktie: TAktie;
begin
  if fTSILaden then
    exit;
  if fCol.Aktie <> ACol then
    exit;
  if grd.Objects[0, ARow] = nil then
    exit;
  Aktie := TAktie(grd.Objects[0, ARow]);
  if not Aktie.Depot then
    exit;
  grd.Canvas.Font.Color := clBlue;
  grd.Canvas.Brush.Style := bsClear;
  grd.Canvas.TextOut(rect.Left + 2, Rect.Top+2, Aktie.Aktie);
end;



end.
