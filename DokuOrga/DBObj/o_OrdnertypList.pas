unit o_OrdnertypList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_ItemListList, o_OrdnerTyp, o_DBGuid, o_SprachList;


type
  TOrdnerTypList = class(TDBItemListList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ReadAll(aGruppe: Integer; const aSort: string = 'desc'); override;
    procedure ReadAllByIndexSort(aGruppe: Integer; const aSort: string = 'asc');
    procedure AddOrdnerTyps;
  end;


implementation

{ TOrdnerTypList }

uses
  c_DBTypes;


constructor TOrdnerTypList.Create(AOwner: TComponent);
begin
  inherited;
  //ReadAll(1);
  ReadAllByIndexSort(1);
  if FList.Count = 0 then
  begin
    AddOrdnerTyps;
    ReadAllByIndexSort(1);
  end;
end;

destructor TOrdnerTypList.Destroy;
begin

  inherited;
end;

procedure TOrdnerTypList.Init;
begin
  inherited;

end;


procedure TOrdnerTypList.ReadAll(aGruppe: Integer; const aSort: string);
begin
  inherited;

end;

procedure TOrdnerTypList.ReadAllByIndexSort(aGruppe: Integer; const aSort: string);
var
  x: TDBObj;
begin
  FList.Clear;
  FQuery.Close;
  FQuery.Transaction := Trans;
  FQuery.Sql.Text := ' select * from ' + getTableName +
                     ' where it_gruppe = ' + IntToStr(aGruppe) +
                     ' order by it_index ' + aSort;
  OpenTrans;
  FQuery.Open;
  while not FQuery.Eof do
  begin
    x := Add(FQuery);
    FList.Add(x);
    FQuery.Next;
  end;
  RollbackTrans;
end;

procedure TOrdnerTypList.AddOrdnerTyps;
var
  OrdnerTyp: TOrdnerTyp;
  DBGuid: TDBGuid;
  SprachList: TSprachList;
begin
  OrdnerTyp  := TOrdnerTyp.Create(nil);
  SprachList := TSprachList.Create(nil);
  try
    OrdnerTyp.Feld(IT_GRUPPE).AsInteger := 1;
    OrdnerTyp.Feld(IT_INDEX).AsInteger  := 0;
    OrdnerTyp.Save;
    DBGuid := OrdnerTyp.DBGuid;
    DBGuid.Feld(GU_GUID).AsString := '{0E59EE59-25BD-46A8-B54C-697F548DC628}';
    DBGuid.Save;
    SprachList.Feld(SL_GUID).AsString     := DBGuid.Feld(GU_GUID).AsString;
    SprachList.Feld(SL_TEXT).AsString     := 'Ordner';
    SprachList.Feld(SL_BLOBTEXT).AsString := 'Ordner';
    SprachList.Feld(SL_SP_ID).AsInteger   := 1;
    SprachList.Save;

    OrdnerTyp.Init;
    SprachList.Init;

    OrdnerTyp.Feld(IT_GRUPPE).AsInteger := 1;
    OrdnerTyp.Feld(IT_INDEX).AsInteger  := 1;
    OrdnerTyp.Save;
    DBGuid := OrdnerTyp.DBGuid;
    DBGuid.Feld(GU_GUID).AsString := '{5A0E7404-6889-4342-9B18-5D4CBF63427C}';
    DBGuid.Save;
    SprachList.Feld(SL_GUID).AsString     := DBGuid.Feld(GU_GUID).AsString;
    SprachList.Feld(SL_TEXT).AsString     := 'Baum';
    SprachList.Feld(SL_BLOBTEXT).AsString := 'Baum';
    SprachList.Feld(SL_SP_ID).AsInteger   := 1;
    SprachList.Save;

  finally
    FreeAndNil(OrdnerTyp);
    FreeAndNil(SprachList);
  end;
end;


end.
