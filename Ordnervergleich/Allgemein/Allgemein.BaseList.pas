unit Allgemein.BaseList;

interface

uses
  SysUtils, Classes, contnrs;

type
  TBaseList = class(TObject)
  private
  protected
    FList: TObjectList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Count: Integer;
    procedure Clear;
    procedure DeleteItem(aIndex: Integer);
  end;


implementation


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

procedure TBaseList.Clear;
begin
  FList.Clear;
end;

function TBaseList.Count: Integer;
begin
  Result := FList.Count;
end;


end.
