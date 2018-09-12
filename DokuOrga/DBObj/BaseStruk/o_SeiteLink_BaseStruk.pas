unit o_SeiteLink_BaseStruk;

interface

uses
  SysUtils, Classes, o_SeiteLink_Base, IBDatabase, IBQuery, o_Dokument;

type
  TSeiteLink_BaseStruk = class(TSeiteLink_Base)
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

{ TSeiteLink_BaseStruk }

uses
  c_DBTypes, o_DBField;


constructor TSeiteLink_BaseStruk.Create(AOwner: TComponent);
var
  DBField: TDBFeld;
begin
  inherited;
  FDBList.Add(KS_SE_ID, KS_SE_ID);
  FDBList.Add(KS_SE_ID_LINK, KS_SE_ID_LINK);
  FDBList.Add(KS_TYP, KS_TYP);
  DBField := DBList.Add(KS_DELETE, KS_DELETE, true);
  DBField.DeleteField := true;
  FDBList.Names('Id').Feldname := 'KS_ID';
  Init;
end;

destructor TSeiteLink_BaseStruk.Destroy;
begin

  inherited;
end;

procedure TSeiteLink_BaseStruk.Init;
begin
  inherited;

end;

procedure TSeiteLink_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;

function TSeiteLink_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (KS_ID, KS_SE_ID, KS_SE_ID_LINK, KS_TYP, KS_DELETE)' +
          ' values' +
          ' (:KS_ID, :KS_SE_ID, :KS_SE_ID_LINK, :KS_TYP, :KS_DELETE)';
  uSql := ' update ' + getTablename +
          ' set KS_SE_ID = :KS_SE_ID,' +
          ' KS_SE_ID_LINK = :KS_SE_ID_LINK, ' +
          ' KS_DELETE = :KS_DELETE ' +
          ' where KS_ID = :KS_ID';

  Result := SaveDB(FQuery, iSql, uSql);
end;

end.
