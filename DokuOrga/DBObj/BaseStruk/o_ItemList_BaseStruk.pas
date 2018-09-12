unit o_ItemList_BaseStruk;

interface

uses
  SysUtils, Classes, o_ItemList_Base, IBDatabase, IBQuery, o_SprachList;


type
  TItemList_BaseStruk = class(TItemList_Base)
  private
    function GetBlobText: string;
    function GetText: string;
  protected
    FSprachList: TSprachList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function Save: Boolean;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    procedure Read(aId: Integer); override;
    property Text: string read GetText;
    property BlobText: string read GetBlobText;
  end;


implementation

{ TItemList_BaseStruk }

uses
  c_DBTypes;


constructor TItemList_BaseStruk.Create(AOwner: TComponent);
begin
  inherited;
  FSprachList := TSprachList.Create(Self);
  FDBList.Add(IT_GRUPPE, IT_GRUPPE);
  FDBList.Add(IT_INDEX, IT_INDEX);
  FDBList.Names('Id').Feldname := 'IT_ID';
  Init;
end;

destructor TItemList_BaseStruk.Destroy;
begin
  FreeAndNil(FSprachList);
  inherited;
end;

function TItemList_BaseStruk.GetBlobText: string;
begin
  if FSprachlist.id = 0  then
    FSprachList.Read(DBGuid.Feld(GU_GUID).AsString);
  Result := FSprachList.Feld(SL_BLOBTEXT).AsString;
end;

function TItemList_BaseStruk.GetText: string;
begin
  if id = -1 then
    exit;

  if FSprachlist.Id = 0  then
    FSprachList.Read(Guid);
//  if FSprachlist.Id = 0  then
//    FSprachList.Read(DBGuid.Feld(GU_GUID).AsString);


  Result := FSprachList.Feld(SL_TEXT).AsString;
end;

procedure TItemList_BaseStruk.Init;
begin
  inherited;
  if FSprachList <> nil then
    FSprachList.Init;
end;

procedure TItemList_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;


procedure TItemList_BaseStruk.Read(aId: Integer);
begin
  inherited;
end;

function TItemList_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (IT_ID, IT_GRUPPE, IT_INDEX)' +
          ' values' +
          ' (:IT_ID, :IT_GRUPPE, :IT_INDEX)';
  uSql := ' update ' + getTablename +
          ' set IT_GRUPPE = :IT_GRUPPE,' +
          ' IT_INDEX = :IT_INDEX ' +
          ' where IT_ID = :IT_ID';

  Result := SaveDB(FQuery, iSql, uSql);

end;

end.
