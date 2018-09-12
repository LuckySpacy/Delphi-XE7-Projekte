unit o_Seite_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt, ObBusinessClasses;

type
  TSeite_Base = class(TDBObjExt)
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

{ TSeite_Base }


constructor TSeite_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSeite_Base.Destroy;
begin

  inherited;
end;

function TSeite_Base.getGeneratorName: string;
begin
  Result := 'SE_ID';
end;

function TSeite_Base.getNotifyIndex: Integer;
begin
  Result := NTA_TABELLE_SEITE;
end;

function TSeite_Base.getTableName: string;
begin
  Result := 'Seite';
end;

function TSeite_Base.getTablePrefix: string;
begin
  Result := 'SE';
end;

procedure TSeite_Base.Init;
begin
  inherited;

end;

end.
