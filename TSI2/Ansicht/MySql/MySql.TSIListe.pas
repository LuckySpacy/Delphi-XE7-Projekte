unit MySql.TSIListe;

interface

uses
  SysUtils, Classes, Contnrs, Objekt.BasisList, MySql.TSIList;

type
  TMySqlTSIListe = class(TBaseList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function TSIList(aAK_ID, aWochen: Integer): TMySqlTSIList;
  end;

implementation

{ TMySqlTSIListe }

constructor TMySqlTSIListe.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TMySqlTSIListe.Destroy;
begin

  inherited;
end;

function TMySqlTSIListe.TSIList(aAK_ID, aWochen: Integer): TMySqlTSIList;
var
  i1: Integer;
  TSIList: TMySqlTSIList;
begin
  for i1 := 0 to fList.Count -1 do
  begin
    if  (TMySqlTSIList(fList.Items[i1]).AK_ID = aAK_ID)
    and (TMySqlTSIList(fList.Items[i1]).Wochen = aWochen) then
    begin
      Result := TMySqlTSIList(fList.Items[i1]);
      exit;
    end;
  end;
  TSIList := TMySqlTSIList.Create(nil);
  TSIList.ReadAll(aAK_ID, aWochen);
  fList.Add(TSIList);
  Result := TSIList;
end;

end.
