unit Objekt.OrdnerList;

interface

uses
  SysUtils, Classes, contnrs, Allgemein.BaseList, Objekt.Ordner, Vcl.ComCtrls,
  Allgemein.System, Objekt.Global;

type
  TOrdnerList = class(TBaseList)
  private
    function GetOrdner(Index: Integer): TOrdner;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Add: TOrdner;
    property Item[Index: Integer]: TOrdner read GetOrdner;
    procedure AlleOrdnerEinlesen(aPfad: string);
    procedure SortiereNachTitel;
  end;

implementation

{ TOrdnerList }


function TitelSortieren(Item1, Item2: Pointer): Integer;
begin
  Result := AnsiCompareText(TOrdner(Item1).Titel, TOrdner(Item2).Titel);
end;



constructor TOrdnerList.Create;
begin
  inherited;

end;

destructor TOrdnerList.Destroy;
begin

  inherited;
end;

function TOrdnerList.GetOrdner(Index: Integer): TOrdner;
begin
  Result := nil;
  if Index > FList.Count -1 then
    exit;
  Result := TOrdner(FList.Items[Index]);
end;

procedure TOrdnerList.SortiereNachTitel;
begin
  fList.Sort(@TitelSortieren);
end;

function TOrdnerList.Add: TOrdner;
var
  Ordner: TOrdner;
begin
  Ordner := TOrdner.Create;
  FList.Add(Ordner);
  Result := Ordner;
end;


procedure TOrdnerList.AlleOrdnerEinlesen(aPfad: string);
var
  List: TStringList;
  i1: Integer;
  Ordner: TOrdner;
begin
  List := TStringList.Create;
  try
    Global.System.GetDirs(aPfad, List);
    for i1 := 0 to List.Count -1 do
    begin
      Ordner := Add;
      Ordner.Pfad  := List.ValueFromIndex[i1];
      Ordner.Titel := List.Names[i1];
    end;
    fList.Sort(@TitelSortieren);
  finally
    FreeAndNil(List);
  end;

end;





end.
