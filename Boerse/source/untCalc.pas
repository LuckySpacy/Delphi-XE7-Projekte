unit untCalc;

interface

uses
  Classes, IBDatabase, IBQuery, Dialogs, ContNrs, SysUtils, o_db, o_Field,
  o_guvdetail, o_bestand, o_bilanz;


procedure CalcDB(AK_ID: Integer);
procedure Calc_GUVDetail(AK_ID: Integer);
procedure Calc_Bestand(AK_ID: Integer);
procedure Calc_Bilanz(AK_ID: Integer);
procedure Calc_BilanzJMDet;

implementation

uses
  untDM, DateUtils, Controls, Forms;


procedure CalcDB(AK_ID: Integer);
var
  Cur: TCursor;
begin
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    Calc_GUVDetail(AK_ID);
    Calc_Bestand(AK_ID);
    Calc_Bilanz(AK_ID);
  finally
    Screen.Cursor := Cur;
  end;
end;



procedure Calc_GUVDetail(AK_ID: Integer);
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
  GUVDetail      : TGUVDetail;
  eStueckWert    : Double;
  Prozent        : Double;
begin
  IBT_Del_Detail := TIBTransaction.Create(nil);
  IBT_Transfer   := TIBTransaction.Create(nil);
  IBT_Detail     := TIBTransaction.Create(nil);
  qry_Del_Detail := TIBQuery.Create(nil);
  qry_Transfer   := TIBQuery.Create(nil);
  qry_GUVDetail  := TIBQuery.Create(nil);
  GUVDetail      := TGUVDetail.Create(nil, dm.IBT);
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
                             ' order by tr_datum, tr_aktion, tr_id';
    ibt_Transfer.StartTransaction;
    try
      eDatum  := 0;
      eAnzahl := 0;
      eWert   := 0;
      qry_Transfer.Open;
      while not qry_Transfer.Eof do
      begin
        if Trim(qry_Transfer.FieldByName('tr_korrektur').AsString) > '' then
        begin
          qry_Transfer.Next;
          continue;
        end;
        if qry_Transfer.FieldByName('tr_aktion').AsString = 'K' then
        begin
          if eDatum = 0 then
            eDatum := qry_Transfer.FieldByName('tr_datum').AsDateTime;
          eAnzahl := eAnzahl + qry_Transfer.FieldByName('tr_stueck').AsInteger;
          eWert   := eWert   + qry_Transfer.FieldByName('tr_wert').AsCurrency;
        end;

        if eAnzahl = 0 then
        begin
          qry_Transfer.Next;
          continue;
        end;

        if qry_Transfer.FieldByName('tr_aktion').AsString = 'V' then
        begin
          eStueckWert := eWert / eAnzahl;
          GUVDetail.AK_ID.AsInteger   := AK_ID;
          GUVDetail.Stueck.AsInteger  := qry_Transfer.FieldByName('tr_stueck').AsInteger;
          GUVDetail.EDatum.AsDateTime := eDatum;
          GUVDetail.EWert.AsCurrency  := eStueckwert * qry_Transfer.FieldByName('tr_stueck').AsInteger;
          GUVDetail.EKurs.AsCurrency  := GUVDetail.EWert.AsCurrency / qry_Transfer.FieldByName('tr_stueck').AsInteger;
          GUVDetail.VDatum.AsDateTime := qry_Transfer.FieldByName('tr_datum').AsDateTime;
          GUVDetail.VWert.AsCurrency  := qry_Transfer.FieldByName('tr_wert').AsCurrency;
          GUVDetail.VKurs.AsCurrency  := GUVDetail.VWert.AsCurrency / qry_Transfer.FieldByName('tr_stueck').AsInteger;
          GUVDetail.GUV.AsCurrency    := GUVDetail.VWert.AsCurrency - GUVDetail.EWert.AsCurrency;
          Prozent := (GUVDetail.VWert.AsCurrency * 100) / GUVDetail.EWert.AsCurrency;
          if Prozent > 100 then
            Prozent := Prozent - 100
          else
          begin
            Prozent := 100 - Prozent;
            Prozent := Prozent * -1;
          end;
          GUVDetail.GUVPRZ.AsCurrency := Prozent;
          eWert   := eWert - GUVDetail.EWert.AsCurrency;
          eAnzahl := eAnzahl - GUVDetail.Stueck.AsInteger;
          GUVDetail.save;
          GUVDetail.Commit;
          if eAnzahl <= 0 then
            eDatum := 0;
        end;
        qry_Transfer.Next;
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


procedure Calc_Bestand(AK_ID: Integer);
var
  IBT_Transfer: TIBTransaction;
  qry_Transfer : TIBQuery;
  AnzKauf : Integer;
  WertKauf: Currency;
  StueckWert: Currency;
  Bestand  : TBestand;
  TRDatum  : TDateTime;
begin
  IBT_Transfer := TIBTransaction.Create(nil);
  qry_Transfer  := TIBQuery.Create(nil);
  try
    IBT_Transfer.DefaultDatabase := dm.IBD;
    qry_Transfer.Transaction     := IBT_Transfer;
    qry_Transfer.SQL.Text := ' select * from transfer ' +
                             ' where tr_ak_id = ' + IntToStr(AK_ID) +
                             ' order by tr_datum, tr_id';
    IBT_Transfer.StartTransaction;
    qry_Transfer.Open;

    AnzKauf  := 0;
    WertKauf := 0;
    TRDatum  := 0;
    while not qry_Transfer.Eof do
    begin
      if Trim(qry_Transfer.FieldByName('tr_korrektur').AsString) > '' then
      begin
        qry_Transfer.Next;
        continue;
      end;
      if qry_Transfer.FieldByName('tr_aktion').AsString = 'K' then
      begin
        AnzKauf  := AnzKauf  + qry_Transfer.FieldByName('tr_stueck').AsInteger;
        WertKauf := WertKauf + qry_Transfer.FieldByName('tr_wert').AsCurrency;
        if qry_Transfer.FieldByName('tr_datum').AsDateTime > TRDatum then
          TRDatum := qry_Transfer.FieldByName('tr_datum').AsDateTime;
      end;
      if qry_Transfer.FieldByName('tr_aktion').AsString = 'V' then
      begin
        if AnzKauf <= 0 then
        begin
          ShowMessage('Fehler: Es wurde ein Verkauf vor einem Kauf getätigt.' + #13 +
                      'Die Berechnung ist fehlerhaft und wird abgebrochen.' + #13 +
                      'Bitte überprüfe das Datum der einzelne Transaktionen.');
          if IBT_Transfer.InTransaction then
            IBT_Transfer.Rollback;
          exit;
        end;
        StueckWert := WertKauf / AnzKauf;
        AnzKauf  := AnzKauf - qry_Transfer.FieldByName('tr_stueck').AsInteger;
        WertKauf := Stueckwert * AnzKauf;
      end;
      qry_Transfer.Next;
    end;
    Bestand := TBestand.Create(nil, dm.IBT);
    try
      Bestand.ReadA(AK_ID);
      Bestand.AK_ID.AsInteger  := AK_ID;
      if TRDatum = 0 then
        Bestand.DATUM.AsDateTime := now
      else
        Bestand.DATUM.AsDateTime := TRDatum;
      Bestand.STUECK.AsInteger := AnzKauf;
      Bestand.WERT.AsCurrency  := WertKauf;
      if AnzKauf > 0 then
        Bestand.KURS.AsCurrency  := WertKauf / AnzKauf
      else
        Bestand.KURS.AsCurrency  := 0;
      Bestand.Save;
      Bestand.Commit;
    finally
      FreeAndNil(Bestand);
    end;
    if IBT_Transfer.InTransaction then
      IBT_Transfer.Rollback;
  finally
    FreeAndNil(IBT_Transfer);
    FreeAndNil(qry_Transfer);
  end;

end;


procedure Calc_Bilanz(AK_ID: Integer);
var
  IBT_GuVDetail: TIBTransaction;
  qry_GuVDetail : TIBQuery;
  IBT_Bilanz: TIBTransaction;
  qry_Bilanz : TIBQuery;
  Jahr: Integer;
  Summe: Currency;
  EKWert: Currency;
  VKWert: Currency;
  Bilanz: TBilanz;
begin
  IBT_GuVDetail := TIBTransaction.Create(nil);
  qry_GuVDetail := TIBQuery.Create(nil);
  IBT_Bilanz := TIBTransaction.Create(nil);
  qry_Bilanz := TIBQuery.Create(nil);
  Bilanz        := TBilanz.Create(nil, dm.IBT);
  try
    IBT_Bilanz.DefaultDatabase := dm.IBD;
    qry_Bilanz.Transaction := IBT_Bilanz;
    qry_Bilanz.SQL.Text := ' update bilanz set' +
                           ' bi_guv = 0,' +
                           ' bi_guvprz = 0,' +
                           ' bi_vwert = 0,' +
                           ' bi_ewert = 0' +
                           ' where bi_ak_id = ' + IntToStr(AK_ID);
    qry_Bilanz.ExecSQL;
    IBT_Bilanz.Commit;

    IBT_GuVDetail.DefaultDatabase := dm.IBD;
    qry_GuVDetail.Transaction      := IBT_GuVDetail;
    qry_GuVDetail.SQL.Text := ' select * from guvdetail ' +
                             ' where gd_ak_id = ' + IntToStr(AK_ID) +
                             ' order by gd_vdatum';
    IBT_GuVDetail.StartTransaction;
    qry_GuVDetail.Open;
    Jahr := YearOf(qry_GuVDetail.FieldByName('gd_vdatum').AsDateTime);
    Summe  := 0;
    EKWert := 0;
    VKWert := 0;
    if qry_GuVDetail.Eof then
      exit;
    while not qry_GuVDetail.Eof do
    begin
      if Jahr <> YearOf(qry_GuVDetail.FieldByName('gd_vdatum').AsDateTime) then
      begin
        Bilanz.ReadA(AK_ID, Jahr);
        Bilanz.AK_ID.AsInteger   := AK_ID;
        Bilanz.Jahr.AsInteger    := Jahr;
        Bilanz.GuV.AsCurrency    := Summe;
        Bilanz.GuVPrz.AsCurrency := (Summe * 100) / EKWert;
        Bilanz.EWert.AsCurrency  := EKWert;
        Bilanz.VWert.AsCurrency  := VKWert;
        Bilanz.Save;
        Bilanz.Commit;
        Jahr   := YearOf(qry_GuVDetail.FieldByName('gd_vdatum').AsDateTime);
        Summe  := 0;
        EKWert := 0;
        VKWert := 0;
      end;
      Summe  := Summe  + qry_GuVDetail.FieldByName('gd_guv').AsCurrency;
      EKWert := EKWert + qry_GUVDetail.FieldByName('gd_ewert').AsCurrency;
      VKWert := VKWert + qry_GUVDetail.FieldByName('gd_vwert').AsCurrency;
      qry_GuVDetail.Next;
    end;
    Bilanz.ReadA(AK_ID, Jahr);
    Bilanz.AK_ID.AsInteger := AK_ID;
    Bilanz.Jahr.AsInteger  := Jahr;
    Bilanz.GuV.AsCurrency  := Summe;
    //Bilanz.GuVPrz.AsCurrency := (Summe * 100) / EKWert;
    Bilanz.GuVPrz.AsCurrency := (Summe * 100 / VKWert);
    Bilanz.EWert.AsCurrency  := EKWert;
    Bilanz.VWert.AsCurrency  := VKWert;
    Bilanz.Save;
    Bilanz.Commit;
    IBT_GuVDetail.Rollback;
  finally
    FreeAndNil(IBT_GuVDetail);
    FreeAndNil(qry_GuVDetail);
    FreeAndNil(Bilanz);
  end;

end;


procedure Calc_BilanzJMDet;
var
  IBT_Trans: TIBTransaction;
  qry_Trans : TIBQuery;
  IBT_JMDet : TIBTransaction;
  qry_JMDet : TIBQuery;
begin
  IBT_Trans := TIBTransaction.Create(nil);
  qry_Trans := TIBQuery.Create(nil);
  IBT_JMDet := TIBTransaction.Create(nil);
  qry_JMDet := TIBQuery.Create(nil);
  try
    IBT_Trans.DefaultDatabase := dm.IBD;
    qry_Trans.Transaction := IBT_Trans;
    IBT_JMDet.DefaultDatabase := dm.IBD;
    qry_JMDet.Transaction := IBT_Trans;
    qry_JMDet.SQL.Text := 'update bilanzjmdet set jm_kapital = 0, jm_guv = 0';
    IBT_JMDet.StartTransaction;
    qry_JMDet.ExecSQL;
    IBT_JMDet.Commit;
    qry_Trans.SQL.Text := 'select * from transfer order by tr_ak_id, tr_datum';
    qry_Trans.Open;
    while not qry_Trans.Eof do
    begin
      qry_Trans.Next;
    end;
  finally
    FreeAndNil(qry_Trans);
    FreeAndNil(qry_JMDet);
    FreeAndNil(IBT_Trans);
    FreeAndNil(IBT_JMDet);
  end;

end;


end.
