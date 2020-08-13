unit Form.Artikeleigenschaft2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, Vcl.ExtCtrls, DB.Artikel, DB.EigenschaftList, DB.ArtikelEigenschaft,
  View.EigenschaftList;

type
  RCol = Record
    Match: Integer;
    CheckBox: Integer;
    EnMatch: Integer;
    const Count: Integer = 3;
  End;

type
  Tfrm_Artikeleigenschaft2 = class(TForm)
    Panel1: TPanel;
    edt_Checkbox: TEdit;
    grd: TAdvStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt_CheckboxKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure grdCheckBoxClick(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
  private
    fArId: Integer;
    fEnId: Integer;
    fArtikel: TDBArtikel;
    fEigenschaftList: TViewEigenschaftList;
    fArtikelEigenschaft: TDBArtikeleigenschaft;
    fFieldList: TStringList;
    fGridIniFile: string;
    fCol: RCol;
    fUpdateTime: TDateTime;
    procedure LadeSpaltenBreite;
    procedure SaveSpaltenBreite;
    procedure AktualGrid;
    procedure Filtere;
    procedure setArId(const Value: Integer);
  public
    property ArId: Integer read fArId write setArId;
    property UpdateTime: TDateTime read fUpdateTime write fUpdateTime;
  end;

var
  frm_Artikeleigenschaft2: Tfrm_Artikeleigenschaft2;

implementation

{$R *.dfm}

uses
  dm.Datenmodul, Objekt.Smartwatch, DB.Eigenschaft, System.UITypes, View.Eigenschaft;



procedure Tfrm_Artikeleigenschaft2.edt_CheckboxKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Filtere;
end;


procedure Tfrm_Artikeleigenschaft2.FormCreate(Sender: TObject);
begin
  fFieldList := TStringList.Create;
  fArId := -1;
  fEnId := -1;
  fArtikel := TDBArtikel.Create(nil);
  fEigenschaftList := TViewEigenschaftList.Create(nil);
  fArtikelEigenschaft := TDBArtikeleigenschaft.Create(nil);

  fCol.Match := 0;
  fCol.CheckBox := 1;
  fCol.EnMatch := 2;
  grd.ColCount := fCol.Count;
  grd.FixedCols := 0;
  grd.DefaultRowHeight := 18;
  grd.RowCount := fCol.Count;
  grd.Options := grd.Options + [goColSizing];
  grd.Options := grd.Options - [goRangeSelect];
  grd.Options := grd.Options + [goEditing];
  grd.Options := grd.Options - [goRowSelect];
  grd.SortSettings.Show := false;


  fFieldList.Add('Match=' + IntToStr(fCol.Match));
  fFieldList.Add('CheckBox=' + IntToStr(fCol.CheckBox));
  fFieldList.Add('EnMatch=' + IntToStr(fCol.EnMatch));
  fGridIniFile := Smartwatch.GridIni;
end;

procedure Tfrm_Artikeleigenschaft2.FormDestroy(Sender: TObject);
begin
  SaveSpaltenBreite;
  FreeAndNil(fArtikel);
  FreeAndNil(fEigenschaftList);
  FreeAndNil(fEigenschaftList);
  FreeAndNil(fArtikelEigenschaft);
end;

procedure Tfrm_Artikeleigenschaft2.FormShow(Sender: TObject);
//var
//  i1: Integer;
begin
 {
  grd.Cells[fCol.Match, 0] := 'Eigenschaft';
  grd.Cells[fCol.CheckBox, 0] := 'Zugeordnet';
  grd.Cells[fCol.EnMatch, 0] := 'Eigenschaftname';

  LadeSpaltenBreite;

  if (fArId > -1) and (fArtikel.Id = fArId) then
    exit;

  edt_Checkbox.Text := '';
  fArtikel.Read(fArId);
  fEigenschaftList.ReadAll;

  for i1 := 0 to fEigenschaftList.Count -1 do
    fEigenschaftList.Item[i1].Checked := fArtikelEigenschaft.Checked(fArId, fEigenschaftList.Item[i1].En_Id, fEigenschaftList.Item[i1].Ei_Id);

  AktualGrid;
  }

end;

procedure Tfrm_Artikeleigenschaft2.grdCheckBoxClick(Sender: TObject; ACol,
  ARow: Integer; State: Boolean);
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
    x.Checked := not x.Checked;
    if State then
    begin
      fArtikelEigenschaft.Update := fUpdateTime;
      fArtikelEigenschaft.Save;
    end
    else
    begin
      fArtikelEigenschaft.Lese(fArId, x.En_Id, x.Ei_Id);
      fArtikelEigenschaft.Delete;
    end;
  end;
end;


procedure Tfrm_Artikeleigenschaft2.grdGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ACol = fCol.CheckBox then
    HAlign := taCenter;
end;

procedure Tfrm_Artikeleigenschaft2.LadeSpaltenBreite;
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

procedure Tfrm_Artikeleigenschaft2.SaveSpaltenBreite;
var
  i1: Integer;
  s: string;
begin
  s := '';
  for i1 := 0 to fFieldList.Count -1 do
    s := s + fFieldList.Names[i1] + '=' + IntToStr(grd.ColWidths[StrToInt(fFieldList.ValueFromIndex[i1])]) + ';';
  Smartwatch.Ini.WriteIni(fGridIniFile, Self.Name + '_' + grd.Name, 'ColWidth', s);
end;


procedure Tfrm_Artikeleigenschaft2.setArId(const Value: Integer);
var
  i1: Integer;
begin
  grd.Cells[fCol.Match, 0] := 'Eigenschaft';
  grd.Cells[fCol.CheckBox, 0] := 'Zugeordnet';
  grd.Cells[fCol.EnMatch, 0] := 'Eigenschaftname';
  fArId := Value;

  LadeSpaltenBreite;

  if (fArId > -1) and (fArtikel.Id = fArId) then
    exit;

  edt_Checkbox.Text := '';
  fArtikel.Read(fArId);
  fEigenschaftList.ReadAll;

  for i1 := 0 to fEigenschaftList.Count -1 do
    fEigenschaftList.Item[i1].Checked := fArtikelEigenschaft.Checked(fArId, fEigenschaftList.Item[i1].En_Id, fEigenschaftList.Item[i1].Ei_Id);

  AktualGrid;

end;

procedure Tfrm_Artikeleigenschaft2.AktualGrid;
var
  i1: Integer;
  Cur: TCursor;
  Anzahl: Integer;
  Checked: Boolean;
  CheckboxText: string;
  Vgl: String;
begin
  Cur := Screen.Cursor;
  grd.BeginUpdate;
  try
    Screen.Cursor := crHourGlass;
    for i1 := 0 to grd.RowCount -1 do
      grd.Objects[0, i1] := nil;
    grd.ClearNormalCells;
    Anzahl := fEigenschaftList.Count;
    if Anzahl <= 1 then
      Anzahl := 1;
    grd.RowCount := Anzahl + 1;
    Anzahl := 0;
    for i1 := 0 to fEigenschaftList.Count -1 do
    begin
      CheckboxText := Trim(edt_Checkbox.Text);
      if CheckboxText > '' then
      begin
        Vgl := copy(fEigenschaftList.Item[i1].Ei_Match, 1, Length(CheckboxText));
        if not SameText(Vgl, CheckboxText) then
          continue;
      end;
      inc(Anzahl);
      grd.Cells[fCol.Match, Anzahl] := fEigenschaftList.Item[i1].Ei_Match;
      grd.Cells[fCol.EnMatch, Anzahl] := fEigenschaftList.Item[i1].En_Match;
      grd.Objects[0, Anzahl] := fEigenschaftList.Item[i1];
      Checked := fEigenschaftList.Item[i1].Checked;
      //Checked := fArtikelEigenschaft.Checked(fArId, fEigenschaftList.Item[i1].En_Id, fEigenschaftList.Item[i1].Ei_Id);
      grd.AddCheckBox(fCol.CheckBox, Anzahl, Checked, false);
    end;

    if Anzahl <= 1 then
      Anzahl := 1;
    grd.RowCount := Anzahl + 1;

  finally
    Screen.Cursor := Cur;
    grd.EndUpdate;
  end;

end;


procedure Tfrm_Artikeleigenschaft2.Filtere;
begin
 // fEigenschaftList.Filter(edt_Checkbox.Text);
  AktualGrid;
end;



end.
