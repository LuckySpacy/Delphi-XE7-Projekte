unit o_Propertyform_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Propertyform;


type
  TPropertyformBaseStrukList = class(TDBObjList)
  private
    function GetPropertyform(Index: Integer): TPropertyform;
  protected
    FCount: Integer;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    function getGeneratorName: string; override;
    function getNotifyIndex: Integer; override;
    function Add(aQuery: TIBQuery): TDBObj; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    property Item[Index: Integer]: TPropertyform read GetPropertyform;
  end;

implementation

{ TBilderBaseStrukList }


constructor TPropertyformBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TPropertyformBaseStrukList.Destroy;
begin

  inherited;
end;

function TPropertyformBaseStrukList.getGeneratorName: string;
begin
  Result := 'PF_ID';
end;

function TPropertyformBaseStrukList.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TPropertyformBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  Propertyform: TPropertyform;
begin
  Propertyform := TPropertyform.Create(nil);
  Propertyform.LoadByQuery(aQuery);
  Result := TDBObj(Propertyform);
end;


function TPropertyformBaseStrukList.GetPropertyform(Index: Integer): TPropertyform;
begin
  Result := TPropertyform(getItem(Index));
end;

function TPropertyformBaseStrukList.getTableName: string;
begin
  Result := 'Propertyform';
end;

function TPropertyformBaseStrukList.getTablePrefix: string;
begin
  Result := 'PF';
end;

procedure TPropertyformBaseStrukList.Init;
begin
  inherited;

end;

end.
