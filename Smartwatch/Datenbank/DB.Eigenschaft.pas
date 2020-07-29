unit DB.Eigenschaft;

interface

uses
  SysUtils, Classes, DB.Base, Data.DB, mySQLDbTables;

type
  TDBEigenschaft = class(TDBBase)
  private
    fMatch: string;
    fEnId: Integer;
    fSaId: Integer;
    procedure setMatch(const Value: string);
    procedure setSaId(const Value: Integer);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Match: string read fMatch write setMatch;
    property EnId: Integer read fEnId write fEnId;
    property SaId: Integer read fSaId write setSaId;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TMySQLQuery); override;
    procedure Save;
    procedure Delete;
  end;

implementation

{ TDBEigenschaft }

constructor TDBEigenschaft.Create(AOwner: TComponent);
begin
  inherited;

end;


destructor TDBEigenschaft.Destroy;
begin

  inherited;
end;

function TDBEigenschaft.getGeneratorName: string;
begin
  Result := 'EI_ID';
end;

function TDBEigenschaft.getTableName: string;
begin
  Result := 'Eigenschaft';
end;

function TDBEigenschaft.getTablePrefix: string;
begin
  Result := 'EI';
end;

procedure TDBEigenschaft.Init;
begin
  inherited;
  fMatch := '';
  fEnId  := 0;
  fSaId  := 0;
end;

procedure TDBEigenschaft.LoadByQuery(aQuery: TMySQLQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fMatch := aQuery.FieldByName('ei_match').AsString;
  fEnId  := aQuery.FieldByName('ei_en_id').AsInteger;
  fSaId  := aQuery.FieldByName('ei_sa_id').AsInteger;
end;

procedure TDBEigenschaft.Save;
var
  Sql: string;
begin
  if fId = 0 then
    Sql := 'insert into eigenschaft (ei_match, ei_en_id, ei_sa_id, ei_datum) values (:match, :enid, :said, :datum)'
  else
    Sql := ' update eigenschaft set ei_match = :match, ei_en_id = :enid, ei_sa_id = :said, ei_datum = :datum '  +
           ' where ei_id = ' + IntToStr(fId);
 fQuery.SQL.Text := Sql;
 fQuery.ParamByName('match').AsString := fMatch;
 fQuery.ParamByName('enid').AsInteger := fEnId;
 fQuery.ParamByName('said').AsInteger := fSaId;
 fQuery.ParamByName('datum').AsDateTime := trunc(now);
 fQuery.ExecSQL;
end;

procedure TDBEigenschaft.Delete;
var
  Sql: string;
begin
  Sql := 'delete from ' + getTableName + ' where ' + getGeneratorName + ' = ' + IntToStr(fId);
  fQuery.SQL.Text := Sql;
  fQuery.ExecSQL;
end;


procedure TDBEigenschaft.setMatch(const Value: string);
begin
  UpdateV(fMatch, Value);
end;

procedure TDBEigenschaft.setSaId(const Value: Integer);
begin
  UpdateV(fSaId, Value);
end;

end.
