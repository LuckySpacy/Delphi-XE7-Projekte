unit o_ButtonProp_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt;

type
  TButtonProp_Base = class(TDBObjExt)
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

{ TButtonProp_Base }

constructor TButtonProp_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TButtonProp_Base.Destroy;
begin

  inherited;
end;

function TButtonProp_Base.getGeneratorName: string;
begin
  Result := 'BP_ID';
end;

function TButtonProp_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TButtonProp_Base.getTableName: string;
begin
  Result := 'Buttonprop';
end;

function TButtonProp_Base.getTablePrefix: string;
begin
  Result := 'BP';
end;

procedure TButtonProp_Base.Init;
begin
  inherited;

end;

end.
