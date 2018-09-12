unit o_BaumButton_BaseStruk;

interface

uses
  SysUtils, Classes, o_BaumButton_Base, IBDatabase, IBQuery;

type
  TBaumButton_BaseStruk = class(TBaumButton_Base)
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

uses
  c_DBTypes, o_DBField;


{ TBaumButton_BaseStruk }

constructor TBaumButton_BaseStruk.Create(AOwner: TComponent);
var
  DBField: TDBFeld;
begin
  inherited;
  FDBList.Add(BB_EBENE, BB_EBENE);
  FDBList.Add(BB_BP_ID, BB_BP_ID);
  DBField := FDBList.Add(BB_DELETE, BB_DELETE, true);
  DBField.DeleteField := true;
  FDBList.Names('Id').Feldname := 'BB_ID';
  init;
end;

destructor TBaumButton_BaseStruk.Destroy;
begin

  inherited;
end;

procedure TBaumButton_BaseStruk.Init;
begin
  inherited;

end;

procedure TBaumButton_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;

function TBaumButton_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (BB_ID, BB_EBENE, BB_BP_ID, BB_DELETE)' +
          ' values' +
          ' (:BB_ID, :BB_EBENE, :BB_BP_ID, :BB_DELETE)';
  uSql := ' update ' + getTablename +
          ' set BB_EBENE = :BB_EBENE,' +
          ' BB_BP_ID = :BB_BP_ID, ' +
          ' BB_DELETE = :BB_DELETE ' +
          ' where BB_ID = :BB_ID';

  Result := SaveDB(FQuery, iSql, uSql);

end;

end.
