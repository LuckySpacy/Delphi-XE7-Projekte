unit o_BaumStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_BaumStruk_BaseStrukList;


type
  TBaumStrukList = class(TBaumStrukBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ReadAll(aEbene, aBaumButtonId: Integer); reintroduce; overload;
    procedure ReadAllEbenen(aBaumButtonId, aEbene: Integer; aAll: Boolean);
  end;



implementation

uses
  c_DBTypes;

{ TBaumStrukList }

constructor TBaumStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TBaumStrukList.Destroy;
begin

  inherited;
end;

procedure TBaumStrukList.Init;
begin
  inherited;

end;

procedure TBaumStrukList.ReadAll(aEbene, aBaumButtonId: Integer);
var
  x: TDBObj;
begin
  FList.Clear;
  FQuery.Close;
  FQuery.Transaction := Trans;
  FQuery.Sql.Text := ' select * from ' + getTableName +
                     ' join zweigprop on bs_zp_id = zp_id' +
                     ' where BS_DELETE != ' + QuotedStr('T') +
                     ' and   BS_BB_ID = ' + IntToStr(aBaumButtonId) +
                     ' and   BS_EBENE = ' + IntToStr(aEbene) +
                     ' order by zp_text';
  OpenTrans;
  FQuery.Open;
  while not FQuery.Eof do
  begin
    x := Add(FQuery);
    FList.Add(x);
    FQuery.Next;
  end;
  RollbackTrans;
end;


procedure TBaumStrukList.ReadAllEbenen(aBaumButtonId, aEbene: Integer; aAll: Boolean);
  procedure ReadAllEbene(aBaumButtonId, aEbene: Integer);
  var
    qry: TIBQuery;
    x: TDBObj;
  begin
    qry := TIBQuery.Create(nil);
    try
      qry.Sql.Text := ' select * from ' + getTableName +
                      ' join zweigprop on bs_zp_id = zp_id' +
                      ' where BS_DELETE != ' + QuotedStr('T') +
                      ' and   BS_EBENE = ' + IntToStr(aEbene) +
                      ' and   BS_BB_ID = ' + IntToStr(aBaumButtonId) +
                      ' order by zp_text';
      qry.Transaction := Trans;
      qry.Open;
      while not qry.Eof do
      begin
        x := Add(qry);
        FList.Add(x);
        ReadAllEbene(aBaumButtonId, qry.FieldByName('BS_ID').AsInteger);
        qry.Next;
      end;
    finally
      FreeAndNil(qry);
    end;
  end;
var
  x: TDBObj;
begin
  FList.Clear;

  FQuery.Close;
  FQuery.Transaction := Trans;
  FQuery.Sql.Text := ' select * from ' + getTableName +
                     ' where BS_DELETE != ' + QuotedStr('T') +
                     ' and   BS_BB_ID = ' + IntToStr(aBaumButtonId) +
                     ' and   BS_EBENE = ' + IntToStr(aEbene);
  OpenTrans;
  FQuery.Open;
  while not FQuery.Eof do
  begin
    x := Add(FQuery);
    FList.Add(x);
    ReadAllEbene(aBaumButtonId, FQuery.FieldByName('BS_ID').AsInteger);
    if not aAll then
      break;
    FQuery.Next;
  end;
  RollbackTrans;
end;


end.
