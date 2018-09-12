unit o_Sprache_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache;


type
  TSpracheBaseStrukList = class(TDBObjList)
  private
    function GetSprache(Index: Integer): TSprache;
  protected
    FCount: Integer;
    FList: TObjectList;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    function getGeneratorName: string; override;
    function Add(aQuery: TIBQuery): TDBObj; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    property Item[Index: Integer]: TSprache read GetSprache;
  end;


implementation

{ TSpracheBaseStrukList }



constructor TSpracheBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSpracheBaseStrukList.Destroy;
begin

  inherited;
end;



function TSpracheBaseStrukList.getGeneratorName: string;
begin

end;

function TSpracheBaseStrukList.GetSprache(Index: Integer): TSprache;
begin
  Result := TSprache(getItem(Index));
end;

function TSpracheBaseStrukList.getTableName: string;
begin
  Result := 'Sprache';
end;

function TSpracheBaseStrukList.getTablePrefix: string;
begin
  Result := 'SP';
end;

procedure TSpracheBaseStrukList.Init;
begin
  inherited;

end;

function TSpracheBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  Sprache: TSprache;
begin
  Sprache := TSprache.Create(nil);
  Sprache.LoadByQuery(aQuery);
  Result := TDBObj(Sprache);
end;



end.
