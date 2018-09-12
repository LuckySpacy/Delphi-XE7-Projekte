unit Objekt.MySqlTSIAnsicht;

interface

uses
  SysUtils, Classes, variants, IBX.IBDatabase, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Dialogs,
  IBX.IBQuery, mySQLDbTables;

type
  TStartEvent = procedure(Sender: TObject; aMaxValue: Integer) of object;

type
  TMySqlTSIAnsicht = class(TComponent)
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

{ TMySqlTSIAnsicht }

constructor TMySqlTSIAnsicht.Create(AOwner: TComponent);
begin
  inherited;
  fTrans := nil;
  fDBMySqlTSI := nil;
  fQry := TIBQuery.Create(nil);
  fQry1 := TIBQuery.Create(nil);
  fQryMySqlS := TMySQLQuery.Create(nil);
  fQryMySqlI := TMySQLQuery.Create(nil);
  fQryMySqlU := TMySQLQuery.Create(nil);

  fQryMySqlS.SQL.Text := 'select ta_id from tsiansicht where ta_ak_id = :akid';
  fQryMySqlI.SQL.Text := 'INSERT INTO tsiansicht(TA_AK_ID, TA_LetzterKurs, TA_TSI27, TA_TSI12, TA_DEPOT) VALUES (:akid,:letzterkurs,:tsi27,:tsi12, :depot)';
  //fQryMySqlU.SQL.Text := 'UPDATE tsiansicht SET TA_LetzterKurs=:letzterkurs, TA_TSI27=:tsi27, TA_TSI12=:tsi12 WHERE ta_id = :taid';
end;

destructor TMySqlTSIAnsicht.Destroy;
begin

  inherited;
end;

function TMySqlTSIAnsicht.Exec: Boolean;
begin
  ExecWochen(27);
  ExecWochen(12);
end;

procedure TMySqlTSIAnsicht.ExecWochen(aWochen: Integer);
var
  Depot: string[1];
begin
  if fDBMySqlTSI = nil then
    exit;
  if fTrans.InTransaction then
    fTrans.Commit;

  if aWochen = 27 then
    fQryMySqlU.SQL.Text := 'UPDATE tsiansicht SET TA_LetzterKurs=:letzterkurs, TA_TSI27=:tsi, TA_DEPOT=:depot WHERE ta_id = :taid';

  if aWochen = 12 then
    fQryMySqlU.SQL.Text := 'UPDATE tsiansicht SET TA_LetzterKurs=:letzterkurs, TA_TSI12=:tsi, TA_DEPOT=:depot WHERE ta_id = :taid';


  fQryMySqlS.Database := fDBMySqlTSI;
  fQryMySqlI.Database := fDBMySqlTSI;
  fQryMySqlU.Database := fDBMySqlTSI;

  fQry.Transaction := fTrans;
  fQry.SQL.Text := ' select * from tsilast ' +
                   ' inner join AKTIE on tl_ak_id = ak_id' +
                   ' where tl_Wochen = :wochen';
  fQry.ParamByName('wochen').AsInteger := aWochen;
  fQry.Open;
  while not fQry.Eof do
  begin
    Depot := 'F';
    if fqry.FieldByName('ak_depot').AsString = 'T' then
      Depot := 'T';

    fQryMySqlS.Close;
    fQryMySqlS.ParamByName('akid').AsInteger := fqry.FieldByName('tl_ak_id').AsInteger;
    fQryMySqlS.Open;
    if fQryMySqlS.Eof then
    begin
      fQryMySqlI.ParamByName('akid').AsInteger := fQry.FieldByName('tl_ak_id').AsInteger;
      fQryMySqlI.ParamByName('letzterkurs').AsDateTime := fQry.FieldByName('tl_datum').AsDateTime;
      fQryMySqlI.ParamByName('tsi27').AsFloat := 0;
      fQryMySqlI.ParamByName('tsi12').AsFloat := 0;
      fQryMySqlI.ParamByName('depot').AsString := Depot;
      if aWochen = 27 then
        fQryMySqlI.ParamByName('tsi27').AsFloat := fQry.FieldByName('tl_wert').AsFloat;
      if aWochen = 12 then
        fQryMySqlI.ParamByName('tsi12').AsFloat := fQry.FieldByName('tl_wert').AsFloat;
      fQryMySqlI.ExecSQL;
    end
    else
    begin
      fQryMySqlU.ParamByName('letzterkurs').AsDateTime := fQry.FieldByName('tl_datum').AsDateTime;
      fQryMySqlU.ParamByName('taid').AsInteger := fQryMySqlS.FieldByName('ta_id').AsInteger;
      fQryMySqlU.ParamByName('tsi').AsFloat := fQry.FieldByName('tl_wert').AsFloat;
      fQryMySqlU.ParamByName('depot').AsString := Depot;
      fQryMySqlU.ExecSQL;
    end;
    fQry.Next;
  end;

  if fTrans.InTransaction then
    fTrans.Commit;

end;

end.
