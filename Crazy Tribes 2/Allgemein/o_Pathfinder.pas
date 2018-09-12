unit o_Pathfinder;

interface

uses
  SysUtils, Classes, Graphics, Math, Winapi.Windows, Vcl.ExtCtrls,
  contnrs, vcl.Controls, Dialogs, o_HexFeld;


type
  TPathFinder = class(TObject)
  private
    FAnzahlFelder: Integer;
    FHexFeld: THexFeld;
    procedure NextPoint;
  protected
  public
    LeftPoint: TPoint;
    Start: TPoint;
    Ende: TPoint;
    constructor Create;
    destructor Destroy; override;
    procedure Calc;
    property AnzahlFelder: Integer read FAnzahlFelder;
  end;

implementation

{ TPathFinder }


constructor TPathFinder.Create;
begin
  FAnzahlFelder := 0;
  FHexFeld := THexFeld.Create;
end;

destructor TPathFinder.Destroy;
begin
  FreeAndNil(FHexFeld);
  inherited;
end;


procedure TPathFinder.Calc;
begin
  FAnzahlFelder := 0;
  FHexFeld.LeftPoint.X := LeftPoint.X;
  FHexFeld.LeftPoint.Y := LeftPoint.Y;

  FHexFeld.setPoint(Start.X, Start.Y);

  while FAnzahlFelder < 1000 do
  begin
    if (FHexFeld.getPoint.X = Ende.X) and (FHexFeld.getPoint.Y = Ende.Y)  then
      break;
    inc(FAnzahlFelder);
    NextPoint;
  end;
end;


procedure TPathFinder.NextPoint;
var
  Point: TPoint;
  Richtung: Integer;
  Abstand: Integer;
  NeuerAbstand: Integer;
  Diff: TPoint;
  Weg: TPoint;
begin

  Point.X := FHexFeld.getPoint.X;
  Point.Y := FHexFeld.getPoint.Y;

  if Point.Y = Ende.Y then // Zeile ist identisch
  begin
    if Point.X < Ende.X then
    begin
      FHexFeld.setPoint(FHexFeld.getPoint.X +1, FHexFeld.getPoint.Y);
      exit;
    end;

    if Point.X > Ende.X then
    begin
      FHexFeld.setPoint(FHexFeld.getPoint.X -1, FHexFeld.getPoint.Y);
      exit;
    end;
    exit;
  end;

  if Point.Y < Ende.Y then
  begin
    if Point.X = Ende.X then
    begin
      if Point.X = FHexFeld.SO.X then
        FHexFeld.setPoint(FHexFeld.SO.X, FHexFeld.SO.Y)
      else
        FHexFeld.setPoint(FHexFeld.SW.X, FHexFeld.SW.Y);
      exit;
    end;

    if Point.X < Ende.X then  // Nach SüdOst
      FHexFeld.setPoint(FHexFeld.SO.X, FHexFeld.SO.Y)
    else
      FHexFeld.setPoint(FHexFeld.SW.X, FHexFeld.SW.Y);
    exit;
  end;

  if Point.Y > Ende.Y then
  begin
    if Point.X = Ende.X then
    begin
      if Point.X = FHexFeld.NO.X then
        FHexFeld.setPoint(FHexFeld.NO.X, FHexFeld.NO.Y)
      else
        FHexFeld.setPoint(FHexFeld.NW.X, FHexFeld.NW.Y);
      exit;
    end;
    if Point.X < Ende.X then  // Nach SüdOst
      FHexFeld.setPoint(FHexFeld.NO.X, FHexFeld.NO.Y)
    else
      FHexFeld.setPoint(FHexFeld.NW.X, FHexFeld.NW.Y);
    exit;
  end;

end;



end.
