unit m_Grid;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, o_Timelinelist, o_Timeline, o_Koordinate;

type
  TOnTimelineDblClick = procedure(Sender: TObject; aKoordinate: TKoordinate) of object;

type
  RCol = Record const
    Base: Integer = 0;
    Biker: Integer = 1;
    Trike: Integer = 2;
    Buggy: Integer = 3;
    Scout: Integer = 4;
    Ranger: Integer = 5;
    Pickup: Integer = 6;
    Gunner: Integer = 7;
    Molotov: Integer = 8;
    Mortar: Integer = 9;
    Knocker: Integer = 10;
    Carrack: Integer = 11;
    Gesamt: Integer = 12;
    Ankunft: Integer = 13;
  End;

type
  Tfra_Grid = class(TFrame)
    Grid: TStringGrid;
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure GridDblClick(Sender: TObject);
  private
    FCol: RCol;
    FTimelineList: TTimelineList;
    FOnTimelineDblClick: TOnTimelineDblClick;
    procedure setTimelineList(const Value: TTimelineList);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property TimelineList: TTimelineList read FTimelineList write setTimelineList;
    property OnTimelineDblClick: TOnTimelineDblClick read FOnTimelineDblClick write FOnTimelineDblClick;
  end;

implementation

{$R *.dfm}

{ Tfra_Grid }

constructor Tfra_Grid.Create(AOwner: TComponent);
begin
  inherited;
  Grid.ColCount := 14;
  Grid.ColWidths[FCol.Base] := 200;
  Grid.ColWidths[FCol.Biker] := 50;
  Grid.ColWidths[FCol.Trike] := 50;
  Grid.ColWidths[FCol.Buggy] := 50;
  Grid.ColWidths[FCol.Scout] := 50;
  Grid.ColWidths[FCol.Ranger] := 50;
  Grid.ColWidths[FCol.Pickup] := 50;
  Grid.ColWidths[FCol.Gunner] := 50;
  Grid.ColWidths[FCol.Molotov] := 50;
  Grid.ColWidths[FCol.Mortar] := 50;
  Grid.ColWidths[FCol.Knocker] := 50;
  Grid.ColWidths[FCol.Carrack] := 50;
  Grid.ColWidths[FCol.Gesamt] := 50;
  Grid.ColWidths[FCol.Ankunft] := 50;


  Grid.Cells[FCol.Base, 0] := 'Basename';
  Grid.Cells[FCol.Biker, 0] := 'Biker';
  Grid.Cells[FCol.Trike, 0] := 'Trike';
  Grid.Cells[FCol.Buggy, 0] := 'Buggy';
  Grid.Cells[FCol.Scout, 0] := 'Scout';
  Grid.Cells[FCol.Ranger, 0] := 'Ranger';
  Grid.Cells[FCol.Pickup, 0] := 'Pickup';
  Grid.Cells[FCol.Gunner, 0] := 'Gunner';
  Grid.Cells[FCol.Molotov, 0] := 'Molotov';
  Grid.Cells[FCol.Mortar, 0] := 'Mortar';
  Grid.Cells[FCol.Knocker, 0] := 'Knocker';
  Grid.Cells[FCol.Carrack, 0] := 'Carrack';
  Grid.Cells[FCol.Gesamt, 0] := 'Gesamt';
  Grid.Cells[FCol.Ankunft, 0] := 'Ankunft';
end;

destructor Tfra_Grid.Destroy;
begin

  inherited;
end;

procedure Tfra_Grid.GridDblClick(Sender: TObject);
var
  Timeline: TTimeline;
begin
  Timeline :=TTimeline(Grid.Objects[0, Grid.Row]);
  if (Assigned(FOnTimelineDblClick)) and (Timeline <> nil) then
    FOnTimelineDblClick(Self, Timeline.Koordinate);
end;

procedure Tfra_Grid.GridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Timeline: TTimeline;
begin
  Grid.Canvas.Font.Color := clBlack;
  Timeline := TTimeline(Grid.Objects[0, ARow]);
  if Timeline <> nil then
  begin
    if not Timeline.FelderOk then
      Grid.canvas.Font.Color := clRed;
  end;

  Grid.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Grid.cells[acol, arow]);
  Grid.Canvas.FrameRect(Rect);

end;

procedure Tfra_Grid.setTimelineList(const Value: TTimelineList);
  function getAnzahl(aValue: Integer): string;
  begin
    if aValue = 0 then
    begin
      Result := '';
      exit;
    end;
    Result := IntToStr(aValue);
  end;
var
  iRow, iCol: Integer;
  Timeline: TTimeline;
begin
  FTimelineList := Value;
  Grid.RowCount := FTimelineList.Count + 1;
  for iRow := 1 to Grid.RowCount - 1 do
  begin
    for iCol := 0 to Grid.ColCount - 1 do
    begin
      Grid.Cells[iCol, iRow] := '';
      Grid.Objects[iCol,iRow] := nil;
    end;
  end;
  for iRow := 0 to FTimelineList.Count - 1 do
  begin
    Timeline := FTimelineList.Item[iRow];
    Grid.Cells[FCol.Base, iRow+1]    := Timeline.Basename;
    Grid.Cells[FCol.Biker, iRow+1]   := getAnzahl(Timeline.Biker);
    Grid.Cells[FCol.Trike, iRow+1]   := getAnzahl(Timeline.Trike);
    Grid.Cells[FCol.Buggy, iRow+1]   := getAnzahl(Timeline.Buggy);
    Grid.Cells[FCol.Scout, iRow+1]   := getAnzahl(Timeline.Scout);
    Grid.Cells[FCol.Ranger, iRow+1]  := getAnzahl(Timeline.Ranger);
    Grid.Cells[FCol.Pickup, iRow+1]  := getAnzahl(Timeline.Pickup);
    Grid.Cells[FCol.Gunner, iRow+1]  := getAnzahl(Timeline.Gunner);
    Grid.Cells[FCol.Molotov, iRow+1] := getAnzahl(Timeline.Molotov);
    Grid.Cells[FCol.Mortar, iRow+1]  := getAnzahl(Timeline.Mortar);
    Grid.Cells[FCol.Knocker, iRow+1] := getAnzahl(Timeline.Knocker);
    Grid.Cells[FCol.Carrack, iRow+1] := getAnzahl(Timeline.Carrack);
    Grid.Cells[FCol.Gesamt, iRow+1]  := getAnzahl(Timeline.Gesamt);
    Grid.Cells[FCol.Ankunft, iRow+1] := Timeline.Ankunft;
    Grid.Objects[0,iRow+1] := Timeline;
  end;
end;

end.
