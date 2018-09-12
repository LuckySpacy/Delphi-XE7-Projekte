unit o_SeiteLink_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt, ObBusinessClasses;

type
  TSeiteLink_Base = class(TDBObjExt)
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
    property NotifyIndex: Integer read getNotifyIndex;
  end;

implementation

{ TSeiteLink_Base }

constructor TSeiteLink_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSeiteLink_Base.Destroy;
begin

  inherited;
end;

function TSeiteLink_Base.getGeneratorName: string;
begin
  Result := 'KS_ID';
end;

function TSeiteLink_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TSeiteLink_Base.getTableName: string;
begin
  Result := 'SEITELINK';
end;

function TSeiteLink_Base.getTablePrefix: string;
begin
  Result := 'KS';
end;

procedure TSeiteLink_Base.Init;
begin
  inherited;

end;

end.
