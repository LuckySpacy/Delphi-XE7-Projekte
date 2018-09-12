unit o_ItemList_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_ItemList;


type
  TItemListBaseStrukList = class(TDBObjList)
  private
    function GetDBItem(Index: Integer): TDBItemList;
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
    property Item[Index: Integer]: TDBItemList read GetDBItem;
  end;


implementation

{ TItemListBaseStrukList }

constructor TItemListBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TItemListBaseStrukList.Destroy;
begin

  inherited;
end;


function TItemListBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  DBItemList: TDBItemList;
begin
  DBItemList := TDBItemList.Create(nil);
  DBItemList.LoadByQuery(aQuery);
  Result := TDBObj(DBItemList);
end;


function TItemListBaseStrukList.GetDBItem(Index: Integer): TDBItemList;
begin
  Result := TDBItemList(getItem(Index));
end;

function TItemListBaseStrukList.getGeneratorName: string;
begin
  Result := 'IT_ID';
end;

function TItemListBaseStrukList.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TItemListBaseStrukList.getTableName: string;
begin
  Result := 'ItemList';
end;

function TItemListBaseStrukList.getTablePrefix: string;
begin
  Result := 'IT';
end;

procedure TItemListBaseStrukList.Init;
begin
  inherited;

end;

end.
