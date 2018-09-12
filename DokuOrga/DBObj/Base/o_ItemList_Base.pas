unit o_ItemList_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt;

type
  TItemList_Base = class(TDBObjExt)
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

{ TItemList_Base }

constructor TItemList_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TItemList_Base.Destroy;
begin

  inherited;
end;

function TItemList_Base.getGeneratorName: string;
begin
  Result := 'IT_ID';
end;

function TItemList_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TItemList_Base.getTableName: string;
begin
  Result := 'Itemlist';
end;

function TItemList_Base.getTablePrefix: string;
begin
  Result := 'IT';
end;

procedure TItemList_Base.Init;
begin
  inherited;

end;

end.
