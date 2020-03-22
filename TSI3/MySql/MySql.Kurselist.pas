unit MySql.Kurselist;

interface

uses
  SysUtils, Classes, Contnrs, Objekt.BasisList, MySql.KursList;

type
  TMySqlKurseList = class(TBaseList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function KursList(aAK_ID: Integer): TMySqlKursList;
  end;

implementation

{ TMySqlKurseList }

constructor TMySqlKurseList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TMySqlKurseList.Destroy;
begin

  inherited;
end;

function TMySqlKurseList.KursList(aAK_ID: Integer): TMySqlKursList;
var
  i1: Integer;
  KursList: TMySqlKursList;
begin
  for i1 := 0 to fList.Count -1 do
  begin
    if TMySqlKursList(fList.Items[i1]).AK_ID = aAK_ID then
    begin
      Result := TMySqlKursList(fList.Items[i1]);
      exit;
    end;
  end;
  KursList := TMySqlKursList.Create(nil);
  KursList.ReadAll(aAK_ID);
  fList.Add(KursList);
  Result := KursList;
end;

end.
