unit WebQuery.BaseList;

interface

uses
  SysUtils, Classes, Contnrs;

type
  TWebQueryBaseList = class(TComponent)
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

{ TWebQueryBaseList }


constructor TWebQueryBaseList.Create(AOwner: TComponent);
begin
  inherited;
  fList := TObjectList.Create;
end;

destructor TWebQueryBaseList.Destroy;
begin
  FreeAndNil(fList);
  inherited;
end;

function TWebQueryBaseList.GetCount: Integer;
begin
  Result := fList.Count;
end;

procedure TWebQueryBaseList.Clear;
begin
  fList.Clear;
end;


end.
