unit o_ButtonProp_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_ButtonProp;


type
  TButtonPropBaseStrukList = class(TDBObjList)
  private
    function GetButtonProp(Index: Integer): TButtonProp;
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
    property Item[Index: Integer]: TButtonProp read GetButtonProp;
  end;


implementation

{ TButtonPropBaseStrukList }


constructor TButtonPropBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TButtonPropBaseStrukList.Destroy;
begin

  inherited;
end;

function TButtonPropBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  ButtonProp: TButtonProp;
begin
  ButtonProp := TButtonProp.Create(nil);
  ButtonProp.LoadByQuery(aQuery);
  Result := TDBObj(ButtonProp);
end;


function TButtonPropBaseStrukList.GetButtonProp(Index: Integer): TButtonProp;
begin
  Result := TButtonProp(getItem(Index));
end;

function TButtonPropBaseStrukList.getGeneratorName: string;
begin
  Result := 'BP_ID';
end;

function TButtonPropBaseStrukList.getTableName: string;
begin
  Result := 'ButtonProp';
end;

function TButtonPropBaseStrukList.getTablePrefix: string;
begin
  Result := 'BP';
end;

procedure TButtonPropBaseStrukList.Init;
begin
  inherited;

end;

end.
