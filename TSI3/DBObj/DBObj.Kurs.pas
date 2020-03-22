unit DBObj.Kurs;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DBObj.Basis, Data.db;

type
  TKurs = class(TBasisDBOj)
  private
    fKU_ID: Integer;
    fAK_ID: Integer;
    fKurs: real;
    fDatum: TDateTime;
    procedure FuelleDBFelder;
    procedure setAK_ID(const Value: Integer);
    procedure setDatum(const Value: TDateTime);
    procedure setKurs(const Value: real);
  protected
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
    property Datum: TDateTime read fDatum write setDatum;
    property Kurs: real read fKurs write setKurs;
    procedure ReadDatum(aAr_id: Integer; aDate: TDateTime);
    function getLastDatum(aAk_Id: Integer): TDateTime;
  end;

implementation

{ TKurs }

constructor TKurs.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('KU_ID', ftInteger);
  fFeldList.Add('KU_AK_ID', ftInteger);
  fFeldList.Add('KU_DATUM', ftDateTime);
  fFeldList.Add('KU_KURS', ftFloat);
end;

destructor TKurs.Destroy;
begin

  inherited;
end;

function TKurs.getGeneratorName: string;
begin
  Result := 'KU_ID';
end;


function TKurs.getTableName: string;
begin
  Result := 'Kurs';
end;

function TKurs.getTablePrefix: string;
begin
  Result := 'KU';
end;



procedure TKurs.FuelleDBFelder;
begin
  fFeldList.FieldByName('KU_ID').AsInteger := fID;
  fFeldList.FieldByName('KU_AK_ID').AsInteger := fAK_ID;
  fFeldList.FieldByName('KU_DATUM').AsDateTime := fDatum;
  fFeldList.FieldByName('KU_KURS').AsFloat := fKurs;
end;


procedure TKurs.Init;
begin
  inherited;
  fKU_ID := 0;
  fAK_ID := 0;
  fDatum := 0;
  fKurs  := 0;
end;

procedure TKurs.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fId     := aQuery.FieldByName('ku_id').AsInteger;
  fAk_Id  := aQuery.FieldByName('ku_ak_id').AsInteger;
  fDatum  := aQuery.FieldByName('ku_datum').AsDateTime;
  fKurs   := aQuery.FieldByName('ku_kurs').AsFloat;
  FuelleDBFelder;
end;

procedure TKurs.setAK_ID(const Value: Integer);
begin
  UpdateV(fAk_Id, Value);
  fFeldList.FieldByName('KU_AK_ID').AsInteger := Value;
end;

procedure TKurs.setDatum(const Value: TDateTime);
begin
  UpdateV(fDatum, Value);
  fFeldList.FieldByName('KU_DATUM').AsDateTime := Value;
end;

procedure TKurs.setKurs(const Value: real);
begin
  UpdateV(fKurs, Value);
  fFeldList.FieldByName('KU_KURS').AsFloat := Value;
end;


procedure TKurs.ReadDatum(aAr_id: Integer; aDate: TDateTime);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName + ' where KU_DATUM = :Datum and ku_ar_id = :arid';
  fQuery.ParamByName('Datum').AsDateTime := aDate;
  fQuery.ParamByName('arid').AsInteger := aAr_Id;
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;

function TKurs.getLastDatum(aAk_Id: Integer): TDateTime;
begin
  Result := StrToDate('01.01.1900');
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select max(ku_datum) from ' + getTableName + ' where ku_ak_id = ' + IntToStr(aAk_Id);
  OpenTrans;
  try
    fQuery.Open;
    if not fQuery.Eof then
      Result := fQuery.Fields[0].AsDateTime;
  finally
    CommitTrans;
  end;
end;


end.
