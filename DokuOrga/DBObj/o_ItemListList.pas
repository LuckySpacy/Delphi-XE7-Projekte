unit o_ItemListList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_ItemList_BaseStrukList;


type
  TDBItemListList = class(TItemListBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ReadAll(aGruppe: Integer; const aSort: string = 'asc'); reintroduce; overload; virtual;
  end;


implementation

{ TDBItemListList }

constructor TDBItemListList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TDBItemListList.Destroy;
begin

  inherited;
end;

procedure TDBItemListList.Init;
begin
  inherited;

end;

procedure TDBItemListList.ReadAll(aGruppe: Integer; const aSort: string = 'asc') ;
var
  x: TDBObj;
begin
  FList.Clear;
  FQuery.Close;
  FQuery.Transaction := Trans;
  FQuery.Sql.Text := ' select * from ' + getTableName +
                     ' where it_gruppe = ' + IntToStr(aGruppe) +
                     ' order by ' + getTablePrefix + '_id ' + aSort;
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


end.
