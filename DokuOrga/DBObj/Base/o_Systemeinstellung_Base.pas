unit o_Systemeinstellung_Base;


interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt;


type
  TSystemeinstellung_Base = class(TDBObjExt)
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

{ TSeite_Base }

constructor TSystemeinstellung_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSystemeinstellung_Base.Destroy;
begin

  inherited;
end;

function TSystemeinstellung_Base.getGeneratorName: string;
begin
  Result := 'SY_ID';
end;

function TSystemeinstellung_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TSystemeinstellung_Base.getTableName: string;
begin
  Result := 'Systemeinstellung';
end;

function TSystemeinstellung_Base.getTablePrefix: string;
begin
  Result := 'SY';
end;

procedure TSystemeinstellung_Base.Init;
begin
  inherited;

end;

end.
