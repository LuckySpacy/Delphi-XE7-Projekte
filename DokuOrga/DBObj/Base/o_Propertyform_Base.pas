unit o_Propertyform_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt;

type
  TPropertyform_Base = class(TDBObjExt)
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

{ TPropertyform_Base }

constructor TPropertyform_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TPropertyform_Base.Destroy;
begin

  inherited;
end;

function TPropertyform_Base.getGeneratorName: string;
begin
  Result := 'PF_ID';
end;

function TPropertyform_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TPropertyform_Base.getTableName: string;
begin
  Result := 'Propertyform';
end;

function TPropertyform_Base.getTablePrefix: string;
begin
  Result := 'PF';
end;

procedure TPropertyform_Base.Init;
begin
  inherited;

end;

end.
