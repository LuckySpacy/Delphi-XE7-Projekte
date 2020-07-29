unit View.EigenschaftList;

interface

uses
  SysUtils, Classes, Contnrs, DB.BaseList, View.Eigenschaft;

type
  TViewEigenschaftList = class(TDBBaseList)
  private
    function getItem(Index: Integer): TViewEigenschaft;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Item[Index:Integer]: TViewEigenschaft read getItem;
    procedure ReadAll;
    procedure Filter(aValue: string);
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


end.
