unit o_Benutzer_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt, ObBusinessClasses;

type
  TBenutzer_Base = class(TDBObjExt)
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

{ TBenutzer_Base }

constructor TBenutzer_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TBenutzer_Base.Destroy;
begin

  inherited;
end;

function TBenutzer_Base.getGeneratorName: string;
begin
  Result := 'BE_ID';
end;

function TBenutzer_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TBenutzer_Base.getTableName: string;
begin
  Result := 'BENUTZER';
end;

function TBenutzer_Base.getTablePrefix: string;
begin
  Result := 'BE';
end;

procedure TBenutzer_Base.Init;
begin
  inherited;

end;

end.
