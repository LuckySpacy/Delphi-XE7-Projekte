unit Frame.Aktie;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, tbStringGrid, DBObj.Aktie, DBObj.AktieList, DBObj.Boersenindexlist,
  dbObj.Boersenindex;

type
  RCol = Record const
    Indicator = 0;
    WKN = 1;
    Aktie = 2;
    Symbol = 3;
    Link = 4;
  End;

type
  Tfra_Aktie = class(TFrame)
    Panel1: TPanel;
    btn_Neu: TButton;
    grd: TtbStringGrid;
    btn_Loeschen: TButton;
    Börsenindex: TLabel;
    cbo_Boersenindex: TComboBox;
    btn_BINeu: TButton;
    btn_BIAendern: TButton;
    btn_BiLoeschen: TButton;
    procedure btn_NeuClick(Sender: TObject);
    procedure grdCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure btn_LoeschenClick(Sender: TObject);
    procedure btn_BINeuClick(Sender: TObject);
    procedure btn_BIAendernClick(Sender: TObject);
    procedure btn_BiLoeschenClick(Sender: TObject);
    procedure cbo_BoersenindexChange(Sender: TObject);
  private
    fAktieList: TAktieList;
    fBoersenindexList: TBoersenindexList;
    fBoersenindex: TBoersenindex;
    fCol: RCol;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LadeGrid;
    procedure LadeBoersenindex;
  end;

implementation

{$R *.dfm}

{ Tfra_Aktie }

uses
  Form.AktieBearb, Datamodul.TSIKurse, Form.BoersenindexBearb;


constructor Tfra_Aktie.Create(AOwner: TComponent);
begin
  inherited;
  grd.ColCount := 5;
  grd.ColWidths[0] := 10;
  grd.Cells[fCol.WKN,0] := 'WKN';
  grd.Cells[fCol.Aktie,0] := 'Aktie';
  grd.Cells[fCol.Link,0] := 'Link';
  grd.Cells[fCol.Symbol,0] := 'Symbol';
  fAktieList := TAktieList.Create(nil);
  fAktieList.Trans := dm.IBT;
  fBoersenindexList := TBoersenindexList.Create(nil);
  fBoersenindexList.Trans := dm.IBT;
  fBoersenindex := TBoersenindex.Create(nil);
  fBoersenindex.Trans := dm.IBT;
end;

destructor Tfra_Aktie.Destroy;
begin
  FreeAndNil(fAktieList);
  FreeAndNil(fBoersenindexList);
  FreeAndNil(fBoersenindex);
  inherited;
end;


procedure Tfra_Aktie.LadeBoersenindex;
var
  BiIndex: Integer;
  i1: Integer;
begin
  BiIndex := -1;
  if cbo_Boersenindex.ItemIndex > -1 then
    BiIndex := Integer(cbo_Boersenindex.Items.Objects[cbo_Boersenindex.ItemIndex]);
  fBoersenindexList.LadeCombobox(cbo_Boersenindex.Items);
  for i1 := 0 to cbo_Boersenindex.Items.Count -1 do
  begin
    if Integer(cbo_Boersenindex.Items.Objects[i1]) = BiIndex then
    begin
      cbo_Boersenindex.ItemIndex := i1;
      break;
    end;
  end;
  if (BiIndex = -1) and (cbo_Boersenindex.Items.Count > 0) then
    cbo_Boersenindex.ItemIndex := 0;
end;

procedure Tfra_Aktie.LadeGrid;
var
  i1: Integer;
  BiId: Integer;
begin
  grd.Clear;

  if cbo_Boersenindex.Items.Count = 0 then
    exit;

  BiId := Integer(cbo_Boersenindex.Items.Objects[cbo_Boersenindex.ItemIndex]);

  fAktieList.ReadAllInBoersenindex(BiId);

  if fAktieList.Count <= 1 then
    grd.RowCount := 2
  else
    grd.RowCount := fAktieList.Count + 1;

  for i1 := 0 to fAktieList.Count -1 do
  begin
    grd.Cells[fCol.WKN, i1+1] := fAktieList.Item[i1].WKN;
    grd.Cells[fCol.Aktie, i1+1] := fAktieList.Item[i1].Aktie;
    grd.Cells[fCol.Link, i1+1] := fAktieList.Item[i1].Link;
    grd.Cells[fCol.Symbol, i1+1] := fAktieList.Item[i1].Symbol;
    grd.Objects[0, i1+1] := fAktieList.Item[i1];
  end;

end;


procedure Tfra_Aktie.btn_LoeschenClick(Sender: TObject);
var
  x: TAktie;
begin
  if grd.Objects[0, grd.Row] = nil then
    exit;
  x := TAktie(grd.Objects[0, grd.Row]);
  if x = nil then
    exit;
  if MessageDlg('Möchtest du wirklich' + sLineBreak +
                 '"' + x.WKN + ' ' + x.Aktie + sLineBreak +
                 'löschen?', mtConfirmation, [mbYes, mbNo],0) = mrNo then
  exit;
  x.Delete;
  LadeGrid;
end;

procedure Tfra_Aktie.btn_NeuClick(Sender: TObject);
var
  Form: Tfrm_Aktiebearb;
  BiId: Integer;
begin
  BiId := -1;
  if cbo_Boersenindex.ItemIndex > -1 then
    BiId := Integer(cbo_Boersenindex.Items.Objects[cbo_Boersenindex.ItemIndex]);
  Form := Tfrm_Aktiebearb.Create(nil);
  try
    if BiId > -1 then
      Form.BI_ID := BiId;
    Form.ShowModal;
    if not Form.Cancel then
      LadeGrid;
  finally
    FreeandNil(Form);
  end;
end;

procedure Tfra_Aktie.cbo_BoersenindexChange(Sender: TObject);
begin
  LadeGrid;
end;

procedure Tfra_Aktie.grdCellDblClick(Sender: TObject; ACol, ARow: Integer);
var
  Form: Tfrm_Aktiebearb;
  x: TAktie;
begin
  if grd.Objects[0, ARow] = nil then
    exit;
  x := TAktie(grd.Objects[0, ARow]);
  if x = nil then
    exit;
  Form := Tfrm_Aktiebearb.Create(nil);
  try
    Form.AK_ID := x.Id;
    Form.ShowModal;
    if not Form.Cancel then
      LadeGrid;
  finally
    FreeandNil(Form);
  end;
end;


procedure Tfra_Aktie.btn_BIAendernClick(Sender: TObject);
var
  Form: Tfrm_BoersenindexBearb;
begin
  if cbo_Boersenindex.ItemIndex = -1 then
    exit;

  Form := Tfrm_BoersenindexBearb.Create(nil);
  try
    Form.BI_ID := Integer(cbo_Boersenindex.Items.Objects[cbo_Boersenindex.ItemIndex]);
    Form.ShowModal;
    LadeBoersenindex;
  finally
    FreeAndNil(Form);
  end;

end;

procedure Tfra_Aktie.btn_BiLoeschenClick(Sender: TObject);
begin
  if cbo_Boersenindex.ItemIndex = -1 then
    exit;
  fBoersenindex.Read(Integer(cbo_Boersenindex.Items.Objects[cbo_Boersenindex.ItemIndex]));
  if fBoersenindex.Gefunden then
  begin
    if MessageDlg('Börsenindex "' + fBoersenindex.Bezeichnung + '" wirklich löschen?', mtConfirmation, [mbYes, mbNO], 0) = mrNo then
      exit;
    fBoersenindex.Delete;
    LadeBoersenindex;
  end;
end;

procedure Tfra_Aktie.btn_BINeuClick(Sender: TObject);
var
  Form: Tfrm_BoersenindexBearb;
begin
  Form := Tfrm_BoersenindexBearb.Create(nil);
  try
    Form.ShowModal;
    LadeBoersenindex;
  finally
    FreeAndNil(Form);
  end;
end;



end.
