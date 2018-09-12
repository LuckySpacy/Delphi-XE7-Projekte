unit o_DokumentLink_BaseStruk;

interface

uses
  SysUtils, Classes, o_SeiteDokumentLink_Base, IBDatabase, IBQuery, o_Dokument;

type
  TSeiteDokumentLink_BaseStruk = class(TSeiteDokumentLink_Base)
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

{ TSeiteDokumentLink_BaseStruk }

uses
  c_DBTypes, o_DBField;

constructor TSeiteDokumentLink_BaseStruk.Create(AOwner: TComponent);
var
  DBField: TDBFeld;
begin
  FDokument := TDokument.Create(aOwner);
  FDokument.Trans := FTrans;
  inherited;
  FDBList.Add(SK_SD_ID, SK_SD_ID);
  FDBList.Add(SK_SD_ID_LINK, SK_SD_ID_LINK);
  FDBList.Add(SK_DO_ID, SK_DO_ID);
  FDBList.Add(SK_VERLINKT, SK_VERLINKT);
  DBField := DBList.Add(SK_DELETE, SK_DELETE, true);
  DBField.DeleteField := true;
  FDBList.Names('Id').Feldname := 'SK_ID';
  Init;
end;

destructor TSeiteDokumentLink_BaseStruk.Destroy;
begin
  FreeAndNil(FDokument);
  inherited;
end;

function TSeiteDokumentLink_BaseStruk.getDokument: TDokument;
begin
  Result := nil;
  if (FDokument <> nil) and (FDokument.Id = FDBList.DBName('SK_DO_ID').AsInteger) then
  begin
    Result := FDokument;
    exit;
  end;

  FDokument.Init;
  FDokument.Read(FDBList.DBName('SK_DO_ID').AsInteger);
  if FDokument.Found then
    Result := FDokument;
end;

procedure TSeiteDokumentLink_BaseStruk.Init;
begin
  inherited;
  FDokument.Init;
end;

procedure TSeiteDokumentLink_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;

function TSeiteDokumentLink_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (SK_ID, SK_SD_ID, SK_SD_ID_LINK, SK_DO_ID, SK_VERLINKT, SK_DELETE)' +
          ' values' +
          ' (:SK_ID, :SK_SD_ID, :SK_SD_ID_LINK, :SK_DO_ID, :SK_VERLINKT, :SD_DELETE)';
  uSql := ' update ' + getTablename +
          ' set SK_SD_ID = :SK_SD_ID,' +
          ' SK_SD_ID_LINK = :SK_SD_ID_LINK, ' +
          ' SK_DO_ID = :SK_DO_ID, ' +
          ' SK_VERLINKT = :SK_VERLINKT, ' +
          ' SK_DELETE = :SK_DELETE ' +
          ' where SK_ID = :SK_ID';

  Result := SaveDB(FQuery, iSql, uSql);
end

end.
