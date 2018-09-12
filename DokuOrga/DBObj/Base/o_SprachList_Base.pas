unit o_SprachList_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt;

type
  TSprachList_Base = class(TDBObjExt)
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

{ TSprachList_Base }

constructor TSprachList_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSprachList_Base.Destroy;
begin

  inherited;
end;

function TSprachList_Base.getGeneratorName: string;
begin
  Result := 'SL_ID';
end;

function TSprachList_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TSprachList_Base.getTableName: string;
begin
  Result := 'Sprachlist';
end;

function TSprachList_Base.getTablePrefix: string;
begin
  Result := 'SL';
end;

procedure TSprachList_Base.Init;
begin
  inherited;

end;

end.
