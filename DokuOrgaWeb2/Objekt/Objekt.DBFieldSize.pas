unit Objekt.DBFieldSize;

interface

uses
  SysUtils, Classes, IBX.IBQuery, IBX.IBDatabase;

type
  TDBFieldSize = class
  private
    fFieldSize: TStringList;
    fQuery: TIBQuery;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function FieldSize(const aFieldName, aTableName: string; aIBT: TIBTransaction): Integer;
  end;

var
  DBFieldSize: TDBFieldSize;


implementation

{ TDBFieldSize }


constructor TDBFieldSize.Create;
begin
  fFieldSize := TStringList.Create;
  fQuery := TIBQuery.Create(nil);
end;

destructor TDBFieldSize.Destroy;
begin
  FreeAndNil(fFieldSize);
  FreeAndNil(fQuery);
  inherited;
end;

function TDBFieldSize.FieldSize(const aFieldName, aTableName: string;
  aIBT: TIBTransaction): Integer;
var
  Key: string;
  Index: integer;
  //TableName: string;
  WasOpen: Boolean;
begin
  Result := 0;
  Key := aTablename + '.' + aFieldName;
  Index := fFieldSize.IndexOf(key);
  if (index >= 0) then
  begin
    result := Integer(fFieldSize.Objects[fFieldSize.IndexOf(key)]);
    exit;
  end;

  fQuery.Transaction := aIBT;
  WasOpen := aIBT.Active;

  if not wasOpen then
    aIBT.StartTransaction;

  fQuery.SQL.Text := ' select t2.*' +
                     ' from rdb$relation_fields t1, rdb$fields t2' +
                     ' where t1.rdb$relation_name = "' + UpperCase(aTableName) + '"' +
                     ' and t1.rdb$field_name = "' + UpperCase(aFieldName) + '"' +
                     ' and t1.rdb$field_source = t2.rdb$field_name';
  try
    fQuery.Open;
    if fQuery.Eof then
      exit;
  except
    exit;
  end;

   Result := fQuery.FieldByName('rdb$field_length').AsInteger;
   if not WasOpen then
    aIBT.Rollback;

   fFieldSize.AddObject(key, TObject(result));
end;

end.
