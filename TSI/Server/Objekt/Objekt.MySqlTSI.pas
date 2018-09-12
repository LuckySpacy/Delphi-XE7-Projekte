unit Objekt.MySqlTSI;

interface

uses
  SysUtils, Classes, variants, IBX.IBDatabase, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Dialogs,
  IBX.IBQuery, mySQLDbTables, Vcl.Forms;

type
  TStartEvent = procedure(Sender: TObject; aMaxValue: Integer) of object;

type
  TMySqlTSI = class(TComponent)
  private
    fTrans: TIBTransaction;
    fOnStart: TStartEvent;
    fProgressBar: TProgressBar;
    fProgressLabel: TLabel;
    fQry1: TIBQuery;
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
    procedure ExecWochen(aWochen: Integer);
  end;

implementation

{ TMySqlTSI }

constructor TMySqlTSI.Create(AOwner: TComponent);
begin
  inherited;
  fTrans := nil;
  fDBMySqlTSI := nil;
  fQry := TIBQuery.Create(nil);
  fQry1 := TIBQuery.Create(nil);
  fQryMySqlS := TMySQLQuery.Create(nil);
  fQryMySqlI := TMySQLQuery.Create(nil);
  fQryMySqlU := TMySQLQuery.Create(nil);

  fQryMySqlS.SQL.Text := 'select max(ts_datum) from tsi where ts_ak_id = :akid and ts_wochen = :wochen';
  fQryMySqlI.SQL.Text := 'INSERT INTO tsi(TS_ID, TS_AK_ID, TS_WOCHEN, TS_DATUM, TS_WERT) VALUES (:tsid,:akid,:wochen,:datum,:wert)';
  //fQryMySqlU.SQL.Text := 'UPDATE kurs SET KU_AK_ID=:akid,KU_DATUM=:datum,KU_KURS=:kurs WHERE ku_id = kuid';
end;

destructor TMySqlTSI.Destroy;
begin
  FreeAndNil(fQry);
  FreeAndNil(fQry1);
  FreeAndNil(fQryMySqlS);
  FreeAndNil(fQryMySqlI);
  FreeAndNil(fQryMySqlU);
  inherited;
end;

function TMySqlTSI.Exec: Boolean;
begin
  Result := true;
  ExecWochen(27);
  ExecWochen(12);
end;

procedure TMySqlTSI.ExecWochen(aWochen: Integer);
var
  Datum: TDateTime;
  Zaehler: Integer;
begin
  if fDBMySqlTSI = nil then
    exit;
  if fTrans.InTransaction then
    fTrans.Commit;
  fQryMySqlS.Database := fDBMySqlTSI;
  fQryMySqlI.Database := fDBMySqlTSI;

  fQry.Transaction := fTrans;
  fQry.SQL.Text := 'select * from tsi where ts_ak_id = :akid and ts_datum > :datum and ts_Wochen = :wochen';
  fQry1.Transaction := fTrans;
  fQry1.SQL.Text := 'select distinct ts_ak_id from tsi';
  fQry1.Open;
  fQry1.FetchAll;
  fQry1.First;
  fProgressBar.Max := fqry1.RecordCount;
  Zaehler := 0;
  while not fQry1.Eof do
  begin
    inc(Zaehler);
    fProgressLabel.Caption := 'TSI: AK_ID =' + IntToStr(fQry1.FieldByName('ts_ak_id').AsInteger) + ' Wochen:' + IntToStr(aWochen);
    fProgressBar.Position := Zaehler;
    Application.ProcessMessages;
    fQryMySqlS.Close;
    fQryMySqlS.ParamByName('akid').AsInteger := fQry1.FieldByName('ts_ak_id').AsInteger;
    fQryMySqlS.ParamByName('wochen').AsInteger := aWochen;
    fQryMySqlS.Open;
    Datum := 0;
    if not fQryMySqlS.Eof then
      Datum := fQryMySqlS.Fields[0].AsDateTime;
    fqry.Close;
    fqry.ParamByName('akid').AsInteger   := fQry1.FieldByName('ts_ak_id').AsInteger;
    fqry.ParamByName('datum').AsDateTime := Datum;
    fqry.ParamByName('wochen').AsInteger := aWochen;
    fqry.Open;
    while not fqry.Eof do
    begin
      fQryMySqlI.ParamByName('tsid').AsInteger := fQry.FieldByName('ts_id').AsInteger;
      fQryMySqlI.ParamByName('akid').AsInteger := fQry.FieldByName('ts_ak_id').AsInteger;
      fQryMySqlI.ParamByName('datum').AsDateTime := fQry.FieldByName('ts_datum').AsDateTime;
      fQryMySqlI.ParamByName('wochen').AsInteger := fQry.FieldByName('ts_wochen').AsInteger;
      fQryMySqlI.ParamByName('wert').AsFloat := fQry.FieldByName('ts_wert').AsFloat;
      fQryMySqlI.ExecSQL;
      fqry.Next;
    end;
    fqry1.Next
  end;

  if fTrans.InTransaction then
    fTrans.Commit;
end;

end.
