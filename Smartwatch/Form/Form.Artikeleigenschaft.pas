unit Form.Artikeleigenschaft;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, DB.Artikel, DB.EigenschaftList, DB.ArtikelEigenschaft;

type
  RCol = Record
    Match: Integer;
    CheckBox: Integer;
    const Count: Integer = 2;
  End;


type
  Tfrm_Artikeleigenschaft = class(TForm)
    pnl_Top: TPanel;
    pnl_Bottom: TPanel;
    pnl_Left: TPanel;
    pnl_Client: TPanel;
    lbl_Artikel: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    cbo_Eigenschaftname: TComboBox;
    grd: TAdvStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbo_EigenschaftnameChange(Sender: TObject);
    procedure grdGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure grdCheckBoxClick(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
  private
    fArId: Integer;
    fEnId: Integer;
    fArtikel: TDBArtikel;
    fEigenschaftList: TDBEigenschaftList;
    fArtikelEigenschaft: TDBArtikeleigenschaft;
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
  frm_Artikeleigenschaft: Tfrm_Artikeleigenschaft;

implementation

{$R *.dfm}

uses
  dm.Datenmodul, Objekt.Smartwatch, DB.Eigenschaft, System.UITypes;


procedure Tfrm_Artikeleigenschaft.cbo_EigenschaftnameChange(Sender: TObject);
begin
  AktualGrid;
end;

procedure Tfrm_Artikeleigenschaft.FormCreate(Sender: TObject);
begin //
  fFieldList := TStringList.Create;
  fArId := -1;
  fEnId := -1;
  fArtikel := TDBArtikel.Create(nil);
  fEigenschaftList := TDBEigenschaftList.Create(nil);
  fArtikelEigenschaft := TDBArtikeleigenschaft.Create(nil);

  fCol.Match := 0;
  fCol.CheckBox := 1;
  grd.ColCount := fCol.Count;
  grd.FixedCols := 0;
  grd.DefaultRowHeight := 18;
  grd.RowCount := 2;
  grd.Options := grd.Options + [goColSizing];
  grd.Options := grd.Options - [goRangeSelect];
  grd.Options := grd.Options + [goEditing];
  grd.Options := grd.Options - [goRowSelect];
  grd.SortSettings.Show := false;


  fFieldList.Add('Match=' + IntToStr(fCol.Match));
  fFieldList.Add('CheckBox=' + IntToStr(fCol.CheckBox));
  fGridIniFile := Smartwatch.GridIni;



end;

procedure Tfrm_Artikeleigenschaft.FormDestroy(Sender: TObject);
begin //
  SaveSpaltenBreite;
  FreeAndNil(fArtikel);
  FreeAndNil(fEigenschaftList);
  FreeAndNil(fEigenschaftList);
  FreeAndNil(fArtikelEigenschaft);
end;

procedure Tfrm_Artikeleigenschaft.FormShow(Sender: TObject);
var
  Index: Integer;
begin //
  if (fArId > -1) and (fArtikel.Id = fArId) then
    exit;
  fEnId := -1;
  Index := -1;
  if cbo_Eigenschaftname.ItemIndex > 0 then
    fEnId := Integer(cbo_Eigenschaftname.Items.Objects[cbo_Eigenschaftname.ItemIndex]);
  cbo_Eigenschaftname.Clear;
  dam.qry.SQL.Text := 'select * from eigenschaftname order by en_match';
  dam.qry.Open;
  while not dam.qry.Eof do
  begin
    cbo_Eigenschaftname.Items.AddObject(dam.qry.FieldByName('en_match').AsString, TObject(Integer(dam.qry.FieldbyName('en_id').AsInteger)));
    if fEnId = dam.qry.FieldbyName('en_id').AsInteger then
      Index := cbo_Eigenschaftname.Items.Count -1;
    dam.qry.Next;
  end;
  if Index > -1 then
    cbo_Eigenschaftname.ItemIndex := Index;
  fArtikel.Read(fArId);
  lbl_Artikel.Caption := fArtikel.Match;

  grd.Cells[fCol.Match, 0] := 'Eigenschaft';
  grd.Cells[fCol.CheckBox, 0] := 'Zugeordnet';

  AktualGrid;
  LadeSpaltenBreite;

end;

procedure Tfrm_Artikeleigenschaft.grdCheckBoxClick(Sender: TObject; ACol,
  ARow: Integer; State: Boolean);
var
  x: TDBEigenschaft;
begin
  if (ACol = fCol.CheckBox) and (grd.Objects[0, ARow] <> nil) then
  begin
    x := TDBEigenschaft(grd.Objects[0, ARow]);
    fArtikelEigenschaft.Init;
    fArtikelEigenschaft.AR_ID := fArId;
    fArtikelEigenschaft.EN_ID := x.EnId;
    fArtikelEigenschaft.EI_ID := x.Id;
    if State then
      fArtikelEigenschaft.Save
    else
    begin
      fArtikelEigenschaft.Lese(fArId, x.EnId, x.Id);
      fArtikelEigenschaft.Delete;
    end;
  end;
end;

procedure Tfrm_Artikeleigenschaft.grdGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ACol = fCol.CheckBox then
    HAlign := taCenter;
end;

procedure Tfrm_Artikeleigenschaft.LadeSpaltenBreite;
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

procedure Tfrm_Artikeleigenschaft.SaveSpaltenBreite;
var
  i1: Integer;
  s: string;
begin
  s := '';
  for i1 := 0 to fFieldList.Count -1 do
    s := s + fFieldList.Names[i1] + '=' + IntToStr(grd.ColWidths[StrToInt(fFieldList.ValueFromIndex[i1])]) + ';';
  Smartwatch.Ini.WriteIni(fGridIniFile, Self.Name + '_' + grd.Name, 'ColWidth', s);
end;

procedure Tfrm_Artikeleigenschaft.AktualGrid;
var
  i1: Integer;
  Cur: TCursor;
  Anzahl: Integer;
  Checked: Boolean;
begin
  if cbo_Eigenschaftname.ItemIndex < 0 then
    exit;
  Cur := Screen.Cursor;
  grd.BeginUpdate;
  try
    Screen.Cursor := crHourGlass;
    fEigenschaftList.ReadAll(Integer(cbo_Eigenschaftname.Items.Objects[cbo_Eigenschaftname.ItemIndex]));
    for i1 := 0 to grd.RowCount -1 do
      grd.Objects[0, i1] := nil;
    grd.ClearNormalCells;
    Anzahl := fEigenschaftList.Count;
    if Anzahl <= 1 then
      Anzahl := 1;
    grd.RowCount := Anzahl + 1;
    for i1 := 0 to fEigenschaftList.Count -1 do
    begin
      grd.Cells[fCol.Match, i1+1] := fEigenschaftList.Item[i1].Match;
      grd.Objects[0, i1+1] := fEigenschaftList.Item[i1];
      Checked := fArtikelEigenschaft.Checked(fArId, fEigenschaftList.Item[i1].EnId, fEigenschaftList.Item[i1].Id);
      grd.AddCheckBox(fCol.CheckBox, i1+1, Checked, false);
    end;
  finally
    Screen.Cursor := Cur;
    grd.EndUpdate;
  end;

end;

end.