unit MySql.Boersenindexlist;

interface

uses
  SysUtils, Classes, Contnrs, MySql.Baselist, MySql.Boersenindex;

type
  TMySqlBoersenindexlist = class(TMySqlBaseList)
  private
    function getItem(Index: Integer): TMySqlBoersenindex;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Item[Index:Integer]: TMySqlBoersenindex read getItem;
    function Add: TMySqlBoersenIndex;
    procedure ReadAll;
  end;

implementation

{ TMySqlBoersenindexlist }

uses
  Objekt.Global;


constructor TMySqlBoersenindexlist.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TMySqlBoersenindexlist.Destroy;
begin

  inherited;
end;

function TMySqlBoersenindexlist.Add: TMySqlBoersenIndex;
begin
  Result := TMySqlBoersenindex.Create;
  fList.Add(Result);
end;


function TMySqlBoersenindexlist.getItem(Index: Integer): TMySqlBoersenindex;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TMySqlBoersenindex(fList.Items[Index]);
end;

procedure TMySqlBoersenindexlist.ReadAll;
var
  i1: Integer;
  MySqlList: TStringList;
  DataList: TStringList;
  BoersenIndex: TMySqlBoersenindex;
begin
  MySqlList := TStringList.Create;
  DataList := TStringList.Create;
  try
    ReadMySql(Global.MySql.BoersenindexLink, MySqlList);
    for i1 := 0 to MySqlList.Count -1 do
    begin
      ItemList(MySqlList.Strings[i1], DataList);
      BoersenIndex := Add;
      BoersenIndex.BI_ID := StrToInt(DataList.Strings[0]);
      BoersenIndex.Boersenname := DataList.Strings[1];
    end;
  finally
    FreeAndNil(MySqlList);
    FreeAndNil(DataList);
  end;
end;

end.
