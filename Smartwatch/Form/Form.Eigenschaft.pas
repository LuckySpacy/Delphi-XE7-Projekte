unit Form.Eigenschaft;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, tbButton, DB.EigenschaftList;

type
  RCol = Record
    Match: Integer;
    const Count: Integer = 1;
  End;

type
  Tfrm_Eigenschaft = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Panel3: TPanel;
    cbo_Eigenschaftname: TComboBox;
    Panel4: TPanel;
    btn_Neu: TTBButton;
    btn_Loeschen: TTBButton;
    grd: TAdvStringGrid;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbo_EigenschaftnameChange(Sender: TObject);
    procedure grdEditCellDone(Sender: TObject; ACol, ARow: Integer);
    procedure btn_NeuClick(Sender: TObject);
    procedure btn_LoeschenClick(Sender: TObject);
  private
    fCol: RCol;
    fFieldList: TStringList;
    fGridIniFile: string;
    fEigenschaftList: TDBEigenschaftList;
    fEi_En_Id: Integer;
    procedure LadeSpaltenBreite;
    procedure SaveSpaltenBreite;
    procedure AktualGrid;
    procedure Neu;
    procedure Delete;
  public
  end;

var
  frm_Eigenschaft: Tfrm_Eigenschaft;

implementation

{$R *.dfm}

uses
  dm.Datenmodul, Objekt.Smartwatch, DB.Eigenschaft, System.UITypes;


procedure Tfrm_Eigenschaft.FormCreate(Sender: TObject);
begin
  fFieldList := TStringList.Create;
  fEi_En_Id := -1;
  fCol.Match := 0;
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

  fGridIniFile := Smartwatch.GridIni;
  fEigenschaftList := TDBEigenschaftList.Create(nil);

end;

procedure Tfrm_Eigenschaft.FormDestroy(Sender: TObject);
begin
  SaveSpaltenBreite;
  FreeAndNil(fFieldList);
  FreeAndNil(fEigenschaftList);
end;

procedure Tfrm_Eigenschaft.FormShow(Sender: TObject);
begin
  if fEi_En_Id > -1 then
    exit;
  cbo_Eigenschaftname.Clear;
  dam.qry.SQL.Text := 'select * from eigenschaftname order by en_match';
  dam.qry.Open;
  while not dam.qry.Eof do
  begin
    cbo_Eigenschaftname.Items.AddObject(dam.qry.FieldByName('en_match').AsString, TObject(Integer(dam.qry.FieldbyName('en_id').AsInteger)));
    dam.qry.Next;
  end;
  AktualGrid;
  LadeSpaltenBreite;
  grd.Cells[0, fCol.Match] := 'Eigenschaft';
end;

procedure Tfrm_Eigenschaft.grdEditCellDone(Sender: TObject; ACol,
  ARow: Integer);
var
  x: TDBEigenschaft;
begin
  if grd.Objects[0, ARow] = nil then
    exit;
  x := TDBEigenschaft(grd.Objects[0, ARow]);
  if ACol = fCol.Match then
    x.Match := grd.Cells[ACol, ARow];
  x.Save;
end;

procedure Tfrm_Eigenschaft.LadeSpaltenBreite;
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


procedure Tfrm_Eigenschaft.SaveSpaltenBreite;
var
  i1: Integer;
  s: string;
begin
  s := '';
  for i1 := 0 to fFieldList.Count -1 do
    s := s + fFieldList.Names[i1] + '=' + IntToStr(grd.ColWidths[StrToInt(fFieldList.ValueFromIndex[i1])]) + ';';
  Smartwatch.Ini.WriteIni(fGridIniFile, Self.Name + '_' + grd.Name, 'ColWidth', s);
end;



procedure Tfrm_Eigenschaft.cbo_EigenschaftnameChange(Sender: TObject);
begin
  fEi_En_Id := 0;
  if cbo_Eigenschaftname.ItemIndex < 0 then
    exit;
  fEi_En_Id := Integer(cbo_Eigenschaftname.Items.Objects[cbo_Eigenschaftname.ItemIndex]);
  fEigenschaftList.ReadAll(fEi_En_Id);
  AktualGrid;
end;



procedure Tfrm_Eigenschaft.AktualGrid;
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
    Anzahl := fEigenschaftList.Count;
    if Anzahl <= 1 then
      Anzahl := 2;
    grd.RowCount := Anzahl + 1;
    for i1 := 0 to fEigenschaftList.Count -1 do
    begin
      grd.Cells[fCol.Match, i1+1] := fEigenschaftList.Item[i1].Match;
      grd.Objects[0, i1+1] := fEigenschaftList.Item[i1];
    end;
  finally
    Screen.Cursor := Cur;
    grd.EndUpdate;
  end;

end;

procedure Tfrm_Eigenschaft.btn_LoeschenClick(Sender: TObject);
begin
  Delete;
end;

procedure Tfrm_Eigenschaft.btn_NeuClick(Sender: TObject);
begin
  Neu;
end;


procedure Tfrm_Eigenschaft.Neu;
var
  x: TDBEigenschaft;
  Cur: TCursor;
begin
  Cur := Screen.Cursor;
  x := TDBEigenschaft.Create(nil);
  try
    Screen.Cursor := crHourGlass;
    fEi_En_Id := Integer(cbo_Eigenschaftname.Items.Objects[cbo_Eigenschaftname.ItemIndex]);
    if fEi_En_Id < 0 then
      exit;
    x.Match := '';
    x.enid  := fei_en_id;
    x.Save;
    fEigenschaftList.ReadAll(fEi_En_Id);
    AktualGrid;
  finally
    FreeAndNil(x);
    Screen.Cursor := Cur;
  end;
end;

procedure Tfrm_Eigenschaft.Delete;
var
  x: TDBEigenschaft;
begin
  if MessageDlg('Wirklich Löschen?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  if grd.Objects[0, grd.Row] = nil then
    exit;
  x := TDBEigenschaft(grd.Objects[0, grd.Row]);
  x.Delete;
  fEigenschaftList.ReadAll(fEi_En_Id);
  AktualGrid;
end;



end.
