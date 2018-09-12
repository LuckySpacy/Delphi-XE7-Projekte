unit o_benutzer;

interface
uses
  Classes, IBDatabase, IBQuery, Dialogs, ContNrs, SysUtils, o_db, o_Field;

type TBenutzer = class(TDB)
  private
    FIBT   : TIBTransaction;
    FLogin : TTBField;
    FName: TTBField;
    FPasswort: TTBField;
  protected
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure setSaveSqlText; override;
    procedure SetValues(aQuery: TIBQuery); override;
  published
  public
    constructor Create(AOwner: TComponent; aIBT: TIBTransaction); override;
    destructor Destroy; override;
    property Login: TTBField read FLogin;
    property Passwort: TTBField read FPasswort;
    property Name: TTBField read FName;
    property Transaction: TIBTransaction read FIBT;
    procedure ReadBenutzer(aLoginname, aPasswort: string);
  end;


implementation

{ TBenutzer }

constructor TBenutzer.Create(AOwner: TComponent; aIBT: TIBTransaction);
begin
  inherited;
  FIBT      := aIBT;
  FLogin    := AddField;
  FName     := AddField;
  FPasswort := AddField;
end;


destructor TBenutzer.Destroy;
begin
  inherited;
end;


procedure TBenutzer.SetSaveSqlText;
var
  Sql: string;
begin
  if FFound then
  begin
    Sql := ' update benutzer set' +
           ' be_login    = :login' +
           ' be_passwort = :passwort' +
           ' be_name     = :name' +
           ' where be_id = :id';
  end
  else
  begin

    Sql := ' insert into benutzer (' +
           ' be_id, be_login, be_passwort, be_name) ' +
           ' values (' +
           ' :id, :login, :passwort, :name)';
  end;

  FQuery.SQL.Text := Sql;

  FQuery.Params.ParamByName('login').AsString    := FLogin.AsString;
  FQuery.Params.ParamByName('passwort').AsString := FPasswort.AsString;
  FQuery.Params.ParamByName('name').AsString     := FName.AsString;
  FQuery.Params.ParamByName('id').AsInteger      := Fid;
end;

procedure TBenutzer.SetValues(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  FLogin.AsString    := aQuery.FieldByName('be_login').AsString;
  FName.AsString     := aQuery.FieldByName('be_name').AsString;
  FPasswort.AsString := aQuery.FieldByName('be_passwort').AsString;
end;

function TBenutzer.getTableName: string;
begin
  Result := 'Benutzer';
end;

function TBenutzer.getTablePrefix: string;
begin
  Result := 'BE';
end;



procedure TBenutzer.ReadBenutzer(aLoginname, aPasswort: string);
begin
  FQuery.Close;
  FQuery.SQL.Text := ' select * from benutzer' +
                     ' where be_login = :login' +
                     ' and   be_passwort = :passwort';
  FQuery.Params.ParamByName('login').AsString    := aLoginname;
  FQuery.Params.ParamByName('passwort').AsString := aPasswort;
  if FIBT.InTransaction then
    FIBT.Rollback;
  FIBT.StartTransaction;
  try
    FQuery.Open;
    SetValues(FQuery);
  finally
    FIBT.Rollback;
  end;
end;

end.
