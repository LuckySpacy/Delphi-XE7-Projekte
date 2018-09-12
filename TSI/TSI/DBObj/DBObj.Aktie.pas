unit DBObj.Aktie;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DBObj.Basis, Data.db,
  DBObj.Boersenindex, DBObj.TSI;

type
  TAktie = class(TBasisDBOj)
  private
    fAK_ID: Integer;
    fLink: string;
    fAktie: string;
    fWKN: string;
    fBI_ID: Integer;
    fSymbol: string;
    fLetzterTISWert27: real;
    fLetzterTISDatum: TDateTime;
    fDepot: Boolean;
    fLetzterTISWert12: real;
    procedure FuelleDBFelder;
    procedure setAK_ID(const Value: Integer);
    procedure setAktie(const Value: string);
    procedure setLink(const Value: string);
    procedure setWKN(const Value: string);
    procedure setBI_ID(const Value: Integer);
    procedure setSymbol(const Value: string);
    procedure setDepot(const Value: Boolean);
  protected
    fBoersenindex: TBoersenindex;
    fTSI: TTSI;
    _Sql: string;
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    property AK_ID: Integer read fAK_ID write setAK_ID;
    property BI_ID: Integer read fBI_ID write setBI_ID;
    property Aktie: string read fAktie write setAktie;
    property WKN: string read fWKN write setWKN;
    property Link: string read fLink write setLink;
    property Symbol: string read fSymbol write setSymbol;
    property Depot: Boolean read fDepot write setDepot;
    property LetzterTISWert27: real read fLetzterTISWert27 write fLetzterTISWert27;
    property LetzterTISWert12: real read fLetzterTISWert12 write fLetzterTISWert12;
    property LetzterTISDatum: TDateTime read fLetzterTISDatum write fLetzterTISDatum;
    function WknExist(aWKN: String): Boolean;
    function Boersenindexname: string;
    procedure ReadWKN(aWKN: string);
    function TSI(aDatum: TDateTime; aWochen: Integer; aLetztesKursDatum: TDateTime): real;
    function LetzterTSIWert(aWochen: Integer): real;
    function LetztesKursdatum: TDateTime;
  end;


implementation

{ TAktie }

uses
  DateUtils;



constructor TAktie.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('AK_ID', ftInteger);
  fFeldList.Add('AK_AKTIE', ftString);
  fFeldList.Add('AK_WKN', ftString);
  fFeldList.Add('AK_LINK', ftString);
  fFeldList.Add('AK_BI_ID', ftInteger);
  fFeldList.Add('AK_SYMBOL', ftString);
  fFeldList.Add('AK_DEPOT', ftString);
  fBoersenindex := TBoersenindex.Create(nil);
  fTSI := TTSI.Create(nil);
end;

destructor TAktie.Destroy;
begin
  Aktie := '';
  WKN   := '';
  Link  := '';
  BI_ID := -1;
  Depot := false;
  FreeAndNil(fBoersenindex);
  FreeAndNil(fTSI);
  inherited;
end;

function TAktie.getGeneratorName: string;
begin
  Result := 'AK_ID';
end;

function TAktie.getTableName: string;
begin
  Result := 'Aktie';
end;

function TAktie.getTablePrefix: string;
begin
  Result := 'AK';
end;



procedure TAktie.FuelleDBFelder;
begin
  fFeldList.FieldByName('AK_ID').AsInteger    := fID;
  fFeldList.FieldByName('AK_AKTIE').AsString  := fAktie;
  fFeldList.FieldByName('AK_WKN').AsString    := fWKN;
  fFeldList.FieldByName('AK_LINK').AsString   := fLink;
  fFeldList.FieldByName('AK_BI_ID').AsInteger := fBI_ID;
  fFeldList.FieldByName('AK_SYMBOL').AsString := fSymbol;
  fFeldList.FieldByName('AK_DEPOT').AsString  := BoolToStr(fDepot);
end;


procedure TAktie.Init;
begin
  inherited;
  fAK_Id := 0;
  fAktie := '';
  fLink  := '';
  fWKN   := '';
  fDepot := false;
end;


procedure TAktie.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fId     := aQuery.FieldByName('ak_id').AsInteger;
  fAktie  := aQuery.FieldByName('ak_aktie').AsString;
  fWKN    := aQuery.FieldByName('ak_wkn').AsString;
  fLink   := aQuery.FieldByName('ak_link').AsString;
  fBI_ID  := aQuery.FieldByName('ak_bi_id').AsInteger;
  fSymbol := aQuery.FieldByName('ak_symbol').AsString;
  fDepot  := aQuery.FieldByName('ak_depot').AsString = 'T';
  FuelleDBFelder;
end;

procedure TAktie.setAktie(const Value: string);
begin
  UpdateV(fAktie, Value);
  fFeldList.FieldByName('AK_AKTIE').AsString := Value;
end;

procedure TAktie.setAK_ID(const Value: Integer);
begin
  UpdateV(fAk_Id, Value);
  fFeldList.FieldByName('AK_ID').AsInteger := fAk_Id;
end;

procedure TAktie.setBI_ID(const Value: Integer);
begin
  UpdateV(fBI_Id, Value);
  fFeldList.FieldByName('AK_BI_ID').AsInteger := fBi_Id;
end;

procedure TAktie.setDepot(const Value: Boolean);
begin
  UpdateV(fDepot, Value);
  fFeldList.FieldByName('AK_DEPOT').AsBoolean := Value;
end;

procedure TAktie.setLink(const Value: string);
begin
  UpdateV(fLink, Value);
  fFeldList.FieldByName('AK_LINK').AsString := Value;
end;


procedure TAktie.setSymbol(const Value: string);
begin
  UpdateV(fSymbol, Value);
  fFeldList.FieldByName('AK_SYMBOL').AsString := Value;
end;

procedure TAktie.setWKN(const Value: string);
begin
  UpdateV(fWKN, Value);
  fFeldList.FieldByName('AK_WKN').AsString := Value;
end;


function TAktie.WknExist(aWKN: String): Boolean;
begin
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName + ' where ak_wkn = ' + QuotedStr(aWKN);
  OpenTrans;
  try
    fQuery.Open;
    Result := not fQuery.eof;
  finally
    RollbackTrans;
  end;
end;

function TAktie.Boersenindexname: string;
begin
  Result := '';
  fBoersenindex.Trans := Trans;
  fBoersenindex.Read(fBI_ID);
  if fBoersenindex.Gefunden then
    Result := fBoersenindex.Bezeichnung;
end;

procedure TAktie.ReadWKN(aWKN: string);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName + ' where upper(ak_wkn) = ' + QuotedStr(UpperCase(aWKN));
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;


function TAktie.TSI(aDatum: TDateTime; aWochen: Integer; aLetztesKursDatum: TDateTime): real;
var
  Datum: TDateTime;
  Wochen: Integer ;
  Tage: Integer;
  SumKurs: real;
  Anzahl: Integer;
  LetzterKurs: real;
begin
  Result := 0;
  Wochen := aWochen;
  Tage := Wochen * 7;
  Datum := aDatum - Tage;
  OpenTrans;
  try
    fQuery.Close;
    fQuery.Transaction := fTrans;
    fQuery.SQL.Text := 'select sum(ku_kurs) from kurs where ku_ak_id = :akid and ku_datum > :datum and ku_datum < :Endedatum';
    fQuery.ParamByName('akid').AsInteger := id;
    fQuery.ParamByName('datum').AsDateTime := Datum;
    fQuery.ParamByName('endedatum').AsDateTime := aLetztesKursDatum;
    fQuery.Open;
    SumKurs := fQuery.Fields[0].AsFloat;
    fQuery.Close;
    fQuery.SQL.Text := 'select count(*) from kurs where ku_ak_id = :akid and ku_datum > :datum and ku_datum < :Endedatum';
    fQuery.ParamByName('endedatum').AsDateTime := aLetztesKursDatum;
    fQuery.ParamByName('akid').AsInteger := id;
    fQuery.ParamByName('datum').AsDateTime := Datum;
    fQuery.Open;
    Anzahl := fQuery.Fields[0].AsInteger;
    fQuery.Close;
    if Anzahl > 0 then
      Result := SumKurs / Anzahl;

    fQuery.Close;
    fQuery.SQL.Text := ' select ku_kurs, ku_datum from kurs where ku_ak_id = :akid and ku_datum < :EndeDatum' +
                       ' order by ku_datum desc';
    fQuery.ParamByName('akid').AsInteger := id;
    fQuery.ParamByName('EndeDatum').AsDateTime := aLetztesKursDatum;
    fQuery.Open;
    LetzterKurs := fQuery.FieldByName('ku_kurs').AsFloat;

    if Result > 0 then
      Result := LetzterKurs / Result;
  finally
    CommitTrans;
  end;

end;


function TAktie.LetzterTSIWert(aWochen: Integer): real;
begin
  OpenTrans;
  try
    fQuery.Close;
    fQuery.Transaction := fTrans;
    fQuery.Close;
    fQuery.SQL.Text := ' select first 1 ts_wert ' +
                       ' from TSI' +
                       ' where ts_ak_id = ' + IntToStr(Id) +
                       ' and   ts_wochen = ' + IntToStr(aWochen) +
                       ' order by ts_datum desc';
    fQuery.Open;
    if fQuery.Eof then
      Result := -1
    else
      Result := fQuery.FieldByName('TS_WERT').AsFloat;
  finally
    CommitTrans;
  end;
end;


function TAktie.LetztesKursdatum: TDateTime;
begin
  OpenTrans;
  try
    fQuery.Close;
    fQuery.Transaction := fTrans;
    fQuery.Close;
    fQuery.SQL.Text := 'select ku_kurs, ku_datum from kurs where ku_ak_id = :akid order by ku_datum desc';
    fQuery.ParamByName('akid').AsInteger := id;
    fQuery.Open;
    Result := fQuery.FieldByName('KU_DATUM').AsDateTime;
  finally
    CommitTrans;
  end;
end;





end.
