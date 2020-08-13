unit Form.ArtikeleigenschaftUebersicht;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, DB.Artikel, DB.EigenschaftList, DB.ArtikelEigenschaft,
  View.EigenschaftList, DB.Eigenschaft, View.Eigenschaft;

type
  RCol = Record
    EnMatch: Integer;
    EiMatch: Integer;
    CheckBox: Integer;
    const Count: Integer = 3;
  End;


type
  Tfrm_ArtikeleigenschaftUebersicht = class(TForm)
    pnl_Artikel: TPanel;
    pnl_Client: TPanel;
    grd: TAdvStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure grdCheckBoxClick(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure FormShow(Sender: TObject);
    procedure grdGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure grdGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
  private
    fArId: Integer;
    fArtikel: TDBArtikel;
    fEigenschaft: TDBEigenschaft;
    fEigenschaftList: TDBEigenschaftList;
    fArtikelEigenschaft: TDBArtikeleigenschaft;
    fViewArtikelEigenschaft: TViewEigenschaftList;
    fFieldList: TStringList;
    fGridIniFile: string;
    fCol: RCol;
    procedure LadeSpaltenBreite;
    procedure SaveSpaltenBreite;
    procedure AktualGrid;
  public
    property ArId: Integer read fArId write fArId;
  end;

var
  frm_ArtikeleigenschaftUebersicht: Tfrm_ArtikeleigenschaftUebersicht;

implementation

{$R *.dfm}

uses
  Objekt.Smartwatch;


procedure Tfrm_ArtikeleigenschaftUebersicht.FormCreate(Sender: TObject);
begin
  fFieldList := TStringList.Create;
  fArId := -1;
  fArtikel := TDBArtikel.Create(nil);
  fEigenschaftList := TDBEigenschaftList.Create(nil);
  fArtikelEigenschaft := TDBArtikeleigenschaft.Create(nil);
  fViewArtikelEigenschaft := TViewEigenschaftList.Create(nil);
  fEigenschaft := TDBEigenschaft.Create(nil);


  fCol.EnMatch := 0;
  fCol.EiMatch := 1;
  fCol.CheckBox := 2;
  grd.ColCount := fCol.Count;
  grd.FixedCols := 0;
  grd.DefaultRowHeight := 18;
  grd.RowCount := 2;
  grd.Options := grd.Options + [goColSizing];
  grd.Options := grd.Options - [goRangeSelect];
  grd.Options := grd.Options + [goEditing];
  grd.Options := grd.Options - [goRowSelect];
  grd.SortSettings.Show := false;

  fFieldList.Add('Eigenschaftname=' + IntToStr(fCol.EnMatch));
  fFieldList.Add('Eigenschaft=' + IntToStr(fCol.EIMatch));
  fFieldList.Add('CheckBox=' + IntToStr(fCol.CheckBox));
  fGridIniFile := Smartwatch.GridIni;
end;

procedure Tfrm_ArtikeleigenschaftUebersicht.FormDestroy(Sender: TObject);
begin
  SaveSpaltenBreite;
  FreeAndNil(fArtikel);
  FreeAndNil(fEigenschaftList);
  FreeAndNil(fEigenschaftList);
  FreeAndNil(fArtikelEigenschaft);
  FreeAndNil(fEigenschaft);
  FreeAndNil(fViewArtikelEigenschaft);
end;

procedure Tfrm_ArtikeleigenschaftUebersicht.FormShow(Sender: TObject);
begin
  fArtikel.Read(fArId);
  pnl_Artikel.Caption := fArtikel.Match;

  LadeSpaltenBreite;
  grd.Cells[fCol.EnMatch, 0] := 'Eigenschaftname';
  grd.Cells[fCol.EIMatch, 0] := 'Eigenschaft';
  grd.Cells[fCol.CheckBox, 0] := 'Zugeordnet';
  AktualGrid;
end;

procedure Tfrm_ArtikeleigenschaftUebersicht.grdCheckBoxClick(Sender: TObject;
  ACol, ARow: Integer; State: Boolean);
var
  x: TViewEigenschaft;
begin
  if (ACol = fCol.CheckBox) and (grd.Objects[0, ARow] <> nil) then
  begin
    x := TViewEigenschaft(grd.Objects[0, ARow]);
    fArtikelEigenschaft.Init;
    fArtikelEigenschaft.AR_ID := fArId;
    fArtikelEigenschaft.EN_ID := x.En_Id;
    fArtikelEigenschaft.EI_ID := x.Ei_Id;
    if State then
      fArtikelEigenschaft.Save
    else
    begin
      fArtikelEigenschaft.Lese(fArId, x.En_Id, x.Ei_Id);
      fArtikelEigenschaft.Delete;
    end;
  end;
end;

procedure Tfrm_ArtikeleigenschaftUebersicht.grdGetAlignment(Sender: TObject;
  ARow, ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ACol = fCol.CheckBox then
    HAlign := taCenter;
end;

procedure Tfrm_ArtikeleigenschaftUebersicht.grdGetCellColor(Sender: TObject;
  ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  x: TViewEigenschaft;
begin
  if grd.Objects[0, ARow] = nil then
    exit;
  x := TViewEigenschaft(grd.Objects[0, ARow]);
  if x = nil then
    exit;
  if x.Neu then
    AFont.Color := clBlue
  else
    AFont.Color := clBlack;
end;

procedure Tfrm_ArtikeleigenschaftUebersicht.LadeSpaltenBreite;
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


procedure Tfrm_ArtikeleigenschaftUebersicht.SaveSpaltenBreite;
var
  i1: Integer;
  s: string;
begin
  s := '';
  for i1 := 0 to fFieldList.Count -1 do
    s := s + fFieldList.Names[i1] + '=' + IntToStr(grd.ColWidths[StrToInt(fFieldList.ValueFromIndex[i1])]) + ';';
  Smartwatch.Ini.WriteIni(fGridIniFile, Self.Name + '_' + grd.Name, 'ColWidth', s);
end;


procedure Tfrm_ArtikeleigenschaftUebersicht.AktualGrid;
var
  Cur: TCursor;
  i1: Integer;
  Anzahl: Integer;
  Checked: Boolean;
begin
  Cur := Screen.Cursor;
  grd.BeginUpdate;
  try
    Screen.Cursor := crHourGlass;
    for i1 := 0 to grd.RowCount -1 do
      grd.Objects[0, i1] := nil;
    fViewArtikelEigenschaft.FilterByArtikel(fArId);
    grd.ClearNormalCells;
    Anzahl := fViewArtikelEigenschaft.Count;
    if Anzahl <= 1 then
      Anzahl := 1;
    grd.RowCount := Anzahl + 1;
    for i1 := 0 to fViewArtikelEigenschaft.Count -1 do
    begin
      grd.Cells[fCol.EnMatch, i1+1] := fViewArtikelEigenschaft.Item[i1].EN_Match;
      grd.Cells[fCol.EIMatch, i1+1] := fViewArtikelEigenschaft.Item[i1].EI_Match;
      grd.Objects[0, i1+1] := fViewArtikelEigenschaft.Item[i1];
      Checked := fArtikelEigenschaft.Checked(fArId, fViewArtikelEigenschaft.Item[i1].En_Id, fViewArtikelEigenschaft.Item[i1].Ei_Id);
      grd.AddCheckBox(fCol.CheckBox, i1+1, Checked, false);
    end;
  finally
    Screen.Cursor := Cur;
    grd.EndUpdate;
  end;
end;

end.
