unit Objekt.MySqlAktie;

interface

uses
  SysUtils, Classes, variants, IBX.IBDatabase, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Dialogs,
  IBX.IBQuery, mySQLDbTables;

type
  TStartEvent = procedure(Sender: TObject; aMaxValue: Integer) of object;

type
  TMySqlAktie = class(TComponent)
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

{ TMySqlAktie }

constructor TMySqlAktie.Create(AOwner: TComponent);
begin
  inherited;
  fTrans := nil;
  fDBMySqlTSI := nil;
  fQry  := TIBQuery.Create(nil);
  fQryMySqlS := TMySQLQuery.Create(nil);
  fQryMySqlI := TMySQLQuery.Create(nil);
  fQryMySqlU := TMySQLQuery.Create(nil);

  fQryMySqlS.SQL.Text := 'select ak_id from aktie where ak_id = :akid';
  fQryMySqlI.SQL.Text := 'INSERT INTO aktie(AK_ID, AK_WKN, AK_AKTIE, AK_BI_ID, AK_DEPOT, AK_AKTIV) VALUES (:akid,:wkn,:aktie,:biid,:depot,:aktiv)';
  fQryMySqlU.SQL.Text := 'UPDATE aktie SET AK_WKN = :wkn, AK_AKTIE=:aktie,AK_BI_ID=:biid,AK_DEPOT=:depot,AK_AKTIV=:aktiv WHERE ak_id = :akid';
end;

destructor TMySqlAktie.Destroy;
begin
  FreeAndNil(fQry);
  FreeAndNil(fQryMySqlS);
  FreeAndNil(fQryMySqlI);
  FreeAndNil(fQryMySqlU);
  inherited;
end;

function TMySqlAktie.Exec: Boolean;
var
  Datum: TDateTime;
  Depot: string[1];
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
  //fQry.SQL.Text := 'select * from aktie where ak_aktiv = ' + QuotedStr('T');
  fQry.SQL.Text := 'select * from aktie';
  fQry.Open;
  while not fQry.Eof do
  begin
    Depot := 'F';
    if fqry.FieldByName('ak_depot').AsString = 'T' then
      Depot := 'T';
    fQryMySqlS.Close;
    fQryMySqlS.ParamByName('akid').AsInteger := fqry.FieldByName('ak_id').AsInteger;
    fQryMySqlS.Open;
    if fQryMySqlS.Eof then
    begin
      fQryMySqlI.ParamByName('akid').AsInteger  := fqry.FieldByName('ak_id').AsInteger;
      fQryMySqlI.ParamByName('wkn').AsString := fqry.FieldByName('ak_wkn').AsString;
      fQryMySqlI.ParamByName('aktie').AsString := fqry.FieldByName('ak_aktie').AsString;
      fQryMySqlI.ParamByName('biid').AsString := fqry.FieldByName('ak_bi_id').AsString;
      fQryMySqlI.ParamByName('depot').AsString := Depot;
      fQryMySqlI.ParamByName('aktiv').AsString := fqry.FieldByName('ak_aktiv').AsString;
      fQryMySqlI.ExecSQL;
    end
    else
    begin
      fQryMySqlU.ParamByName('akid').AsInteger := fqry.FieldByName('ak_id').AsInteger;
      fQryMySqlU.ParamByName('wkn').AsString := fqry.FieldByName('ak_wkn').AsString;
      fQryMySqlU.ParamByName('aktie').AsString := fqry.FieldByName('ak_aktie').AsString;
      fQryMySqlU.ParamByName('biid').AsString := fqry.FieldByName('ak_bi_id').AsString;
      fQryMySqlU.ParamByName('depot').AsString := Depot;
      fQryMySqlU.ParamByName('aktiv').AsString := fqry.FieldByName('ak_aktiv').AsString;
      fQryMySqlU.ExecSQL;
    end;
    fQry.Next;
  end;

  if fTrans.InTransaction then
    fTrans.Commit;
end;

end.
