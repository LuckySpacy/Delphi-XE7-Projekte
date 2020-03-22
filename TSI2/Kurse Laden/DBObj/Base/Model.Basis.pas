unit Model.Basis;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.DBFeldList, Data.db,
  vcl.Dialogs;


type
  TBasisModel = class(TComponent)
  private
  protected
    _Trans: TIBTransaction;
    //_WasOpen: Boolean;
    _Query: TIBQuery;
    _Id: Integer;
    _DoUpdate: Boolean;
    _FeldList: TDBFeldList;
    _Gefunden: Boolean;
    _TransCounter: Integer;
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
    property Id: Integer read _Id;
    property Trans: TIBTransaction read _Trans write _Trans;
    property FeldList: TDBFeldList read _FeldList write _FeldList;
    property Gefunden: Boolean read _Gefunden;
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
  _Trans := nil;
  _TransCounter := 0;
  _Query := TIBQuery.Create(nil);
  _FeldList := TDBFeldList.Create(nil);
  _FeldList.Tablename := getTableName;
  _FeldList.PrimaryKey := getGeneratorName;
  _FeldList.Add(getGeneratorName, ftInteger);
end;

destructor TBasisModel.Destroy;
begin
  FreeAndNil(_Query);
  FreeAndNil(_FeldList);
  inherited;
end;

function TBasisModel.GenerateId: Integer;
begin
  Result := 0;
  if not Assigned(_Trans) then
    exit;
  _Query.Close;
  _Query.Transaction := _Trans;
  _Query.SQL.Text := 'select GEN_ID(' + getGeneratorName + ', 1) FROM RDB$DATABASE';
  OpenTrans;
  try
    _Query.Open;
    Result := _Query.Fields[0].AsInteger;
    _Query.Close;
  finally
    CommitTrans;
  end;
end;

procedure TBasisModel.Init;
begin
  _Id := 0;
  _Gefunden := false;
  _DoUpdate := false;
end;

procedure TBasisModel.LoadByQuery(aQuery: TIBQuery);
begin
  Init;
  _Gefunden := not aQuery.Eof;
  if aQuery.Eof then
    exit;
  _Id := aQuery.FieldByName(getGeneratorName).AsInteger;
end;


procedure TBasisModel.Delete;
begin
  if not Assigned(_Trans) then
    exit;
  _Query.Close;
  _Query.Transaction := _Trans;
  _Query.SQL.Text := _FeldList.DeleteStatement;
  OpenTrans;
  try
    _Query.ExecSQL;
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
  inc(_TransCounter);
  if not _Trans.InTransaction then
    _Trans.StartTransaction;
end;


procedure TBasisModel.CommitTrans;
begin
  dec(_TransCounter);
  if (not _Trans.InTransaction) or (_TransCounter > 0) then
    exit;
  _Trans.Commit;
  _TransCounter := 0;
end;


procedure TBasisModel.RollbackTrans;
begin
  dec(_TransCounter);
  if (not _Trans.InTransaction) or (_TransCounter > 0) then
    exit;
  _Trans.Rollback;
  _TransCounter := 0;
end;


procedure TBasisModel.SaveToDB;
var
  Sql: string;
begin
  if not Assigned(_Trans) then
    exit;
  if (not _DoUpdate) and (_Id > 0) then
    exit;
  _DoUpdate := false;
  if _Id = 0 then
  begin
    _id := GenerateId;
    _FeldList.FieldByName(getGeneratorName).AsInteger := _Id;
    Sql := _FeldList.InsertStatement;
  end
  else
    Sql := _FeldList.UpdateStatement;
  _Query.Close;
  _Query.Transaction := _Trans;
  _Query.SQL.Text := Sql;
  OpenTrans;
  try
    _Query.ExecSQL;
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
  if not _DoUpdate then
    _DoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;

procedure TBasisModel.UpdateV(var aOldValue: Integer; aNewValue: Integer);
begin
  if not _DoUpdate then
    _DoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;

procedure TBasisModel.UpdateV(var aOldValue: string; aNewValue: string);
begin
  if not _DoUpdate then
    _DoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;



procedure TBasisModel.Read(aId: Integer);
begin
  Init;
  if not Assigned(_Trans) then
    exit;
  _Query.Close;
  _Query.Transaction := _Trans;
  _Query.SQL.Text := 'select * from ' + getTableName + ' where ' + getGeneratorName + '=' + IntToStr(aId);
  OpenTrans;
  try
    _Query.Open;
    LoadByQuery(_Query);
  finally
    CommitTrans;
  end;
end;




end.
