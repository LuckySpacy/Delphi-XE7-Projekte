unit DBObj.AkStList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery,  DBObj.AkSt, Objekt.BasisList,
  DBObj.BasisList, Vcl.StdCtrls;

type
  TAkStList = class(TBasisListDBObj)
  private
    function getItem(Index: Integer): TAkSt;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadAll(aSchnittstelleId, aBoersenIndexId: Integer);
    property Item[Index:Integer]: TAkSt read getItem;
    procedure Delete;
    procedure DeleteAktie(aAkId: Integer);
  end;

implementation

{ TAkStList }

uses
  System.Contnrs;

constructor TAkStList.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TAkStList.Delete;
var
  i1: Integer;
begin
  if fTrans = nil then
    exit;
  OpenTrans;
  try
    for i1 := 0 to fList.Count -1 do
      TAkSt(fList.Items[i1]).Delete;
  finally
    CommitTrans;
    fList.Clear;
  end;
end;


destructor TAkStList.Destroy;
begin

  inherited;
end;

function TAkStList.getItem(Index: Integer): TAkSt;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TAkSt(fList.Items[Index]);
end;

procedure TAkStList.ReadAll(aSchnittstelleId, aBoersenIndexId: Integer);
var
  x: TAkSt;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  OpenTrans;
  try
    fQuery.SQL.Text := ' select * ' +
                       ' from AkSt' +
                       ' order by ak_id';
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TAkSt.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fquery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
  end;
end;

procedure TAkStList.DeleteAktie(aAkId: Integer);
begin
  if fTrans = nil then
    exit;
  OpenTrans;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  OpenTrans;
  try
    fQuery.SQL.Text := ' delete ' +
                       ' from AkSt' +
                       ' where as_ak_id = ' + IntToStr(aAkId);
    fquery.ExecSQL;
  finally
    CommitTrans;
  end;
end;


end.
