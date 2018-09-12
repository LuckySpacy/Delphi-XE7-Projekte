unit o_db;

interface

uses
  Classes, IBDatabase, IBQuery, Dialogs, ContNrs, SysUtils, Graphics, o_Field;

  type TDB = class(TComponent)
  private
    FIntQuery: TIBQuery;
    FIBTInt: TIBTransaction;
    FIBT: TIBTransaction;
    function GetId: Int64;
    function getGeneratorValue: Int64;
    procedure SetId(const Value: Int64);
  protected
    FQuery: TIBQuery;
    FID: Integer;
    FFound: Boolean;
    FFieldList: TObjectList;
    function getTableName: string; virtual; abstract;
    function getTablePrefix: string; virtual; abstract;
    procedure setSaveSqlText; virtual; abstract;
    function AddField: TTBField;
    procedure ClearValues;
    procedure SetValues(aQuery: TIBQuery); virtual;
  published
  public
    constructor Create(AOwner: TComponent; aIBT: TIBTransaction); reintroduce; virtual;
    destructor Destroy; override;
    function getAllRecordCount: Integer;
    property ID: Int64 read GetId write SetId;
    procedure Rollback;
    procedure Commit;
    function Save: Boolean; virtual;
    procedure ReadId(aValue: Integer);
    procedure Init;
    property Found: Boolean read FFound;
  end;

implementation

{ TDB }

uses
  untDM;


constructor TDB.Create(AOwner: TComponent; aIBT: TIBTransaction);
begin
  inherited Create(AOwner);
  FFieldList := TObjectList.Create;
  FIBT := aIBT;
  FIBTInt := TIBTransaction.Create(AOwner);
  FIBTInt.DefaultDatabase := dm.IBD;
  FIntQuery := TIBQuery.Create(AOwner);
  FIntQuery.Transaction := FIBTInt;
  FID := -1;
  FFound := false;
  FQuery := TIBQuery.Create(AOwner);
  FQuery.Transaction := FIBT;
end;

destructor TDB.Destroy;
begin
  FreeAndNil(FIntQuery);
  FreeAndNil(FQuery);
  FreeAndNil(FIBTInt);
  FreeAndNil(FFieldList);
  inherited;
end;


procedure TDB.Init;
begin
  ClearValues;
  FID    := -1;
  FFound := false;
end;


function TDB.AddField: TTBField;
begin
  Result := TTBField.Create;
  FFieldList.Add(Result);
end;


function TDB.getAllRecordCount: Integer;
begin
  if FIBTInt.InTransaction then
    FIBTInt.Rollback;
  FIntQuery.SQL.Text := 'select count(*) from ' + getTableName;
  FIBTInt.StartTransaction;
  try
    FIntQuery.Open;
    Result := FIntQuery.Fields[0].AsInteger;
  finally
    FIBTInt.Rollback;
  end;
end;

function TDB.GetId: Int64;
begin
  Result := FID;
end;


procedure TDB.ReadId(aValue: Integer);
begin
  if FIBTInt.InTransaction then
    FIBTInt.Rollback;
  FIntQuery.Close;
  FIntQuery.SQL.Text := ' select * from ' + getTableName +
                        ' where ' + getTablePrefix + '_id = :id';
  FIntQuery.ParamByName('id').AsInteger := aValue;
  FIBTInt.StartTransaction;
  try
    FIntQuery.Open;
    SetValues(FIntQuery);
  finally
    FIBTInt.Rollback;
  end;
end;

procedure TDB.Rollback;
begin
  if FIBT.InTransaction then
    FIBT.Rollback;
end;


procedure TDB.ClearValues;
var
  i1: Integer;
  Field: TTBField;
begin
  for i1 := 0 to FFieldList.Count - 1 do
  begin
    Field := TTBField(FFieldList.Items[i1]);
    Field.SetValueEmpty;
    FID := -1;
    FFound := false;
  end;
end;

procedure TDB.Commit;
begin
  if FIBT.InTransaction then
    FIBT.Commit;
end;



function TDB.Save: Boolean;
begin
  Result := false;
  try
    if not Assigned(FIBT) then
      exit;
    FQuery.Transaction := FIBT;

    if not FIBT.InTransaction then
      FIBT.StartTransaction;

    if not FFound then
    begin
      FID := getGeneratorValue;
      if FID = -1 then
        exit;
    end;

    SetSaveSqlText;

    FQuery.ExecSQL;
  except
    on E: Exception do
    begin
      ShowMessage('Fehler beim Speichern.' + #13 + E.Message);
      exit;
    end;
  end;

  Result := true;

end;


procedure TDB.SetId(const Value: Int64);
begin
  FID := Value;
end;

procedure TDB.SetValues(aQuery: TIBQuery);
begin
  ClearValues;
  FFound := false;
  if aQuery.eof then
    exit;
  FFound := true;
  FID := aQuery.FieldByName(getTablePrefix + '_id').AsInteger;
end;

function TDB.getGeneratorValue: Int64;
begin
  try
    FIntQuery.Close;
    FIntQuery.SQL.Text := 'select GEN_ID(' + getTablePrefix + '_ID, 1) from IDGEN';
    FIntQuery.Open;
    Result := FIntQuery.Fields[0].AsInteger;
  except
    ShowMessage('Fehler beim Lesen des Generators --> ' + getTablePrefix + '_ID');
    result := -1;
  end;
end;


end.
