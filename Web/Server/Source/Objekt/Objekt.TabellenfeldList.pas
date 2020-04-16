unit Objekt.TabellenfeldList;

interface

uses
  SysUtils, Classes, Contnrs, Objekt.BaseList, Objekt.Tabellenfeld;


type
  TTabellenfeldList = class(TBaseList)
  private
    function GetTabellenfeld(Index: Integer): TTabellenfeld;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Add: TTabellenfeld;
    property Item[Index: Integer]: TTabellenfeld read GetTabellenfeld;
    function getItemByFeldname(aValue: String): TTabellenfeld;
    procedure Sort;
  end;

implementation

{ TTabellenfeldList }


function SortTabellenfeldList(Item1, Item2: TTabellenfeld): Integer;
begin
  Result := AnsiCompareText(Item1.Feldname, Item2.Feldname);
end;

constructor TTabellenfeldList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TTabellenfeldList.Destroy;
begin

  inherited;
end;

function TTabellenfeldList.getItemByFeldname(aValue: String): TTabellenfeld;
var
  L, R, M : Integer;
  FeldName: String;
begin
  Result := nil;

  L := 0;
  R := fList.Count;

  while (L <= R) and (Result = nil) do
  begin
    M := (L+R) div 2;
    if M > fList.Count -1 then
    begin
      Result := nil;
      exit;
    end;
    FeldName := TTabellenfeld(fList.Items[M]).Feldname;
    if aValue < FeldName then
      R := M - 1;
    if aValue > FeldName then
      L := M + 1;
    if aValue = FeldName then
      Result := TTabellenfeld(fList.Items[M]);
  end;

end;

function TTabellenfeldList.GetTabellenfeld(Index: Integer): TTabellenfeld;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TTabellenfeld(fList[Index]);
end;

procedure TTabellenfeldList.Sort;
begin
  fList.Sort(@SortTabellenfeldList);
end;

function TTabellenfeldList.Add: TTabellenfeld;
begin
  Result := TTabellenfeld.Create;
  fList.Add(Result);
end;


end.
