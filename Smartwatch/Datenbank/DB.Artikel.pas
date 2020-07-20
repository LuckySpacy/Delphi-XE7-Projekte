unit DB.Artikel;

interface

uses
  SysUtils, Classes, DB.Base, Data.DB, mySQLDbTables;

type
  TDBArtikel = class(TDBBase)
  private
    fMatch: string;
    fNr: string;
    procedure setMatch(const Value: string);
    procedure setNr(const Value: String);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Match: string read fMatch write setMatch;
    property Nr: String read fNr write setNr;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TMySQLQuery); override;
    procedure Save;
    procedure Delete;
    procedure Read(aId: Integer); override;
  end;

implementation

{ TDBArtikel }


constructor TDBArtikel.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TDBArtikel.Destroy;
begin

  inherited;
end;


function TDBArtikel.getGeneratorName: string;
begin
  Result := 'AR_ID';
end;

function TDBArtikel.getTableName: string;
begin
  Result := 'Artikel';
end;

function TDBArtikel.getTablePrefix: string;
begin
  Result := 'AR';
end;

procedure TDBArtikel.Init;
begin
  inherited;
  fMatch := '';
  fNr    := '';
end;

procedure TDBArtikel.LoadByQuery(aQuery: TMySQLQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fMatch := aQuery.FieldByName('ar_match').AsString;
  fNr    := aQuery.FieldByName('ar_nr').AsString;
end;

procedure TDBArtikel.Read(aId: Integer);
begin
  inherited Read(aId);
  LoadByQuery(fQuery);
  fQuery.Close;
end;

procedure TDBArtikel.Save;
var
  Sql: string;
begin
  if fId = 0 then
    Sql := 'insert into artikel (ar_match, ar_nr) values (:match, :nr)'
  else
    Sql := ' update artikel set ar_match = :match, ar_nr = :nr'  +
           ' where ar_id = ' + IntToStr(fId);
 fQuery.SQL.Text := Sql;
 fQuery.ParamByName('match').AsString := fMatch;
 fQuery.ParamByName('nr').AsString := fNr;
 fQuery.Database.StartTransaction;
 fQuery.ExecSQL;
 fQuery.Database.Commit;
 if fId = 0 then
 begin
   fQuery.SQL.Text := 'select ar_id from artikel order by ar_id desc';
   fQuery.Open;
   fId := fQuery.FieldByName('ar_id').AsInteger;    //muss neu überdacht werden.
 end;
end;

procedure TDBArtikel.setMatch(const Value: string);
begin
  UpdateV(fMatch, Value);
end;


procedure TDBArtikel.setNr(const Value: String);
begin
  UpdateV(fNr, Value);
end;

procedure TDBArtikel.Delete;
var
  Sql: string;
begin
  Sql := 'delete from ' + getTableName + ' where ' + getGeneratorName + ' = ' + IntToStr(fId);
  fQuery.SQL.Text := Sql;
  fQuery.ExecSQL;
  Sql := 'delete from firmaartikel where fa_ar_id = ' + IntToStr(fId);
  fQuery.SQL.Text := Sql;
  fQuery.ExecSQL;
end;

end.
