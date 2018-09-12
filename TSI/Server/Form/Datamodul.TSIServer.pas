unit Datamodul.TSIServer;

interface

uses
  System.SysUtils, System.Classes, IBX.IBDatabase, Data.DB, mySQLDbTables,
  IBX.IBCustomDataSet, IBX.IBQuery;

type
  Tdm = class(TDataModule)
    DatabaseKurse: TIBDatabase;
    IBTKursex: TIBTransaction;
    DatabaseTSI: TIBDatabase;
    IBTTSI: TIBTransaction;
    DBMySqlTSI: TMySQLDatabase;
    IBQuery1: TIBQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DBMySqlTSIConnectionFailure(Connection: TMySQLDatabase;
      Error: string);
  private
    fDBMySqlTSIConnectError: Boolean;
    fDBMySqlTSIConnectErrorMsg: string;
  public
    function ConnectKurse: Boolean;
    function ConnectTSI: Boolean;
    function ConnectMySql: Boolean;
    property DBMySqlTSIConnectError: Boolean read fDBMySqlTSIConnectError;
    property DBMySqlTSIConnectErrorMsg: string read fDBMySqlTSIConnectErrorMsg;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  System.UITypes, Objekt.Ini, Objekt.Protokoll;


{ Tdm }

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  fDBMySqlTSIConnectError := false;
end;


procedure Tdm.DBMySqlTSIConnectionFailure(Connection: TMySQLDatabase;
  Error: string);
begin
  fDBMySqlTSIConnectError := true;
  fDBMySqlTSIConnectErrorMsg := Error;
end;


function Tdm.ConnectKurse: Boolean;
var
  lst: TStringList;
  Filename: string;
begin
  if DatabaseKurse.Connected then
  begin
    Result := true;
    exit;
  end;
  DatabaseKurse.DatabaseName := Ini.Server + ':' + Ini.KurseFDB;
  DatabaseKurse.Params.Clear;
  DatabaseKurse.Params.Add('user_name=sysdba');
  DatabaseKurse.Params.Add('password=masterkey');
  DatabaseKurse.LoginPrompt := false;
  try
    DatabaseKurse.Connected := true;
  except
    on E: Exception do
    begin
      lst := TStringList.Create;
      try
        lst.Add('Databasename = ' + DatabaseKurse.DatabaseName);
        lst.Add(E.Message);
        Filename := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Error.txt';
        lst.SaveToFile(Filename);
      finally
        FreeAndNil(lst);
      end;
      Protokoll.write('Tdm.ConnectKurse', E.Message);
      Result := false;
      exit;
    end;
  end;
  Result := true;
end;


function Tdm.ConnectTSI: Boolean;
var
  lst: TStringList;
  Filename: string;
begin
  if DatabaseTSI.Connected then
  begin
    Result := true;
    exit;
  end;
  DatabaseTSI.DatabaseName := Ini.Server + ':' + Ini.TSIFDB;
  DatabaseTSI.Params.Clear;
  DatabaseTSI.Params.Add('user_name=sysdba');
  DatabaseTSI.Params.Add('password=masterkey');
  DatabaseTSI.LoginPrompt := false;
  try
    DatabaseTSI.Connected := true;
  except
    on E: Exception do
    begin
      lst := TStringList.Create;
      try
        lst.Add('Databasename = ' + DatabaseKurse.DatabaseName);
        lst.Add(E.Message);
        Filename := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Error.txt';
        lst.SaveToFile(Filename);
      finally
        FreeAndNil(lst);
      end;
      Protokoll.write('Tdm.ConnectKurse', E.Message);
      Result := false;
      exit;
    end;
  end;
  Result := true;
end;


function Tdm.ConnectMySql: Boolean;
begin
  Result := true;
  try
    DBMySqlTSI.Connect;
  except
    Result := false;
  end;
end;



end.
