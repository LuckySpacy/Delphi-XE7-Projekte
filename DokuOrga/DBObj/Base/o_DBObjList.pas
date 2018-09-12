unit o_DBObjList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs;


type
  TDBObjList = class(TDBObj)
  private
  protected
    FCount: Integer;
    FList: TObjectList;
    function getCount: Integer;
    //function getTableName: string; reintroduce; virtual; abstract;
    function getTableName: string; override; abstract;
    function getTablePrefix: string; override; abstract;
    //function getTablePrefix: string; reintroduce; virtual; abstract;
    function Add(aQuery: TIBQuery): TDBObj; virtual; abstract;
    function getGeneratorName: string; override;
    function getItem(aIndex: Integer): TDBObj;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    property Count: Integer read getCount;
    procedure ReadAll(const aSort: string = 'desc'); virtual;
    procedure ReadAllForExport(aDatum: TDateTime; const aSort: string = 'desc') ;
  end;


implementation

{ TDBBaseList }


constructor TDBObjList.Create(AOwner: TComponent);
begin
  inherited;
  FList := TObjectList.Create;
end;

destructor TDBObjList.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

procedure TDBObjList.Init;
begin
  inherited;
  FList.Clear;
end;


function TDBObjList.getCount: Integer;
begin
  Result := FList.Count;
end;

function TDBObjList.getGeneratorName: string;
begin
  inherited;
end;

function TDBObjList.getItem(aIndex: Integer): TDBObj;
begin
  Result := nil;
  if aIndex > FList.Count -1 then
    exit;
  Result := TDBObj(FList.Items[aIndex]);
end;


procedure TDBObjList.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;



procedure TDBObjList.ReadAll(const aSort: string = 'desc') ;
var
  x: TDBObj;
begin
  FList.Clear;
  FQuery.Close;
  FQuery.Transaction := Trans;
  FQuery.Sql.Text := 'select * from ' + getTableName + ' order by ' + getTablePrefix + '_id ' + aSort;
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

procedure TDBObjList.ReadAllForExport(aDatum: TDateTime; const aSort: string = 'desc') ;
var
  x: TDBObj;
begin
  FList.Clear;
  FQuery.Close;
  FQuery.Transaction := Trans;
  FQuery.Sql.Text := ' select * from ' + getTableName +
                     ' join guid on gu_refid = ' + getTablePrefix + '_id ' +
                     ' and gu_refkey = ' + QuotedStr(getTablePrefix) +
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

