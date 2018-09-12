unit o_Seiteverbinden_BaseStruk;

interface

uses
  SysUtils, Classes, o_Seiteverbinden_Base, IBDatabase, IBQuery;


type
  TSeiteverbinden_BaseStruk = class(TSeiteverbinden_Base)
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

{ TSeiteverbinden_BaseStruk }


uses
  c_DBTypes, o_DBField;


constructor TSeiteverbinden_BaseStruk.Create(AOwner: TComponent);
var
  DBField: TDBFeld;
begin
  inherited;
  FDBList.Add(VS_SE_ID, VS_SE_ID);
  FDBList.Add(VS_EBENE, VS_EBENE);
  FDBList.Add(VS_BS_ID, VS_BS_ID);
  DBField := DBList.Add(VS_DELETE, VS_DELETE, true);
  DBField.DeleteField := true;
  FDBList.Names('Id').Feldname := 'VS_ID';
  Init;
end;

destructor TSeiteverbinden_BaseStruk.Destroy;
begin

  inherited;
end;

procedure TSeiteverbinden_BaseStruk.Init;
begin
  inherited;

end;

procedure TSeiteverbinden_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;

function TSeiteverbinden_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (VS_ID, VS_SE_ID, VS_EBENE, VS_BS_ID, VS_DELETE)' +
          ' values' +
          ' (:VS_ID, :VS_SE_ID, :VS_EBENE, :VS_BS_ID, :VS_DELETE)';
  uSql := ' update ' + getTablename +
          ' set VS_SE_ID = :VS_SE_ID,' +
          ' VS_EBENE = :VS_EBENE, ' +
          ' VS_BS_ID = :VS_BS_ID, ' +
          ' VS_DELETE = :VS_DELETE ' +
          ' where VS_ID = :VS_ID';

  Result := SaveDB(FQuery, iSql, uSql);
end;

end.
