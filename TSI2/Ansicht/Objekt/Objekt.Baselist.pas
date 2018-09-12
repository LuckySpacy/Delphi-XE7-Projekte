unit Objekt.Baselist;

interface

uses
  SysUtils, Classes, Contnrs;

type
  TBaseListObj = class
  private
    function GetCount: Integer;
  protected
    fList: TObjectList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    procedure Delete(aIndex: Integer);
    procedure Clear;
  end;


implementation

{ TBaseListObj }

procedure TBaseListObj.Clear;
begin
  fList.Clear;
end;

constructor TBaseListObj.Create;
begin
  fList := TObjectList.Create;
end;

procedure TBaseListObj.Delete(aIndex: Integer);
begin
  if aIndex > fList.Count then
    exit;
  fList.Delete(aIndex);
end;

destructor TBaseListObj.Destroy;
begin
  FreeAndNil(fList);
  inherited;
end;

function TBaseListObj.GetCount: Integer;
begin
  Result := fList.Count;
end;

end.
