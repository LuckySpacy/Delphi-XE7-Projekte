unit o_BaumStruk_BaseStruk;

interface

uses
  SysUtils, Classes, o_BaumStruk_Base, IBDatabase, IBQuery;

type
  TBaumStruk_BaseStruk = class(TBaumStruk_Base)
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

{ TBaumStruk_BaseStruk }

uses
  c_DBTypes, o_DBField;


constructor TBaumStruk_BaseStruk.Create(AOwner: TComponent);
var
  DBField: TDBFeld;
begin
  inherited;
  FDBList.Add(BS_EBENE, BS_EBENE);
  FDBList.Add(BS_ZP_ID, BS_ZP_ID);
  FDBList.Add(BS_BB_ID, BS_BB_ID);
  DBField := FDBList.Add(BS_DELETE, BS_DELETE, true);
  DBField.DeleteField := true;
  FDBList.Names('Id').Feldname := 'BS_ID';
  init;
end;

destructor TBaumStruk_BaseStruk.Destroy;
begin

  inherited;
end;

procedure TBaumStruk_BaseStruk.Init;
begin
  inherited;

end;

procedure TBaumStruk_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;

function TBaumStruk_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (BS_ID, BS_EBENE, BS_ZP_ID, BS_BB_ID, BS_DELETE)' +
          ' values' +
          ' (:BS_ID, :BS_EBENE, :BS_ZP_ID, :BS_BB_ID, :BS_DELETE)';
  uSql := ' update ' + getTablename +
          ' set BS_EBENE = :BS_EBENE,' +
          ' BS_ZP_ID = :BS_ZP_ID, ' +
          ' BS_BB_ID = :BS_BB_ID, ' +
          ' BS_DELETE = :BS_DELETE ' +
          ' where BS_ID = :BS_ID';

  Result := SaveDB(FQuery, iSql, uSql);

end;

end.
