unit o_deletebaum;

interface

uses
  SysUtils, Classes, IBDatabase, IBQuery, obServerClient, o_Msg;


type
  TDeleteBaum = class(TComponent)
  private
  public
    procedure DeleteBaumButton(aBB_Id: Integer; aTrans: TIBTransaction);
    procedure DeleteBaumStruk(aBB_Id, aEbene: Integer; aAll: Boolean; aTrans: TIBTransaction);
    procedure DeleteSeite(aSE_ID: Integer; aTrans: TIBTransaction);
    procedure DeleteSeiteverbinden(aEbene, aBS_ID: Integer; aTrans: TIBTransaction);
    function DeleteFromList(aList: TStrings; aBaumEbene, aEbene: Integer; aTrans: TIBTransaction): Boolean;
  end;

implementation

uses
  o_BaumButton, o_BaumButtonList, o_Buttonprop, o_Buttonproplist,
  o_Baumstruk, o_Baumstruklist, o_Zweigprop, vcl.dialogs, c_dbTypes,
  o_seiteverbinden, o_SeiteDokumentList, o_Seite, o_Dokument, o_sysobj;

{ TDeleteBaum }

procedure TDeleteBaum.DeleteBaumButton(aBB_Id: Integer; aTrans: TIBTransaction);
var
  BaumButtonList: TBaumButtonList;
  BaumStrukList : TBaumstrukList;
  i1 : Integer;
  //i2: Integer;
  BaumButton: TBaumButton;
  Buttonprop: TButtonprop;
  ZweigProp: TZweigProp;
  WasOpen: Boolean;
  WasIBTCreated: Boolean;
begin
  WasIBTCreated := true;
  if aTrans = nil then
  begin
    WasIBTCreated := false;
    aTrans := TIBTransaction.Create(nil);
    aTrans.DefaultDatabase := SysObj.Database;
    aTrans.Name := 'tra_DeleteBaum';
  end;
  WasOpen := aTrans.InTransaction;
  try

    if not aTrans.InTransaction then
      aTrans.StartTransaction;
    Buttonprop     := TButtonprop.Create(nil);
    Zweigprop      := TZweigprop.Create(nil);
    BaumStrukList  := TBaumstrukList.Create(nil);
    BaumButtonList := TBaumButtonList.Create(nil);
    try
      Buttonprop.Trans := ATrans;
      Zweigprop.Trans  := ATrans;
      BaumstrukList.Trans := ATrans;
      BaumButtonList.Trans := ATrans;
      BaumButtonList.ReadAllEbenen(aBB_Id);
      for i1 := 0 to BaumButtonList.Count -1 do
      begin
        BaumButton := BaumButtonList.Item[i1];
        Buttonprop.Read(BaumButton.Feld(BB_BP_ID).AsInteger);
        if not Buttonprop.Found then
          continue;
        DeleteBaumStruk(BaumButton.Id, 0, true, aTrans);
        DeleteSeiteverbinden(BaumButton.Feld(BB_BP_ID).AsInteger, 0, aTrans);
        Buttonprop.Delete;
      end;
    finally
      FreeAndNil(BaumButtonList);
      FreeAndNil(BaumStrukList);
      FreeAndNil(Buttonprop);
      FreeAndNil(Zweigprop);
    end;
  finally
    if (not WasOpen) and (aTrans.InTransaction) then
      aTrans.Commit;
    if not WasIBTCreated then
      FreeAndNil(aTrans);
  end;
end;

function TDeleteBaum.DeleteFromList(aList: TStrings; aBaumEbene, aEbene: Integer; aTrans: TIBTransaction): Boolean;
var
  i1: Integer;
  BaumStrukList: TBaumstrukList;
  BaumStruk: TBaumStruk;
  Zweigprop: TZweigprop;
  Id: Integer;
  qry: TIBQuery;
begin
  Result := true;
  qry := TIBQuery.Create(nil);
  try
    qry.Transaction := aTrans;
    qry.SQL.Text := ' select * from seiteverbindung ' +
                    ' join seitedokument on sd_se_id = vs_se_id and sd_delete != ' + QuotedStr('T') +
                    ' where vs_delete != ' + QuotedStr('T') +
                    ' and   vs_bs_id = :bs_id';
    qry.Prepare;
    for i1 := 0 to aList.Count -1 do
    begin
      if not TryStrToInt(aList.Strings[i1], Id) then
        continue;
      qry.Close;
      qry.ParamByName('bs_id').AsInteger := Id;
      qry.Open;
      if not qry.Eof then
      begin
        Result := false;
        ShowMessage('Es sind Dokumenten verknüpft.' + sLineBreak +
                    'Bitte löschen Sie vorher alle Dokumente manuell.');
        exit;
      end;
    end;
  finally
    qry.Close;
    qry.UnPrepare;
    FreeAndNil(qry);
  end;
  Zweigprop := TZweigprop.Create(nil);
  BaumStruk := TBaumStruk.Create(nil);
  BaumStrukList := TBaumstrukList.Create(nil);
  try
    BaumStruk.Trans := aTrans;
    BaumStrukList.Trans := aTrans;
    Zweigprop.Trans := aTrans;
    for i1 := 0 to aList.count -1 do
    begin
      if not TryStrToInt(aList.Strings[i1], Id) then
        continue;
      BaumStruk.Read(Id);
      if not Baumstruk.Found then
        continue;
      Zweigprop.Read(BaumStruk.Feld(BS_ZP_ID).AsInteger);
      if Zweigprop.Found then
        Zweigprop.Delete;
      DeleteSeiteverbinden(aEbene, Id, aTrans);
      Baumstruk.Delete;
    end;
  finally
    FreeAndNil(BaumStrukList);
    FreeAndNil(BaumStruk);
    FreeAndNil(Zweigprop);
  end;
end;


procedure TDeleteBaum.DeleteBaumStruk(aBB_Id, aEbene: Integer; aAll: Boolean; aTrans: TIBTransaction);
var
  BaumStrukList: TBaumstrukList;
  BaumStruk: TBaumStruk;
  Zweigprop: TZweigprop;
  i1: Integer;
begin
  Zweigprop := TZweigprop.Create(nil);
  BaumStruk := TBaumStruk.Create(nil);
  BaumStrukList := TBaumstrukList.Create(nil);
  try
    BaumStruk.Trans := aTrans;
    BaumStrukList.Trans := aTrans;
    Zweigprop.Trans := aTrans;
    //BaumStrukList.ReadAllEbenen(aEbene, aBB_Id, aAll);
    BaumStrukList.ReadAllEbenen(aBB_Id, aEbene, aAll);
    for i1 := 0 to BaumStrukList.Count -1 do
    begin
      BaumStruk.Read(Baumstruklist.Item[i1].Id);
      if not Baumstruk.Found then
        continue;
      Zweigprop.Read(BaumStruk.Feld(BS_ZP_ID).AsInteger);
      if Zweigprop.Found then
        Zweigprop.Delete;
      DeleteSeiteverbinden(aBB_Id, Baumstruklist.Item[i1].Id, aTrans);
      Baumstruk.Delete;
    end;
  finally
    FreeAndNil(BaumStrukList);
    FreeAndNil(BaumStruk);
    FreeAndNil(Zweigprop);
  end;
end;


procedure TDeleteBaum.DeleteSeite(aSE_ID: Integer; aTrans: TIBTransaction);
var
  Seite: TSeite;
  SeiteDokumentList: TSeiteDokumentList;
  i1: Integer;
  DoId: Integer;
  Dokument: TDokument;
  WasOpen: Boolean;
begin
  WasOpen := aTrans.InTransaction;
  try
    if not aTrans.InTransaction then
      aTrans.StartTransaction;
    Dokument := TDokument.Create(nil);
    SeiteDokumentList := TSeiteDokumentList.Create(nil);
    try
      Dokument.Trans := ATrans;
      SeiteDokumentList.Trans := ATrans;
      SeiteDokumentList.ReadAll(aSE_ID);
      for i1 := 0 to SeiteDokumentList.Count -1 do
      begin
        DoId := SeiteDokumentList.Item[i1].Feld(SD_DO_ID).AsInteger;
        SeiteDokumentlist.Item[i1].Delete;
        if not SeiteDokumentlist.ExistsDokument(DoId) then
        begin
          Dokument.Read(DoId);
          if Dokument.Found then
            Dokument.Delete;
        end;
      end;
    finally
      FreeAndNil(SeiteDokumentList);
      FreeAndNil(Dokument);
    end;
    Seite := TSeite.Create(nil);
    try
      Seite.Trans := ATrans;
      Seite.Read(aSE_ID);
      if Seite.Found then
        Seite.Delete;
    finally
      FreeAndNil(Seite);
    end;
  finally
    if (not WasOpen) and (aTrans.InTransaction) then
      aTrans.Commit;
  end;

end;




procedure TDeleteBaum.DeleteSeiteverbinden(aEbene, aBS_ID: Integer; aTrans: TIBTransaction);
var
  WasOpen: Boolean;
  Seiteverbinden: TSeiteverbinden;
  SE_ID: Integer;
begin
  WasOpen := aTrans.InTransaction;
  Seiteverbinden := TSeiteverbinden.Create(nil);
  try
    Seiteverbinden.Trans := aTrans;
    Seiteverbinden.Read(aEbene, aBS_Id);
    if not Seiteverbinden.Found then
      exit;
    SE_ID := Seiteverbinden.Feld(VS_SE_ID).AsInteger;
    Seiteverbinden.Delete;
    if not Seiteverbinden.ExistsSeite(SE_ID) then
      DeleteSeite(SE_ID, aTrans);
  finally
    FreeAndNil(Seiteverbinden);
    if (not WasOpen) and (aTrans.InTransaction) then
      aTrans.Commit;
  end;
end;

end.
