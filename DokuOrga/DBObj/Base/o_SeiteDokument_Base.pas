unit o_SeiteDokument_Base;

interface

uses
  SysUtils, Classes, o_DBObj, o_DBObjExt, ObBusinessClasses;

type
  TSeiteDokument_Base = class(TDBObjExt)
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

{ TSeiteDokument_Base }

constructor TSeiteDokument_Base.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSeiteDokument_Base.Destroy;
begin

  inherited;
end;

function TSeiteDokument_Base.getGeneratorName: string;
begin
  Result := 'SD_ID';
end;

function TSeiteDokument_Base.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TSeiteDokument_Base.getTableName: string;
begin
  Result := 'SEITEDOKUMENT';
end;

function TSeiteDokument_Base.getTablePrefix: string;
begin
  Result := 'SD';
end;

procedure TSeiteDokument_Base.Init;
begin
  inherited;

end;

end.
