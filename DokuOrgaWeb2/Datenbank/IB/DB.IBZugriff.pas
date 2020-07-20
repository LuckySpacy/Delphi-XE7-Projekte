unit DB.IBZugriff;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, Objekt.DBFeldList, Data.db,
  vcl.Dialogs, IBX.IBQuery, TBQuery, TBTrans;

type
  TQueryEvent = procedure(aQuery: TTBQuery) of object;
  TIBZugriff = class
  private
    fTrans: TTBTrans;
    fTBQuery: TTBQuery;
    fWasOpen: Boolean;
    fOnNewTransaction: TNotifyEvent;
    fOnAfterExecSql: TNotifyEvent;
    fOnLoadByQuery: TQueryEvent;
    procedure setTrans(const Value: TTBTrans);
    procedure OpenTrans;
    procedure CommitTrans;
    procedure RollbackTrans;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Trans: TTBTrans read fTrans write setTrans;
    property OnNewTransaction: TNotifyEvent read fOnNewTransaction write fOnNewTransaction;
    function GenerateId(aSql: String): Integer;
    function Delete(aSql: String): Boolean;
    property OnAfterExecSql: TNotifyEvent read fOnAfterExecSql write fOnAfterExecSql;
    property OnLoadByQuery: TQueryEvent read fOnLoadByQuery write fOnLoadByQuery;
    function SaveToDB(aSql: String): Boolean;
    procedure Read(aSql: String);
  end;

implementation

{ TIBZugriff }

uses
  System.UITypes;



constructor TIBZugriff.Create;
begin
  fTrans := nil;
  fTBQuery := TTBQuery.Create(nil);
  fTBQuery.UseInterbase := true;
  fWasOpen := false;
end;


destructor TIBZugriff.Destroy;
begin
  FreeAndNil(fTBQuery);
  inherited;
end;

function TIBZugriff.GenerateId(aSql: String): Integer;
begin
  Result := 0;
  if not Assigned(fTrans) then
    exit;
  fTBQuery.Close;
  fTBQuery.SQL.Text := aSql;
  OpenTrans;
  try
    fTBQuery.Open;
    Result := fTBQuery.IBQuery.Fields[0].AsInteger;
    fTBQuery.Close;
  finally
    CommitTrans;
  end;
end;


procedure TIBZugriff.OpenTrans;
begin
  if fTrans = nil then
    exit;
  fTrans.OpenTrans;
end;


procedure TIBZugriff.RollbackTrans;
begin
  if fTrans = nil then
    exit;
  fTrans.RollbackTrans;
end;


procedure TIBZugriff.CommitTrans;
begin
  if fTrans = nil then
    exit;
  fTrans.CommitTrans;
end;


procedure TIBZugriff.setTrans(const Value: TTBTrans);
begin
  fTrans := Value;
  fTBQuery.TBTrans := fTrans;
  if Assigned(fOnNewTransaction) then
    fOnNewTransaction(nil);
end;


function TIBZugriff.Delete(aSql: String): Boolean;
begin
  Result := false;
  if not Assigned(fTrans) then
    exit;
  fTBQuery.Close;
  fTBQuery.TBTrans := fTrans;
  fTBQuery.IBQuery.SQL.Text := aSql;
  OpenTrans;
  try
    fTBQuery.IBQuery.ExecSQL;
    //fGeloescht := true;
    if Assigned(fOnAfterExecSql) then
      fOnAfterExecSql(nil);
  except
    on E: Exception do
    begin
      RollbackTrans;
      MessageDlg(E.Message, mtError, [mbOk], 0);
      raise;
      exit;
    end;
  end;
  Result := true;
  CommitTrans;
end;


function TIBZugriff.SaveToDB(aSql: String): Boolean;
begin
  Result := true;
  fTBQuery.IBQuery.Close;
  fTBQuery.TBTrans := fTrans;
  fTBQuery.IBQuery.SQL.Text := aSql;
  OpenTrans;
  try
    fTBQuery.IBQuery.ExecSQL;
    if Assigned(fOnAfterExecSql) then
      fOnAfterExecSql(nil);
  except
    on E: Exception do
    begin
      Result := false;
      RollbackTrans;
      MessageDlg(E.Message, mtError, [mbOk], 0);
      raise;
      exit;
    end;
  end;
  CommitTrans;
end;

procedure TIBZugriff.Read(aSql: String);
begin
  if not Assigned(fTrans) then
    exit;
  fTBQuery.IBQuery.Close;
  fTBQuery.TBTrans := fTrans;
  fTBQuery.IBQuery.SQL.Text := aSql;
  OpenTrans;
  try
    fTBQuery.IBQuery.Open;
    if Assigned(fOnLoadByQuery) then
      fOnLoadByQuery(fTBQuery);
  finally
    CommitTrans;
  end;
end;



end.
