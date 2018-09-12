unit Objekt.BasisList;

interface

uses
  SysUtils, Classes, Contnrs;

type
  TBaseList = class(TComponent)
  private
    function GetCount: Integer;
  protected
    _List: TObjectList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    procedure Clear;
  end;


implementation

{ TBaseList }


constructor TBaseList.Create(AOwner: TComponent);
begin
  inherited;
  _List := TObjectList.Create;
end;

destructor TBaseList.Destroy;
begin
  FreeAndNil(_List);
  inherited;
end;

function TBaseList.GetCount: Integer;
begin
  Result := _List.Count;
end;

procedure TBaseList.Clear;
begin
  _List.Clear;
end;


end.
