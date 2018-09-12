unit o_Seiteverbinden_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt;

type
  TSeiteverbinden_Base = class(TDBObjExt)
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

{ TSeiteverbinden_Base }

constructor TSeiteverbinden_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSeiteverbinden_Base.Destroy;
begin

  inherited;
end;

function TSeiteverbinden_Base.getGeneratorName: string;
begin
  Result := 'VS_ID';
end;

function TSeiteverbinden_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TSeiteverbinden_Base.getTableName: string;
begin
  Result := 'Seiteverbindung';
end;

function TSeiteverbinden_Base.getTablePrefix: string;
begin
  Result := 'VS';
end;

procedure TSeiteverbinden_Base.Init;
begin
  inherited;

end;

end.
