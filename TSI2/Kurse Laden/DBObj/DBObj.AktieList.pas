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
    procedure ReadAll;
    procedure ReadAllInBoersenindex(aBI_Id: Integer);
    property Item[Index:Integer]: TAktie read getItem;
    procedure Delete;
  end;

implementation

{ TAktieList }

uses
  System.Contnrs;

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
    fQuery.SQL.Text := 'select * from aktie order by ak_id';
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
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  OpenTrans;
  try
    fQuery.SQL.Text := 'select * from aktie where ak_bi_id = ' + IntToStr(aBI_Id) + ' order by ak_id';
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
