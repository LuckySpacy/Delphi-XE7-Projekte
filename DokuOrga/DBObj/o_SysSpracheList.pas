unit o_SysSpracheList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_SysSprache,
  o_SysSprache_BaseStrukList;


type
  TSysSpracheList = class(TSysSpracheBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;


implementation

{ TSysSpracheList }

constructor TSysSpracheList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSysSpracheList.Destroy;
begin

  inherited;
end;

procedure TSysSpracheList.Init;
begin
  inherited;

end;

end.
