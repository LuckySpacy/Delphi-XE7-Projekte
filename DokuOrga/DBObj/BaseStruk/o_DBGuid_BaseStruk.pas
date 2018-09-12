unit o_DBGuid_BaseStruk;

interface

uses
  SysUtils, Classes, o_DBGuid_Base, IBDatabase, IBQuery, o_DBFieldList, o_DBField;
type
  TDBGuid_BaseStruk = class(TDBGuid_Base)
  private
    FImportingData: Boolean;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function Save: Boolean;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    function SaveDB(aQuery: TIBQuery; aiSql, auSql: string): Boolean; override;
    property ImportingData: Boolean read FImportingData write FImportingData;
  end;


implementation

{ TDBGuid_BaseStruk }

uses
  c_DBTypes, o_sysobj;


constructor TDBGuid_BaseStruk.Create(AOwner: TComponent);
begin
  inherited;
  FImportingData := false;
  FDBList.Init;
  FDBList.Add(GU_GUID, GU_GUID);
  FDBList.Add(GU_REFID, GU_REFID);
  FDBList.Add(GU_REFKEY, GU_REFKEY);
  FDBList.Add(GU_BE_ID, GU_BE_ID);
  FDBList.Add(GU_TABELLE, GU_TABELLE);
  FDBList.Add(GU_INSERT, GU_INSERT);
  FDBList.Add(GU_UPDATE, GU_UPDATE);
  FDBList.Add(GU_USERID_INSERT, GU_USERID_INSERT);
  FDBList.Add(GU_USERID_UPDATE, GU_USERID_UPDATE);
  FDBList.Add(GU_DELETE, GU_DELETE, true);
  //FDBList.Names('Id').Feldname := 'GU_ID';
end;

destructor TDBGuid_BaseStruk.Destroy;
begin

  inherited;
end;

procedure TDBGuid_BaseStruk.Init;
begin
  inherited;

end;

procedure TDBGuid_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;

function TDBGuid_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (GU_REFKEY, GU_TABELLE, GU_GUID, GU_INSERT, GU_UPDATE, GU_USERID_INSERT, ' +
          ' GU_BE_ID, GU_USERID_UPDATE, GU_REFID, GU_DELETE )' +
          ' values' +
          ' (:GU_REFKEY, :GU_TABELLE, :GU_GUID, :GU_INSERT, :GU_UPDATE, :GU_USERID_INSERT, ' +
          ' :GU_BE_ID, :GU_USERID_UPDATE, :GU_REFID, :GU_DELETE )';
  uSql := ' update ' + getTablename +
          ' set GU_INSERT = :GU_INSERT,' +
          ' GU_UPDATE = :GU_UPDATE,' +
          ' GU_USERID_INSERT = :GU_USERID_INSERT,' +
          ' GU_USERID_UPDATE = :GU_USERID_UPDATE,' +
          ' GU_DELETE = :GU_DELETE,' +
          ' GU_REFID = :GU_REFID,' +
          ' GU_BE_ID = :GU_BE_ID' +
          ' where GU_GUID = :GU_GUID' +
          ' and GU_TABELLE = :GU_TABELLE' +
          ' and GU_REFKEY = :GU_REFKEY';

  if FDBList.Names(GU_GUID).Changed then
  begin
    uSql := ' update ' + getTablename +
            ' set GU_INSERT = :GU_INSERT,' +
            ' GU_UPDATE = :GU_UPDATE,' +
            ' GU_USERID_INSERT = :GU_USERID_INSERT,' +
            ' GU_USERID_UPDATE = :GU_USERID_UPDATE,' +
            ' GU_DELETE = :GU_DELETE,' +
            ' GU_BE_ID = :GU_BE_ID,' +
            ' GU_GUID = :GU_GUID' +
            ' WHERE GU_TABELLE = :GU_TABELLE' +
            ' and GU_REFKEY = :GU_REFKEY' +
            ' and GU_REFID = :GU_REFID';
  end;

  Result := SaveDB(FQuery, iSql, uSql);
end;


function TDBGuid_BaseStruk.SaveDB(aQuery: TIBQuery; aiSql, auSql: string): Boolean;
var
  i1: Integer;
  Guid: TGuid;
begin
  Result := false;
  if (not FDBList.Changed) and (FDBList.Names(GU_GUID).AsString > '') then
    exit;

  aQuery.Close;

  if not FImportingData then
    FDBList.Names(GU_UPDATE).AsDateTime := now;

  if FDBList.Names('GU_GUID').AsString = '' then
  begin
    CreateGUID(Guid);
    FDBList.Names('GU_GUID').AsString := GUIDToString(Guid);
    FDBList.Names('GU_BE_ID').AsInteger := sysobj.Benutzer.Id;
    aQuery.SQL.Text := aiSql;
  end
  else
    aQuery.Sql.Text := auSql;

  aQuery.Transaction := Trans;

  OpenTrans;
  for i1 := 0 to FDBList.Count - 1 do
    aQuery.ParamByName(FDBList.Item[i1].Feldname).Value := FDBList.Item[i1].AsString;

  aQuery.ExecSQL;


  CommitTrans;

  Result := true;

end;


end.
