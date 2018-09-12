unit o_aktie;

interface

uses
  Classes, IBDatabase, IBQuery, Dialogs, ContNrs, SysUtils, o_db, o_Field;

type TAktie = class(TDB)
  private
    FIBT   : TIBTransaction;
    FName: TTBField;
    FWKN: TTBField;
    FBestand: Integer;
    FBestandswert: Currency;
    procedure SetTransaction(const Value: TIBTransaction);
    function LeseBestand: Integer;
    function GetBestand: Integer;
    function LeseBestandswert: Currency;
    function GetBestandswert: Currency;
  protected
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure setSaveSqlText; override;
    procedure SetValues(aQuery: TIBQuery); override;
  published
  public
    constructor Create(AOwner: TComponent; aIBT: TIBTransaction); override;
    destructor Destroy; override;
    procedure ReadWKN(aWKN: string);
    property WKN : TTBField read FWKN;
    property Name: TTBField read FName;
    property Transaction: TIBTransaction read FIBT write SetTransaction;
    property Bestand: Integer read GetBestand;
    property Bestandswert: Currency read GetBestandswert;
  end;


implementation

{ TAktie }

constructor TAktie.Create(AOwner: TComponent; aIBT: TIBTransaction);
begin
  inherited;
  FIBT  := aIBT;
  FWKN  := AddField;
  FName := AddField;
  FBestand := -1;
  FBestandswert := -1;
end;

destructor TAktie.Destroy;
begin

  inherited;
end;



function TAktie.getTableName: string;
begin
  Result := 'Aktie';
end;

function TAktie.getTablePrefix: string;
begin
  Result := 'AK';
end;

procedure TAktie.setSaveSqlText;
var
  Sql: string;
begin
  if FFound then
  begin
    Sql := ' update aktie set' +
           ' ak_wkn  = :wkn' +
           ' ak_name = :name' +
           ' where ak_id = :id';
  end
  else
  begin

    Sql := ' insert into aktie (' +
           ' ak_id, ak_wkn, ak_name) ' +
           ' values (' +
           ' :id, :wkn, :name)';
  end;

  FQuery.SQL.Text := Sql;

  FQuery.Params.ParamByName('wkn').AsString    := FWKN.AsString;
  FQuery.Params.ParamByName('name').AsString   := FName.AsString;
  FQuery.Params.ParamByName('id').AsInteger    := Fid;
end;


procedure TAktie.SetTransaction(const Value: TIBTransaction);
begin
  FIBT := Value;
end;

procedure TAktie.SetValues(aQuery: TIBQuery);
begin
  inherited;
  ClearValues;
  if aQuery.Eof then
    exit;
  FWKN.AsString  := aQuery.FieldByName('ak_wkn').AsString;
  FName.AsString := aQuery.FieldByName('ak_name').AsString;
  FFound         := true;
end;

function TAktie.GetBestand: Integer;
begin
  if FBestand = -1 then
    FBestand := LeseBestand;
  Result := FBestand;
end;


function TAktie.GetBestandswert: Currency;
begin
  if FBestandswert = -1 then
    FBestandswert := LeseBestandswert;
  Result := FBestandswert;
end;

function TAktie.LeseBestand: Integer;
var
  StueckKauf  : Integer;
  StueckVerkauf: Integer;
begin
  if FIBT.InTransaction then
    FIBT.Rollback;
  FQuery.Close;
  FQuery.SQL.Text := ' select sum(tr_stueck) from transfer' +
                     ' where tr_ak_id = ' + IntToStr(FID) +
                     ' and tr_aktion = ' + QuotedStr('K');
  FIBT.StartTransaction;
  try
    FQuery.Transaction := FIBT;
    FQuery.Open;
    StueckKauf := FQuery.Fields[0].AsInteger;

    FQuery.Close;
    FQuery.SQL.Text := ' select sum(tr_stueck) from transfer' +
                       ' where tr_ak_id = ' + IntToStr(FID) +
                       ' and tr_aktion = ' + QuotedStr('V');
    FQuery.Open;
    StueckVerkauf := FQuery.Fields[0].AsInteger;

    Result := StueckKauf - StueckVerkauf;

  finally
    FIBT.Rollback;
  end;
end;


function TAktie.LeseBestandswert: Currency;
var
  AnzKauf   : Integer;
  WertKauf  : Currency;
  StueckWert: Currency;
begin
  if FIBT.InTransaction then
    FIBT.Rollback;
  FQuery.Close;
  FQuery.SQL.Text := ' select * from transfer order by tr_datum';
  FIBT.StartTransaction;
  try
    FQuery.Open;

    AnzKauf  := 0;
    WertKauf := 0;
    while not FQuery.Eof do
    begin
      if FQuery.FieldByName('tr_aktion').AsString = 'K' then
      begin
        AnzKauf  := AnzKauf  + FQuery.FieldByName('tr_stueck').AsInteger;
        WertKauf := WertKauf + FQuery.FieldByName('tr_wert').AsCurrency;
      end;
      if FQuery.FieldByName('tr_aktion').AsString = 'V' then
      begin
        StueckWert := WertKauf / AnzKauf;
        AnzKauf  := AnzKauf - FQuery.FieldByName('tr_stueck').AsInteger;
        WertKauf := Stueckwert * AnzKauf;
      end;
      FQuery.Next;
    end;

    Result := WertKauf;


  {
  FQuery.Close;
  FQuery.SQL.Text := ' select sum(tr_wert) from transfer' +
                     ' where tr_ak_id = ' + IntToStr(FID) +
                     ' and tr_aktion = ' + QuotedStr('K');
  FIBT.StartTransaction;
  try
    FQuery.Transaction := FIBT;
    FQuery.Open;
    WertKauf := FQuery.Fields[0].AsCurrency;

    FQuery.Close;
    FQuery.SQL.Text := ' select sum(tr_wert) from transfer' +
                       ' where tr_ak_id = ' + IntToStr(FID) +
                       ' and tr_aktion = ' + QuotedStr('V');
    FQuery.Open;
    WertVerkauf := FQuery.Fields[0].AsCurrency;

    Result := WertKauf - WertVerkauf;
   }
  finally
    FIBT.Rollback;
  end;
end;

procedure TAktie.ReadWKN(aWKN: string);
begin
  FQuery.Close;
  FQuery.SQL.Text := ' select * from aktie' +
                     ' where ak_wkn = :wkn';
  FQuery.Params.ParamByName('wkn').AsString := aWKN;
  if FIBT.InTransaction then
    FIBT.Rollback;
  FIBT.StartTransaction;
  try
    FQuery.Open;
    SetValues(FQuery);
  finally
    FIBT.Rollback;
  end;
end;

end.
