unit o_SprachList_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_SprachList;


type
  TSprachListBaseStrukList = class(TDBObjList)
  private
    function GetSprachList(Index: Integer): TSprachList;
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
    property Item[Index: Integer]: TSprachList read GetSprachList;
  end;


implementation

{ TSprachListBaseStrukList }


constructor TSprachListBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSprachListBaseStrukList.Destroy;
begin

  inherited;
end;

function TSprachListBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  SprachList: TSprachList;
begin
  SprachList := TSprachList.Create(nil);
  SprachList.LoadByQuery(aQuery);
  Result := TDBObj(SprachList);
end;


function TSprachListBaseStrukList.getGeneratorName: string;
begin
  Result := 'SL_ID';
end;

function TSprachListBaseStrukList.GetSprachList(Index: Integer): TSprachList;
begin
  Result := TSprachList(getItem(Index));
end;

function TSprachListBaseStrukList.getTableName: string;
begin
  Result := 'SprachList';
end;

function TSprachListBaseStrukList.getTablePrefix: string;
begin
  Result := 'SL';
end;

procedure TSprachListBaseStrukList.Init;
begin
  inherited;

end;

end.
