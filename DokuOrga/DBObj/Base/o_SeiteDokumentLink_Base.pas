unit o_SeiteDokumentLink_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt, ObBusinessClasses;

type
  TSeiteDokumentLink_Base = class(TDBObjExt)
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

{ TSeiteDokumentLink_Base }

constructor TSeiteDokumentLink_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSeiteDokumentLink_Base.Destroy;
begin

  inherited;
end;

function TSeiteDokumentLink_Base.getGeneratorName: string;
begin
  Result := 'SK_ID';
end;

function TSeiteDokumentLink_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TSeiteDokumentLink_Base.getTableName: string;
begin
  Result := 'SEITEDOKUMENTLINK';
end;

function TSeiteDokumentLink_Base.getTablePrefix: string;
begin
  Result := 'SK';
end;

procedure TSeiteDokumentLink_Base.Init;
begin
  inherited;

end;

end.
