unit o_Sprache_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt;

type
  TSprache_Base = class(TDBObjExt)
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

{ TSprache_Base }

constructor TSprache_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSprache_Base.Destroy;
begin

  inherited;
end;

function TSprache_Base.getGeneratorName: string;
begin
  Result := 'SP_ID';
end;

function TSprache_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TSprache_Base.getTableName: string;
begin
  Result := 'Sprache';
end;

function TSprache_Base.getTablePrefix: string;
begin
  Result := 'SP';
end;

procedure TSprache_Base.Init;
begin
  inherited;

end;

end.
