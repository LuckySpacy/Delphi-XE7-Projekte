unit DBObj.AktieList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery,  DBObj.Aktie, Objekt.BasisList,
  DBObj.BasisList, Vcl.StdCtrls;

type
  TAktieList = class(TBasisListDBObj)
  private
    function getItem(Index: Integer): TAktie;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SortTSI27;
    procedure ReadAll;
    procedure ReadAllInBoersenindex(aBI_Id: Integer);
    procedure LeseAlleInBoersenindex(aBI_Id: Integer);
    procedure ReadAllAktien;
    property Item[Index:Integer]: TAktie read getItem;
    procedure Delete;
  end;

implementation

{ TAktieList }

uses
  System.Contnrs;

function TSI27Sortieren(Item1, Item2: Pointer): Integer;
begin
  if (TAktie(Item1).LetzterTISWert27 = TAktie(Item2).LetzterTISWert27) then
  begin
    Result := 0;
    exit;
  end;

  if (TAktie(Item1).LetzterTISWert27 < TAktie(Item2).LetzterTISWert27) then
    Result := 1
  else
    Result := -1;
end;


constructor TAktieList.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TAktieList.Delete;
var
  i1: Integer;
begin
  if fTrans = nil then
    exit;
  OpenTrans;
  try
    for i1 := 0 to fList.Count -1 do
      TAktie(fList.Items[i1]).Delete;
  finally
    CommitTrans;
    fList.Clear;
  end;
end;

destructor TAktieList.Destroy;
begin

  inherited;
end;


function TAktieList.getItem(Index: Integer): TAktie;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TAktie(fList.Items[Index]);
end;



procedure TAktieList.ReadAll;
var
  x: TAktie;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  OpenTrans;
  try
    fQuery.SQL.Text := ' select * ' +
                       ' from aktie' +
                       ' order by ak_id';
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TAktie.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fquery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
  end;
end;

procedure TAktieList.ReadAllInBoersenindex(aBI_Id: Integer);
var
  x: TAktie;
  qry: TIBQuery;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  qry := TIBQuery.Create(nil);
  qry.Transaction := fTrans;
  qry.SQL.Text := 'select tl_wert from tsilast where TL_AK_ID = :akid and TL_WOCHEN = 12';
  OpenTrans;
  qry.Prepare;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  try
    if aBI_Id > 0 then
      fQuery.SQL.Text := ' select * from aktie ' +
                         ' left outer join tsilast on aktie.AK_ID = tsilast.TL_AK_ID and tsilast.TL_WOCHEN = 27' +
                         ' where ak_bi_id = ' + IntToStr(aBI_Id) + ' order by ak_aktie'
    else
      fQuery.SQL.Text := ' select * from aktie ' +
                         ' left outer join tsilast on aktie.AK_ID = tsilast.TL_AK_ID and tsilast.TL_WOCHEN = 27' +
                         ' order by ak_aktie';

    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TAktie.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fquery);
      x.LetzterTISWert12 := 0;
      x.LetzterTISWert27 := fQuery.FieldByName('TL_WERT').AsFloat;
      x.LetzterTISDatum  := fQuery.FieldByName('TL_DATUM').AsDateTime;
      qry.Close;
      qry.ParamByName('akid').AsInteger := x.Id;
      qry.Open;
      if not qry.Eof then
        x.LetzterTISWert12 := qry.FieldByName('TL_WERT').AsFloat;
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
    FreeAndNil(qry);
  end;
end;

procedure TAktieList.SortTSI27;
begin
  fList.Sort(@TSI27Sortieren);
end;

{
procedure TAktieList.ReadAllAktien;
var
  x: TAktie;
  qry: TIBQuery;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  qry := TIBQuery.Create(nil);
  qry.Transaction := fTrans;
  qry.SQL.Text := 'select tl_wert from tsilast where TL_AK_ID = :akid and TL_WOCHEN = 12';
  OpenTrans;
  qry.Prepare;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  try
    fQuery.SQL.Text := ' select * from aktie ' +
                       ' left outer join tsilast on aktie.AK_ID = tsilast.TL_AK_ID and tsilast.TL_WOCHEN = 27' +
                       ' order by ak_aktie';
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TAktie.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fquery);
      x.LetzterTISWert12 := 0;
      x.LetzterTISWert27 := fQuery.FieldByName('TL_WERT').AsFloat;
      x.LetzterTISDatum  := fQuery.FieldByName('TL_DATUM').AsDateTime;
      qry.Close;
      qry.ParamByName('akid').AsInteger := x.Id;
      qry.Open;
      if not qry.Eof then
        x.LetzterTISWert12 := qry.FieldByName('TL_WERT').AsFloat;
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
    FreeAndNil(qry);
  end;
end;
 }

procedure TAktieList.ReadAllAktien;
var
  x: TAktie;
  qry: TIBQuery;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  qry := TIBQuery.Create(nil);
  qry.Transaction := fTrans;
  qry.SQL.Text := 'select tl_wert from tsilast where TL_AK_ID = :akid and TL_WOCHEN = 12';
  OpenTrans;
  qry.Prepare;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  try
    fQuery.SQL.Text := ' select * from aktie ' +
                       ' left outer join tsilast on aktie.AK_ID = tsilast.TL_AK_ID and tsilast.TL_WOCHEN = 27' +
                       ' where ak_aktiv = ' + QuotedStr('T') +
                       ' order by ak_aktie';
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TAktie.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fquery);
      x.LetzterTISWert12 := 0;
      x.LetzterTISWert27 := fQuery.FieldByName('TL_WERT').AsFloat;
      x.LetzterTISDatum  := fQuery.FieldByName('TL_DATUM').AsDateTime;
      qry.Close;
      qry.ParamByName('akid').AsInteger := x.Id;
      qry.Open;
      if not qry.Eof then
        x.LetzterTISWert12 := qry.FieldByName('TL_WERT').AsFloat;
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
    FreeAndNil(qry);
  end;
end;

procedure TAktieList.LeseAlleInBoersenindex(aBI_Id: Integer);
var
  x: TAktie;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  OpenTrans;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  try
    if aBI_Id > 0 then
      fQuery.SQL.Text := ' select * from aktie ' +
                         ' where ak_bi_id = ' + IntToStr(aBI_Id) + ' order by ak_aktie'
    else
      fQuery.SQL.Text := ' select * from aktie ' +
                         ' order by ak_aktie';
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TAktie.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fquery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
  end;
end;


end.
