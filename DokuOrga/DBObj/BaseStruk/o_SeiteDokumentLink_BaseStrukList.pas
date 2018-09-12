unit o_SeiteDokumentLink_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_SeiteDokumentLink;


type
  TSeiteDokumentLinkBaseStrukList = class(TDBObjList)
  private
    function GetDokumentLink(Index: Integer): TSeiteDokumentLink;
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
    property Item[Index: Integer]: TSeiteDokumentLink read GetDokumentLink;
    function getNotifyIndex: Integer; override;
  end;

implementation

{ TSeiteDokumentLinkBaseStrukList }


constructor TSeiteDokumentLinkBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSeiteDokumentLinkBaseStrukList.Destroy;
begin

  inherited;
end;

function TSeiteDokumentLinkBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  SeiteDokumentLink: TSeiteDokumentLink;
begin
  SeiteDokumentLink := TSeiteDokumentLink.Create(nil);
  SeiteDokumentLink.Trans := FTrans;
  SeiteDokumentLink.LoadByQuery(aQuery);
  Result := TDBObj(SeiteDokumentLink);
end;

function TSeiteDokumentLinkBaseStrukList.GetDokumentLink(Index: Integer): TSeiteDokumentLink;
begin
  Result := TSeiteDokumentLink(getItem(Index));
end;

function TSeiteDokumentLinkBaseStrukList.getGeneratorName: string;
begin
  Result := 'SK_ID';
end;

function TSeiteDokumentLinkBaseStrukList.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TSeiteDokumentLinkBaseStrukList.getTableName: string;
begin
  Result := 'SEITEDOKUMENTLINK';
end;

function TSeiteDokumentLinkBaseStrukList.getTablePrefix: string;
begin
  Result := 'SK';
end;

procedure TSeiteDokumentLinkBaseStrukList.Init;
begin
  inherited;

end;

end.
