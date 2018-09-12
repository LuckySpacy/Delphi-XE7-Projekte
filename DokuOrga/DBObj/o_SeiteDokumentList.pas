unit o_SeiteDokumentList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_SeiteDokument_BaseStrukList;


type
  TSeiteDokumentList = class(TSeiteDokumentBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ReadAll(aSeiteId: Integer); reintroduce; overload;
    function ExistsDokument(aDO_Id: Integer): Boolean;
  end;

implementation

{ TSeiteDokumentList }

constructor TSeiteDokumentList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSeiteDokumentList.Destroy;
begin

  inherited;
end;


procedure TSeiteDokumentList.Init;
begin
  inherited;

end;

procedure TSeiteDokumentList.ReadAll(aSeiteId: Integer);
var
  x: TDBObj;
begin
  FList.Clear;
  FQuery.Close;
  FQuery.Transaction := Trans;
  FQuery.Sql.Text := ' select * from ' + getTableName +
                     ' where SD_DELETE != ' + QuotedStr('T') +
                     ' and   SD_SE_ID = ' + IntToStr(aSeiteId);
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


function TSeiteDokumentList.ExistsDokument(aDO_Id: Integer): Boolean;
begin
  FQuery.Close;
  FQuery.Transaction := Trans;
  FQuery.Sql.Text := ' select * from ' + getTableName +
                     ' where SD_DELETE != ' + QuotedStr('T') +
                     ' and   SD_DO_ID = ' + IntToStr(aDO_Id);
  OpenTrans;
  FQuery.Open;
  Result := not FQuery.Eof;
  FQuery.Close;
  RollbackTrans;
end;


end.
