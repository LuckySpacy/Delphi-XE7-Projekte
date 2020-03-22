unit MySql.Aktielist;

interface

uses
  SysUtils, Classes, Contnrs, MySql.Baselist, MySql.Aktie;

type
  TMySqlAktielist = class(TMySqlBaseList)
  private
    function getItem(Index: Integer): TMySqlAktie;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Item[Index:Integer]: TMySqlAktie read getItem;
    function Add: TMySqlAktie;
    procedure ReadAll;
  end;

implementation

{ TMySqlAktielist }

uses
  Objekt.Global;


constructor TMySqlAktielist.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TMySqlAktielist.Destroy;
begin

  inherited;
end;

function TMySqlAktielist.getItem(Index: Integer): TMySqlAktie;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TMySqlAktie(fList.Items[Index]);
end;

function TMySqlAktielist.Add: TMySqlAktie;
begin
  Result := TMySqlAktie.Create(nil);
  fList.Add(Result);
end;


procedure TMySqlAktielist.ReadAll;
var
  i1: Integer;
  MySqlList: TStringList;
  DataList: TStringList;
  Ansicht: TMySqlAktie;
begin
  MySqlList := TStringList.Create;
  DataList := TStringList.Create;
  try
    ReadMySql(Global.MySql.AktieLink, MySqlList);
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
