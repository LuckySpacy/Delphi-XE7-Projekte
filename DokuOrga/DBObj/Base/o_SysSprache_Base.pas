unit o_SysSprache_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt;

type
  TSysSprache_Base = class(TDBObjExt)
  private
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    function getNotifyIndex: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    property GeneratorName: string read getGeneratorName;
    property TableName: string read getTableName;
    property TablePrefix: string read getTablePrefix;
  end;


implementation

{ TSysSprache_Base }

constructor TSysSprache_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSysSprache_Base.Destroy;
begin

  inherited;
end;

function TSysSprache_Base.getGeneratorName: string;
begin
  Result := 'SYSSP_Id';
end;

function TSysSprache_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TSysSprache_Base.getTableName: string;
begin
  Result := 'SysSprache';
end;

function TSysSprache_Base.getTablePrefix: string;
begin
  Result := 'SYSSP';
end;

procedure TSysSprache_Base.Init;
begin
  inherited;

end;

end.
