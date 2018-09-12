unit o_SeiteLink_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_SeiteLink;


type
  TSeiteLinkBaseStrukList = class(TDBObjList)
  private
    function GetSeiteLink(Index: Integer): TSeiteLink;
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
    property Item[Index: Integer]: TSeiteLink read GetSeiteLink;
    function getNotifyIndex: Integer; override;
  end;

implementation

{ TSeiteLinkBaseStrukList }


constructor TSeiteLinkBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSeiteLinkBaseStrukList.Destroy;
begin

  inherited;
end;

function TSeiteLinkBaseStrukList.getGeneratorName: string;
begin
  Result := 'KS_ID';
end;

function TSeiteLinkBaseStrukList.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TSeiteLinkBaseStrukList.GetSeiteLink(Index: Integer): TSeiteLink;
begin
  Result := TSeiteLink(getItem(Index));
end;

function TSeiteLinkBaseStrukList.getTableName: string;
begin
  Result := 'SEITELINK';
end;

function TSeiteLinkBaseStrukList.getTablePrefix: string;
begin
  Result := 'KS';
end;

procedure TSeiteLinkBaseStrukList.Init;
begin
  inherited;

end;

function TSeiteLinkBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  SeiteLink: TSeiteLink;
begin
  SeiteLink := TSeiteLink.Create(nil);
  SeiteLink.Trans := FTrans;
  SeiteLink.LoadByQuery(aQuery);
  Result := TDBObj(SeiteLink);
end;


end.
