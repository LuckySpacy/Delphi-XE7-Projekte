unit DB.ArtikelEigenschaft;

interface

uses
  SysUtils, Classes, DB.Base, Data.DB, mySQLDbTables;

type
  TDBArtikelEigenschaft = class(TDBBase)
  private
    fArId: Integer;
    fEiId: Integer;
    fEnId: Integer;
    procedure setArId(const Value: Integer);
    procedure setEiId(const Value: Integer);
    procedure setEnId(const Value: Integer);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TMySQLQuery); override;
    procedure Save;
    procedure Delete;
    property AR_ID: Integer read fArId write setArId;
    property EN_ID: Integer read fEnId write setEnId;
    property EI_ID: Integer read fEiId write setEiId;
    procedure Lese(aArId, aEnId, aEiId: Integer);
    function Checked(aArId, aEnId, aEiId: Integer): Boolean;
  end;

implementation

{ TDBArtikelEigenschaft }


constructor TDBArtikelEigenschaft.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TDBArtikelEigenschaft.Destroy;
begin

  inherited;
end;


procedure TDBArtikelEigenschaft.Delete;
var
  Sql: string;
begin
  Sql := 'delete from ' + getTableName + ' where ' + getGeneratorName + ' = ' + IntToStr(fId);
  fQuery.SQL.Text := Sql;
  fQuery.ExecSQL;
end;



function TDBArtikelEigenschaft.getGeneratorName: string;
begin
  Result := 'AE_ID';
end;

function TDBArtikelEigenschaft.getTableName: string;
begin
  Result := 'Artikeleigenschaft';
end;

function TDBArtikelEigenschaft.getTablePrefix: string;
begin
  Result := 'AE';
end;

procedure TDBArtikelEigenschaft.Init;
begin
  inherited;
  fArId := 0;
  fEiId := 0;
  fEnId := 0;
end;


procedure TDBArtikelEigenschaft.LoadByQuery(aQuery: TMySQLQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fArId := aQuery.FieldByName('ae_ar_id').AsInteger;
  fEnId := aQuery.FieldByName('ae_en_id').AsInteger;
  fEiId := aQuery.FieldByName('ae_ei_id').AsInteger;
end;

procedure TDBArtikelEigenschaft.Save;
var
  Sql: string;
begin
  if fId = 0 then
    Sql := 'insert into artikeleigenschaft (ae_ar_id, ae_en_id, ae_ei_id) values (:arid, :enid, :eiid)'
  else
    Sql := ' update artikeleigenschaft set ae_ar_id = :arid, ae_en_id = :enid, ae_ei_id = :eiid'  +
           ' where ae_id = ' + IntToStr(fId);
 fQuery.SQL.Text := Sql;
 fQuery.ParamByName('arid').AsInteger := farid;
 fQuery.ParamByName('enid').AsInteger := fEnId;
 fQuery.ParamByName('eiid').AsInteger := fEiId;
 fQuery.ExecSQL;
end;

procedure TDBArtikelEigenschaft.Lese(aArId, aEnId, aEiId: Integer);
begin
  fQuery.Close;
  fQuery.SQL.Text := 'select * from ' + getTableName +
                     ' where ae_ar_id = ' + IntToStr(aArId) +
                     ' and   ae_en_id = ' + IntToStr(aEnId) +
                     ' and   ae_ei_id = ' + IntToStr(aEiId);
  fQuery.Open;
  LoadByQuery(fQuery);
  fQuery.Close;
end;

function TDBArtikelEigenschaft.Checked(aArId, aEnId, aEiId: Integer): Boolean;
begin
  Lese(aArId, aEnId, aEiId);
  Result := fId > 0;
end;



procedure TDBArtikelEigenschaft.setArId(const Value: Integer);
begin
  UpdateV(fArId, Value);
end;

procedure TDBArtikelEigenschaft.setEiId(const Value: Integer);
begin
  UpdateV(fEiId, Value);
end;

procedure TDBArtikelEigenschaft.setEnId(const Value: Integer);
begin
  UpdateV(fEnId, Value);
end;

end.
