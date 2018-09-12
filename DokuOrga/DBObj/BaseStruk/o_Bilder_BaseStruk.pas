unit o_Bilder_BaseStruk;

interface

uses
  SysUtils, Classes, o_Bilder_Base, IBDatabase, IBQuery;

type
  TBilder_BaseStruk = class(TBilder_Base)
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

{ TBilder_BaseStruk }

uses
  c_DBTypes, o_DBField;


constructor TBilder_BaseStruk.Create(AOwner: TComponent);
var
  DBField: TDBFeld;
begin
  inherited;
  FDBList.Add(BI_TYP, BI_TYP);
  DBField := FDBList.Add(BI_BILD, BI_BILD);
  DBField.BitmapField := true;
  FDBList.Add(BI_ERWEITERUNG, BI_ERWEITERUNG);
  DBField := DBList.Add(BI_DELETE, BI_DELETE, true);
  DBField.DeleteField := true;
  FDBList.Names('Id').Feldname := 'BI_ID';
  Init;
end;

destructor TBilder_BaseStruk.Destroy;
begin

  inherited;
end;

procedure TBilder_BaseStruk.Init;
begin
  inherited;

end;

procedure TBilder_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;

function TBilder_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (BI_ID, BI_TYP, BI_BILD, BI_ERWEITERUNG, BI_DELETE)' +
          ' values' +
          ' (:BI_ID, :BI_TYP, :BI_BILD, :BI_ERWEITERUNG, :BI_DELETE)';
  uSql := ' update ' + getTablename +
          ' set BI_TYP = :BI_TYP,' +
          ' BI_BILD = :BI_BILD, ' +
          ' BI_ERWEITERUNG = :BI_ERWEITERUNG, ' +
          ' BI_DELETE = :BI_DELETE ' +
          ' where BI_ID = :BI_ID';

  Result := SaveDB(FQuery, iSql, uSql);

end;

end.
