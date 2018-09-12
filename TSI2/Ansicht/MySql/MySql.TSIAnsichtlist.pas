unit MySql.TSIAnsichtlist;

interface

uses
  SysUtils, Classes, Contnrs, MySql.Baselist, MySql.TSIAnsicht;

type
  TMySqlTSIAnsichtlist = class(TMySqlBaseList)
  private
    function getItem(Index: Integer): TMySqlTSIAnsicht;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Item[Index:Integer]: TMySqlTSIAnsicht read getItem;
    function Add: TMySqlTSIAnsicht;
    procedure ReadAll;
  end;

implementation

{ TMySqlBoersenindexlist }

uses
  Objekt.Global;


constructor TMySqlTSIAnsichtlist.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TMySqlTSIAnsichtlist.Destroy;
begin

  inherited;
end;

function TMySqlTSIAnsichtlist.Add: TMySqlTSIAnsicht;
begin
  Result := TMySqlTSIAnsicht.Create(nil);
  fList.Add(Result);
end;


function TMySqlTSIAnsichtlist.getItem(Index: Integer): TMySqlTSIAnsicht;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TMySqlTSIAnsicht(fList.Items[Index]);
end;

procedure TMySqlTSIAnsichtlist.ReadAll;
var
  i1: Integer;
  MySqlList: TStringList;
  DataList: TStringList;
  Ansicht: TMySqlTSIAnsicht;
begin
  MySqlList := TStringList.Create;
  DataList := TStringList.Create;
  try
    ReadMySql(Global.MySql.TSIAnsichtLink, MySqlList);
    for i1 := 0 to MySqlList.Count -1 do
    begin
      ItemList(MySqlList.Strings[i1], DataList);
      Ansicht := Add;
      Ansicht.FillFields(DataList);
    end;
  finally
    FreeAndNil(MySqlList);
    FreeAndNil(DataList);
  end;
end;

end.
