unit DBObj.BoersenindexList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery,  DBObj.Boersenindex, Objekt.BasisList,
  DBObj.BasisList, Vcl.StdCtrls;

type
  TBoersenindexList = class(TBasisListDBObj)
  private
    function getItem(Index: Integer): TBoersenindex;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadAll;
    property Item[Index:Integer]: TBoersenindex read getItem;
    procedure LadeCombobox(aItems: TStrings);
    procedure Delete;
  end;

implementation

{ TBoersenindexList }

uses
  System.Contnrs;

constructor TBoersenindexList.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TBoersenindexList.Delete;
var
  i1: Integer;
begin
  if fTrans = nil then
    exit;
  OpenTrans;
  try
    for i1 := 0 to fList.Count -1 do
      TBoersenindex(fList.Items[i1]).Delete;
  finally
    CommitTrans;
    fList.Clear;
  end;
end;

destructor TBoersenindexList.Destroy;
begin

  inherited;
end;

function TBoersenindexList.getItem(Index: Integer): TBoersenindex;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TBoersenindex(fList.Items[Index]);
end;


procedure TBoersenindexList.ReadAll;
var
  x: TBoersenindex;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  OpenTrans;
  try
    fQuery.SQL.Text := 'select * from boersenindex order by bi_id';
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TBoersenindex.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fquery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
  end;
end;


procedure TBoersenindexList.LadeCombobox(aItems: TStrings);
var
  x: TBoersenindex;
begin
  aItems.Clear;
  if fTrans = nil then
    exit;
  aItems.AddObject('Alle', TObject(0));
  fQuery.Close;
  fQuery.Transaction := fTrans;
  OpenTrans;
  try
    fQuery.SQL.Text := 'select * from boersenindex order by bi_id';
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TBoersenindex.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fquery);
      aItems.AddObject(fQuery.FieldByName('bi_name').AsString, TObject(fQuery.FieldByName('bi_id').AsInteger));
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
  end;
end;


end.
