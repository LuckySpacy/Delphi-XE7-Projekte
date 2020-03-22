unit DBObj.Boersenindex;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DBObj.Basis, Data.db;

type
  TBoersenindex = class(TBasisDBOj)
  private
    fBI_ID: Integer;
    fBezeichnung: string;
    procedure FuelleDBFelder;
    procedure setBI_ID(const Value: Integer);
    procedure setBezeichnung(const Value: string);
  protected
    _Sql: string;
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    property BI_ID: Integer read fBI_ID write setBI_ID;
    property Bezeichnung: string read fBezeichnung write setBezeichnung;
    procedure ReadFromBoersenindexname(aName: String);
  end;

implementation

{ TAktie }

constructor TBoersenindex.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('BI_ID', ftInteger);
  fFeldList.Add('BI_NAME', ftString);
end;

destructor TBoersenindex.Destroy;
begin
  inherited;
end;


function TBoersenindex.getGeneratorName: string;
begin
  Result := 'BI_ID';
end;

function TBoersenindex.getTableName: string;
begin
  Result := 'Boersenindex';
end;

function TBoersenindex.getTablePrefix: string;
begin
  Result := 'BI';
end;

procedure TBoersenindex.Init;
begin
  inherited;
  fBezeichnung := '';
end;

procedure TBoersenindex.FuelleDBFelder;
begin
  fFeldList.FieldByName('BI_ID').AsInteger   := fID;
  fFeldList.FieldByName('BI_NAME').AsString := fBezeichnung;
end;


procedure TBoersenindex.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fId          := aQuery.FieldByName('bi_id').AsInteger;
  fBezeichnung  := aQuery.FieldByName('bi_name').AsString;
  FuelleDBFelder;
end;

procedure TBoersenindex.ReadFromBoersenindexname(aName: String);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName + ' where bi_name = ' + QuotedStr(aName);
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;

procedure TBoersenindex.setBezeichnung(const Value: string);
begin
  UpdateV(fBezeichnung, Value);
  fFeldList.FieldByName('BI_NAME').AsString := fBezeichnung;
end;

procedure TBoersenindex.setBI_ID(const Value: Integer);
begin
  UpdateV(fBI_Id, Value);
  fFeldList.FieldByName('BI_ID').AsInteger := fBI_Id;
end;

end.
