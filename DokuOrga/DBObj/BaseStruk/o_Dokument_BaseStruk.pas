unit o_Dokument_BaseStruk;

interface

uses
  SysUtils, Classes, o_Dokument_Base, IBDatabase, IBQuery;

type
  TDokument_BaseStruk = class(TDokument_Base)
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

{ TDokument_BaseStruk }

uses
  c_DBTypes, o_DBField;

constructor TDokument_BaseStruk.Create(AOwner: TComponent);
var
  DBField: TDBFeld;
begin
  inherited;
  FDBList.Add(DO_BEZ, DO_BEZ);
  FDBList.Add(DO_DATEINAME, DO_DATEINAME);
  FDBList.Add(DO_PFAD, DO_PFAD);
  FDBList.Add(DO_EXT, DO_EXT);
  FDBList.Add(DO_SAVE_FP, DO_SAVE_FP);
  FDBList.Add(DO_SAVE_FTP, DO_SAVE_FTP);
  FDBList.Add(DO_SAVE_CLOUD, DO_SAVE_CLOUD);
  FDBList.Add(DO_PFADGDRIVE, DO_PFADGDRIVE);
  DBField := DBList.Add(DO_DELETE, DO_DELETE, true);
  DBField.DeleteField := true;
  FDBList.Names('Id').Feldname := 'DO_ID';
  Init;
end;

destructor TDokument_BaseStruk.Destroy;
begin

  inherited;
end;

procedure TDokument_BaseStruk.Init;
begin
  inherited;
end;

procedure TDokument_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;

function TDokument_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (DO_ID, DO_BEZ, DO_DATEINAME, DO_EXT, DO_PFAD, DO_DELETE, DO_SAVE_FP, DO_SAVE_FTP, DO_SAVE_CLOUD, DO_PFADGDRIVE)' +
          ' values' +
          ' (:DO_ID, :DO_BEZ, :DO_DATEINAME, :DO_EXT, :DO_PFAD, :DO_DELETE, :DO_SAVE_FP, :DO_SAVE_FTP, :DO_SAVE_CLOUD, :DO_PFADGDRIVE)';
  uSql := ' update ' + getTablename +
          ' set DO_BEZ = :DO_BEZ,' +
          ' DO_DATEINAME = :DO_DATEINAME, ' +
          ' DO_EXT = :DO_EXT, ' +
          ' DO_PFAD = :DO_PFAD, ' +
          ' DO_SAVE_FP = :DO_SAVE_FP, ' +
          ' DO_SAVE_FTP = :DO_SAVE_FTP, ' +
          ' DO_SAVE_CLOUD = :DO_SAVE_CLOUD, ' +
          ' DO_PFADGDRIVE = :DO_PFADGDRIVE, ' +
          ' DO_DELETE = :DO_DELETE ' +
          ' where DO_ID = :DO_ID';

  Result := SaveDB(FQuery, iSql, uSql);
end;

end.
