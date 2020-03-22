unit DBObj.TSI;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DBObj.Basis, Data.db;

type
  TTSI = class(TBasisDBOj)
  private
    fAK_ID: Integer;
    fTSIWert: real;
    fDatum: TDateTime;
    fWochen: Integer;
    procedure FuelleDBFelder;
    procedure setAK_ID(const Value: Integer);
    procedure setDatum(const Value: TDateTime);
    procedure setTSIWert(const Value: real);
    procedure setWochen(const Value: Integer);
  protected
    _Sql: string;
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadWert(aAK_ID, aWochen: Integer; aDatum: TDateTime);
    procedure ReadLastValue(aAK_ID, aWochen: Integer);
    procedure Init; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    property AK_ID: Integer read fAK_ID write setAK_ID;
    property Wochen: Integer read fWochen write setWochen;
    property Datum: TDateTime read fDatum write setDatum;
    property TSIWert: real read fTSIWert write setTSIWert;
  end;

implementation

{ TTSI }

constructor TTSI.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('TS_ID', ftInteger);
  fFeldList.Add('TS_AK_ID', ftInteger);
  fFeldList.Add('TS_WOCHEN', ftInteger);
  fFeldList.Add('TS_DATUM', ftDateTime);
  fFeldList.Add('TS_WERT', ftFloat);
end;

destructor TTSI.Destroy;
begin

  inherited;
end;

procedure TTSI.Init;
begin
  inherited;
  fID := 0;
  fAK_ID := 0;
  fWochen := 0;
  fDatum  := 0;
  fTSIWert := 0;
end;


procedure TTSI.FuelleDBFelder;
begin
  fFeldList.FieldByName('TS_ID').AsInteger := fID;
  fFeldList.FieldByName('TS_AK_ID').AsInteger := fAk_Id;
  fFeldList.FieldByName('TS_Wochen').AsInteger := fWochen;
  fFeldList.FieldByName('TS_Datum').AsDateTime := fDatum;
  fFeldList.FieldByName('TS_Wert').AsFloat     := fTSIWert;
end;

function TTSI.getGeneratorName: string;
begin
  Result := 'TS_ID';
end;

function TTSI.getTableName: string;
begin
  Result := 'TSI';
end;

function TTSI.getTablePrefix: string;
begin
  Result := 'TS';
end;


procedure TTSI.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fId      := aQuery.FieldByName('ts_id').AsInteger;
  fAk_Id   := aQuery.FieldByName('ts_ak_id').AsInteger;
  fWochen  := aQuery.FieldByName('ts_Wochen').AsInteger;
  fDatum   := aQuery.FieldByName('ts_Datum').AsDateTime;
  fTSIWert := aQuery.FieldByName('ts_wert').AsFloat;
  FuelleDBFelder;
end;

procedure TTSI.setAK_ID(const Value: Integer);
begin
  UpdateV(fAK_Id, Value);
  fFeldList.FieldByName('TS_AK_ID').AsInteger := fAK_Id;
end;


procedure TTSI.setDatum(const Value: TDateTime);
begin
  UpdateV(fDatum, Value);
  fFeldList.FieldByName('TS_DATUM').AsDateTime := fDatum;
end;

procedure TTSI.setTSIWert(const Value: real);
begin
  UpdateV(fTSIWert, Value);
  fFeldList.FieldByName('TS_WERT').AsFloat := fTSIWert;
end;

procedure TTSI.setWochen(const Value: Integer);
begin
  UpdateV(fWochen, Value);
  fFeldList.FieldByName('TS_WOCHEN').AsInteger := fWochen;
end;



procedure TTSI.ReadWert(aAK_ID, aWochen: Integer; aDatum: TDateTime);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := ' select * from ' + getTableName +
                     ' where ts_ak_id = ' + IntToStr(aAK_ID) +
                     ' and   ts_wochen = ' + IntToStr(aWochen) +
                     ' and   ts_Datum  = ' + QuotedStr(DateToStr(aDatum));
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;


procedure TTSI.ReadLastValue(aAK_ID, aWochen: Integer);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := ' select * from ' + getTableName +
                     ' where ts_ak_id = ' + IntToStr(aAK_ID) +
                     ' and   ts_wochen = ' + IntToStr(aWochen) +
                     ' order by ts_datum desc';
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;


end.
