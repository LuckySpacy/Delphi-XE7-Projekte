unit MySql.TSIList;

interface

uses
  SysUtils, Classes, Contnrs, MySql.Baselist, MySql.TSI;

type
  TMySqlTSIlist = class(TMySqlBaseList)
  private
    fAK_ID: Integer;
    fWochen: Integer;
    function getItem(Index: Integer): TMySqlTSI;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Item[Index:Integer]: TMySqlTSI read getItem;
    function Add: TMySqlTSI;
    procedure ReadAll(aAK_ID, aWochen: Integer);
    property AK_ID: Integer read fAK_ID;
    property Wochen: Integer read fWochen;
  end;

implementation

{ TMySqlTSIlist }

uses
  Objekt.Global;


constructor TMySqlTSIlist.Create(AOwner: TComponent);
begin
  inherited;
  fAk_Id := 0;
  fWochen := 0;
end;

destructor TMySqlTSIlist.Destroy;
begin

  inherited;
end;

function TMySqlTSIlist.getItem(Index: Integer): TMySqlTSI;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TMySqlTSI(fList.Items[Index]);
end;

function TMySqlTSIlist.Add: TMySqlTSI;
begin
  Result := TMySqlTSI.Create(nil);
  fList.Add(Result);
end;


procedure TMySqlTSIlist.ReadAll(aAK_ID, aWochen: Integer);
var
  i1: Integer;
  MySqlList: TStringList;
  DataList: TStringList;
  TSI: TMySqlTSI;
begin
  fAk_ID := aAK_ID;
  fWochen := aWochen;
  MySqlList := TStringList.Create;
  DataList := TStringList.Create;
  try
    ReadMySql(Global.MySql.TSIWochenLink+'?AKID='+IntToStr(aAK_ID)+'&WOCHEN='+IntToStr(aWochen), MySqlList);
    for i1 := 0 to MySqlList.Count -1 do
    begin
      ItemList(MySqlList.Strings[i1], DataList);
      TSI := Add;
      TSI.FillFields(DataList);
    end;
  finally
    FreeAndNil(MySqlList);
    FreeAndNil(DataList);
  end;
end;

end.
