unit o_DBGuid_Base;

interface

uses
  SysUtils, Classes, o_DBObj;

type
  TDBGuid_Base = class(TDBObj)
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

{ TDBGuid_Base }

constructor TDBGuid_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TDBGuid_Base.Destroy;
begin

  inherited;
end;

procedure TDBGuid_Base.Init;
begin
  inherited;

end;


function TDBGuid_Base.getGeneratorName: string;
begin
  Result := '';
end;

function TDBGuid_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TDBGuid_Base.getTableName: string;
begin
  Result := 'GuId';
end;

function TDBGuid_Base.getTablePrefix: string;
begin
  Result := 'GU';
end;


end.
