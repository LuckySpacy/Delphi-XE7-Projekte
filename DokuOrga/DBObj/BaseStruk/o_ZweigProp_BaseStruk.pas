unit o_ZweigProp_BaseStruk;

interface

uses
  SysUtils, Classes, o_ZweigProp_Base, IBDatabase, IBQuery;

type
  TZweigProp_BaseStruk = class(TZweigProp_Base)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function Save: Boolean;
    procedure LoadByQuery(aQuery: TIBQuery); override;
  end;


implementation

{ TZweigProp_BaseStruk }

uses
  c_DBTypes, o_DBField;


constructor TZweigProp_BaseStruk.Create(AOwner: TComponent);
var
  DBField: TDBFeld;
begin
  inherited;
  FDBList.Add(ZP_TEXT, ZP_TEXT);
  FDBList.Add(ZP_BI_ID, ZP_BI_ID);
  DBField := DBList.Add(ZP_DELETE, ZP_DELETE, true);
  DBField.DeleteField := true;
  FDBList.Names('Id').Feldname := 'ZP_ID';
  Init;
end;

destructor TZweigProp_BaseStruk.Destroy;
begin

  inherited;
end;

procedure TZweigProp_BaseStruk.Init;
begin
  inherited;

end;

procedure TZweigProp_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;

function TZweigProp_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (ZP_ID, ZP_TEXT, ZP_BI_ID, ZP_DELETE)' +
          ' values' +
          ' (:ZP_ID, :ZP_TEXT, :ZP_BI_ID, :ZP_DELETE)';
  uSql := ' update ' + getTablename +
          ' set ZP_TEXT = :ZP_TEXT,' +
          ' ZP_BI_ID = :ZP_BI_ID, ' +
          ' ZP_DELETE = :ZP_DELETE ' +
          ' where ZP_ID = :ZP_ID';

  Result := SaveDB(FQuery, iSql, uSql);

end;

end.
