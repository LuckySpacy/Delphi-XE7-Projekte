unit o_SeiteDokumentLinkList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_SeiteDokumentLink_BaseStrukList;


type
  TSeiteDokumentLinkList = class(TSeiteDokumentLinkBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ReadAll(aSeiteId: Integer); reintroduce; overload;
    procedure ReadAllLinks(aSeiteId: Integer); overload;
    procedure ReadAllLinks(aSeiteId, aDokumentId: Integer); overload;
    procedure ReadAllSourceLinks(aSourceSeiteId, aLinkSeiteId: Integer);
  end;

implementation

{ TSeiteDokumentLinkList }

constructor TSeiteDokumentLinkList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSeiteDokumentLinkList.Destroy;
begin

  inherited;
end;


procedure TSeiteDokumentLinkList.Init;
begin
  inherited;

end;

procedure TSeiteDokumentLinkList.ReadAll(aSeiteId: Integer);
var
  x: TDBObj;
begin
  FList.Clear;
  FQuery.Close;
  FQuery.Transaction := Trans;
  FQuery.Sql.Text := ' select * from ' + getTableName +
                     ' where SK_DELETE != ' + QuotedStr('T') +
                     ' and   SK_SE_ID = ' + IntToStr(aSeiteId);
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

procedure TSeiteDokumentLinkList.ReadAllLinks(aSeiteId, aDokumentId: Integer);
var
  x: TDBObj;
begin
  FList.Clear;
  FQuery.Close;
  FQuery.Transaction := Trans;
  FQuery.Sql.Text := ' select * from ' + getTableName +
                     ' where SK_DELETE != ' + QuotedStr('T') +
                     ' and   SK_DO_ID = ' + IntToStr(aDokumentId) +
                     ' and   SK_SE_ID_LINK = ' + IntToStr(aSeiteId);
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

procedure TSeiteDokumentLinkList.ReadAllLinks(aSeiteId: Integer);
var
  x: TDBObj;
begin
  FList.Clear;
  FQuery.Close;
  FQuery.Transaction := Trans;
  FQuery.Sql.Text := ' select * from ' + getTableName +
                     ' where SK_DELETE != ' + QuotedStr('T') +
                     ' and   SK_SE_ID_LINK = ' + IntToStr(aSeiteId);
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

procedure TSeiteDokumentLinkList.ReadAllSourceLinks(aSourceSeiteId, aLinkSeiteId: Integer);
var
  x: TDBObj;
begin
  FList.Clear;
  FQuery.Close;
  FQuery.Transaction := Trans;
  FQuery.Sql.Text := ' select * from ' + getTableName +
                     ' where SK_DELETE != ' + QuotedStr('T') +
                     ' and   SK_SE_ID = ' + IntToStr(aSourceSeiteId) +
                     ' and   SK_SE_ID_LINK = ' + IntToStr(aLinkSeiteId);
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
