unit o_BaumButtonList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_BaumButton_BaseStrukList;


type
  TBaumButtonList = class(TBaumButtonBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ReadAll(aEbene: Integer); reintroduce; overload;
    procedure ReadAllEbenen(aEbene: Integer);
  end;



implementation

{ TBaumButtonList }

uses
  c_DBTypes;

constructor TBaumButtonList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TBaumButtonList.Destroy;
begin

  inherited;
end;

procedure TBaumButtonList.Init;
begin
  inherited;

end;

procedure TBaumButtonList.ReadAll(aEbene: Integer);
var
  x: TDBObj;
begin
  FList.Clear;
  FQuery.Close;
  FQuery.Transaction := Trans;
  FQuery.Sql.Text := ' select * from ' + getTableName +
                     ' join buttonprop on bb_bp_id = bp_id' +
                     ' where BB_DELETE != ' + QuotedStr('T') +
                     ' and   BB_EBENE = ' + IntToStr(aEbene) +
                     ' order by bp_text';
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

procedure TBaumButtonList.ReadAllEbenen(aEbene: Integer);
  procedure ReadAllEbene(aEbene: Integer);
  var
    qry: TIBQuery;
    x: TDBObj;
  begin
    qry := TIBQuery.Create(nil);
    try
      qry.Sql.Text := ' select * from ' + getTableName +
                      ' join buttonprop on bb_bp_id = bp_id' +
                      ' where BB_DELETE != ' + QuotedStr('T') +
                      ' and   BB_EBENE = ' + IntToStr(aEbene) +
                      ' order by bp_text';
      qry.Transaction := Trans;
      qry.Open;
      while not qry.Eof do
      begin
        x := Add(qry);
        FList.Add(x);
        ReadAllEbene(qry.FieldByName('BB_BP_ID').AsInteger);
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
                     ' join buttonprop on bb_bp_id = bp_id' +
                     ' where BB_DELETE != ' + QuotedStr('T') +
                     ' and   BB_ID = ' + IntToStr(aEbene) +
                     ' order by bp_text';

  FQuery.Open;
  if FQuery.Eof then
    exit;
  x := Add(FQuery);
  FList.Add(x);
  FQuery.Close;

  FQuery.Sql.Text := ' select * from ' + getTableName +
                     ' join buttonprop on bb_bp_id = bp_id' +
                     ' where BB_DELETE != ' + QuotedStr('T') +
                     ' and   BB_EBENE = ' + IntToStr(aEbene) +
                     ' order by bp_text';
  OpenTrans;
  FQuery.Open;
  while not FQuery.Eof do
  begin
    x := Add(FQuery);
    FList.Add(x);
    ReadAllEbene(FQuery.FieldByName('BB_BP_ID').AsInteger);
    FQuery.Next;
  end;
  RollbackTrans;
end;

end.
