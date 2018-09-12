unit o_ZweigProp_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt;

type
  TZweigProp_Base = class(TDBObjExt)
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

{ TZweigProp_Base }

constructor TZweigProp_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TZweigProp_Base.Destroy;
begin

  inherited;
end;

function TZweigProp_Base.getGeneratorName: string;
begin
  Result := 'ZP_ID';
end;

function TZweigProp_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TZweigProp_Base.getTableName: string;
begin
  Result := 'Zweigprop';
end;

function TZweigProp_Base.getTablePrefix: string;
begin
  Result := 'ZP';
end;

procedure TZweigProp_Base.Init;
begin
  inherited;

end;

end.
