unit DBObj.KursList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery,  DBObj.Kurs, Objekt.BasisList,
  DBObj.BasisList, Vcl.StdCtrls;

type
  TKursList = class(TBasisListDBObj)
  private
    function getItem(Index: Integer): TKurs;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadAll(aAk_Id: Integer); overload;
    procedure ReadAll(aAk_Id: Integer; aStartDatum, aEndDatum: TDateTime); overload;
    property Item[Index:Integer]: TKurs read getItem;
    procedure Delete;
  end;

implementation

{ TKursList }

uses
  System.Contnrs;


constructor TKursList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TKursList.Destroy;
begin

  inherited;
end;


procedure TKursList.Delete;
var
  i1: Integer;
begin
  if fTrans = nil then
    exit;
  OpenTrans;
  try
    for i1 := 0 to fList.Count -1 do
      TKurs(fList.Items[i1]).Delete;
  finally
    CommitTrans;
    fList.Clear;
  end;
end;


function TKursList.getItem(Index: Integer): TKurs;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TKurs(fList.Items[Index]);
end;

procedure TKursList.ReadAll(aAk_Id: Integer; aStartDatum, aEndDatum: TDateTime);
var
  x: TKurs;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  OpenTrans;
  try
    fQuery.SQL.Text := ' select * from kurs ' +
                       ' where ku_ak_id = ' + IntToStr(aAk_Id) +
                       ' and   ku_datum >= :Startdatum' +
                       ' and   ku_datum <= :Endedatum' +
                       ' order by ku_datum';
    fquery.ParamByName('Startdatum').AsDate := aStartDatum;
    fQuery.ParamByName('Endedatum').AsDate  := aEndDatum;
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TKurs.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fquery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
  end;
end;

procedure TKursList.ReadAll(aAk_Id: Integer);
var
  x: TKurs;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  OpenTrans;
  try
    fQuery.SQL.Text := ' select * from kurs ' +
                       ' where ku_ak_id = ' + IntToStr(aAk_Id) +
                       ' order by ku_datum';
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TKurs.Create(nil);
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
