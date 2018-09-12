unit o_Dokument_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt, ObBusinessClasses;

type
  TDokument_Base = class(TDBObjExt)
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

{ TDokument_Base }

constructor TDokument_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TDokument_Base.Destroy;
begin

  inherited;
end;

function TDokument_Base.getGeneratorName: string;
begin
  Result := 'DO_ID';
end;

function TDokument_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TDokument_Base.getTableName: string;
begin
  Result := 'DOKUMENT';
end;

function TDokument_Base.getTablePrefix: string;
begin
  Result := 'DO';
end;

procedure TDokument_Base.Init;
begin
  inherited;

end;

end.
