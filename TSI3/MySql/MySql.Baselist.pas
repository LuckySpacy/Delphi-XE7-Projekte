unit MySql.Baselist;

interface

uses
  SysUtils, Classes, Contnrs, MySql.Base;

type
  TMySqlBaseList = class(TMySqlBase)
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

{ TMySqlBaseList }


constructor TMySqlBaseList.Create(AOwner: TComponent);
begin
  inherited;
  fList := TObjectList.Create;
end;

destructor TMySqlBaseList.Destroy;
begin
  FreeAndNil(fList);
  inherited;
end;

function TMySqlBaseList.GetCount: Integer;
begin
  Result := fList.Count;
end;

procedure TMySqlBaseList.Clear;
begin
  fList.Clear;
end;


end.
