unit Form.Artikeleigenschaft2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, Vcl.ExtCtrls, DB.Artikel, DB.EigenschaftList, DB.ArtikelEigenschaft;

type
  RCol = Record
    Match: Integer;
    CheckBox: Integer;
    const Count: Integer = 2;
  End;

type
  Tfrm_Artikeleigenschaft2 = class(TForm)
    Panel1: TPanel;
    edt_Checkbox: TEdit;
    grd: TAdvStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
  public
  end;

var
  frm_Artikeleigenschaft2: Tfrm_Artikeleigenschaft2;

implementation

{$R *.dfm}

uses
  dm.Datenmodul, Objekt.Smartwatch, DB.Eigenschaft, System.UITypes;


procedure Tfrm_Artikeleigenschaft2.FormCreate(Sender: TObject);
begin
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

procedure Tfrm_Artikeleigenschaft2.FormDestroy(Sender: TObject);
begin
  SaveSpaltenBreite;
  FreeAndNil(fArtikel);
  FreeAndNil(fEigenschaftList);
  FreeAndNil(fEigenschaftList);
  FreeAndNil(fArtikelEigenschaft);
end;

procedure Tfrm_Artikeleigenschaft2.FormShow(Sender: TObject);
begin
  grd.Cells[fCol.Match, 0] := 'Eigenschaft';
  grd.Cells[fCol.CheckBox, 0] := 'Zugeordnet';

  LadeSpaltenBreite;
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

end.
