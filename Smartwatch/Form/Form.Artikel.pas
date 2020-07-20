unit Form.Artikel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, tbButton, View.ArtikelList, DB.FirmaArtikel;

type
  RCol = Record
    ArNr: Integer;
    Match: Integer;
    FiNr: Integer;
    Webseite: Integer;
    ImageUrl: Integer;
    const Count: Integer = 5;
  End;


type
  TArtNrDblClick=procedure(aArId: Integer) of object;
  Tfrm_Artikel = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Panel3: TPanel;
    cbo_Firma: TComboBox;
    Panel4: TPanel;
    btn_Neu: TTBButton;
    btn_Loeschen: TTBButton;
    grd: TAdvStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_NeuClick(Sender: TObject);
    procedure btn_LoeschenClick(Sender: TObject);
    procedure grdEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure grdDblClickCell(Sender: TObject; ARow, ACol: Integer);
  private
    fCol: RCol;
    fFieldList: TStringList;
    fGridIniFile: string;
    fArtikelList: TViewArtikelList;
    fFirmaArtikel: TDBFirmaArtikel;
    fFa_FI_ID: Integer;
    fOnArtNrDblClick: TArtNrDblClick;
    procedure LadeSpaltenBreite;
    procedure SaveSpaltenBreite;
    procedure AktualGrid;
    procedure Neu;
    procedure Delete;
    function ShowMemo(aValue: string): string;
  public
    property OnArtNrDblClick: TArtNrDblClick read fOnArtNrDblClick write fOnArtNrDblClick;
  end;

var
  frm_Artikel: Tfrm_Artikel;

implementation

{$R *.dfm}

uses
  dm.Datenmodul, Objekt.Smartwatch, View.Artikel, System.UITypes,
  DB.Artikel, Form.Memo;


procedure Tfrm_Artikel.FormCreate(Sender: TObject);
begin
  cbo_Firma.Clear;
  cbo_Firma.AddItem('Amazon', TObject(1));
  cbo_Firma.ItemIndex := 0;

  fFieldList := TStringList.Create;
  fCol.ArNr  := 0;
  fCol.Match := 1;
  fCol.FiNr  := 2;
  fCol.Webseite := 3;
  fCol.ImageUrl := 4;
  grd.ColCount := fCol.Count;
  grd.FixedCols := 0;
  grd.DefaultRowHeight := 18;
  grd.RowCount := 2;
  grd.Options := grd.Options + [goColSizing];
  grd.Options := grd.Options - [goRangeSelect];
  grd.Options := grd.Options + [goEditing];
  grd.Options := grd.Options - [goRowSelect];
  grd.SortSettings.Show := false;

  fFieldList.Add('ArNr=' + IntToStr(fCol.ArNr));
  fFieldList.Add('Match=' + IntToStr(fCol.Match));
  fFieldList.Add('FiNr=' + IntToStr(fCol.FiNr));
  fFieldList.Add('Webseite=' + IntToStr(fCol.Webseite));
  fFieldList.Add('ImageUrl=' + IntToStr(fCol.ImageUrl));

  fGridIniFile := Smartwatch.GridIni;
  fArtikelList := TViewArtikelList.Create(nil);

  grd.Cells[fCol.ArNr, 0] := 'ArNr';
  grd.Cells[fCol.Match, 0] := 'Artikel';
  grd.Cells[fCol.FiNr, 0] := 'FirmenNr';
  grd.Cells[fCol.Webseite, 0] := 'Webseite';
  grd.Cells[fCol.ImageUrl, 0] := 'BildUrl';

  fFa_FI_ID := 0;
  fFirmaArtikel := TDBFirmaArtikel.Create(nil);


end;

procedure Tfrm_Artikel.FormDestroy(Sender: TObject);
begin
  SaveSpaltenBreite;
  FreeAndNil(fFieldList);
  FreeAndNil(fArtikelList);
  FreeAndNil(fFirmaArtikel);
end;

procedure Tfrm_Artikel.FormShow(Sender: TObject);
begin
  fFa_FI_ID := Integer(cbo_Firma.Items.Objects[cbo_Firma.ItemIndex]);
  fArtikelList.ReadAll(fFa_FI_ID);
  AktualGrid;
  LadeSpaltenBreite;
end;

procedure Tfrm_Artikel.grdDblClickCell(Sender: TObject; ARow, ACol: Integer);
var
  s1, s2: string;
  x: TViewArtikel;
begin
  if grd.Objects[0, ARow] = nil then
    exit;
  x := TViewArtikel(grd.Objects[0, ARow]);
  if ACol = fCol.ArNr then
  begin
    if Assigned(fOnArtNrDblClick) then
    begin
      fOnArtNrDblClick(x.Ar_Id);
      exit;
    end;
  end;
  if ACol = fCol.Match then
  begin
    s1 := grd.Cells[ACol, ARow];
    s2 := ShowMemo(s1);
    if s1 <> s2 then
    begin
      x.Match := S2;
      grd.Cells[ACol, ARow] := s2;
      x.Save;
    end;
  end;
  if ACol = fCol.Webseite then
  begin
    s1 := grd.Cells[ACol, ARow];
    s2 := ShowMemo(s1);
    if s1 <> s2 then
    begin
      x.Webseite := S2;
      grd.Cells[ACol, ARow] := s2;
      x.Save;
    end;
  end;
  if ACol = fCol.ImageUrl then
  begin
    s1 := grd.Cells[ACol, ARow];
    s2 := ShowMemo(s1);
    if s1 <> s2 then
    begin
      x.ImageUrl := S2;
      grd.Cells[ACol, ARow] := s2;
      x.Save;
    end;
  end;
end;

procedure Tfrm_Artikel.grdEditCellDone(Sender: TObject; ACol, ARow: Integer);
var
  x: TViewArtikel;
begin
  if grd.Objects[0, ARow] = nil then
    exit;
  x := TViewArtikel(grd.Objects[0, ARow]);
  if ACol = fCol.Match then
    x.Match := grd.Cells[ACol, ARow];
  if ACol = fCol.ArNr then
    x.Nr := grd.Cells[ACol, ARow];
  if ACol = fCol.Webseite then
    x.Webseite := grd.Cells[ACol, ARow];
  if ACol = fCol.ImageUrl then
    x.ImageUrl := grd.Cells[ACol, ARow];
  if ACol = fCol.FiNr then
  begin
    if fFirmaArtikel.CheckFirmenNr(x.Fa_Id, Trim(grd.Cells[ACol, ARow])) then
    begin
      ShowMessage('Firmennummer schon vorhanden');
      exit;
    end;
    x.FiNr := grd.Cells[ACol, ARow];
  end;
  x.Save;
end;

procedure Tfrm_Artikel.LadeSpaltenBreite;
var
  SpaltenList: TStringList;
  s: string;
  i1: Integer;
  Feldname: string;
  Breite: Integer;
begin
  SpaltenList := TStringList.Create;
  try
    SpaltenList.Delimiter := ';';
    s := Smartwatch.Ini.ReadIni(fGridIniFile, Self.Name + '_' + grd.Name, 'ColWidth', '');
    if s = '' then
      exit;
    SpaltenList.DelimitedText := s;
    for i1 := 0 to SpaltenList.Count -1 do
    begin
      Feldname := SpaltenList.Names[i1];
      if Trim(Feldname) = '' then
        continue;
      Breite := StrToInt(SpaltenList.ValueFromIndex[i1]);
      grd.ColWidths[StrToInt(fFieldList.Values[Feldname])] := Breite;
    end;
  finally
    FreeAndNil(SpaltenList);
  end;

end;


procedure Tfrm_Artikel.SaveSpaltenBreite;
var
  i1: Integer;
  s: string;
begin
  s := '';
  for i1 := 0 to fFieldList.Count -1 do
    s := s + fFieldList.Names[i1] + '=' + IntToStr(grd.ColWidths[StrToInt(fFieldList.ValueFromIndex[i1])]) + ';';
  Smartwatch.Ini.WriteIni(fGridIniFile, Self.Name + '_' + grd.Name, 'ColWidth', s);
end;



procedure Tfrm_Artikel.AktualGrid;
var
  i1: Integer;
  Cur: TCursor;
  Anzahl: Integer;
begin
  Cur := Screen.Cursor;
  grd.BeginUpdate;
  try
    Screen.Cursor := crHourGlass;
    for i1 := 0 to grd.RowCount -1 do
      grd.Objects[0, i1] := nil;
    grd.ClearNormalCells;
    Anzahl := fArtikelList.Count;
    if Anzahl <= 1 then
      Anzahl := 1;
    grd.RowCount := Anzahl + 1;
    for i1 := 0 to fArtikelList.Count -1 do
    begin
      grd.Cells[fCol.Match, i1+1] := fArtikelList.Item[i1].Match;
      grd.Cells[fCol.ArNr, i1+1] := fArtikelList.Item[i1].Nr;
      grd.Cells[fCol.Webseite, i1+1] := fArtikelList.Item[i1].Webseite;
      grd.Cells[fCol.ImageUrl, i1+1] := fArtikelList.Item[i1].ImageUrl;
      grd.Cells[fCol.FiNr, i1+1]     := fArtikelList.Item[i1].FiNr;
      grd.Objects[0, i1+1] := fArtikelList.Item[i1];
    end;
    grd.Cells[fCol.ArNr, 0] := 'ArNr';
    grd.Cells[fCol.Match, 0] := 'Artikel';
    grd.Cells[fCol.Webseite, 0] := 'Webseite';
    grd.Cells[fCol.ImageUrl, 0] := 'BildUrl';
    grd.Cells[fCol.FiNr, 0] := 'Firmennr.';
  finally
    Screen.Cursor := Cur;
    grd.EndUpdate;
  end;

end;

procedure Tfrm_Artikel.Neu;
var
  Cur: TCursor;
  Artikel: TDBArtikel;
  FirmaArtikel: TDBFirmaArtikel;
begin
  Cur := Screen.Cursor;
  Artikel      := TDBArtikel.Create(nil);
  FirmaArtikel := TDBFirmaArtikel.Create(nil);
  try
    Screen.Cursor := crHourGlass;
    fFa_FI_ID := Integer(cbo_Firma.Items.Objects[cbo_Firma.ItemIndex]);
    if fFa_FI_ID < 0 then
      exit;
    Artikel.Save;
    FirmaArtikel.Fi_Id := fFA_FI_Id;
    FirmaArtikel.Ar_Id := Artikel.Id;
    FirmaArtikel.Save;
    fArtikelList.ReadAll(fFa_FI_ID);
    AktualGrid;
  finally
    FreeAndNil(Artikel);
    FreeAndNil(Artikel);
    Screen.Cursor := Cur;
  end;
end;

procedure Tfrm_Artikel.btn_LoeschenClick(Sender: TObject);
begin
  Delete;
end;

procedure Tfrm_Artikel.btn_NeuClick(Sender: TObject);
begin
  Neu;
end;

procedure Tfrm_Artikel.Delete;
var
  x: TViewArtikel;
begin
  if MessageDlg('Wirklich Löschen?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  if grd.Objects[0, grd.Row] = nil then
    exit;
  x := TViewArtikel(grd.Objects[0, grd.Row]);
  x.Delete;
  fArtikelList.ReadAll(fFa_FI_ID);
  AktualGrid;
end;


function Tfrm_Artikel.ShowMemo(aValue: string): string;
var
  Form: Tfrm_Memo;
begin
  Result := aValue;
  Form := Tfrm_Memo.Create(nil);
  try
    Form.mem_Memo.Text := aValue;
    Form.ShowModal;
    if not Form.Cancel then
      Result := Form.mem_Memo.Text;
  finally
    FreeAndNil(Form);
  end;
end;



end.
