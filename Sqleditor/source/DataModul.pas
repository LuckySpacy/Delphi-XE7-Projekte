unit DataModul;

interface

uses
  System.SysUtils, System.Classes, Data.DB, IBX.IBCustomDataSet, IBX.IBQuery, IBX.IBDatabase,
  o_dbini, Data.Win.ADODB, o_dbiniObj, c_Types, mySQLDbTables;

type
  TConnectAdoEvent = procedure(Sender: TObject; aDatenbankname, aSectionname: string) of object;

type
  Tdm = class(TDataModule)
    IBDatabase: TIBDatabase;
    ds_IB: TDataSource;
    IBTransaction: TIBTransaction;
    IBQuery: TIBQuery;
    IBQuery2: TIBQuery;
    ADOConnect: TADOConnection;
    ds_Ado: TDataSource;
    ADOQuery: TADOQuery;
    MySqlConnect: TmySQLDatabase;
    mySQLQuery: TmySQLQuery;
    ds_mysql: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FOnConnectIB: TNotifyEvent;
    FQryTablenameFromField: TIBQuery;
    FQryPrimaryKey: TIBQuery;
    FQryUniqueKey: TIBQuery;
    FQryFieldKey: TIBQuery;
    FDBIni: TDBIni;
    FOnConnectAdo: TConnectAdoEvent;
    FOnConnectMySql: TConnectAdoEvent;
    FOnBevorConnect: TNotifyEvent;
    function GetDatabaseName: string;
    function getDatenbank: TcDatenbank;
  public
    function ConnectIB(const aSectionName: string = ''): Boolean;
    function ConnectAdo(const aSectionName: string = ''): Boolean;
    function ConnectMySql(const aSectionName: string = ''): Boolean;
    property OnConnectIB: TNotifyEvent read FOnConnectIB write FOnConnectIB;
    property OnConnectAdo: TConnectAdoEvent read FOnConnectAdo write FOnConnectAdo;
    property OnConnectMySql: TConnectAdoEvent read FOnConnectMySql write FOnConnectMySql;
    property OnBevorConnect: TNotifyEvent read FOnBevorConnect write FOnBevorConnect;
    property DatabaseName: string read GetDatabaseName;
    function getTableNameFromField(aFieldname: string): string;
    function getPrimaryKeyFromTable(aTablename: string): string;
    function getUniqueKeyFromTable(aTablename: string): string;
    function getFieldKey(aTablename, aFieldname: string; var aLength: Integer): Integer;
    property DBIni: TDBIni read FDBIni write FDBIni;
    property Datenbank: TcDatenbank read getDatenbank;
    function getAdoconnectStr(aSectionName: string): string;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

uses
  Dialogs;


procedure Tdm.DataModuleCreate(Sender: TObject);
var
  s: string;
begin
  FDBIni := TDBIni.Create;
  FQryTablenameFromField := TIBQuery.Create(nil);
  s := ' select f.rdb$relation_name, f.rdb$field_name' +
       ' from rdb$relation_fields f' +
       ' join rdb$relations r on f.rdb$relation_name = r.rdb$relation_name' +
       ' and r.rdb$view_blr is null' +
       ' and (r.rdb$system_flag is null or r.rdb$system_flag = 0)' +
       ' and rdb$field_name = :fieldname';
  FQryTablenameFromField.SQL.Text := s;

  FQryPrimaryKey := TIBQuery.Create(nil);
  s := ' select i.rdb$index_name, s.rdb$field_name, i.rdb$relation_name' +
       ' from rdb$indices i' +
       ' left join rdb$index_segments s on i.rdb$index_name = s.rdb$index_name' +
       ' left join rdb$relation_constraints rc on rc.rdb$index_name = i.rdb$index_name' +
       ' where rc.rdb$constraint_type = ' + QuotedStr('PRIMARY KEY') +
       ' and   i.rdb$relation_name = :tablename';
  FQryPrimaryKey.SQL.Text := s;

  FQryUniqueKey := TIBQuery.Create(nil);
  s := ' select i.rdb$index_name, s.rdb$field_name, i.rdb$relation_name' +
       ' from rdb$indices i' +
       ' left join rdb$index_segments s on i.rdb$index_name = s.rdb$index_name' +
       ' left join rdb$relation_constraints rc on rc.rdb$index_name = i.rdb$index_name' +
       ' where rc.rdb$constraint_type = ' + QuotedStr('UNIQUE') +
       ' and   i.rdb$relation_name = :tablename';
  FQryUniqueKey.SQL.Text := s;

  FQryFieldKey := TIBQuery.Create(nil);
  s := ' select t3.rdb$field_type, t3.rdb$field_length' +
       ' from RDB$RELATIONS t1, rdb$relation_fields t2, rdb$fields t3' +
       ' where RDB$SYSTEM_FLAG=0' +
       ' and   t1.RDB$RELATION_NAME = t2.RDB$RELATION_NAME' +
       ' and   t2.RDB$FIELD_SOURCE = t3.RDB$FIELD_NAME' +
       ' and   t1.RDB$RELATION_NAME = :Tablename' +
       ' and   t2.rdb$field_name = :Fieldname';
  FQryFieldKey.SQL.Text := s;


end;


procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  FQryTablenameFromField.Close;
  FQryTablenameFromField.UnPrepare;
  FreeAndNil(FQryTablenameFromField);

  FQryPrimaryKey.Close;
  FQryPrimaryKey.UnPrepare;
  FreeAndNil(FQryPrimaryKey);

  FQryUniqueKey.Close;
  FQryUniqueKey.UnPrepare;
  FreeAndNil(FQryUniqueKey);

  FQryFieldKey.Close;
  FQryFieldKey.UnPrepare;
  FreeAndNil(FQryFieldKey);
  FreeAndNil(FDBIni);

end;

function Tdm.ConnectIB(const aSectionName: string = ''): Boolean;
var
 DBIniObj: TDBIniObj;
 SectionName: string;
begin
  Result := false;
  SectionName := aSectionName;
  if SectionName = '' then
    SectionName := FDBIni.CurSectionName;
  DBIniObj := FDBIni.getSection(SectionName);
  if DBIniObj = nil then
    exit;
  if IBDatabase.DatabaseName = '' then
    exit;
  if Assigned(FOnBevorConnect) then
    FOnBevorConnect(Self);
  IBDatabase.Connected := true;
  try
    Result := true;
    FDBIni.CurSectionName := SectionName;
    if Assigned(FOnConnectIB) then
      FOnConnectIB(Self);
  except
    on E:Exception do
    begin
      ShowMessage(E.Message);
      Result := false;
    end;
  end;
end;


function Tdm.ConnectAdo(const aSectionName: string = ''): Boolean;
var
 DBIniObj: TDBIniObj;
 SectionName: string;
 ConStr: string;
begin
  Result := false;
  SectionName := aSectionName;
  if SectionName = '' then
    SectionName := FDBIni.CurSectionName;
  DBIniObj := FDBIni.getSection(SectionName);
  if DBIniObj = nil then
    exit;
  if Assigned(FOnBevorConnect) then
    FOnBevorConnect(Self);
  ConStr := getAdoconnectStr(SectionName);
  //Provider=SQLOLEDB.1;Password=Dwd!919!;Persist Security Info=True;User ID=nfs_esv;Initial Catalog=newfrontiers-cloud-services_db;Data Source=lgkwo8zaze.database.windows.net
  ADOConnect.Connected := false;
  ADOConnect.ConnectionString := ConStr;
  ADOConnect.Connected := true;
  try
    Result := true;
    dm.DBIni.CurSectionName := SectionName;
    if Assigned(FOnConnectAdo) then
      FOnConnectAdo(Self, DBIniObj.Datenbankname, SectionName);
  except
    on E:Exception do
    begin
      ShowMessage(E.Message);
      Result := false;
    end;
  end;
end;


function Tdm.ConnectMySql(const aSectionName: string = ''): Boolean;
var
 DBIniObj: TDBIniObj;
 SectionName: string;
 //ConStr: string;
begin
  Result := false;
  SectionName := aSectionName;
  if SectionName = '' then
    SectionName := FDBIni.CurSectionName;
  DBIniObj := FDBIni.getSection(SectionName);
  if DBIniObj = nil then
    exit;
  if Assigned(FOnBevorConnect) then
    FOnBevorConnect(Self);
  MySqlConnect.Connected := false;
  MySqlConnect.Host := DBIniObj.Server;
  MySqlConnect.DatabaseName := DBIniObj.Datenbankname;
  MySqlConnect.UserName     := DBIniObj.Benutzer;
  MySqlConnect.UserPassword := DBIniObj.Passwort;

  if DBIniObj.Port > -1 then
    MySqlConnect.Port := DBIniObj.Port;

  MySqlConnect.Connected := true;
  try
    dm.DBIni.CurSectionName := SectionName;
    Result := true;
    if Assigned(FOnConnectMySql) then
      FOnConnectMySql(Self, DBIniObj.Datenbankname, SectionName);
  except
    on E:Exception do
    begin
      ShowMessage(E.Message);
      Result := false;
    end;
  end;
end;

function Tdm.getAdoconnectStr(aSectionName: string): string;
var
 DBIniObj: TDBIniObj;
begin
  Result := '';
  DBIniObj := FDBIni.getSection(aSectionName);
  if DBIniObj = nil then
    exit;
  Result := 'Provider=SQLOLEDB.1;' +
            'Password=' + DBIniObj.Passwort + ';' +
            'Persist Security Info=True;' +
            'User ID=' + DBIniObj.Benutzer + ';' +
            'Initial Catalog=' + DBIniObj.Datenbankname + ';' +
            'Data Source=' + DBIniObj.Server;
end;




function Tdm.GetDatabaseName: string;
var
  iPos: Integer;
  DBIniObj: TDBIniObj;
begin
  Result := '';
  DBIniObj := FDBIni.getSection(FDBIni.CurSectionName);
  if (DBIniObj.Datenbank = cFirebird) and (IBDatabase.Connected) then
  begin
    iPos := LastDelimiter('\', IBDatabase.DatabaseName);
    if iPos > 0 then
    begin
      Result := copy(IBDatabase.DatabaseName, iPos+1, Length(IBDatabase.DatabaseName));
    end;
  end;
  if DBIniObj.Datenbank = cMsSql then
  begin
    Result := DBIniObj.Datenbankname;
  end;
end;

function Tdm.getDatenbank: TcDatenbank;
var
  DBIniObj: TDBIniObj;
begin
  DBIniObj := FDBIni.getSection(FDBIni.CurSectionName);
  Result := DBIniObj.Datenbank;
end;

function Tdm.getFieldKey(aTablename, aFieldname: string; var aLength: Integer): Integer;
begin
  Result := -1;
  aLength := 0;
  if FQryFieldKey.Transaction = nil then
  begin
    FQryFieldKey.Transaction := IBTransaction;
    FQryFieldKey.Prepare;
  end;
  FQryFieldKey.Close;
  FQryFieldKey.ParamByName('tablename').AsString := Uppercase(aTablename);
  FQryFieldKey.ParamByName('Fieldname').AsString := Uppercase(aFieldname);
  FQryFieldKey.Open;
  if FQryFieldKey.Eof then
    exit;
  Result  := FQryFieldKey.Fields[0].AsInteger;
  aLength := FQryFieldKey.Fields[1].AsInteger;
end;

function Tdm.getPrimaryKeyFromTable(aTablename: string): string;
begin
  Result := '';
  if FQryPrimaryKey.Transaction = nil then
  begin
    FQryPrimaryKey.Transaction := IBTransaction;
    FQryPrimaryKey.Prepare;
  end;
  FQryPrimaryKey.Close;
  FQryPrimaryKey.ParamByName('tablename').AsString := aTablename;
  FQryPrimaryKey.Open;
  FQryPrimaryKey.FetchAll;
  if (FQryPrimaryKey.RecordCount = 0) or (FQryPrimaryKey.RecordCount > 1) then
    exit;
  Result := Trim(FQryPrimaryKey.Fields[1].AsString);
  FQryPrimaryKey.Close;
end;

function Tdm.getTableNameFromField(aFieldname: string): string;
begin
  Result := '';
  if FQryTablenameFromField.Transaction = nil then
  begin
    FQryTablenameFromField.Transaction := IBTransaction;
    FQryTablenameFromField.Prepare;
  end;
  FQryTablenameFromField.Close;
  FQryTablenameFromField.ParamByName('Fieldname').AsString := aFieldname;
  FQryTablenameFromField.Open;
  FQryTablenameFromField.FetchAll;
  if (FQryTablenameFromField.RecordCount = 0) or (FQryTablenameFromField.RecordCount > 1) then
    exit;
  Result := Trim(FQryTablenameFromField.Fields[0].AsString);
  FQryTablenameFromField.Close;
end;

function Tdm.getUniqueKeyFromTable(aTablename: string): string;
begin
  Result := '';
  if FQryUniqueKey.Transaction = nil then
  begin
    FQryUniqueKey.Transaction := IBTransaction;
    FQryUniqueKey.Prepare;
  end;
  FQryUniqueKey.Close;
  FQryUniqueKey.ParamByName('tablename').AsString := aTablename;
  FQryUniqueKey.Open;
  FQryUniqueKey.FetchAll;
  if (FQryUniqueKey.RecordCount = 0) or (FQryUniqueKey.RecordCount > 1) then
    exit;
  Result := Trim(FQryUniqueKey.Fields[1].AsString);
  FQryUniqueKey.Close;
end;

end.
