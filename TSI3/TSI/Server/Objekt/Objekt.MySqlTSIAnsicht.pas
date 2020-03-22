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
    fQryMySqlSJHoch : TMySQLQuery;
    fQryMySqlSHJTief : TMySQLQuery;
    fQryMySqlKurs : TMySQLQuery;
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
    procedure ExecJahreskurse;
  end;

implementation

{ TMySqlTSIAnsicht }

uses
  DateUtils, Vcl.Forms;

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
  fQryMySqlSJHoch := TMySQLQuery.Create(nil);
  fQryMySqlSHJTief := TMySQLQuery.Create(nil);
  fQryMySqlKurs := TMySQLQuery.Create(nil);

  fQryMySqlS.SQL.Text := 'select ta_id from tsiansicht where ta_ak_id = :akid';
  fQryMySqlI.SQL.Text := 'INSERT INTO tsiansicht(TA_AK_ID, TA_LetzterKurs, TA_TSI27, TA_TSI12, TA_DEPOT)' +
                         ' VALUES (:akid,:letzterkurs,:tsi27,:tsi12, :depot)';

  fQryMySqlSJHoch.SQL.Text  := 'select * from kurs where ku_ak_id = :akid and   ku_datum >= :JHochDatum order by ku_kurs desc';
  fQryMySqlSHJTief.SQL.Text := 'select * from kurs where ku_ak_id = :akid and   ku_datum >= :HJTiefDatum order by ku_kurs';
  fQryMySqlKurs.SQL.Text    := 'select * from kurs where ku_ak_id = :akid and   ku_datum >= :Datum order by ku_kurs desc';

  //fQryMySqlU.SQL.Text := 'UPDATE tsiansicht SET TA_LetzterKurs=:letzterkurs, TA_TSI27=:tsi27, TA_TSI12=:tsi12 WHERE ta_id = :taid';
end;

destructor TMySqlTSIAnsicht.Destroy;
begin
  FreeAndNil(fQry);
  FreeAndNil(fQry1);
  FreeAndNil(fQryMySqlS);
  FreeAndNil(fQryMySqlI);
  FreeAndNil(fQryMySqlU);
  FreeAndNil(fQryMySqlSJHoch);
  FreeAndNil(fQryMySqlSHJTief);
  FreeAndNil(fQryMySqlKurs);
  inherited;
end;

function TMySqlTSIAnsicht.Exec: Boolean;
begin
  Result := true;

  ExecWochen(27);
  ExecWochen(12);

  ExecJahreskurse;
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
                   ' and ak_aktiv = ' + QuotedStr('T') +
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


procedure TMySqlTSIAnsicht.ExecJahreskurse;
var
  DatumVorEinemJahr: TDateTime;
  DatumVorEinemHalbenJahr: TDateTime;
  Proz: Currency;
  Diff: Currency;
begin
  DatumVorEinemJahr := IncYear(now, -1);
  DatumVorEinemHalbenJahr := IncMonth(now, -6);

  fQryMySqlS.Database := fDBMySqlTSI;
  fQryMySqlU.Database := fDBMySqlTSI;
  fQryMySqlSJHoch.Database := fDBMySqlTSI;
  fQryMySqlSHJTief.Database := fDBMySqlTSI;
  fQryMySqlKurs.Database := fDBMySqlTSI;


  fQryMySqlU.SQL.Text := 'UPDATE tsiansicht SET TA_JHOCHKURS=:JHochKurs, TA_JHOCHDATUM=:JHochdatum, TA_HJTIEFKURS=:HJTiefkurs, TA_HJTIEFDATUM=:HJTiefdatum,' +
                         'TA_KURS=:kurs, TA_KURSDATUM=:Kursdatum, TA_AKTIV=:Aktiv, TA_PJHOCH=:PJHoch, TA_PHJTIEF=:PHJTief, TA_PSPANNE=:PSpanne' +
                         ' WHERE ta_id = :taid';


  fQryMySqlS.Close;
  fQryMySqlS.SQL.Text := 'select * from tsiansicht join aktie on ak_id = ta_ak_id';
  fQryMySqlS.Open;
  fProgressBar.Position := 0;
  fProgressBar.Max := fQryMySqlS.RecordCount;

  while not fQryMySqlS.Eof do
  begin
    fProgressLabel.Caption := 'Jahreskurse Aktie: ' +  fQryMySqlS.FieldByName('ak_aktie').AsString;
    fProgressBar.Position := fProgressBar.Position + 1;
    Application.ProcessMessages;

    fQryMySqlSJHoch.Close;
    fQryMySqlSJHoch.ParamByName('akid').AsInteger := fQryMySqlS.FieldByName('ta_ak_id').AsInteger;
    fQryMySqlSJHoch.ParamByName('JHochDatum').AsDateTime := DatumVorEinemJahr;
    fQryMySqlSJHoch.Open;

    fQryMySqlSHJTief.Close;
    fQryMySqlSHJTief.ParamByName('akid').AsInteger := fQryMySqlS.FieldByName('ta_ak_id').AsInteger;
    fQryMySqlSHJTief.ParamByName('HJTiefDatum').AsDateTime := DatumVorEinemHalbenJahr;
    fQryMySqlSHJTief.Open;

    fQryMySqlKurs.Close;
    fQryMySqlKurs.ParamByName('akid').AsInteger  := fQryMySqlS.FieldByName('ta_ak_id').AsInteger;
    fQryMySqlKurs.ParamByName('datum').AsDateTime := fQryMySqlS.FieldByName('ta_letzterkurs').AsDateTime;
    fQryMySqlKurs.Open;


    fQryMySqlU.ParamByName('JHochKurs').AsFloat    := fQryMySqlSJHoch.FieldByName('ku_kurs').AsFloat;
    fQryMySqlU.ParamByName('JHochDatum').AsDateTime := fQryMySqlSJHoch.FieldByName('ku_datum').AsDateTime;

    fQryMySqlU.ParamByName('HJTiefkurs').AsFloat    := fQryMySqlSHJTief.FieldByName('ku_kurs').AsFloat;
    fQryMySqlU.ParamByName('HJTiefdatum').AsDateTime := fQryMySqlSHJTief.FieldByName('ku_datum').AsDateTime;

    fQryMySqlU.ParamByName('Kurs').AsFloat         := fQryMySqlKurs.FieldByName('ku_kurs').AsFloat;
    fQryMySqlU.ParamByName('Kursdatum').AsDateTime := fQryMySqlKurs.FieldByName('ku_datum').AsDateTime;
    fQryMySqlU.ParamByName('Aktiv').AsString := fQryMySqlS.FieldByName('ak_aktiv').AsString;

    Diff := fQryMySqlSJHoch.FieldByName('ku_kurs').AsFloat - fQryMySqlKurs.FieldByName('ku_kurs').AsFloat;
    if fQryMySqlKurs.FieldByName('ku_kurs').AsFloat > 0 then
      Proz := Diff * 100 / fQryMySqlKurs.FieldByName('ku_kurs').AsFloat
    else
      Proz := 0;
    fQryMySqlU.ParamByName('PJHoch').AsFloat := Proz;

    Diff := fQryMySqlKurs.FieldByName('ku_kurs').AsFloat - fQryMySqlSHJTief.FieldByName('ku_kurs').AsFloat;
    if fQryMySqlSHJTief.FieldByName('ku_kurs').AsFloat > 0 then
      Proz := Diff * 100 / fQryMySqlSHJTief.FieldByName('ku_kurs').AsFloat
    else
      Proz := 0;
    fQryMySqlU.ParamByName('PHJTief').AsFloat := Proz;

    Diff := fQryMySqlSJHoch.FieldByName('ku_kurs').AsFloat - fQryMySqlSHJTief.FieldByName('ku_kurs').AsFloat;
    if fQryMySqlSHJTief.FieldByName('ku_kurs').AsFloat > 0 then
      Proz := Diff * 100 / fQryMySqlSHJTief.FieldByName('ku_kurs').AsFloat
    else
      Proz := 0;
    fQryMySqlU.ParamByName('PSpanne').AsFloat := Proz;


    fQryMySqlU.ParamByName('taid').AsInteger := fQryMySqlS.FieldByName('ta_id').AsInteger;
    fQryMySqlU.ExecSQL;




    fQryMySqlS.Next;

  end;


end;


end.
