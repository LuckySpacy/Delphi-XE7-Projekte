unit o_HexFeld;

interface

uses
  SysUtils, Classes, Graphics, Math, Winapi.Windows, Vcl.ExtCtrls,
  contnrs, vcl.Controls, Dialogs;


type
  THexFeld = class(TObject)
  private
    FPoint: TPoint;
    FNord: TPoint;
    FSued: TPoint;
    FNW  : TPoint;
    FNO  : TPoint;
    FSW  : TPoint;
    FSO  : TPoint;
    FLinkeReihe: Boolean;
    procedure Init;
    function LinkeReihe: Boolean;
    function getNordWest: TPoint;
    function getNordOst: TPoint;
    function getSuedOst: TPoint;
    function getSuedWest: TPoint;
    function getOst: TPoint;
    function getWest: TPoint;
  protected

  public
    LeftPoint: TPoint;
    constructor Create;
    destructor Destroy; override;
    property NW: TPoint read getNordWest;
    property NO: TPoint read getNordOst;
    property SW: TPoint read getSuedWest;
    property SO: TPoint read getSuedOst;
    property  O: TPoint read getOst;
    property  W: TPoint read getWest;
    procedure setPoint(X, Y: Integer);
    function getPoint: TPoint;
  end;


implementation

{ THexFeld }

constructor THexFeld.Create;
begin
  Init;
end;

destructor THexFeld.Destroy;
begin

  inherited;
end;




procedure THexFeld.Init;
begin
  LeftPoint.X := 0;
  LeftPoint.Y := 0;
end;


function THexFeld.getNordOst: TPoint;
begin
  if not FLinkeReihe then
  begin
    Result.X := FPoint.X + 1;
    Result.Y := FPoint.Y - 1;
  end
  else
  begin
    Result.X := FPoint.X;
    Result.Y := FPoint.Y - 1;
  end;
end;

function THexFeld.getNordWest: TPoint;
begin
  Result.X := 1;
  Result.Y := 2;

  if not FLinkeReihe then
  begin
    Result.X := FPoint.X;
    Result.Y := FPoint.Y - 1;
  end
  else
  begin
    Result.X := FPoint.X - 1;
    Result.Y := FPoint.Y -1;
  end;

end;

function THexFeld.getOst: TPoint;
begin
  Result.X := FPoint.X + 1;
  Result.Y := FPoint.Y;
end;

function THexFeld.getPoint: TPoint;
begin
  Result.X := FPoint.X;
  Result.Y := FPoint.Y;
end;

function THexFeld.getSuedOst: TPoint;
begin
  if not FLinkeReihe then
  begin
    Result.X := FPoint.X + 1;
    Result.Y := FPoint.Y + 1;
  end
  else
  begin
    Result.X := FPoint.X;
    Result.Y := FPoint.Y + 1;
  end;
end;

function THexFeld.getSuedWest: TPoint;
begin
  if not FLinkeReihe then
  begin
    Result.X := FPoint.X;
    Result.Y := FPoint.Y + 1;
  end
  else
  begin
    Result.X := FPoint.X - 1;
    Result.Y := FPoint.Y + 1;
  end;
end;

function THexFeld.getWest: TPoint;
begin
  Result.X := FPoint.X -1;
  Result.Y := FPoint.Y;
end;

function THexFeld.LinkeReihe: Boolean;
var
  iZahl: Integer;
  bEinrueckenBeiGeraderZahl: Boolean;
  bGeradeZahl: Boolean;
begin
  {
  iZahl := trunc(LeftPoint.Y / 2);
  if iZahl = LeftPoint.Y / 2 then
    bEinrueckenBeiGeraderZahl := true
  else
    bEinrueckenBeiGeraderZahl := false;
  }

  bEinrueckenBeiGeraderZahl := true;


  iZahl := trunc(FPoint.Y / 2);
  if iZahl = FPoint.Y / 2 then
    bGeradeZahl := true
  else
    bGeradeZahl := false;

  Result := true;

  if (bEinrueckenBeiGeraderZahl) and (bGeradeZahl) then
    Result := false;

  if (not bEinrueckenBeiGeraderZahl) and (not bGeradeZahl) then
    Result := false;

end;

procedure THexFeld.setPoint(X, Y: Integer);
begin
  FPoint.X := X;
  FPoint.Y := Y;
  FLinkeReihe := LinkeReihe;
end;

end.
