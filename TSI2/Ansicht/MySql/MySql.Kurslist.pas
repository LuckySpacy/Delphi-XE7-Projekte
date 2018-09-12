unit MySql.Kurslist;

interface

uses
  SysUtils, Classes, Contnrs, MySql.Baselist, MySql.Kurs;

type
  TMySqlKurslist = class(TMySqlBaseList)
  private
    fAK_ID: Integer;
    function getItem(Index: Integer): TMySqlKurs;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Item[Index:Integer]: TMySqlKurs read getItem;
    function Add: TMySqlKurs;
    procedure ReadAll(aAK_ID: Integer);
    property AK_ID: Integer read fAK_ID;
  end;

implementation

{ TMySqlKurslist }

uses
  Objekt.Global;

constructor TMySqlKurslist.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TMySqlKurslist.Destroy;
begin

  inherited;
end;

function TMySqlKurslist.getItem(Index: Integer): TMySqlKurs;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TMySqlKurs(fList.Items[Index]);
end;

function TMySqlKurslist.Add: TMySqlKurs;
begin
  Result := TMySqlKurs.Create(nil);
  fList.Add(Result);
end;


procedure TMySqlKurslist.ReadAll(aAK_ID: Integer);
var
  i1: Integer;
  MySqlList: TStringList;
  DataList: TStringList;
  Ansicht: TMySqlKurs;
begin
  fAk_ID := aAK_ID;
  MySqlList := TStringList.Create;
  DataList := TStringList.Create;
  try
    ReadMySql(Global.MySql.KursLink+'?AKID='+IntToStr(aAK_ID), MySqlList);
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
