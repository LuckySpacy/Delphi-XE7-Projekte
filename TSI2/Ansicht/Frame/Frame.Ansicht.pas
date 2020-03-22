unit Frame.Ansicht;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Frame.BoersenIndex,
  MySql.Base, Vcl.StdCtrls, MySql.TSIAnsichtList, MySql.TSIAnsicht, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, Vcl.Menus;


type
  RCol = Record const
    Indicator = 0;
    WKN = 1;
    Aktie = 2;
    LetzterKurs = 3;
    TSI27 = 4;
    TSI12 = 5;
    Kurs = 6;
    Kursdatum = 7;
    JHochKurs = 8;
    JHochDatum = 9;
    HJTiefKurs = 10;
    HJTiefDatum = 11;
    ColCount = 12;
  End;


type
  Tfra_Ansicht = class(TFrame)
    pnl_BI: TPanel;
    grd: TAdvStringGrid;
    pop: TPopupMenu;
    pop_Depot: TMenuItem;
    procedure grdGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure popPopup(Sender: TObject);
  private
    fBoersenIndex: Tfra_BoersenIndex;
    fMySqlAnsichtlist: TMySqlTSIAnsichtlist;
    fCol: RCol;
    fBI_Id: Integer;
    procedure ChangedBoersenIndex(Sender: TObject; aBI_ID: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Aktual;
    procedure LeseDaten;
  end;

implementation

{$R *.dfm}

uses
  Objekt.Global;

{ Tfra_Ansicht }



constructor Tfra_Ansicht.Create(AOwner: TComponent);
begin
  inherited;
  fBoersenIndex := Tfra_BoersenIndex.Create(Self);
  fBoersenIndex.Parent := pnl_BI;
  fBoersenIndex.Align := alClient;
  fBoersenIndex.OnChangedBoersenindex := ChangedBoersenIndex;
  fMySqlAnsichtlist := TMySqlTSIAnsichtlist.Create(nil);
  //fMySqlBase.ReadMySql(Global.MySql.BoersenindexLink, Memo1.Lines);

  grd.ColCount := fCol.ColCount;
  grd.FixedCols := 1;
  grd.FixedColWidth := 10;
  grd.DefaultRowHeight := 18;
  grd.rowcount := 2;
  grd.Options := grd.Options + [goRowSelect];
  grd.Cells[fCol.WKN,0] := 'WKN';
  grd.Cells[fCol.Aktie,0] := 'Aktie';
  grd.Cells[fCol.LetzterKurs,0] := 'Letzter Kurs';
  grd.Cells[fCol.TSI27,0] := 'TSI 27';
  grd.Cells[fCol.TSI12,0] := 'TSI 12';
  grd.Cells[fCol.Kurs,0] := 'Kurs';
  grd.Cells[fCol.KursDatum,0] := 'Kurs Dat.';
  grd.Cells[fCol.JHochKurs,0] := 'JHochkurs';
  grd.Cells[fCol.JHochDatum,0] := 'JHoch Dat.';
  grd.Cells[fCol.HJTiefKurs,0] := 'JTiefkurs';
  grd.Cells[fCol.HJTiefDatum,0] := 'JTief Dat.';

  grd.ColWidths[fCol.WKN] := 80;
  grd.ColWidths[fCol.Aktie] := 100;
  grd.ColWidths[fCol.LetzterKurs] := 100;
  grd.ColWidths[fCol.TSI27] := 80;
  grd.ColWidths[fCol.TSI12] := 80;
  grd.ColWidths[fCol.Kurs] := 80;
  grd.ColWidths[fCol.KursDatum] := 80;
  grd.ColWidths[fCol.JHochKurs] := 80;
  grd.ColWidths[fCol.JHochDatum] := 80;
  grd.ColWidths[fCol.HJTiefKurs] := 80;
  grd.ColWidths[fCol.HJTiefDatum] := 80;
  grd.SortSettings.Show := true;

  grd.Options := grd.Options + [goColSizing];

  fBI_Id := 0;

end;

destructor Tfra_Ansicht.Destroy;
begin
  FreeAndNil(fMySqlAnsichtlist);
  inherited;
end;



procedure Tfra_Ansicht.LeseDaten;
begin
  fMySqlAnsichtlist.ReadAll;
  Aktual;
end;


procedure Tfra_Ansicht.ChangedBoersenIndex(Sender: TObject; aBI_ID: Integer);
begin
  fBi_Id := aBI_ID;
  Aktual;
end;


procedure Tfra_Ansicht.Aktual;
var
  i1: Integer;
  RowCount: Integer;
  Ansicht: TMySqlTSIAnsicht;
  iRow: Integer;
begin
  grd.ClearNormalCells;
  RowCount := fMySqlAnsichtlist.Count;
  if RowCount < 2 then
    RowCount := 2;
  grd.RowCount := RowCount;
  iRow := 0;
  for i1 := 0 to fMySqlAnsichtlist.Count -1 do
  begin
    Ansicht := fMySqlAnsichtlist.Item[i1];
    if (fBI_Id > 0) and (fBI_Id <> Ansicht.FieldByName('BI_ID').AsInteger) then
      continue;
    inc(iRow);
    grd.Objects[0, iRow] := Ansicht;
    grd.Cells[fCol.WKN, iRow] := Ansicht.FieldByName('WKN').AsString;
    grd.Cells[fCol.Aktie, iRow] := Ansicht.FieldByName('Aktie').AsString;
    grd.Cells[fCol.LetzterKurs, iRow] := Ansicht.FieldByName('LetzterKurs').AsString;
    grd.Cells[fCol.Kurs, iRow] := Ansicht.FieldByName('Kurs').AsString;
    grd.Cells[fCol.Kursdatum, iRow] := Ansicht.FieldByName('Kursdatum').AsString;
    grd.Cells[fCol.JHochKurs, iRow] := Ansicht.FieldByName('JHochkurs').AsString;
    grd.Cells[fCol.JHochDatum, iRow] := Ansicht.FieldByName('JHochdatum').AsString;
    grd.Cells[fCol.HJTiefKurs, iRow] := Ansicht.FieldByName('HJTiefkurs').AsString;
    grd.Cells[fCol.HJTiefDatum, iRow] := Ansicht.FieldByName('HJTiefdatum').AsString;
    grd.Cells[fCol.TSI27, iRow] := Ansicht.FieldByName('TSI27').AsString;
    grd.Cells[fCol.TSI12, iRow] := Ansicht.FieldByName('TSI12').AsString;
  end;

  if iRow > 1 then
    grd.RowCount := iRow
  else
    grd.RowCount := 2;

end;


procedure Tfra_Ansicht.grdGetCellColor(Sender: TObject; ARow, ACol: Integer;
  AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  Ansicht: TMySqlTSIAnsicht;
begin
  if ARow < 1 then
    exit;
  if grd.Objects[0, ARow] = nil then
    exit;
  Ansicht := TMySqlTSIAnsicht(grd.Objects[0, ARow]);
  if ACol = fCol.Aktie then
  begin
    if Ansicht.FieldByName('Depot').AsBoolean then
      aFont.Color := clBlue;
  end;
  if ACol = fCol.JHochKurs then
  begin
    if Ansicht.FieldByName('Kurs').AsFloat >= Ansicht.FieldByName('JHochkurs').AsFloat then
    begin
      ABrush.Color := clYellow;
    end;
  end;
  if ACol = fCol.HJTiefKurs then
  begin
    if Ansicht.FieldByName('Kurs').AsFloat <= Ansicht.FieldByName('HJTiefkurs').AsFloat then
    begin
      ABrush.Color := clRed;
    end;
  end;
end;


procedure Tfra_Ansicht.popPopup(Sender: TObject);
var
  Aktie: TMySqlTSIAnsicht;
begin //
  if grd.Objects[0, grd.Row] = nil then
    exit;
  Aktie := TMySqlTSIAnsicht(grd.Objects[0, grd.Row]);
  if Aktie.FieldByName('Depot').AsBoolean then
    pop.Items[0].Caption := 'Aktie "' + Aktie.FieldByName('Aktie').asString + '" aus dem Depot entfernen'
  else
    pop.Items[0].Caption := 'Aktie "' + Aktie.FieldByName('Aktie').asString + '" dem Depot hinzufügen';
end;




end.
