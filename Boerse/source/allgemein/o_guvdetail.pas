unit o_guvdetail;

interface

uses
  Classes, IBDatabase, IBQuery, Dialogs, ContNrs, SysUtils, o_db, o_Field;

type TGUVDetail = class(TDB)
  private
    FIBT   : TIBTransaction;
    FAK_ID : TTBField;
    FStueck: TTBField;
    FEDatum: TTBField;
    FEWert : TTBField;
    FEKurs : TTBField;
    FVDatum: TTBField;
    FVWert : TTBField;
    FVKurs : TTBField;
    FGUV   : TTBField;
    FGUVPRZ: TTBField;
    procedure SetTransaction(const Value: TIBTransaction);
  protected
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure setSaveSqlText; override;
    procedure SetValues(aQuery: TIBQuery); override;
  published
  public
    constructor Create(AOwner: TComponent; aIBT: TIBTransaction); override;
    destructor Destroy; override;
    property Transaction: TIBTransaction read FIBT write SetTransaction;
    procedure Reload(AK_ID: Integer);
    property AK_ID: TTBField read FAK_ID;
    property Stueck: TTBField read FStueck;
    property EDatum: TTBField read FEDatum;
    property EWert: TTBField read FEWert;
    property EKurs: TTBField read FEKurs;
    property VDatum: TTBField read FVDatum;
    property VWert: TTBField read FVWert;
    property VKurs: TTBField read FVKurs;
    property GUV: TTBField read FGUV;
    property GUVPRZ: TTBField read FGUVPRZ;
  end;


implementation

{ TGUVDetail }

uses
  untDM;

constructor TGUVDetail.Create(AOwner: TComponent; aIBT: TIBTransaction);
begin
  inherited;
  FIBT    := aIBT;
  FAK_ID  := AddField;
  FStueck := AddField;
  FEDatum := AddField;
  FEWert  := AddField;
  FEKurs  := AddField;
  FVDatum := AddField;
  FVWert  := AddField;
  FVKurs  := AddField;
  FGUV    := AddField;
  FGUVPRZ := AddField;
end;

destructor TGUVDetail.Destroy;
begin

  inherited;
end;

function TGUVDetail.getTableName: string;
begin
  Result := 'GUVDETAIL';
end;

function TGUVDetail.getTablePrefix: string;
begin
  Result := 'GD';
end;


procedure TGUVDetail.setSaveSqlText;
var
  Sql: string;
begin
  if FFound then
  begin
    Sql := ' update guvdetail set' +
           ' gd_ak_id  = :ak_id,' +
           ' gd_stueck = :stueck,' +
           ' gd_edatum = :edatum,' +
           ' gd_ewert  = :ewert,' +
           ' gd_ekurs  = :ekurs,' +
           ' gd_vdatum = :vdatum,' +
           ' gd_vwert  = :vwert,' +
           ' gd_vkurs  = :vkurs,' +
           ' gd_guv    = :guv,' +
           ' gd_guvprz = :guvprz' +
           ' where ak_id = :id';
  end
  else
  begin

    Sql := ' insert into guvdetail (' +
           ' gd_id, gd_ak_id, gd_stueck, gd_edatum, gd_ewert, gd_ekurs, ' +
           ' gd_vdatum, gd_vwert, gd_vkurs, gd_guv, gd_guvprz)' +
           ' values (' +
           ' :id, :ak_id, :stueck, :edatum, :ewert, :ekurs, ' +
           ' :vdatum, :vwert, :vkurs, :guv, :guvprz)';

  end;

  FQuery.SQL.Text := Sql;

  FQuery.Params.ParamByName('id').AsInteger      := Fid;
  FQuery.Params.ParamByName('ak_id').AsInteger   := FAK_ID.AsInteger;
  FQuery.Params.ParamByName('stueck').AsCurrency := FStueck.AsCurrency;
  FQuery.Params.ParamByName('edatum').AsDate     := FEDatum.AsDateTime;
  FQuery.Params.ParamByName('ewert').AsCurrency  := FEWert.AsCurrency;
  FQuery.Params.ParamByName('ekurs').AsCurrency  := FEKurs.AsCurrency;
  FQuery.Params.ParamByName('vdatum').AsDate     := FVDatum.AsDateTime;
  FQuery.Params.ParamByName('vwert').AsCurrency  := FVWert.AsCurrency;
  FQuery.Params.ParamByName('vkurs').AsCurrency  := FVKurs.AsCurrency;
  FQuery.Params.ParamByName('guv').AsCurrency    := FGUV.AsCurrency;
  FQuery.Params.ParamByName('guvprz').AsCurrency := FGUVPRZ.AsCurrency;
end;

procedure TGUVDetail.SetTransaction(const Value: TIBTransaction);
begin

end;

procedure TGUVDetail.SetValues(aQuery: TIBQuery);
begin
  inherited;

end;


procedure TGUVDetail.Reload(AK_ID: Integer);
var
  IBT_Del_Detail: TIBTransaction;
  IBT_Transfer: TIBTransaction;
  IBT_Detail  : TIBTransaction;
  qry_Del_Detail: TIBQuery;
  qry_Transfer  : TIBQuery;
  qry_GUVDetail : TIBQuery;
  eAnzahl        : Integer;
  eWert          : Currency;
  eDatum         : TDateTime;
  vAnzahl        : Integer;
  vWert          : Currency;
  vDatum         : TDateTime;
begin
  IBT_Del_Detail := TIBTransaction.Create(Self);
  IBT_Transfer   := TIBTransaction.Create(Self);
  IBT_Detail     := TIBTransaction.Create(Self);
  qry_Del_Detail := TIBQuery.Create(Self);
  qry_Transfer   := TIBQuery.Create(Self);
  qry_GUVDetail  := TIBQuery.Create(Self);
  try
    IBT_Del_Detail.DefaultDatabase := dm.IBD;
    IBT_Transfer.DefaultDatabase   := dm.IBD;
    IBT_Detail.DefaultDatabase     := dm.IBD;
    qry_GUVDetail.Transaction      := IBT_Detail;
    qry_Del_Detail.Transaction     := IBT_Del_Detail;
    qry_Transfer.Transaction       := IBT_Transfer;
    qry_Del_Detail.SQL.Text := ' delete from guvdetail where gd_ak_id = ' + IntToStr(ak_id);
    IBT_Del_Detail.StartTransaction;
    qry_Del_Detail.ExecSQL;
    IBT_Del_Detail.Commit;
    qry_Transfer.SQL.Text := ' select * from transfer' +
                             ' where tr_ak_id = ' + IntToStr(ak_id) +
                             ' order by tr_datum, tr_aktion';
    ibt_Transfer.StartTransaction;
    try
      eDatum  := 0;
      eAnzahl := 0;
      eWert   := 0;
      vDatum  := 0;
      vAnzahl := 0;
      vWert   := 0;
      qry_Transfer.Open;
      while not qry_Transfer.Eof do
      begin
        if qry_Transfer.FieldByName('tr_aktion').AsString = 'K' then
        begin
          if eDatum = 0 then
            eDatum := qry_Transfer.FieldByName('tr_datum').AsDateTime;
          eAnzahl := eAnzahl + qry_Transfer.FieldByName('tr_stueck').AsInteger;
          eWert   := eWert   + qry_Transfer.FieldByName('tr_wert').AsCurrency;
        end;
        if qry_Transfer.FieldByName('tr_aktion').AsString = 'V' then
        begin
          if vDatum = 0 then
            vDatum := qry_Transfer.FieldByName('tr_datum').AsDateTime;
          vAnzahl := vAnzahl + qry_Transfer.FieldByName('tr_stueck').AsInteger;
          vWert   := vWert   + qry_Transfer.FieldByName('tr_wert').AsCurrency;
        end;

        if eAnzahl = 0 then
        begin
          qry_Transfer.Next;
          continue;
        end;

        if eAnzahl - vAnzahl <= 0 then
        begin
          FAK_ID.AsInteger   := AK_ID;
          FStueck.AsInteger  := eAnzahl;
          FEDatum.AsDateTime := trunc(eDatum);
          FEWert.AsCurrency  := eWert;
          FEKurs.AsCurrency  := eWert / eAnzahl;
          FVDatum.AsDateTime := trunc(vDatum);
          FVWert.AsCurrency  := vWert;
          FVKurs.AsCurrency  := vWert / vAnzahl;
          FGUV.AsCurrency    := FVWert.AsCurrency - FEWert.AsCurrency;
          save;
          eDatum  := 0;
          eAnzahl := 0;
          eWert   := 0;
          vDatum  := 0;
          vAnzahl := 0;
          vWert   := 0;
        end;
        qry_Transfer.Next;
      end;

      if eAnzahl > 0 then
      begin
        FAK_ID.AsInteger   := AK_ID;
        FStueck.AsInteger  := eAnzahl - vAnzahl;
        FEDatum.AsDateTime := trunc(eDatum);
        FEWert.AsCurrency  := eWert;
        FEKurs.AsCurrency  := eWert / eAnzahl;
        FVDatum.AsDateTime := 0;
        FVWert.AsCurrency  := 0;
        FVKurs.AsCurrency  := 0;
        FGUV.AsCurrency    := 0;
        save;
      end;

    finally
      ibt_Transfer.Rollback;
    end;
  finally
    FreeAndNil(IBT_Del_Detail);
    FreeAndNil(IBT_Transfer);
    FreeAndNil(qry_Del_Detail);
    FreeAndNil(qry_Transfer);
    FreeAndNil(qry_GUVDetail);
    FreeAndNil(IBT_Detail);
  end;

end;


end.
