unit Objekt.TextEinlesenWortList;

interface

uses
  SysUtils, Types, Windows, Classes, Objekt.BaseList, Objekt.TextEinlesenWort;


type
  TTextEinlesenWortList = class(TBaseList)
  private
    function getItem(Index: Integer): TTextEinlesenWort;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Item[Index:Integer]: TTextEinlesenWort read getItem;
    function Add(aValue: string; aEnId, aEiId: Integer): TTextEinlesenWort;
    function EintragExistiert(aValue: string; aEnId, aEiId: Integer): TTextEinlesenWort;
  end;

implementation

{ TTextEinlesenWortList }

function TTextEinlesenWortList.Add(aValue: string; aEnId, aEiId: Integer): TTextEinlesenWort;
begin
  Result := EintragExistiert(aValue, aEnId, aEiId);
  if Result = nil then
  begin
    Result := TTextEinlesenWort.Create;
    Result.Wort := aValue;
    Result.EnId := aEnId;
    Result.EiId := aEiId;
    fList.Add(Result);
  end;
end;

constructor TTextEinlesenWortList.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TTextEinlesenWortList.Destroy;
begin

  inherited;
end;

function TTextEinlesenWortList.EintragExistiert(aValue: string; aEnId,
  aEiId: Integer): TTextEinlesenWort;
var
  i1: Integer;
  x: TTextEinlesenWort;
begin
  Result := nil;
  for i1 := 0 to fList.Count -1 do
  begin
    x := TTextEinlesenWort(fList.Items[i1]);
    if  (x.Wort = aValue)
    and (x.EnId = aEnId)
    and (x.EiId = aEiId) then
    begin
      Result := x;
      exit;
    end;
  end;
end;

function TTextEinlesenWortList.getItem(Index: Integer): TTextEinlesenWort;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TTextEinlesenWort(fList.Items[Index]);
end;

end.
