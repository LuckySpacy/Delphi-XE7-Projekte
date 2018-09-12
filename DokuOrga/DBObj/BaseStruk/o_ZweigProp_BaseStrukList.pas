unit o_ZweigProp_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_ZweigProp;


type
  TZweigPropBaseStrukList = class(TDBObjList)
  private
    function GetZweigProp(Index: Integer): TZweigProp;
  protected
    FCount: Integer;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    function getGeneratorName: string; override;
    function Add(aQuery: TIBQuery): TDBObj; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    property Item[Index: Integer]: TZweigProp read GetZweigProp;
  end;


implementation

{ TZweigPropBaseStrukList }

constructor TZweigPropBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TZweigPropBaseStrukList.Destroy;
begin

  inherited;
end;

procedure TZweigPropBaseStrukList.Init;
begin
  inherited;

end;


function TZweigPropBaseStrukList.getGeneratorName: string;
begin
  Result := 'ZP_ID';
end;

function TZweigPropBaseStrukList.getTableName: string;
begin
  Result := 'ZweigProp';
end;

function TZweigPropBaseStrukList.getTablePrefix: string;
begin
  Result := 'ZP';
end;

function TZweigPropBaseStrukList.GetZweigProp(Index: Integer): TZweigProp;
begin
  Result := TZweigProp(getItem(Index));
end;


function TZweigPropBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  ZweigProp: TZweigProp;
begin
  ZweigProp := TZweigProp.Create(nil);
  ZweigProp.LoadByQuery(aQuery);
  Result := TDBObj(ZweigProp);
end;

end.
