unit o_SeiteDokument_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_SeiteDokument;


type
  TSeiteDokumentBaseStrukList = class(TDBObjList)
  private
    function GetDokument(Index: Integer): TSeiteDokument;
  protected
    FCount: Integer;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    function getGeneratorName: string; override;
    function Add(aQuery: TIBQuery): TDBObj; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    property Item[Index: Integer]: TSeiteDokument read GetDokument;
    function getNotifyIndex: Integer; override;
  end;

implementation

{ TSeiteDokumentBaseStrukList }

constructor TSeiteDokumentBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSeiteDokumentBaseStrukList.Destroy;
begin

  inherited;
end;


function TSeiteDokumentBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  SeiteDokument: TSeiteDokument;
begin
  SeiteDokument := TSeiteDokument.Create(nil);
  SeiteDokument.Trans := FTrans;
  SeiteDokument.LoadByQuery(aQuery);
  Result := TDBObj(SeiteDokument);
end;


function TSeiteDokumentBaseStrukList.GetDokument(
  Index: Integer): TSeiteDokument;
begin
  Result := TSeiteDokument(getItem(Index));
end;

function TSeiteDokumentBaseStrukList.getGeneratorName: string;
begin
  Result := 'SD_ID';
end;

function TSeiteDokumentBaseStrukList.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TSeiteDokumentBaseStrukList.getTableName: string;
begin
  Result := 'SEITEDOKUMENT';
end;

function TSeiteDokumentBaseStrukList.getTablePrefix: string;
begin
  Result := 'SD';
end;

procedure TSeiteDokumentBaseStrukList.Init;
begin
  inherited;

end;

end.
