unit WebDB.Basis;

interface

uses
  SysUtils, Classes, Objekt.DBFeldList, Data.db, vcl.Dialogs, WebQuery,
  Objekt.WebClient;

type
  TWebDBBasis = class(TComponent)
  private
    fWebClient: TWebClient;
  protected
    //fTrans: TIBTransaction;
    fQuery: TWebQuery;
    fId: Integer;
    fDoUpdate: Boolean;
    fFeldList: TDBFeldList;
    fGefunden: Boolean;
    fTransCounter: Integer;
    fData: TStringList;
    function getGeneratorName: string; virtual; abstract;
    function getTableName: string; virtual; abstract;
    function getTablePrefix: string; virtual; abstract;
    procedure UpdateV(var aOldValue: string; aNewValue: string); overload;
    procedure UpdateV(var aOldValue: Integer; aNewValue: Integer); overload;
    procedure UpdateV(var aOldValue: Boolean; aNewValue: Boolean); overload;
    procedure UpdateV(var aOldValue: TDateTime; aNewValue: TDateTime); overload;
    procedure SendSql(aSql: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; virtual;
    procedure OpenTrans;
    procedure CommitTrans;
    procedure RollbackTrans;
    procedure LoadByQuery(aQuery: TWebQuery); virtual;
    property Id: Integer read fId;
    property WebClient: TWebClient read fWebClient write fWebClient;
    //property Trans: TIBTransaction read fTrans write fTrans;
    property FeldList: TDBFeldList read fFeldList write fFeldList;
    property Gefunden: Boolean read fGefunden;
    procedure Read(aId: Integer); virtual;
    procedure Delete; virtual;
    function SaveToDB: Boolean; virtual;
    function GenerateId: Integer;
    function BooleanToString(aValue: Boolean): string;
  end;

implementation

{ TWebDBBasis }

uses
  System.UITypes;


constructor TWebDBBasis.Create(AOwner: TComponent);
begin
  inherited;
  fWebClient := nil;
  //fTrans := nil;
  fTransCounter := 0;
  fData  := TStringList.Create;
  fQuery := TWebQuery.Create(nil);
  fFeldList := TDBFeldList.Create(nil);
  fFeldList.Tablename := getTableName;
  fFeldList.PrimaryKey := getGeneratorName;
  fFeldList.Add(getGeneratorName, ftInteger);
end;


destructor TWebDBBasis.Destroy;
begin
  FreeAndNil(fData);
  FreeAndNil(fQuery);
  FreeAndNil(fFeldList);
  inherited;
end;

function TWebDBBasis.GenerateId: Integer;
begin
  Result := 0;
  {
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
  }

end;

procedure TWebDBBasis.Init;
begin
  fId := 0;
  fGefunden := false;
  fDoUpdate := false;
end;

procedure TWebDBBasis.SendSql(aSql: string);
var
  stream: TMemoryStream;
begin
  fData.Clear;
  stream := TMemoryStream.Create;
  try
    fWebClient.get(fWebClient.Url, 'DokuOrga', aSql, Stream);
    if Stream.Size > 0 then
    begin
      fData.LoadFromStream(Stream);
      if fData.Strings[0] = 'Dynamic SQL Error' then
      begin
        MessageDlg(fData.Text, mtError, [mbOk], 0);
        fData.Clear;
      end
    end;
  finally
    FreeAndNil(Stream);
  end;
end;



procedure TWebDBBasis.LoadByQuery(aQuery: TWebQuery);
begin
  Init;
  fGefunden := not aQuery.Eof;
  if aQuery.Eof then
    exit;
  fId := aQuery.FieldByName(getGeneratorName).AsInteger;
end;


procedure TWebDBBasis.Delete;
begin
  {
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
  }
end;


procedure TWebDBBasis.OpenTrans;
begin
{
  inc(fTransCounter);
  if not fTrans.InTransaction then
    fTrans.StartTransaction;
 }
end;


function TWebDBBasis.BooleanToString(aValue: Boolean): string;
begin
  if aValue then
    Result := 'T'
  else
    Result := 'F';
end;

procedure TWebDBBasis.CommitTrans;
begin
  {
  dec(fTransCounter);
  if (not fTrans.InTransaction) or (fTransCounter > 0) then
    exit;
  fTrans.Commit;
  fTransCounter := 0;
  }
end;

procedure TWebDBBasis.RollbackTrans;
begin
{
  dec(fTransCounter);
  if (not fTrans.InTransaction) or (fTransCounter > 0) then
    exit;
  fTrans.Rollback;
  fTransCounter := 0;
  }
end;

function TWebDBBasis.SaveToDB: Boolean;
//var
//  Sql: string;
begin
  Result := false;
  {
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
  fFeldList.SetSqlValues(fQuery);
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
  Result := true;
  }
end;



procedure TWebDBBasis.UpdateV(var aOldValue: Boolean; aNewValue: Boolean);
begin
  if not fDoUpdate then
    fDoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;

procedure TWebDBBasis.UpdateV(var aOldValue: Integer; aNewValue: Integer);
begin
  if not fDoUpdate then
    fDoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;

procedure TWebDBBasis.UpdateV(var aOldValue: string; aNewValue: string);
begin
  if not fDoUpdate then
    fDoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;

procedure TWebDBBasis.UpdateV(var aOldValue: TDateTime; aNewValue: TDateTime);
begin
  if not fDoUpdate then
    fDoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;

procedure TWebDBBasis.Read(aId: Integer);
begin
  Init;
  SendSql('select * from ' + getTableName + ' where ' + getGeneratorName + '=' + IntToStr(aId));
  fQuery.Open(fData.Text);
  LoadByQuery(fQuery);
  {
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
  }
end;


end.
