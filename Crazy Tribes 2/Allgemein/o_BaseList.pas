unit o_BaseList;

interface

uses
  SysUtils, Classes, contnrs, o_Base;

type
  TBaseList = class(TObject)
  private
    FList: TObjectList;
    function GetBase(Index: Integer): TBase;
  public
    constructor Create;
    destructor Destroy; override;
    property Item[Index: Integer]: TBase read GetBase;
    function Count: Integer;
    function Add: TBase;
    procedure Clear;
    procedure Sort;
    procedure DeleteItem(aIndex: Integer);
  end;


implementation


function SortBasename(Item1, Item2: pointer): Integer;
begin
  Result := CompareText(TBase(Item1).Basename, TBase(Item2).Basename);
end;


{ TBaseList }

constructor TBaseList.Create;
begin
  inherited;
  FList := TObjectList.Create;
end;


destructor TBaseList.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;


procedure TBaseList.DeleteItem(aIndex: Integer);
begin
  if aIndex > FList.Count -1 then
    exit;
  FList.Delete(aIndex);
end;



function TBaseList.Add: TBase;
begin
  Result := TBase.Create;
  FList.Add(Result);
end;

procedure TBaseList.Clear;
begin
  FList.Clear;
end;

function TBaseList.Count: Integer;
begin
  Result := FList.Count;
end;


function TBaseList.GetBase(Index: Integer): TBase;
begin
  Result := nil;
  if Index > FList.Count -1 then
    exit;
  Result := TBase(FList.Items[Index]);
end;


procedure TBaseList.Sort;
begin
  FList.Sort(@SortBasename);
end;


end.
