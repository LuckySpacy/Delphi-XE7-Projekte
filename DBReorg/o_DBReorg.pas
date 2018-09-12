unit o_DBReorg;

interface

uses
  SysUtils, Classes, IBDatabase, IBQuery, Dialogs;

type
  TDBReorg = class(TComponent)
  private
    FFilename: string;
    FDatabase: TIBDatabase;
    FIBTransaction: TIBTransaction;
    FQuery: TIBQuery;
    FLastNumber: Integer;
    FSqlList: TStringList;
    function getLastNumber: Integer;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Filename: string read FFilename write FFilename;
    property Database: TIBDatabase read FDatabase write FDatabase;
    procedure DoImport;
  end;


implementation

{ TDBReorg }

constructor TDBReorg.Create(AOwner: TComponent);
begin
  inherited;
  FIBTransaction := TIBTransaction.Create(Self);
  FQuery := TIBQuery.Create(Self);
  FSqlList := TStringList.Create;
end;

destructor TDBReorg.Destroy;
begin
  FreeAndNil(FIBTransaction);
  FreeAndNil(FQuery);
  FreeAndNil(FSqlList);
  inherited;
end;

procedure TDBReorg.DoImport;
var
  myFile: TextFile;
  Letter: Char;
  sId: string;
  Id: Integer;
  sText: string;
  i1: Integer;
  FInsertId: Integer;
  bEof: Boolean;
begin
  if not FileExists(FFilename) then
    exit;
  FIBTransaction.DefaultDatabase := FDatabase;
  FQuery.Transaction := FIBTransaction;
  FLastNumber := getLastNumber;
  AssignFile(myFile, FFilename);
  Reset(myFile);
  FSqlList.Clear;
  sId := '';
  Id  := -1;
  sText := '';
  while not Eof(myFile) do
  begin
    Read(myFile, Letter);
    if (Letter = #$D) or (Letter = #$A) then
      continue;
    if Letter = ' ' then
    begin
      if Id = -1 then
      begin
        if not TryStrToInt(sId, Id) then
        begin
          ShowMessage('Die Datei ' + #13 +
                      '"' + FFilename + '"' + #13 +
                      'scheint defekt zu sein.');
          exit;
        end;
      end
      else
      begin
        if FLastNumber < Id then
          FSqlList.Add(IntToStr(Id) + '=' + sText);
        Id := -1;
        sText := '';
        sId := '';
      end;
      continue;
    end;
    if id = -1 then
      sId := sId + Letter
    else
      sText := sText + Letter;
  end;
  FInsertId := FLastNumber;
  try
    if FIBTransaction.InTransaction then
      FIBTransaction.Rollback;
    for i1 := 0 to FSqlList.count - 1 do
    begin
      FQuery.Close;
      try
        FQuery.SQL.Text := FSqlList.ValueFromIndex[i1];
        FIBTransaction.StartTransaction;
        FQuery.ExecSQL;
      except
        on e: exception do
        begin
          ShowMessage(e.Message);
          FIBTransaction.Rollback;
          //exit;
        end;
      end;
      if FIBTransaction.InTransaction then
        FIBTransaction.Commit;
      FInsertId := StrToInt(FSqlList.Names[i1]);
    end;
  finally
    FQuery.Close;
    if FSqlList.Count > 0 then
    begin
      FQuery.SQL.Text := ' select di_id from dbinfo';
      try
        FQuery.Open;
        bEof := FQuery.Eof;
      except
        bEof := true;
      end;
      if FQuery.Transaction.InTransaction then
        FQuery.Transaction.Rollback;
      if bEof then
      begin
        FQuery.Close;
        sText := ' insert into dbinfo (di_id, di_nummer, di_text, di_lastupdate)' +
                 ' values' +
                 '(:id, :nummer, :text, :lastupdate)';
        FQuery.SQL.Text := sText;
        FQuery.ParamByName('lastupdate').AsDateTime := now;
        FQuery.ParamByName('id').AsInteger := 1;
        FQuery.ParamByName('nummer').AsInteger := FInsertId;
        FQuery.ParamByName('text').asString := 'Start';
      end
      else
      begin
        FQuery.Close;
        sText := ' update dbinfo set di_nummer = ' + IntToStr(FInsertId) +
                 ' , di_lastupdate = :lastupdate';
        FQuery.SQL.Text := sText;
        FQuery.ParamByName('lastupdate').AsDateTime := now;
      end;
      if not FIBTransaction.InTransaction then
        FIBTransaction.StartTransaction;
      FQuery.ExecSQL;
      FIBTransaction.Commit;
    end;
  end;
end;

function TDBReorg.getLastNumber: Integer;
begin
  try
    FQuery.Close;
    FQuery.SQL.Text := 'select di_nummer from dbinfo';
    FQuery.Open;
    Result := FQuery.Fields[0].AsInteger;
    FQuery.Close;
  except
    Result := 0;
  end;
end;

end.
