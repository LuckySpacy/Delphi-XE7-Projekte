unit o_Bilder_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt;

type
  TBilder_Base = class(TDBObjExt)
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

{ TBilder_Base }

constructor TBilder_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TBilder_Base.Destroy;
begin

  inherited;
end;

function TBilder_Base.getGeneratorName: string;
begin
  Result := 'BI_ID';
end;

function TBilder_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TBilder_Base.getTableName: string;
begin
  Result := 'Bilder';
end;

function TBilder_Base.getTablePrefix: string;
begin
  Result := 'BI';
end;

procedure TBilder_Base.Init;
begin
  inherited;

end;

end.
