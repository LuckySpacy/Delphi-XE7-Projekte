unit o_DBObj;

interface

uses
  SysUtils, Classes, IBDatabase, IBQuery, o_DBFieldList, o_DBField, obBusinessClasses, obServerClient;

type
  TDBObj = class(TComponent)
  private
    FFound: Boolean;
    function getNewId: Integer;
    function getId: Integer;
  protected
    FUpdate: Boolean;
    FInTrans: Boolean;
    FQuery: TIBQuery;
    FTrans: TIBTransaction;
    FInterneTrans: TIBTransaction;
    FDBList: TDBFeldList;
    procedure UpdateV(var aOldValue: string; aNewValue: string); overload;
    procedure UpdateV(var aOldValue: TDateTime; aNewValue: TDateTime); overload;
    procedure UpdateV(var aOldValue: Integer; aNewValue: Integer); overload;
    function getGeneratorName: string; virtual; abstract;
    function getTableName: string; virtual; abstract;
    function getTablePrefix: string; virtual; abstract;
    function getNotifyIndex: Integer; virtual; abstract;
    function getTrans: TIBTransaction;
    procedure OpenTrans;
    procedure CommitTrans;
    procedure RollbackTrans;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; virtual;
    procedure LoadByQuery(aQuery: TIBQuery); virtual;
    property Id: Integer read getId;
    property Trans: TIBTransaction read getTrans write FTrans;
    property NewId: Integer read getNewId;
    procedure Read(aId: Integer); virtual;
    procedure Delete; virtual;
    function Feld(aName: string): TDBFeld;
    function SaveDB(aQuery: TIBQuery; aiSql, auSql: string): Boolean; virtual;
    procedure Reload;
    property DBList: TDBFeldList read FDBList;
    property Found: Boolean read FFound;

  end;


implementation

{ TDBObj }

uses
  o_sysobj, DB;


constructor TDBObj.Create(AOwner: TComponent);
var
  s: string;
begin
  inherited;
  FQuery := TIBQuery.Create(Self);
  FInterneTrans := TIBTransaction.Create(Self);
  s := getTableName;
  FInterneTrans.Name := 'Trans_Intern' + '_' + s;
  FTrans := nil;
  FInterneTrans.DefaultDatabase := SysObj.Database;
  FQuery.Database := SysObj.Database;
  FDBList := TDBFeldList.Create(Self);
  FDBList.Add('Id', '');
  FFound := false;
end;


destructor TDBObj.Destroy;
begin
  FreeAndNil(FDBList);
  FreeAndNil(FQuery);
  FreeAndNil(FInterneTrans);
  inherited;
end;


function TDBObj.Feld(aName: string): TDBFeld;
begin
  Result := FDBList.Names(aName);
end;

function TDBObj.getId: Integer;
begin
  Result := FDBList.Names('Id').AsInteger;
end;

function TDBObj.getNewId: Integer;
var
  Gen: string;
begin
  Result := 0;
  Gen := getGeneratorName;
  if Gen = '' then
    exit;
  FQuery.Close;
  FQuery.SQL.Text := 'select gen_id(' + Gen + ',1) from dbinfo';
  OpenTrans;
  FQuery.Open;
  Result := FQuery.Fields[0].AsInteger;
  FQuery.Close;
  CommitTrans;
end;

function TDBObj.getTrans: TIBTransaction;
begin
  if FTrans = nil then
    Result := FInterneTrans
  else
    Result := FTrans;
end;

procedure TDBObj.Init;
begin
  FFound  := false;
  FUpdate := false;
  FDBList.InitValues;
end;


procedure TDBObj.LoadByQuery(aQuery: TIBQuery);
var
  i1: Integer;
  TablePrefix: string;
  Ext: string;
begin
  Init;
  if aQuery.Eof then
    exit;
  FFound := true;
  for i1 := 0 to FDBList.Count - 1 do
  begin
    FDBList.Item[i1].AsString := aQuery.FieldByName(FDBList.Item[i1].Feldname).AsString;
    if FDBList.Item[i1].BitmapField then
    begin
      TablePrefix := getTablePrefix;
      try
        ext := aquery.FieldByName(TablePrefix + '_ERWEITERUNG').AsString;
      except
        ext := '';
      end;
      if SameText(ext, 'bmp') then
        FDBList.Item[i1].Bmp.Load(TBlobField(aQuery.FieldByName(FDBList.Item[i1].Feldname)));
      if SameText(ext, 'ico') then
        FDBList.Item[i1].Ico.Load(TBlobField(aQuery.FieldByName(FDBList.Item[i1].Feldname)));
      if SameText(ext, 'png') then
        FDBList.Item[i1].Png.Load(TBlobField(aQuery.FieldByName(FDBList.Item[i1].Feldname)));
    end;
  end;
end;

procedure TDBObj.Read(aId: Integer);
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where ' + getTablePrefix + '_id = ' + IntToStr(aId);
  OpenTrans;
  FQuery.Open;
  LoadByQuery(FQuery);
  RollbackTrans;
end;


procedure TDBObj.Reload;
begin
  Read(getId);
end;

procedure TDBObj.Delete;
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' delete from  ' + getTableName +
                     ' where ' + getTablePrefix + '_id = ' + IntToStr(Id);
  OpenTrans;
  FQuery.ExecSQL;
  CommitTrans;
end;


procedure TDBObj.OpenTrans;
begin
  FInTrans := getTrans.InTransaction;
  if not FInTrans then
    getTrans.StartTransaction;
end;

procedure TDBObj.RollbackTrans;
begin
  if not FInTrans then
    getTrans.Rollback;
end;




procedure TDBObj.CommitTrans;
begin
  if not FInTrans then
    getTrans.Commit;
end;


function TDBObj.SaveDB(aQuery: TIBQuery; aiSql, auSql: string): Boolean;
var
  i1: Integer;
  Id: Integer;
  m : TMemoryStream;
begin
  m := nil;
  Result := false;
  if (not FDBList.Changed) and (FDBList.Names('id').AsInteger > 0) then
    exit;
  aQuery.Close;

  Id := FDBList.Names('Id').AsInteger;
  if Id = 0 then
  begin
    Id := NewId;
    FDBList.Names('Id').AsInteger := id;
    aQuery.SQL.Text := aiSql;
  end
  else
    aQuery.Sql.Text := auSql;

  aQuery.Transaction := Trans;

  OpenTrans;
  for i1 := 0 to FDBList.Count - 1 do
  begin
    aQuery.ParamByName(FDBList.Item[i1].Feldname).Value := FDBList.Item[i1].AsString;
    if FDBList.Item[i1].BitmapField then
    begin
      if FDBList.Item[i1].Bmp.AsBitmap <> nil then
        m := FDBList.Item[i1].Bmp.AsStream;
      if FDBList.Item[i1].Ico.AsIcon <> nil then
        m := FDBList.Item[i1].Ico.AsStream;
      if FDBList.Item[i1].Png.AsPng <> nil then
        m := FDBList.Item[i1].Png.AsStream;
      if m <> nil then
        aQuery.ParamByName(FDBList.Item[i1].Feldname).LoadFromStream(m, ftBlob);
    end;
  end;
        //aQuery.ParamByName(FDBList.Item[i1].Feldname).LoadFromStream(m, ftBlob);

  aQuery.ExecSQL;


  CommitTrans;

  Result := true;

  if not aQuery.Transaction.InTransaction then
    SysObj.ObServer.Notify(ntobCoreData, getNotifyIndex, FDBList.Names('Id').AsInteger);

end;


procedure TDBObj.UpdateV(var aOldValue: string; aNewValue: string);
begin
  if aOldValue = aNewValue then
    exit;
  aOldValue := aNewValue;
  FUpdate   := true;
end;

procedure TDBObj.UpdateV(var aOldValue: TDateTime; aNewValue: TDateTime);
begin
  if aOldValue = aNewValue then
    exit;
  aOldValue := aNewValue;
  FUpdate   := true;
end;


procedure TDBObj.UpdateV(var aOldValue: Integer; aNewValue: Integer);
begin
  if aOldValue = aNewValue then
    exit;
  aOldValue := aNewValue;
  FUpdate   := true;
end;


end.
