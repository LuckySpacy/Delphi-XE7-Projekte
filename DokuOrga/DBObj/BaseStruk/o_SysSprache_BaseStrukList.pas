unit o_SysSprache_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_SysSprache;


type
  TSysSpracheBaseStrukList = class(TDBObjList)
  private
    function GetSprache(Index: Integer): TSysSprache;
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
    property Item[Index: Integer]: TSysSprache read GetSprache;
  end;


implementation

{ TSysSpracheBaseStrukList }


constructor TSysSpracheBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSysSpracheBaseStrukList.Destroy;
begin

  inherited;
end;

procedure TSysSpracheBaseStrukList.Init;
begin
  inherited;

end;


function TSysSpracheBaseStrukList.getGeneratorName: string;
begin

end;

function TSysSpracheBaseStrukList.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TSysSpracheBaseStrukList.GetSprache(Index: Integer): TSysSprache;
begin
  Result := TSysSprache(getItem(Index));
end;

function TSysSpracheBaseStrukList.getTableName: string;
begin
  Result := 'SysSprache';
end;

function TSysSpracheBaseStrukList.getTablePrefix: string;
begin
  Result := 'SYSSP';
end;


function TSysSpracheBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  Sprache: TSysSprache;
begin
  Sprache := TSysSprache.Create(nil);
  Sprache.LoadByQuery(aQuery);
  Result := TDBObj(Sprache);
end;

end.
