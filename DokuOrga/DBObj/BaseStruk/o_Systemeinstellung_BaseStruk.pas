unit o_Systemeinstellung_BaseStruk;

interface

uses
  SysUtils, Classes, o_Systemeinstellung_Base, IBDatabase, IBQuery;

type
  TSystemeinstellung_BaseStruk = class(TSystemeinstellung_Base)
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

{ TSeite_BaseStruk }

uses
  c_DBTypes, o_DBField;


constructor TSystemeinstellung_BaseStruk.Create(AOwner: TComponent);
//var
//  DBField: TDBFeld;
begin
  inherited;
  FDBList.Add(SY_KEY, SY_KEY);
  FDBList.Add(SY_BEZ, SY_BEZ);
  FDBList.Add(SY_VALUE1, SY_VALUE1);
  FDBList.Add(SY_BLOB1, SY_BLOB1);
  FDBList.Add(SY_BLOB2, SY_BLOB2);
  FDBList.Add(SY_BLOB3, SY_BLOB3);
  FDBList.Names('Id').Feldname := 'SY_ID';
  Init;
end;

destructor TSystemeinstellung_BaseStruk.Destroy;
begin

  inherited;
end;

procedure TSystemeinstellung_BaseStruk.Init;
begin
  inherited;
end;


procedure TSystemeinstellung_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;

function TSystemeinstellung_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (SY_ID, SY_BEZ, SY_KEY, SY_VALUE1, SY_BLOB1, SY_BLOB2, SY_BLOB3)' +
          ' values' +
          ' (:SY_ID, :SY_BEZ, :SY_KEY, :SY_VALUE1, :SY_BLOB1, :SY_BLOB2, :SY_BLOB3)';
  uSql := ' update ' + getTablename +
          ' set SY_BEZ = :SY_BEZ,' +
          ' SY_KEY = :SY_KEY, ' +
          ' SY_VALUE1 = :SY_VALUE1, ' +
          ' SY_BLOB1 = :SY_BLOB1, ' +
          ' SY_BLOB2 = :SY_BLOB2, ' +
          ' SY_BLOB3 = :SY_BLOB3 ' +
          ' where SY_ID = :SY_ID';

  Result := SaveDB(FQuery, iSql, uSql);

end;

end.
