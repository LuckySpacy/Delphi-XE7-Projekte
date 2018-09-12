unit DB.Basis;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.FeldList, Data.db,
  vcl.Dialogs, DB.Feld, System.UITypes;

type
  TDBBasis = class(TComponent)
  private
    fGefunden: Boolean;
    fId: Integer;
  protected
    fFeldList: TDBFeldList;
    fTrans: TIBTransaction;
    fTransCounter: Integer;
    fQuery: TIBQuery;
    function getGeneratorName: string; virtual; abstract;
    function getTableName: string; virtual; abstract;
    function getTablePrefix: string; virtual; abstract;
  public
    constructor Create(AOwner: TComponent; aIBT: TIBTransaction); reintroduce; overload; virtual;
    destructor Destroy; override;
    property FeldList: TDBFeldList read fFeldList write fFeldList;
    procedure Init; virtual;
    property Id: Integer read fId;
    function GenerateId: Integer;
    procedure OpenTrans;
    procedure CommitTrans;
    procedure RollbackTrans;
    procedure LoadByQuery(aQuery: TIBQuery); virtual;
    property Gefunden: Boolean read fGefunden;
    procedure Read(aId: Integer); virtual;
    function DoUpdate: Boolean;
    function ClearUpdate: Boolean;
    procedure FuelleDBFelder(aQuery: TIBQuery);
    procedure SaveToDB; virtual;
    function ParamByName(aFieldName: string): TDBFeld;
    function FieldByName(aFieldName: string): TDBFeld;
    procedure Delete;
  end;

implementation

{ TDBBasis }



constructor TDBBasis.Create(AOwner: TComponent; aIBT: TIBTransaction);
begin
  inherited Create(AOwner);
  fTrans := aIBT;
  fTransCounter := 0;
  fFeldList := TDBFeldList.Create;
  fFeldList.Tablename := getTableName;
  fFeldList.PrimaryKey := getTablePrefix + '_ID';
  fQuery := TIBQuery.Create(nil);
  fQuery.Transaction := fTrans;
end;



destructor TDBBasis.Destroy;
begin
  FreeAndNil(fQuery);
  FreeAndNil(fFeldList);
  inherited;
end;

procedure TDBBasis.Init;
var
  i1: Integer;
begin
  fId := 0;
  fGefunden := false;
  if fFeldList = nil then
    exit;
  ClearUpdate;
  for i1 := 0 to fFeldList.Count -1 do
  begin
    if fFeldList.Feld[i1].DataType = ftString then
      fFeldList.Feld[i1].AsString := '';
    if (fFeldList.Feld[i1].DataType = ftInteger)
    or (fFeldList.Feld[i1].DataType = ftFloat) then
      fFeldList.Feld[i1].AsInteger := 0;
    if fFeldList.Feld[i1].DataType = ftDateTime then
      fFeldList.Feld[i1].AsDateTime := now;
    if fFeldList.Feld[i1].DataType = ftBoolean then
      fFeldList.Feld[i1].AsBoolean := false;
  end;

end;



function TDBBasis.DoUpdate: Boolean;
var
  i1: Integer;
begin
  Result := false;
  for i1 := 0 to fFeldList.Count -1 do
  begin
    if fFeldList.Feld[i1].Changed then
    begin
      Result := true;
      exit;
    end;
  end;
end;


procedure TDBBasis.FuelleDBFelder(aQuery: TIBQuery);
var
  i1: Integer;
begin
  for i1 := 0 to fFeldList.Count -1 do
  begin
    if not fFeldList.Feld[i1].CalcField then
      fFeldList.Feld[i1].AsString := aQuery.FieldByName(fFeldList.Feld[i1].Feldname).AsString;
  end;
end;


function TDBBasis.ClearUpdate: Boolean;
var
  i1: Integer;
begin
  Result := false;
  if fFeldList = nil then
    exit;
  for i1 := 0 to fFeldList.Count -1 do
    fFeldList.Feld[i1].Changed := false;
end;


function TDBBasis.GenerateId: Integer;
begin
  Result := 0;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select GEN_ID(' + getGeneratorName + ', 1) FROM RDB$DATABASE';
  OpenTrans;
  try
    fQuery.Open;
    Result := fQuery.Fields[0].AsInteger;
    fQuery.Close;
  finally
    CommitTrans;
  end;
end;


procedure TDBBasis.LoadByQuery(aQuery: TIBQuery);
var
  FeldName: string;
begin
  Init;
  fGefunden := not aQuery.Eof;
  if aQuery.Eof then
    exit;
  Feldname := '';
  if aQuery.FieldByName(getTablePrefix + '_id') <> nil then
    FeldName := getTablePrefix + '_id'
  else
    if aQuery.FieldByName(getGeneratorName) <> nil then
      Feldname := getGeneratorName;

  fId := aQuery.FieldByName(Feldname).AsInteger;
  FuelleDBFelder(aQuery);
end;

procedure TDBBasis.OpenTrans;
begin
  inc(fTransCounter);
  if not fTrans.InTransaction then
    fTrans.StartTransaction;
end;

function TDBBasis.ParamByName(aFieldName: string): TDBFeld;
begin
  Result := fFeldList.FieldByName(aFieldName);
end;

function TDBBasis.FieldByName(aFieldName: string): TDBFeld;
begin
  Result := fFeldList.FieldByName(aFieldName);
end;


procedure TDBBasis.CommitTrans;
begin
  dec(fTransCounter);
  if (not fTrans.InTransaction) or (fTransCounter > 0) then
    exit;
  fTrans.Commit;
  fTransCounter := 0;
end;

procedure TDBBasis.RollbackTrans;
begin
  dec(fTransCounter);
  if (not fTrans.InTransaction) or (fTransCounter > 0) then
    exit;
  fTrans.Rollback;
  fTransCounter := 0;
end;



procedure TDBBasis.Read(aId: Integer);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName + ' where ' + getGeneratorName + '=' + IntToStr(aId);
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;

procedure TDBBasis.Delete;
begin
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := ' update ' + getTableName +
                     ' set ' + getTablePrefix + '_delete = "T"' +
                     ' where ' + getTablePrefix + '_id =' + IntToStr(fId);
  OpenTrans;
  try
    fQuery.ExecSQL
  except
    RollbackTrans;
    exit;
  end;
  CommitTrans;
end;



procedure TDBBasis.SaveToDB;
var
  Sql: string;
begin
  if not Assigned(fTrans) then
    exit;
  if (not DoUpdate) and (fId > 0) then
    exit;
  ClearUpdate;
  if fId = 0 then
  begin
    fid := GenerateId;
    fFeldList.FieldByName(getGeneratorName).AsInteger := fId;
    Sql := fFeldList.InsertStatement;
  end
  else
    Sql := fFeldList.UpdateStatement;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := Sql;
  OpenTrans;
  try
    fQuery.ExecSQL;
  except
    on E: Exception do
    begin
      RollbackTrans;
      MessageDlg(E.Message, mtError, [mbOk], 0);
      raise;
      exit;
    end;
  end;
  CommitTrans;
end;





end.
