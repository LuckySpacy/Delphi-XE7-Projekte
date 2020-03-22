unit DBObj.TSILAST;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DBObj.Basis, Data.db;

type
  TTSILAST = class(TBasisDBOj)
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
    procedure ReadWert(aAK_ID, aWochen: Integer);
    procedure Init; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    property AK_ID: Integer read fAK_ID write setAK_ID;
    property Wochen: Integer read fWochen write setWochen;
    property Datum: TDateTime read fDatum write setDatum;
    property TSIWert: real read fTSIWert write setTSIWert;
  end;

implementation

{ TTSILAST }

constructor TTSILAST.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('TL_ID', ftInteger);
  fFeldList.Add('TL_AK_ID', ftInteger);
  fFeldList.Add('TL_WOCHEN', ftInteger);
  fFeldList.Add('TL_DATUM', ftDateTime);
  fFeldList.Add('TL_WERT', ftFloat);
end;

destructor TTSILAST.Destroy;
begin

  inherited;
end;

procedure TTSILAST.Init;
begin
  inherited;
  fID := 0;
  fAK_ID := 0;
  fWochen := 0;
  fDatum  := 0;
  fTSIWert := 0;
end;


procedure TTSILAST.FuelleDBFelder;
begin
  fFeldList.FieldByName('TL_ID').AsInteger := fID;
  fFeldList.FieldByName('TL_AK_ID').AsInteger := fAk_Id;
  fFeldList.FieldByName('TL_Wochen').AsInteger := fWochen;
  fFeldList.FieldByName('TL_Datum').AsDateTime := fDatum;
  fFeldList.FieldByName('TL_Wert').AsFloat     := fTSIWert;
end;

function TTSILAST.getGeneratorName: string;
begin
  Result := 'TL_ID';
end;

function TTSILAST.getTableName: string;
begin
  Result := 'TSILAST';
end;

function TTSILAST.getTablePrefix: string;
begin
  Result := 'TL';
end;


procedure TTSILAST.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fId      := aQuery.FieldByName('tl_id').AsInteger;
  fAk_Id   := aQuery.FieldByName('tl_ak_id').AsInteger;
  fWochen  := aQuery.FieldByName('tl_Wochen').AsInteger;
  fDatum   := aQuery.FieldByName('tl_Datum').AsDateTime;
  fTSIWert := aQuery.FieldByName('tl_wert').AsFloat;
  FuelleDBFelder;
end;

procedure TTSILAST.setAK_ID(const Value: Integer);
begin
  UpdateV(fAK_Id, Value);
  fFeldList.FieldByName('TL_AK_ID').AsInteger := fAK_Id;
end;


procedure TTSILAST.setDatum(const Value: TDateTime);
begin
  UpdateV(fDatum, Value);
  fFeldList.FieldByName('TL_DATUM').AsDateTime := fDatum;
end;

procedure TTSILAST.setTSIWert(const Value: real);
begin
  UpdateV(fTSIWert, Value);
  fFeldList.FieldByName('TL_WERT').AsFloat := fTSIWert;
end;

procedure TTSILAST.setWochen(const Value: Integer);
begin
  UpdateV(fWochen, Value);
  fFeldList.FieldByName('TL_WOCHEN').AsInteger := fWochen;
end;


procedure TTSILAST.ReadWert(aAK_ID, aWochen: Integer);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := ' select * from ' + getTableName +
                     ' where tl_ak_id = ' + IntToStr(aAK_ID) +
                     ' and   tl_wochen = ' + IntToStr(aWochen);
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;

end.
