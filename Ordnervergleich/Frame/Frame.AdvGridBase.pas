unit Frame.AdvGridBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, AdvObj, Vcl.StdCtrls,
  BaseGrid, AdvGrid, Objekt.Global, Vcl.ComCtrls, Objekt.Ordner, Objekt.OrdnerList;

type
  RCol = Record const
    Fixed     : Integer = 0;
    Titel     : Integer = 1;
    Pfad      : Integer = 2;
  End;


type
  Tfra_AdvGridBase = class(TFrame)
    grd: TAdvStringGrid;
    procedure grdGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure grdGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure grdDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure grdCheckBoxClick(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
  private
  protected
    fCol: RCol;
    fPB: TProgressBar;
    fPBLabel: TLabel;
    procedure SchreibeHeader;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowGrid(aOrdnerList: TOrdnerList);
    procedure setProgressBar(aProgressbar: TProgressbar);
    procedure setProgressLabel(aLabel: TLabel);
  end;

implementation

{$R *.dfm}

{ Tfra_AdvGridBase }


constructor Tfra_AdvGridBase.Create(AOwner: TComponent);
var
  i1: Integer;
begin
  inherited;
  grd.Align := alClient;
  grd.Options := grd.Options + [goColSizing];
  grd.Options := grd.Options + [goEditing];
  grd.FixedColWidth := 10;
  grd.ColCount := 3;
  {
  for i1 := 1 to grd.RowCount -1 do
  begin
    grd.AddCheckBox(fCol.NichtJetzt,i1, false,false);
    grd.AddCheckBox(fCol.Nie,i1, false,false);
  end;
  }
  SchreibeHeader;
  grd.AutoSize := true;
end;


destructor Tfra_AdvGridBase.Destroy;
begin
  inherited;
end;

procedure Tfra_AdvGridBase.grdCheckBoxClick(Sender: TObject; ACol,
  ARow: Integer; State: Boolean);
begin
  {
  Datei := TDatei(grd.Objects[0, ARow]);
  if Datei = nil then
    exit;
  if (ARow > 0) and (ACol = fCol.NichtJetzt) then
    Datei.NichtJetzt := State;
  if (ARow > 0) and (ACol = fCol.Nie) then
    Datei.Nie := State;
    }
end;

procedure Tfra_AdvGridBase.grdDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  ColWidthHalbe: Integer;
  ColHeightHalbe: Integer;
  Icon: TIcon;
begin
  {
  if (ARow > 0) and (ACol = fCol.Icon) then
  begin
    Datei := TDatei(grd.Objects[0, ARow]);
    if Datei = nil then
      exit;
    if Global.FileIcons.FileIcon(Datei.Ext) = nil then
      exit;
    Icon := Global.FileIcons.FileIcon(Datei.Ext).Icon;
    ColWidthHalbe := trunc((Rect.Right - Rect.Left) / 2);
    ColWidthHalbe := ColWidthHalbe - (trunc(Icon.Width / 2));
    ColHeightHalbe := trunc((Rect.Bottom - Rect.Top) / 2);
    ColHeightHalbe := ColHeightHalbe - (trunc(Icon.Height / 2));
    grd.Canvas.Draw(Rect.Left + ColWidthHalbe, Rect.Top + ColHeightHalbe, Icon);
  end;
  }
end;

procedure Tfra_AdvGridBase.grdGetAlignment(Sender: TObject; ARow, ACol: Integer;
  var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  {
  if (ACol = fCol.NichtJetzt) or (ACol = fCol.Nie) then
  begin
    HAlign := taCenter;
    VAlign := vtaCenter;
  end;
  if (ACol = fCol.Groesse) then
    HAlign := taRightJustify;
    }
end;

procedure Tfra_AdvGridBase.grdGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
//  if (ACol = fCol.NichtJetzt) or (ACol = fCol.Nie) then
//    AEditor := edCheckBox;
end;

procedure Tfra_AdvGridBase.SchreibeHeader;
begin
  grd.Cells[fCol.Titel, 0]  := 'Titel';
  grd.Cells[fCol.Pfad, 0] := 'Pfad';
end;


procedure Tfra_AdvGridBase.setProgressBar(aProgressbar: TProgressbar);
begin
  fPB := aProgressbar;
end;

procedure Tfra_AdvGridBase.setProgressLabel(aLabel: TLabel);
begin
  fPBLabel := aLabel;
end;

procedure Tfra_AdvGridBase.ShowGrid(aOrdnerList: TOrdnerList);
var
  i1: Integer;
  Ordner: TOrdner;
begin
  grd.ClearNormalCells;
  if aOrdnerList.Count = 0 then
  begin
    Grd.RowCount := 2;
    exit;
  end;
  Grd.RowCount := aOrdnerList.Count + 1;

  for i1 := 0 to aOrdnerList.Count -1 do
  begin
    Ordner := aOrdnerList.Item[i1];
    grd.Cells[fCol.Titel, i1+1] := Ordner.Titel;
    grd.Cells[fCol.Pfad, i1+1]  := Ordner.Pfad;
  end;
  //grd.AutoSize := true;
  grd.AutoFitColumns;
  grd.ColWidths[fCol.Fixed] := 10;
end;

{
procedure Tfra_AdvGridBase.ShowGrid(aDateiList: TDateiList);
var
  i1: Integer;
  Datei: TDatei;
begin
  grd.ClearNormalCells;
  if aDateiList.Count = 0 then
  begin
    Grd.RowCount := 2;
    exit;
  end;

  Grd.RowCount := aDateiList.Count + 1;

  for i1 := 0 to aDateiList.Count -1 do
  begin
    Datei := aDateiList.Item[i1];

    grd.Cells[fCol.Pfad, i1+1]      := Datei.Pfad;
    grd.Cells[fCol.Dateiname, i1+1] := Datei.Dateiname;
    grd.Cells[fCol.Datum, i1+1]     := Datei.Datum;
    grd.Cells[fCol.Groesse, i1+ 1]  := Datei.Groesse;

    grd.AddCheckBox(fCol.NichtJetzt,i1+1, Datei.NichtJetzt,false);
    grd.AddCheckBox(fCol.Nie,i1+1, Datei.Nie,false);

    grd.Objects[0, i1+1] := Datei;

  end;

  grd.AutoSize := true;

end;

 }


end.
