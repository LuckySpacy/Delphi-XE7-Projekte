unit Form.Aktien;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  DBObj.Boersenindex, DBObj.BoersenIndexList, DBObj.Aktie, DBObj.AktieList,
  Vcl.Grids, AdvObj, BaseGrid, AdvGrid, DBObj.AkSt, DBObj.AkStList, DBObj.TSIList,
  DBObj.TSILastList;

type
  RCol = Record const
    Indicator = 0;
    WKN = 1;
    Aktie = 2;
    Depot = 3;
    Aktiv = 4;
    Index = 5;
  End;

type
  Tfrm_Aktien = class(TForm)
    Panel2: TPanel;
    pnl_Boersenindex: TLabel;
    cbo_Boersenindex: TComboBox;
    grd: TAdvStringGrid;
    btn_Neu: TButton;
    btn_Loeschen: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbo_BoersenindexChange(Sender: TObject);
    procedure grdEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure grdCheckBoxClick(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure grdGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure grdGetEditorProp(Sender: TObject; ACol, ARow: Integer;
      AEditLink: TEditLink);
    procedure grdGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure grdComboChange(Sender: TObject; ACol, ARow, AItemIndex: Integer;
      ASelection: string);
    procedure btn_NeuClick(Sender: TObject);
    procedure btn_LoeschenClick(Sender: TObject);
  private
    fCol: RCol;
    fBoersenindexList: TBoersenindexList;
    fBoersenindex: TBoersenindex;
    fAktieList: TAktieList;
    fAktie: TAktie;
    fAkStList: TAkStList;
    fTSIList: TTSIList;
    fTSILastList: TTSILastList;
    procedure Aktual;
  public
  end;

var
  frm_Aktien: Tfrm_Aktien;

implementation

{$R *.dfm}

uses
  Datamodul.TSI, System.UITypes;



procedure Tfrm_Aktien.FormCreate(Sender: TObject);
begin //
  fBoersenindexList := TBoersenindexList.Create(nil);
  fBoersenindexList.Trans := dm.IBT;
  fBoersenindex := TBoersenindex.Create(nil);
  fBoersenindex.Trans := dm.IBT;

  fAktieList := TAktieList.Create(nil);
  fAktieList.Trans := dm.IBT;

  fAktie := TAktie.Create(nil);
  fAktie.Trans := dm.IBT;


  Grd.FixedCols := 1;
  Grd.FixedColWidth := 10;
  Grd.ColCount := 6;
  Grd.ColumnHeaders.Add(' ');
  Grd.ColumnHeaders.Add('WKN');
  Grd.ColumnHeaders.Add('Aktie');
  Grd.ColumnHeaders.Add('Depot');
  Grd.ColumnHeaders.Add('Aktiv');
  Grd.ColumnHeaders.Add('Börsenindex');
  Grd.Options := Grd.Options + [goColSizing];
  Grd.Options := Grd.Options + [goEditing];
  //Grd.Options := Grd.Options + [goRowSelect];
  Grd.AutoSize := true;
  Grd.DefaultRowHeight := 18;

  grd.ColWidths[fCol.Aktie] := 200;
  grd.ColWidths[fCol.Wkn]   := 80;
  grd.ColWidths[fCol.Index]   := 100;

  fAkStList := TAkStList.Create(Self);
  fTSIList  := TTSIList.Create(Self);
  fTSILastList := TTSILastList.Create(Self);

  fAkStList.Trans := dm.IBT;
  fTSIList.Trans := dm.IBT;
  fTSILastList.Trans := dm.IBT;


end;

procedure Tfrm_Aktien.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fBoersenindexList);
  FreeAndNil(fBoersenindex);
  FreeAndNil(fAktieList);
  FreeAndNil(fAktie);
  FreeAndNil(fAkStList);
  FreeAndNil(fTSIList);
  FreeAndNil(fTSILastList);
end;

procedure Tfrm_Aktien.FormShow(Sender: TObject);
begin
  fBoersenindexList.LadeCombobox(cbo_Boersenindex.Items);
  cbo_Boersenindex.ItemIndex := 0;
  Aktual;
end;



procedure Tfrm_Aktien.cbo_BoersenindexChange(Sender: TObject);
begin
  Aktual;
end;


procedure Tfrm_Aktien.Aktual;
var
  i1, i2: Integer;
  iRow: Integer;
begin
  grd.ClearNormalCells;
  i2 := Integer(cbo_Boersenindex.Items.Objects[cbo_Boersenindex.ItemIndex]);
  fAktieList.LeseAlleInBoersenindex(i2);

  iRow := 0;
  grd.RowCount := fAktieList.Count + 1;

  for i1 := 0 to fAktieList.Count -1 do
  begin
    inc(iRow);
    grd.Objects[0, iRow] := fAktieList.Item[i1];
    grd.Cells[fCol.Aktie, iRow]  := fAktieList.Item[i1].Aktie;
    grd.Cells[fCol.WKN, iRow]    := fAktieList.Item[i1].WKN;
    grd.Cells[fCol.Index, iRow]  := fAktieList.Item[i1].Boersenindexname;
    grd.AddCheckBox(fCol.Depot, iRow, fAktieList.Item[i1].Depot, false);
    grd.AddCheckBox(fCol.Aktiv, iRow, fAktieList.Item[i1].Aktiv, false);
  end;

  //grd.RowCount := iRow + 1;

end;

procedure Tfrm_Aktien.grdCheckBoxClick(Sender: TObject; ACol, ARow: Integer;
  State: Boolean);
var
  Aktie: TAktie;
  Cur: TCursor;
begin
  if (fCol.Depot <> ACol) and (fCol.Aktiv <> ACol) then
    exit;

  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    Aktie := TAktie(grd.Objects[0, ARow]);
    if Aktie = nil then
      exit;

    if fCol.Depot = ACol then
      Aktie.Depot := State;

    if fCol.Aktiv = ACol then
      Aktie.Aktiv := State;

    Aktie.SaveToDB;
  finally
    Screen.Cursor := Cur;
  end;

end;

procedure Tfrm_Aktien.grdComboChange(Sender: TObject; ACol, ARow,
  AItemIndex: Integer; ASelection: string);
var
  Boersenindex: TBoersenindex;
  Aktie: TAktie;
begin
  if grd.Combobox.ItemIndex < 0 then
    exit;
  BoersenIndex := TBoersenindex(grd.Combobox.Items.Objects[grd.Combobox.ItemIndex]);
  if BoersenIndex = nil then
    exit;
  Aktie := TAktie(grd.Objects[0, ARow]);
  if Aktie = nil then
    exit;
  Aktie.BI_ID := Boersenindex.Id;
  Aktie.SaveToDB;
end;

procedure Tfrm_Aktien.grdEditCellDone(Sender: TObject; ACol, ARow: Integer);
var
  Aktie: TAktie;
  Cur: TCursor;
begin
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    Aktie := TAktie(grd.Objects[0, ARow]);
    if Aktie = nil then
      exit;
    if (fCol.WKN <> ACol) and (fCol.Aktie <> ACol) then
      exit;

    if fCol.Aktie = ACol then
      Aktie.Aktie := grd.Cells[fCol.Aktie, ARow];
    if (fCol.WKN = ACol) and (Trim(grd.Cells[fCol.WKN, ARow]) > '') then
    begin
      if Aktie.WknExist(grd.Cells[fCol.WKN, ARow], Aktie.Id) then
      begin
        ShowMessage('WKN "' + grd.Cells[fCol.WKN, ARow] + '" existiert bereits.');
        grd.Cells[fCol.WKN, ARow] := Aktie.WKN;
      end;
      Aktie.WKN := grd.Cells[fCol.WKN, ARow];
    end;

    Aktie.SaveToDB;
  finally
    Screen.Cursor := Cur;
  end;

end;

procedure Tfrm_Aktien.grdGetAlignment(Sender: TObject; ARow, ACol: Integer;
  var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if (fCol.Depot = ACol) and (fCol.Aktiv = ACol) then
    VAlign := vtaCenter;

end;

procedure Tfrm_Aktien.grdGetEditorProp(Sender: TObject; ACol, ARow: Integer;
  AEditLink: TEditLink);
var
  i1: Integer;
begin
  if fCol.Index <> ACol then
    exit;

  if grd.Combobox.Items.Count = 0  then
  begin
    for i1 := 0 to fBoersenindexList.Count -1 do
    begin
      grd.Combobox.AddItem(fBoersenindexList.Item[i1].Bezeichnung, fBoersenindexList.Item[i1]);
    end;
  end;
end;

procedure Tfrm_Aktien.grdGetEditorType(Sender: TObject; ACol, ARow: Integer;
  var AEditor: TEditorType);
begin
  if fCol.Index = aCol then
    aEditor := edComboList;
end;

procedure Tfrm_Aktien.btn_LoeschenClick(Sender: TObject);
var
  Aktie: TAktie;
begin
  Aktie := TAktie(grd.Objects[0, grd.Row]);
  if Aktie = nil then
    exit;
  if MessageDlg('Aktie "' + Aktie.Aktie + '" wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;

  if dm.IBT.InTransaction then
    dm.IBT.Commit;
  dm.IBT.StartTransaction;
  try
    fTSILastList.DeleteAktie(Aktie.Id);
    fAkStList.DeleteAktie(Aktie.Id);
    fTSIList.DeleteAktie(Aktie.Id);
    Aktie.Delete;
  except
    if dm.IBT.InTransaction then
      dm.IBT.Rollback;
  end;
  if dm.IBT.InTransaction then
    dm.IBT.Commit;
  Aktual;
end;

procedure Tfrm_Aktien.btn_NeuClick(Sender: TObject);
var
  Aktie: TAktie;
begin
  grd.AddRow;
  Aktie := TAktie.Create(self);
  Aktie.Trans := dm.IBT;
  Aktie.BI_ID :=  TBoersenindex(fBoersenindexList.Item[0]).Id;
  grd.Objects[0, grd.RowCount -1] := Aktie;
  grd.AddCheckBox(fCol.Depot, grd.RowCount -1, false, false);
  grd.AddCheckBox(fCol.Aktiv, grd.RowCount -1, true, false);

end;

end.
