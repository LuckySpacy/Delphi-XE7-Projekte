unit o_BaumStruk_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt;

type
  TBaumStruk_Base = class(TDBObjExt)
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

{ TBaumStruk_Base }

constructor TBaumStruk_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TBaumStruk_Base.Destroy;
begin

  inherited;
end;

procedure TBaumStruk_Base.Init;
begin
  inherited;

end;


function TBaumStruk_Base.getGeneratorName: string;
begin
  Result := 'BS_ID';
end;

function TBaumStruk_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TBaumStruk_Base.getTableName: string;
begin
  Result := 'BaumStruk';
end;

function TBaumStruk_Base.getTablePrefix: string;
begin
  Result := 'BS';
end;


end.
