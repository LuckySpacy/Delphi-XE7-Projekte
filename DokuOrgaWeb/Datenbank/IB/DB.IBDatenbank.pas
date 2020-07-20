unit DB.IBDatenbank;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, Objekt.IniEinstellung, TBTrans, TBQuery;


//{$R DokuOrgares.res}


type
  TIBDatenbank = class
  private
    FDatabase: TIBDatabase;
    fIni: TIniEinstellung;
    fTrans: TTBTrans;
    fQry: TTBQuery;
    fUseInterbase: Boolean;
    procedure setUseInterbase(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    function DataBase: TIBDatabase;
    function Connect: String;
    procedure Disconnect;
    property Trans: TTBTrans read fTrans write fTrans;
    property Qry: TTBQuery read fQry write fQry;
    property UseInterbase: Boolean read fUseInterbase write setUseInterbase;
  end;

implementation

{ TIBDatenbank }


constructor TIBDatenbank.Create;
begin
  fDatabase := TIBDatabase.Create(nil);
  fIni := TIniEinstellung.Create;
  fTrans := nil;
  fQry   := nil;
end;

destructor TIBDatenbank.Destroy;
begin
  FreeAndNil(fDataBase);
  FreeAndNil(fIni);
  if fTrans <> nil then
    FreeAndNil(fTrans);
  if fQry <> nil then
    FreeAndNil(fQry);
  inherited;
end;

procedure TIBDatenbank.Disconnect;
begin
  FDatabase.Connected := false;
end;

procedure TIBDatenbank.setUseInterbase(const Value: Boolean);
begin
  fUseInterbase := Value;
  if fQry <> nil then
    fQry.UseInterbase := fUseInterbase;
end;

function TIBDatenbank.DataBase: TIBDatabase;
begin
  Result := fDatabase;
end;

function TIBDatenbank.Connect: string;
begin
  Result := '';
  FDatabase.Connected    := false;
  FDatabase.LoginPrompt  := false;
  FDatabase.DatabaseName := fIni.Host + ':' + IncludeTrailingPathDelimiter(fIni.Datenbankpfad) + fIni.Datenbankname;
  FDatabase.Params.Clear;
  FDatabase.Params.Add('user_name=sysdba');
  FDatabase.Params.Add('password=masterkey');
  try
    FDatabase.Connected := true;
    if fTrans = nil then
    begin
      fTrans := TTBTrans.Create(nil);
      fTrans.Trans.DefaultDatabase := FDatabase;
    end;
    if fQry = nil then
    begin
      fQry := TTBQuery.Create(nil);
      fQry.TBTrans := fTrans;
      fQry.UseInterbase := fUseInterbase;
    end;
  except
    on E: Exception do
    begin
      Result := e.Message;
    end;
  end;

end;


end.
