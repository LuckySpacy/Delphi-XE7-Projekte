unit View.Eigenschaft;

interface

uses
  SysUtils, Classes, DB.Base, Data.DB, mySQLDbTables;

type
  TViewEigenschaft = class(TDBBase)
  private
    fqry: TMySqlQuery;
    fEiId: Integer;
    fEnId: Integer;
    fEiMatch: string;
    fEnMatch: string;
    fChecked: Boolean;
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
    property EI_ID: Integer read fEiId write fEiId;
    property EI_Match: string read fEiMatch write fEiMatch;
    property EN_ID: Integer read fEnId write fEnId;
    property EN_Match: string read fEnMatch write fEnMatch;
    property Checked: Boolean read fChecked write fChecked;
  end;

implementation

{ TViewEigenschaft }

constructor TViewEigenschaft.Create(AOwner: TComponent);
begin
  inherited;
  fqry := TMySqlQuery.Create(nil);
  fqry.Database := fQuery.Database;
end;

destructor TViewEigenschaft.Destroy;
begin
  FreeAndNil(fqry);
  inherited;
end;


procedure TViewEigenschaft.Delete;
begin

end;


function TViewEigenschaft.getGeneratorName: string;
begin
  Result := 'ei_id';
end;

function TViewEigenschaft.getTableName: string;
begin
  Result := '';
end;

function TViewEigenschaft.getTablePrefix: string;
begin
  Result := '';
end;

procedure TViewEigenschaft.Init;
begin
  inherited;
  fEiId := 0;
  fEnId := 0;
  fEiMatch:= '';
  fEnMatch:= '';
  fChecked := false;
end;

procedure TViewEigenschaft.LoadByQuery(aQuery: TMySQLQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fEiId := aQuery.FieldByName('ei_id').AsInteger;
  fEnId := aQuery.FieldByName('en_id').AsInteger;
  fEiMatch := aQuery.FieldByName('ei_match').AsString;
  fEnMatch := aQuery.FieldByName('en_match').AsString;
end;

procedure TViewEigenschaft.Save;
begin

end;

end.
