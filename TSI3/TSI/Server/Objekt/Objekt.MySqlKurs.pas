unit Objekt.MySqlKurs;

interface

uses
  SysUtils, Classes, variants, IBX.IBDatabase, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Dialogs,
  IBX.IBQuery, mySQLDbTables, Vcl.Forms;

type
  TStartEvent = procedure(Sender: TObject; aMaxValue: Integer) of object;

type
  TMySqlKurs = class(TComponent)
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
  end;

implementation

{ TMySqlKurs }

constructor TMySqlKurs.Create(AOwner: TComponent);
begin
  inherited;
  fTrans := nil;
  fDBMySqlTSI := nil;
  fQry := TIBQuery.Create(nil);
  fQry1 := TIBQuery.Create(nil);
  fQryMySqlS := TMySQLQuery.Create(nil);
  fQryMySqlI := TMySQLQuery.Create(nil);
  fQryMySqlU := TMySQLQuery.Create(nil);

  fQryMySqlS.SQL.Text := 'select max(ku_datum) from kurs where ku_ak_id = :akid';
  fQryMySqlI.SQL.Text := 'INSERT INTO kurs(KU_ID, KU_AK_ID, KU_DATUM, KU_KURS) VALUES (:kuid,:akid,:datum,:kurs)';
  fQryMySqlU.SQL.Text := 'UPDATE kurs SET KU_AK_ID=:akid,KU_DATUM=:datum,KU_KURS=:kurs WHERE ku_id = kuid';
end;

destructor TMySqlKurs.Destroy;
begin
  FreeAndNil(fQry);
  FreeAndNil(fQry1);
  FreeAndNil(fQryMySqlS);
  FreeAndNil(fQryMySqlI);
  FreeAndNil(fQryMySqlU);
  inherited;
end;

function TMySqlKurs.Exec: Boolean;
var
  Datum: TDateTime;
  Zaehler: Integer;
begin
  Result := true;
  if fDBMySqlTSI = nil then
    exit;
  if fTrans.InTransaction then
    fTrans.Commit;
  fQryMySqlS.Database := fDBMySqlTSI;
  fQryMySqlI.Database := fDBMySqlTSI;

  fQry.Transaction := fTrans;
  fQry.SQL.Text := 'select * from KURS where ku_ak_id = :akid and ku_datum > :datum';
  fQry1.Transaction := fTrans;
  fQry1.SQL.Text := 'select distinct ku_ak_id from KURS ' +
                    'join aktie on AK_ID = ku_ak_id  and ak_aktiv = ' + QuotedStr('T');
  fQry1.Open;
  while not fQry1.Eof do
  begin
    fQryMySqlS.Close;
    fQryMySqlS.ParamByName('akid').AsInteger := fQry1.FieldByName('ku_ak_id').AsInteger;
    fQryMySqlS.Open;
    Datum := 0;
    if not fQryMySqlS.Eof then
      Datum := fQryMySqlS.Fields[0].AsDateTime;
    fqry.Close;
    fqry.ParamByName('akid').AsInteger   := fQry1.FieldByName('ku_ak_id').AsInteger;
    fqry.ParamByName('datum').AsDateTime := Datum;
    fqry.Open;
    fQry.FetchAll;
    fQry.First;
    fProgressBar.Max := fQry.RecordCount;
    Zaehler := 0;
    while not fqry.Eof do
    begin
      inc(Zaehler);
      fProgressLabel.Caption := 'Kurs: AK_ID =' + IntToStr(fQry1.FieldByName('ku_ak_id').AsInteger) + ' ' + FormatDateTime('dd.mm.yyyy', fQry.FieldByName('ku_datum').AsDateTime);
      fProgressBar.Position := Zaehler;
      Application.ProcessMessages;
      fQryMySqlI.ParamByName('kuid').AsInteger := fQry.FieldByName('ku_id').AsInteger;
      fQryMySqlI.ParamByName('akid').AsInteger := fQry.FieldByName('ku_ak_id').AsInteger;
      fQryMySqlI.ParamByName('datum').AsDateTime := fQry.FieldByName('ku_datum').AsDateTime;
      fQryMySqlI.ParamByName('kurs').AsFloat := fQry.FieldByName('ku_kurs').AsFloat;
      fQryMySqlI.ExecSQL;
      fqry.Next;
    end;
    fqry1.Next
  end;

  if fTrans.InTransaction then
    fTrans.Commit;


end;

end.
