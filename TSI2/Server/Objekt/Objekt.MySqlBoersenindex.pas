unit Objekt.MySqlBoersenindex;

interface

uses
  SysUtils, Classes, variants, IBX.IBDatabase, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Dialogs,
  IBX.IBQuery, mySQLDbTables;

type
  TStartEvent = procedure(Sender: TObject; aMaxValue: Integer) of object;

type
  TMySqlBoersenindex = class(TComponent)
  private
    fTrans: TIBTransaction;
    fOnStart: TStartEvent;
    fProgressBar: TProgressBar;
    fProgressLabel: TLabel;
    fQry: TIBQuery;
    fQryMySqlS : TMySQLQuery;
    fQryMySqlI : TMySQLQuery;
    fQryMySqlU : TMySQLQuery;
    fDBMySqlTSI: TMySQLDatabase;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Trans: TIBTransaction read fTrans write fTrans;
    function Exec: Boolean;
    property OnStart: TStartEvent read fOnStart write fOnStart;
    property ProgressLabel: TLabel read fProgressLabel write fProgressLabel;
    property ProgressBar: TProgressBar read fProgressBar write fProgressBar;
    property DBMYSqlTSI: TMySQLDatabase read fDBMySqlTSI write fDBMySqlTSI;
  end;

implementation

{ TMySqlBoersenindex }

constructor TMySqlBoersenindex.Create(AOwner: TComponent);
begin
  inherited;
  fTrans := nil;
  fDBMySqlTSI := nil;
  fQry := TIBQuery.Create(nil);
  fQryMySqlS := TMySQLQuery.Create(nil);
  fQryMySqlI := TMySQLQuery.Create(nil);
  fQryMySqlU := TMySQLQuery.Create(nil);

  fQryMySqlS.SQL.Text := 'select bi_id from boersenindex where bi_id = :biid';
  fQryMySqlI.SQL.Text := 'INSERT INTO boersenindex(BI_ID, BI_NAME) VALUES (:biid,:biname)';
  fQryMySqlU.SQL.Text := 'UPDATE boersenindex SET BI_NAME=:biname WHERE bi_id = :biid';
end;

destructor TMySqlBoersenindex.Destroy;
begin
  FreeAndNil(fQry);
  FreeAndNil(fQryMySqlS);
  FreeAndNil(fQryMySqlI);
  FreeAndNil(fQryMySqlU);
  inherited;
end;

function TMySqlBoersenindex.Exec: Boolean;
begin
  if fTrans = nil then
    exit;
  if fDBMySqlTSI = nil then
    exit;
  if fTrans.InTransaction then
    fTrans.Commit;
  fQryMySqlS.Database := fDBMySqlTSI;
  fQryMySqlI.Database := fDBMySqlTSI;
  fQryMySqlU.Database := fDBMySqlTSI;
  fQry.Transaction := fTrans;
  fQry.SQL.Text := 'select * from boersenindex';
  fQry.Open;
  while not fQry.Eof do
  begin
    fQryMySqlS.Close;
    fQryMySqlS.ParamByName('biid').AsInteger := fqry.FieldByName('bi_id').AsInteger;
    fQryMySqlS.Open;
    if fQryMySqlS.Eof then
    begin
      fQryMySqlI.ParamByName('biid').AsInteger  := fqry.FieldByName('bi_id').AsInteger;
      fQryMySqlI.ParamByName('biname').AsString := fqry.FieldByName('bi_name').AsString;
      fQryMySqlI.ExecSQL;
    end
    else
    begin
      fQryMySqlU.ParamByName('biid').AsInteger := fqry.FieldByName('bi_id').AsInteger;
      fQryMySqlU.ParamByName('biname').AsString := fqry.FieldByName('bi_name').AsString;
      fQryMySqlU.ExecSQL;
    end;
    fQry.Next;
  end;
  if fTrans.InTransaction then
    fTrans.Commit;
end;


end.
