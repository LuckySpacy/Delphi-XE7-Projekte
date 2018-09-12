unit o_DBFieldList;

interface

uses
  SysUtils, Classes, o_DBField, Contnrs;

type
  TDBFeldList = class(TComponent)
  private
    FList: TList;
    function getCount: Integer;
    function getItem(aIndex: Integer): TDBFeld;
    function getChanged: Boolean;
    function getDeleteItem: TDBFeld;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init;
    property Item[Index: Integer]: TDBFeld read getItem;
    property Count: Integer read getCount;
    function Add(aName, aFeldName: string; const aisBoolean: Boolean = false): TDBFeld;
    procedure InitValues;
    function Names(aValue: string): TDBFeld;
    function DBName(aValue: string): TDBFeld;
    property Changed: Boolean read getChanged;
    property DeleteItem: TDBFeld read getDeleteItem;
  end;


implementation

{ TDBFeldList }


constructor TDBFeldList.Create(AOwner: TComponent);
begin
  inherited;
  FList := TList.Create;
end;


destructor TDBFeldList.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

procedure TDBFeldList.Init;
begin
  FList.Clear;
end;


procedure TDBFeldList.InitValues;
var
  i1: Integer;
begin
  for i1 := 0 to FList.Count - 1 do
    getItem(i1).InitValue;
end;

function TDBFeldList.Names(aValue: string): TDBFeld;
var
  i1: Integer;
  s : string;
begin
  Result := nil;
  for i1 := 0 to FList.Count - 1 do
  begin
    s := getItem(i1).name;
    if SameText(aValue, s) then
    begin
      Result := getItem(i1);
      exit;
    end;
  end;
end;

function TDBFeldList.DBName(aValue: string): TDBFeld;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FList.Count - 1 do
  begin
    if SameText(aValue, getItem(i1).Feldname) then
    begin
      Result := getItem(i1);
      exit;
    end;
  end;
end;


function TDBFeldList.getChanged: Boolean;
var
  i1: Integer;
begin
  Result := false;
  for i1 := 0 to FList.Count - 1 do
  begin
    if getItem(i1).Changed then
    begin
      Result := true;
      exit;
    end;
  end;
end;

function TDBFeldList.getCount: Integer;
begin
  Result := FList.Count;
end;

function TDBFeldList.getDeleteItem: TDBFeld;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FList.Count - 1 do
  begin
    if TDBFeld(FList.Items[i1]).DeleteField then
    begin
      Result := TDBFeld(FList.Items[i1]);
      exit;
    end;
  end;
end;

function TDBFeldList.getItem(aIndex: Integer): TDBFeld;
begin
  Result := nil;
  if aIndex > FList.Count -1 then
    exit;
  Result := TDBFeld(FList.Items[aIndex]);
end;



function TDBFeldList.Add(aName, aFeldName: string; const aisBoolean: Boolean = false): TDBFeld;
begin
  Result := TDBFeld.Create(nil);
  Result.Name      := aName;
  Result.Feldname  := aFeldName;
  Result.isBoolean := aisBoolean;
  FList.Add(Result);
end;



end.
