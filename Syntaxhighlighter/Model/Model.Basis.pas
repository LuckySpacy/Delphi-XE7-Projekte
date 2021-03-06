unit Model.Basis;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.DBFeldList, Data.db,
  vcl.Dialogs;


type
  TBasisModel = class(TComponent)
  private
  protected
    fTrans: TIBTransaction;
    //_WasOpen: Boolean;
    fQuery: TIBQuery;
    fId: Integer;
    fDoUpdate: Boolean;
    fFeldList: TDBFeldList;
    fGefunden: Boolean;
    fTransCounter: Integer;
    function getGeneratorName: string; virtual; abstract;
    function getTableName: string; virtual; abstract;
    function getTablePrefix: string; virtual; abstract;
    procedure UpdateV(var aOldValue: string; aNewValue: string); overload;
    procedure UpdateV(var aOldValue: Integer; aNewValue: Integer); overload;
    procedure UpdateV(var aOldValue: Boolean; aNewValue: Boolean); overload;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; virtual;
    procedure OpenTrans;
    procedure CommitTrans;
    procedure RollbackTrans;
    procedure LoadByQuery(aQuery: TIBQuery); virtual;
    property Id: Integer read fId;
    property Trans: TIBTransaction read fTrans write fTrans;
    property FeldList: TDBFeldList read fFeldList write fFeldList;
    property Gefunden: Boolean read fGefunden;
    procedure Read(aId: Integer); virtual;
    procedure Delete; virtual;
    procedure SaveToDB; virtual;
    function GenerateId: Integer;
  end;


implementation

{ TBasisModel }

uses
  System.UITypes;


constructor TBasisModel.Create(AOwner: TComponent);
begin
  inherited;
  fTrans := nil;
  fTransCounter := 0;
  fQuery := TIBQuery.Create(nil);
  fFeldList := TDBFeldList.Create(nil);
  fFeldList.Tablename := getTableName;
  fFeldList.PrimaryKey := getGeneratorName;
  fFeldList.Add(getGeneratorName, ftInteger);
end;

destructor TBasisModel.Destroy;
begin
  FreeAndNil(fQuery);
  FreeAndNil(fFeldList);
  inherited;
end;

function TBasisModel.GenerateId: Integer;
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

procedure TBasisModel.Init;
begin
  fId := 0;
  fGefunden := false;
  fDoUpdate := false;
end;

procedure TBasisModel.LoadByQuery(aQuery: TIBQuery);
begin
  Init;
  fGefunden := not aQuery.Eof;
  if aQuery.Eof then
    exit;
  fId := aQuery.FieldByName(getGeneratorName).AsInteger;
end;


procedure TBasisModel.Delete;
begin
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := fFeldList.DeleteStatement;
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

procedure TBasisModel.OpenTrans;
begin
//  _WasOpen := _Trans.InTransaction;
  inc(fTransCounter);
  if not fTrans.InTransaction then
    fTrans.StartTransaction;
end;


procedure TBasisModel.CommitTrans;
begin
  dec(fTransCounter);
  if (not fTrans.InTransaction) or (fTransCounter > 0) then
    exit;
  fTrans.Commit;
  fTransCounter := 0;
end;


procedure TBasisModel.RollbackTrans;
begin
  dec(fTransCounter);
  if (not fTrans.InTransaction) or (fTransCounter > 0) then
    exit;
  fTrans.Rollback;
  fTransCounter := 0;
end;


procedure TBasisModel.SaveToDB;
var
  Sql: string;
begin
  if not Assigned(fTrans) then
    exit;
  if (not fDoUpdate) and (fId > 0) then
    exit;
  fDoUpdate := false;
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

procedure TBasisModel.UpdateV(var aOldValue: Boolean; aNewValue: Boolean);
begin
  if not fDoUpdate then
    fDoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;

procedure TBasisModel.UpdateV(var aOldValue: Integer; aNewValue: Integer);
begin
  if not fDoUpdate then
    fDoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;

procedure TBasisModel.UpdateV(var aOldValue: string; aNewValue: string);
begin
  if not fDoUpdate then
    fDoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;



procedure TBasisModel.Read(aId: Integer);
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




end.
