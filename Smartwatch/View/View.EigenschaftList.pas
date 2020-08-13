unit View.EigenschaftList;

interface

uses
  SysUtils, Classes, Contnrs, DB.BaseList, View.Eigenschaft;

type
  TViewEigenschaftList = class(TDBBaseList)
  private
    function getItem(Index: Integer): TViewEigenschaft;
    procedure setFieldNeu;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Item[Index:Integer]: TViewEigenschaft read getItem;
    procedure ReadAll;
    procedure Filter(aValue: string);
    procedure FilterByArtikel(aArId: Integer);
  end;


implementation

{ TViewEigenschaftList }

constructor TViewEigenschaftList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TViewEigenschaftList.Destroy;
begin

  inherited;
end;


function TViewEigenschaftList.getItem(Index: Integer): TViewEigenschaft;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TViewEigenschaft(fList.Items[Index]);
end;

procedure TViewEigenschaftList.ReadAll;
var
  x: TViewEigenschaft;
  Sql: String;
begin
  fList.Clear;
  fQuery.Close;
  try
    sql := ' select * from eigenschaft' +
           ' join eigenschaftname on en_id = ei_en_id' +
           ' order by ei_match';

    fQuery.SQL.Text := Sql;
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TViewEigenschaft.Create(nil);
      x.LoadByQuery(fquery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
  end;
end;



procedure TViewEigenschaftList.Filter(aValue: string);
var
  x: TViewEigenschaft;
  Sql: String;
begin
  fList.Clear;
  fQuery.Close;
  try
    sql := ' select * from eigenschaft' +
           ' join eigenschaftname on en_id = ei_en_id' +
           ' where ei_match like ' + QuotedStr(aValue) + '%' +
           ' order by ei_match';

    fQuery.SQL.Text := Sql;
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TViewEigenschaft.Create(nil);
      x.LoadByQuery(fquery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
  end;
end;


procedure TViewEigenschaftList.FilterByArtikel(aArId: Integer);
var
  x: TViewEigenschaft;
  Sql: String;
begin
  fList.Clear;
  fQuery.Close;
  try
    sql := ' select * ' +
           ' from artikeleigenschaft' +
           ' join eigenschaftname on en_id = ae_en_id' +
           ' join eigenschaft on ei_id = ae_ei_id' +
           ' where ae_ar_id = ' + IntToStr(aArId) +
           ' order by ei_match, en_match';

    fQuery.SQL.Text := Sql;
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TViewEigenschaft.Create(nil);
      x.LoadByQuery(fquery);
      fList.Add(x);
      x.Update :=  fquery.FieldByName('ae_update').AsDateTime;
      fQuery.Next;
    end;
    setFieldNeu;
  finally
  end;
end;


procedure TViewEigenschaftList.setFieldNeu;
var
  i1: Integer;
  Max: TDateTime;
  Min: TDateTime;
  x: TViewEigenschaft;
begin
  Max := 0;
  Min := now;
  for i1 := 0 to fList.Count -1 do
  begin
    x := TViewEigenschaft(fList.Items[i1]);
    x.Neu := false;
    if x.Update > Max then
      Max := x.Update;
    if x.Update < Min then
      Min := x.Update;
  end;
  if Min = Max then
    exit;

  for i1 := 0 to fList.Count -1 do
  begin
    x := TViewEigenschaft(fList.Items[i1]);
    if x.Update = Max then
      x.Neu := true;
  end;

end;

end.
