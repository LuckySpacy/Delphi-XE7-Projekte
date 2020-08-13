unit DB.EigenschaftList;

interface

uses
  SysUtils, Classes, Contnrs, DB.BaseList, DB.Eigenschaft;

type
  TDBEigenschaftList = class(TDBBaseList)
  private
    function getItem(Index: Integer): TDBEigenschaft;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBEigenschaft read getItem;
    procedure ReadAll(aEI_EN_Id: Integer);
    procedure ReadAll2;
  end;

implementation

{ TDBEigenschaftList }

constructor TDBEigenschaftList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TDBEigenschaftList.Destroy;
begin

  inherited;
end;

function TDBEigenschaftList.getItem(Index: Integer): TDBEigenschaft;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TDBEigenschaft(fList.Items[Index]);
end;


procedure TDBEigenschaftList.ReadAll(aEI_EN_Id: Integer);
var
  x: TDBEigenschaft;
begin
  fList.Clear;
  fQuery.Close;
  try
    fQuery.SQL.Text := 'select * from eigenschaft where ei_en_id = ' + IntToStr(aEI_EN_Id) + ' order by ei_match';
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TDBEigenschaft.Create(nil);
      x.LoadByQuery(fquery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
  end;
end;


procedure TDBEigenschaftList.ReadAll2;
var
  x: TDBEigenschaft;
begin
  fList.Clear;
  fQuery.Close;
  try
    fQuery.SQL.Text := 'select * from eigenschaft order by ei_match';
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TDBEigenschaft.Create(nil);
      x.LoadByQuery(fquery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
  end;
end;

end.
