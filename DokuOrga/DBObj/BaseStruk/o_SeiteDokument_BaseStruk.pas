unit o_SeiteDokument_BaseStruk;

interface

uses
  SysUtils, Classes, o_SeiteDokument_Base, IBDatabase, IBQuery, o_Dokument;

type
  TSeiteDokument_BaseStruk = class(TSeiteDokument_Base)
  private
    FDokument: TDokument;
    function getDokument: TDokument;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function Save: Boolean;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    property Dokument: TDokument read getDokument;
  end;

implementation

{ TSeiteDokument_BaseStruk }

uses
  c_DBTypes, o_DBField;

constructor TSeiteDokument_BaseStruk.Create(AOwner: TComponent);
var
  DBField: TDBFeld;
begin
  FDokument := TDokument.Create(aOwner);
  FDokument.Trans := FTrans;
  inherited;
  FDBList.Add(SD_SE_ID, SD_SE_ID);
  FDBList.Add(SD_DO_ID, SD_DO_ID);
  DBField := DBList.Add(SD_DELETE, SD_DELETE, true);
  DBField.DeleteField := true;
  FDBList.Names('Id').Feldname := 'SD_ID';
  Init;
end;


destructor TSeiteDokument_BaseStruk.Destroy;
begin
  FreeAndNil(FDokument);
  inherited;
end;


procedure TSeiteDokument_BaseStruk.Init;
begin
  inherited;
  FDokument.Init;
end;

function TSeiteDokument_BaseStruk.getDokument: TDokument;
begin
  Result := nil;
  if (FDokument <> nil) and (FDokument.Id = FDBList.DBName('SD_DO_ID').AsInteger) then
  begin
    Result := FDokument;
    exit;
  end;

  FDokument.Init;
  FDokument.Read(FDBList.DBName('SD_DO_ID').AsInteger);
  if FDokument.Found then
    Result := FDokument;


end;


procedure TSeiteDokument_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;

function TSeiteDokument_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (SD_ID, SD_SE_ID, SD_DO_ID, SD_DELETE)' +
          ' values' +
          ' (:SD_ID, :SD_SE_ID, :SD_DO_ID, :SD_DELETE)';
  uSql := ' update ' + getTablename +
          ' set SD_SE_ID = :SD_SE_ID,' +
          ' SD_DO_ID = :SD_DO_ID, ' +
          ' SD_DELETE = :SD_DELETE ' +
          ' where DO_ID = :DO_ID';

  Result := SaveDB(FQuery, iSql, uSql);
end;

end.
