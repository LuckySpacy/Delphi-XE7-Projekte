unit Feld.Feldlist;

interface

uses
  SysUtils, Classes, Contnrs, Feld.Feld, Data.DB;

type
  TFeldlist = class(TComponent)
  private
    function GetCount: Integer;
    function getFeld(aIndex: Integer): TFeld;
  protected
    fList: TObjectList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    procedure Clear;
    function Add(aName: string; aDataType: TFieldType): TFeld;
    function FieldByName(aName: string): TFeld;
    property Feld[aIndex: Integer]: TFeld read getFeld;
  end;


implementation

{ TBaseList }


constructor TFeldlist.Create(AOwner: TComponent);
begin
  inherited;
  fList := TObjectList.Create;
end;

destructor TFeldlist.Destroy;
begin
  FreeAndNil(fList);
  inherited;
end;

function TFeldlist.FieldByName(aName: string): TFeld;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to fList.Count -1 do
  begin
    if SameText(Feld[i1].Feldname, aName) then
    begin
      Result := Feld[i1];
      exit;
    end;
  end;
end;

function TFeldlist.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TFeldlist.Add(aName: string; aDataType: TFieldType): TFeld;
begin
  Result := TFeld.Create(nil);
  Result.Feldname := aName;
  Result.DataType := aDataType;
  fList.Add(Result)
end;

function TFeldlist.getFeld(aIndex: Integer): TFeld;
begin
  Result := nil;
  if aIndex > fList.Count then
    exit;
  Result := TFeld(fList.Items[aIndex]);
end;

procedure TFeldlist.Clear;
begin
  fList.Clear;
end;

end.
