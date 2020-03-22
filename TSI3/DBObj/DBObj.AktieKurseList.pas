unit DBObj.AktieKurseList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery,  DBObj.AktieKurse, Objekt.BasisList,
  DBObj.BasisList, Vcl.StdCtrls;

type
  TAktieKurseList = class(TBasisListDBObj)
  private
    function getItem(Index: Integer): TAktieKurse;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadAll;
    procedure ReadAllInBoersenindex(aBI_Id: Integer);
    property Item[Index:Integer]: TAktieKurse read getItem;
    procedure Delete;
  end;

implementation

{ TAktieList }

uses
  System.Contnrs;

constructor TAktieKurseList.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TAktieKurseList.Delete;
var
  i1: Integer;
begin
  if fTrans = nil then
    exit;
  OpenTrans;
  try
    for i1 := 0 to fList.Count -1 do
      TAktieKurse(fList.Items[i1]).Delete;
  finally
    CommitTrans;
    fList.Clear;
  end;
end;

destructor TAktieKurseList.Destroy;
begin

  inherited;
end;


function TAktieKurseList.getItem(Index: Integer): TAktieKurse;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TAktieKurse(fList.Items[Index]);
end;



procedure TAktieKurseList.ReadAll;
var
  x: TAktieKurse;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  OpenTrans;
  try
    fQuery.SQL.Text := 'select * from aktie where ak_aktiv = ' + QuotedStr('T') + ' order by ak_id';
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TAktieKurse.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fquery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
  end;
end;

procedure TAktieKurseList.ReadAllInBoersenindex(aBI_Id: Integer);
var
  x: TAktieKurse;
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
      x := TAktieKurse.Create(nil);
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
