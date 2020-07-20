unit DB.Eigenschaft;

interface

uses
  SysUtils, Classes, DB.Base, Data.DB, mySQLDbTables;

type
  TDBEigenschaft = class(TDBBase)
  private
    fMatch: string;
    fEnId: Integer;
    procedure setMatch(const Value: string);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Match: string read fMatch write setMatch;
    property EnId: Integer read fEnId write fEnId;
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
end;

procedure TDBEigenschaft.LoadByQuery(aQuery: TMySQLQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fMatch := aQuery.FieldByName('ei_match').AsString;
  fEnId  := aQuery.FieldByName('ei_en_id').AsInteger;
end;

procedure TDBEigenschaft.Save;
var
  Sql: string;
begin
  if fId = 0 then
    Sql := 'insert into eigenschaft (ei_match, ei_en_id) values (:match, :enid)'
  else
    Sql := ' update eigenschaft set ei_match = :match, ei_en_id = :enid'  +
           ' where ei_id = ' + IntToStr(fId);
 fQuery.SQL.Text := Sql;
 fQuery.ParamByName('match').AsString := fMatch;
 fQuery.ParamByName('enid').AsInteger := fEnId;
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

end.
