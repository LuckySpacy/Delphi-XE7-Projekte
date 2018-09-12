unit o_SeiteLinkList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_SeiteLink_BaseStrukList;


type
  TSeiteLinkList = class(TSeiteLinkBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ReadAll(aSeiteLinkId: Integer); reintroduce; overload;
    procedure ReadAllFromSeite(aSeiteId: Integer);
  end;

implementation

{ TSeiteLinkList }

constructor TSeiteLinkList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSeiteLinkList.Destroy;
begin

  inherited;
end;

procedure TSeiteLinkList.Init;
begin
  inherited;

end;

procedure TSeiteLinkList.ReadAll(aSeiteLinkId: Integer);
var
  x: TDBObj;
begin
  FList.Clear;
  FQuery.Close;
  FQuery.Transaction := Trans;
  FQuery.Sql.Text := ' select * from ' + getTableName +
                     ' where KS_DELETE != ' + QuotedStr('T') +
                     ' and   KS_SE_ID_LINK = ' + IntToStr(aSeiteLinkId);
  OpenTrans;
  FQuery.Open;
  while not FQuery.Eof do
  begin
    x := Add(FQuery);
    FList.Add(x);
    FQuery.Next;
  end;
  RollbackTrans;
end;


procedure TSeiteLinkList.ReadAllFromSeite(aSeiteId: Integer);
var
  x: TDBObj;
begin
  FList.Clear;
  FQuery.Close;
  FQuery.Transaction := Trans;
  FQuery.Sql.Text := ' select * from ' + getTableName +
                     ' where KS_DELETE != ' + QuotedStr('T') +
                     ' and   KS_SE_ID = ' + IntToStr(aSeiteId);
  OpenTrans;
  FQuery.Open;
  while not FQuery.Eof do
  begin
    x := Add(FQuery);
    FList.Add(x);
    FQuery.Next;
  end;
  RollbackTrans;
end;


end.
