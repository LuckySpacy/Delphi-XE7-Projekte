unit o_bilanz;

interface

uses
  Classes, IBDatabase, IBQuery, Dialogs, ContNrs, SysUtils, o_db, o_Field;

type TBilanz = class(TDB)
  private
    FIBT   : TIBTransaction;
    FAK_ID : TTBField;
    FJahr  : TTBField;
    FGuV   : TTBField;
    FGuvPrz: TTBField;
    FEWert : TTBField;
    FVWert : TTBField;
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
    property Jahr: TTBField read FJahr;
    property GuV: TTBField read FGuV;
    property GuVPrz: TTBField read FGuVPrz;
    property EWert: TTBField read FEWert;
    property VWert: TTBField read FVWert;
    property Transaction: TIBTransaction read FIBT;
    procedure ReadA(ak_id: integer; aJahr: Integer);
  end;


implementation

{ TBestand }

constructor TBilanz.Create(AOwner: TComponent; aIBT: TIBTransaction);
begin
  inherited;
  FIBT    := aIBT;
  FAK_ID  := AddField;
  FJahr   := AddField;
  FGuV    := AddField;
  FGuvPrz := AddField;
  FEWert  := AddField;
  FVWert  := AddField;
end;

destructor TBilanz.Destroy;
begin

  inherited;
end;

function TBilanz.getTableName: string;
begin
  Result := 'BILANZ';
end;

function TBilanz.getTablePrefix: string;
begin
  Result := 'BI';
end;


procedure TBilanz.setSaveSqlText;
var
  Sql: string;
begin
  if FFound then
  begin
    Sql := ' update bilanz set' +
           ' bi_ak_id  = :ak_id,' +
           ' bi_jahr   = :jahr,' +
           ' bi_guv    = :guv,' +
           ' bi_ewert  = :ewert,' +
           ' bi_vwert  = :vwert,' +
           ' bi_guvprz = :guvprz' +
           ' where bi_id = :id';
  end
  else
  begin

    Sql := ' insert into bilanz (' +
           ' bi_id, bi_ak_id, bi_jahr, bi_guv, bi_guvprz, bi_ewert, bi_vwert) ' +
           ' values (' +
           ' :id, :ak_id, :jahr, :guv, :guvprz, :ewert, :vwert)';
  end;

  FQuery.SQL.Text := Sql;

  FQuery.Params.ParamByName('ak_id').AsInteger   := FAK_ID.AsInteger;
  FQuery.Params.ParamByName('jahr').AsInteger    := FJahr.AsInteger;
  FQuery.Params.ParamByName('guv').AsCurrency    := FGuV.AsCurrency;
  FQuery.Params.ParamByName('guvprz').AsCurrency := FGuVPrz.AsCurrency;
  FQuery.Params.ParamByName('ewert').AsCurrency  := FEWert.AsCurrency;
  FQuery.Params.ParamByName('vwert').AsCurrency  := FVWert.AsCurrency;
  FQuery.Params.ParamByName('id').AsInteger      := Fid;
end;

procedure TBilanz.SetValues(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  FAK_ID.AsString    := aQuery.FieldByName('bi_ak_id').AsString;
  FJahr.AsInteger    := aQuery.FieldByName('bi_jahr').AsInteger;
  FGuV.AsCurrency    := aQuery.FieldByName('bi_guv').AsCurrency;
  FGuVPrz.AsCurrency := aQuery.FieldByName('bi_guvprz').AsCurrency;
  FEWert.AsCurrency  := aQuery.FieldByName('bi_ewert').AsCurrency;
  FVWert.AsCurrency  := aQuery.FieldByName('bi_vwert').AsCurrency;
end;

procedure TBilanz.ReadA(ak_id: integer; aJahr: Integer);
begin
  FQuery.Close;
  FQuery.SQL.Text := ' select * from bilanz' +
                     ' where bi_ak_id = ' + IntToStr(ak_id) +
                     ' and bi_jahr = ' + IntToStr(aJahr);
  FQuery.Open;
  SetValues(FQuery);
end;


end.
