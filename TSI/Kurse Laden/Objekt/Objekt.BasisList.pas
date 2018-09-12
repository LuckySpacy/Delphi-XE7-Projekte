unit Objekt.BasisList;

interface

uses
  SysUtils, Classes, Contnrs;

type
  TBaseList = class(TComponent)
  private
    function GetCount: Integer;
  protected
    fList: TObjectList;
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
  fList := TObjectList.Create;
end;

destructor TBaseList.Destroy;
begin
  FreeAndNil(fList);
  inherited;
end;

function TBaseList.GetCount: Integer;
begin
  Result := fList.Count;
end;

procedure TBaseList.Clear;
begin
  fList.Clear;
end;


end.
