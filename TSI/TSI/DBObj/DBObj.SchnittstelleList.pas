unit DBObj.SchnittstelleList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery,  DBObj.Schnittstelle, Objekt.BasisList,
  DBObj.BasisList, Vcl.StdCtrls;

type
  TSchnittstelleList = class(TBasisListDBObj)
  private
    function getItem(Index: Integer): TSchnittstelle;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadAll;
    property Item[Index:Integer]: TSchnittstelle read getItem;
    procedure LadeCombobox(aItems: TStrings);
    procedure Delete;
  end;

implementation

{ TSchnittstelleList }

constructor TSchnittstelleList.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TSchnittstelleList.Delete;
var
  i1: Integer;
begin
  if fTrans = nil then
    exit;
  OpenTrans;
  try
    for i1 := 0 to fList.Count -1 do
      TSchnittstelle(fList.Items[i1]).Delete;
  finally
    CommitTrans;
    fList.Clear;
  end;
end;

destructor TSchnittstelleList.Destroy;
begin

  inherited;
end;

function TSchnittstelleList.getItem(Index: Integer): TSchnittstelle;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TSchnittstelle(fList.Items[Index]);
end;

procedure TSchnittstelleList.LadeCombobox(aItems: TStrings);
var
  x: TSchnittstelle;
begin
  aItems.Clear;
  if fTrans = nil then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  OpenTrans;
  try
    fQuery.SQL.Text := 'select * from schnittstelle order by ss_name';
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TSchnittstelle.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fquery);
      aItems.AddObject(fQuery.FieldByName('ss_name').AsString, TObject(fQuery.FieldByName('ss_id').AsInteger));
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
  end;
end;

procedure TSchnittstelleList.ReadAll;
var
  x: TSchnittstelle;
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
      x := TSchnittstelle.Create(nil);
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
