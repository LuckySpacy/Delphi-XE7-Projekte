unit o_transfer;

interface
uses
  Classes, IBDatabase, IBQuery, Dialogs, ContNrs, SysUtils, o_db, o_Field,
  o_aktie;

type TTransfer = class(TDB)
  private
    FIBT   : TIBTransaction;
    FAK_ID: TTBField;
    FAKTION: TTBField;
    FDATUM: TTBField;
    FSTUECK: TTBField;
    FWERT: TTBField;
    FKURS: TTBField;
    FKorrektur: TTBField;
    FAktie: TAktie;
    function getAktie: TAktie;
  protected
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure setSaveSqlText; override;
    procedure SetValues(aQuery: TIBQuery); override;
  published
  public
    constructor Create(AOwner: TComponent; aIBT: TIBTransaction); override;
    destructor Destroy; override;
    property AK_ID : TTBField read FAK_ID;
    property Aktion: TTBField read FAKTION;
    property Datum: TTBField read FDATUM;
    property Stueck: TTBField read FSTUECK;
    property Wert: TTBField read FWERT;
    property Kurs: TTBField read FKURS;
    property Korrektur: TTBField read FKorrektur;
    property Transaction: TIBTransaction read FIBT;
    property Aktie: TAktie read getAktie;
  end;


implementation

{ TTransfer }

constructor TTransfer.Create(AOwner: TComponent; aIBT: TIBTransaction);
begin
  inherited;
  FAktie     := nil;
  FIBT       := aIBT;
  FAK_ID     := AddField;
  FAktion    := AddField;
  FDatum     := AddField;
  FStueck    := AddField;
  FWert      := AddField;
  FKurs      := AddField;
  FKorrektur := AddField;
end;

destructor TTransfer.Destroy;
begin
  if Assigned(FAktie) then
    FreeAndNil(FAktie);
  inherited;
end;

function TTransfer.getAktie: TAktie;
begin
  Result := nil;
  if ID < 0 then
    exit;
  if Assigned(FAktie) then
  begin
    Result := FAktie;
    exit;
  end;
  FAktie := TAktie.Create(Self, Transaction);
  FAktie.ReadId(FAK_ID.AsInteger);
  Result := FAktie;
end;

function TTransfer.getTableName: string;
begin
  Result := 'TRANSFER';
end;

function TTransfer.getTablePrefix: string;
begin
  Result := 'TR';
end;

procedure TTransfer.setSaveSqlText;
var
  Sql: string;
begin
  if FFound then
  begin
    Sql := ' update transfer set' +
           ' tr_ak_id     = :ak_id,' +
           ' tr_aktion    = :aktion,' +
           ' tr_datum     = :datum,' +
           ' tr_stueck    = :stueck,' +
           ' tr_wert      = :wert,' +
           ' tr_kurs      = :kurs, ' +
           ' tr_korrektur = :korrektur ' +
           ' where tr_id = :id';
  end
  else
  begin

    Sql := ' insert into transfer (' +
           ' tr_id, tr_ak_id, tr_aktion, tr_datum, tr_stueck, tr_wert, tr_kurs, tr_korrektur) ' +
           ' values (' +
           ' :id, :ak_id, :aktion, :datum, :stueck, :wert, :kurs, :korrektur)';
  end;

  FQuery.SQL.Text := Sql;

  FQuery.Params.ParamByName('ak_id').AsInteger    := FAK_ID.AsInteger;
  FQuery.Params.ParamByName('aktion').AsString    := FAktion.AsString;
  FQuery.Params.ParamByName('datum').AsDate       := FDatum.AsDateTime;
  FQuery.Params.ParamByName('stueck').AsCurrency  := FStueck.AsCurrency;
  FQuery.Params.ParamByName('wert').AsCurrency    := FWert.AsCurrency;
  FQuery.Params.ParamByName('kurs').AsCurrency    := FWert.AsCurrency / FStueck.AsCurrency;
  FQuery.Params.ParamByName('korrektur').AsString := FKorrektur.AsString;
  FQuery.Params.ParamByName('id').AsInteger        := Fid;
end;

procedure TTransfer.SetValues(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  FAK_ID.AsString     := aQuery.FieldByName('tr_ak_id').AsString;
  FAktion.AsString    := aQuery.FieldByName('tr_aktion').AsString;
  FDatum.AsDateTime   := aQuery.FieldByName('tr_datum').AsDateTime;
  FStueck.AsCurrency  := aQuery.FieldByName('tr_stueck').AsCurrency;
  FWert.AsCurrency    := aQuery.FieldByName('tr_wert').AsCurrency;
  FKurs.AsCurrency    := aQuery.FieldByName('tr_kurs').AsCurrency;
  FKorrektur.AsString := aQuery.FieldByName('tr_korrektur').AsString;
end;

end.
