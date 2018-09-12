unit o_BaumButton_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt;

type
  TBaumButton_Base = class(TDBObjExt)
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

{ TBaumButton_Base }

constructor TBaumButton_Base.Create(AOwner: TComponent);
begin
  inherited;
  init;
end;

destructor TBaumButton_Base.Destroy;
begin

  inherited;
end;

function TBaumButton_Base.getGeneratorName: string;
begin
  Result := 'BB_ID';
end;

function TBaumButton_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TBaumButton_Base.getTableName: string;
begin
  Result := 'BaumButton';
end;

function TBaumButton_Base.getTablePrefix: string;
begin
  Result := 'BB';
end;

procedure TBaumButton_Base.Init;
begin
  inherited;

end;

end.
