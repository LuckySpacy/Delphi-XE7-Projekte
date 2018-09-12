unit o_bestand;

interface

uses
  Classes, IBDatabase, IBQuery, Dialogs, ContNrs, SysUtils, o_db, o_Field;

type TBestand = class(TDB)
  private
    FIBT   : TIBTransaction;
    FAK_ID: TTBField;
    FDATUM: TTBField;
    FSTUECK: TTBField;
    FWERT: TTBField;
    FKURS: TTBField;
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
    property DATUM: TTBField read FDATUM;
    property STUECK: TTBField read FSTUECK;
    property WERT: TTBField read FWERT;
    property KURS: TTBField read FKURS;
    property Transaction: TIBTransaction read FIBT;
    procedure ReadA(ak_id: integer);
  end;


implementation

{ TTransfer }

constructor TBestand.Create(AOwner: TComponent; aIBT: TIBTransaction);
begin
  inherited;
  FIBT  := aIBT;
  FAK_ID  := AddField;
  FDatum  := AddField;
  FStueck  := AddField;
  FWert  := AddField;
  FKurs  := AddField;
end;

destructor TBestand.Destroy;
begin

  inherited;
end;

function TBestand.getTableName: string;
begin
  Result := 'BESTAND';
end;

function TBestand.getTablePrefix: string;
begin
  Result := 'BS';
end;


procedure TBestand.setSaveSqlText;
var
  Sql: string;
begin
  if FFound then
  begin
    Sql := ' update bestand set' +
           ' bs_ak_id  = :ak_id,' +
           ' bs_datum  = :datum,' +
           ' bs_stueck  = :stueck,' +
           ' bs_wert    = :wert,' +
           ' bs_kurs    = :kurs ' +
           ' where bs_id = :id';
  end
  else
  begin

    Sql := ' insert into bestand (' +
           ' bs_id, bs_ak_id, bs_datum, bs_stueck, bs_wert, bs_kurs) ' +
           ' values (' +
           ' :id, :ak_id, :datum, :stueck, :wert, :kurs)';
  end;

  FQuery.SQL.Text := Sql;

  FQuery.Params.ParamByName('ak_id').AsInteger := FAK_ID.AsInteger;
  FQuery.Params.ParamByName('datum').AsDate      := trunc(FDatum.AsDateTime);
  FQuery.Params.ParamByName('stueck').AsCurrency := FStueck.AsCurrency;
  FQuery.Params.ParamByName('wert').AsCurrency   := FWert.AsCurrency;
  if FStueck.AsInteger > 0 then
    FQuery.Params.ParamByName('kurs').AsCurrency   := FWert.AsCurrency / FStueck.AsInteger
  else
    FQuery.Params.ParamByName('kurs').AsCurrency   := 0;
  FQuery.Params.ParamByName('id').AsInteger    := Fid;
end;

procedure TBestand.SetValues(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  FAK_ID.AsString    := aQuery.FieldByName('bs_ak_id').AsString;
  FDatum.AsDateTime  := aQuery.FieldByName('bs_datum').AsDateTime;
  FStueck.AsCurrency := aQuery.FieldByName('bs_stueck').AsCurrency;
  FWert.AsCurrency   := aQuery.FieldByName('bs_wert').AsCurrency;
  FKurs.AsCurrency   := aQuery.FieldByName('bs_kurs').AsCurrency;
  FFound := true;
end;

procedure TBestand.ReadA(ak_id: integer);
begin
  FQuery.Close;
  FQuery.SQL.Text := ' select * from bestand' +
                     ' where bs_ak_id = ' + IntToStr(ak_id);
  FQuery.Open;
  SetValues(FQuery);
end;


end.
