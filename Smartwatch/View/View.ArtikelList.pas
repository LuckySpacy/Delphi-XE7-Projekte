unit View.ArtikelList;

interface

uses
  SysUtils, Classes, Contnrs, DB.BaseList, View.Artikel;

type
  TViewArtikelList = class(TDBBaseList)
  private
    function getItem(Index: Integer): TViewArtikel;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Item[Index:Integer]: TViewArtikel read getItem;
    procedure ReadAll(aFi_Id, aSa_Id: Integer);
  end;

implementation

{ TViewArtikelList }

constructor TViewArtikelList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TViewArtikelList.Destroy;
begin

  inherited;
end;

function TViewArtikelList.getItem(Index: Integer): TViewArtikel;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TViewArtikel(fList.Items[Index]);
end;

procedure TViewArtikelList.ReadAll(aFi_Id, aSa_Id: Integer);
var
  x: TViewArtikel;
  Sql: String;
begin
  fList.Clear;
  fQuery.Close;
  try
    sql := ' select * from artikel' +
           ' join firmaartikel on ar_id = fa_ar_id and fa_fi_id = ' + IntToStr(aFi_Id) +
           ' where ar_sa_id = ' + IntToStr(aSa_Id) +
           ' order by ar_match';

    fQuery.SQL.Text := Sql;
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TViewArtikel.Create(nil);
      x.LoadByQuery(fquery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
  end;
end;

end.
