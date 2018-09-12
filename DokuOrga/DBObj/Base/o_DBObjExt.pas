unit o_DBObjExt;

interface

uses
  SysUtils, Classes, o_DBObj, IBQuery, o_DBGuid;

type
  TDBObjExt = class(TDBObj)
  private
    FDBGuid: TDBGuid;
    function getGuid: string;
    procedure ReadDBGuid;
    function getInsert: string;
    function getUpdate: string;
    function getUserIdUpdate: string;
    function getUserIdInsert: string;
    function getDeleteValue: string;
    function getGuidExportString: string;
    //procedure SetUpdateAsDateTime(const Value: TDateTime);
    function getUpdateAsDateTime: TDateTime;
  protected
    //function getTableName: string; virtual; abstract;
    //function getTablePrefix: string; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function SaveDB(aQuery: TIBQuery; aiSql, auSql: string): Boolean; override;
    procedure ReadByGuid(aValue: string);
    procedure MarkAsDelete; virtual;
    procedure Delete; override;
    property Guid: string read getGuid;
    property Insert: string read getInsert;
    property Update: string read getUpdate;
    property UpdateAsDateTime: TDateTime read getUpdateAsDateTime;
    property UserIdUpdate: string read getUserIdUpdate;
    property UserIdInsert: string read getUserIdInsert;
    property DeleteValue: string read getDeleteValue;
    property GuidExportString: string read getGuidExportString;
    property DBGuid: TDBGuid read FDBGuid write FDBGuid;
end;


implementation

{ TDBObjExt }

uses
  c_DBTypes, o_DBField;


constructor TDBObjExt.Create(AOwner: TComponent);
begin
  inherited;
  FDBGuid := TDBGuid.Create(nil);
end;


destructor TDBObjExt.Destroy;
begin
  FreeAndNil(FDBGuid);
  inherited;
end;

function TDBObjExt.getDeleteValue: string;
begin
  ReadDBGuid;
  Result := FDBGuid.Feld(GU_DELETE).AsString;
end;

function TDBObjExt.getGuidExportString: string;
begin
  Result := '';
  Result := Result + getGuid + '# #';
  Result := Result + getInsert + '# #';
  Result := Result + getUpdate + '# #';
  Result := Result + getUserIdInsert + '# #';
  Result := Result + getUserIdUpdate + '# #';
  Result := Result + getDeleteValue + '# #';
end;

function TDBObjExt.getGuid: string;
begin
  ReadDBGuid;
  Result := FDBGuid.Feld(GU_GUID).AsString;
end;

function TDBObjExt.getInsert: string;
begin
  ReadDBGuid;
  Result := FDBGuid.Feld(GU_INSERT).AsString;
end;

function TDBObjExt.getUpdate: string;
begin
  ReadDBGuid;
  Result := FDBGuid.Feld(GU_UPDATE).AsString;
end;

function TDBObjExt.getUpdateAsDateTime: TDateTime;
begin
  if not TryStrToDateTime(getUpdate, Result) then
    Result := 0;
end;

function TDBObjExt.getUserIdInsert: string;
begin
  ReadDBGuid;
  Result := FDBGuid.Feld(GU_USERID_INSERT).AsString;
end;

function TDBObjExt.getUserIdUpdate: string;
begin
  ReadDBGuid;
  Result := FDBGuid.Feld(GU_USERID_UPDATE).AsString;
end;

procedure TDBObjExt.MarkAsDelete;
//var
//  Sql: string;
begin
  if FDBList.DeleteItem <> nil then
    FDBList.DeleteItem.AsString := 'T';
{
  Sql := ' update ' + getTableName +
         ' set ' + FDBList.DeleteItem.Feldname + ' = ' + QuotedStr('T') +
         ' where ' + FDBList.Names('Id').Feldname + ' = ' + IntToStr(Id);
  SaveDB(FQuery, '', Sql);
}
end;

procedure TDBObjExt.ReadByGuid(aValue: string);
begin
  Init;
  FDBGuid.Trans := getTrans;
  FDBGuid.ReadByGuid(aValue);
  if FDBGuid.Feld(GU_REFID).AsInteger > 0 then
    Read(FDBGuid.Feld(GU_REFID).AsInteger);
end;

procedure TDBObjExt.ReadDBGuid;
begin
  if (Id <> FDBGuid.Feld(GU_REFID).AsInteger)
  or (getTableName <> FDBGuid.Feld(GU_TABELLE).AsString)
  or (getTablePrefix <> FDBGuid.Feld(GU_REFKEY).AsString) then
  begin
    FDBGuid.Trans := getTrans;
    FDBGuid.ReadData(getTablePrefix, getTableName, Id);
  end
  else
  begin
    if not FDBGuid.Found then
    begin
      FDBGuid.Trans := getTrans;
      FDBGuid.ReadData(getTablePrefix, getTableName, Id);
    end;
  end;
end;

function TDBObjExt.SaveDB(aQuery: TIBQuery; aiSql, auSql: string): Boolean;
var
  DelItem: TDBFeld;
begin
  Result := Inherited SaveDB(aQuery, aiSql, auSql);
  FDBGuid.Trans := getTrans;
  ReadDBGuid;
  if Result then
  begin
    DelItem := FDBList.DeleteItem;
    FDBGuid.Feld(GU_TABELLE).AsString := getTableName;
    FDBGuid.Feld(GU_REFKEY).AsString := getTablePrefix;
    if FDBGuid.Feld(GU_GUID).AsString = '' then
      FDBGuid.Feld(GU_INSERT).AsString := DateTimeToStr(now);
    FDBGuid.Feld(GU_UPDATE).AsString := DateTimeToStr(now);
    FDBGuid.Feld(GU_REFID).AsInteger := Id;
    if DelItem <> nil then
      FDBGuid.Feld(GU_DELETE).AsString := DelItem.AsString;
    FDBGuid.Save;
  end;

end;

procedure TDBObjExt.Delete;
var
  WasOpen: Boolean;
begin
  WasOpen := getTrans.InTransaction;
  OpenTrans;
  try
    FDBGuid.Trans := getTrans;
    ReadDBGuid;
    inherited;
    if FDBGuid.Found then
    begin
      FDBGuid.Feld(GU_DELETE).AsBoolean := true;
      FDBGuid.Save;
    end;
    CommitTrans;
    if (not WasOpen) and (getTrans.InTransaction) then
      getTrans.Commit;
    // rausgenommen, hoffe es kommt hier nicht zu einem Fehler
    //if getTrans.InTransaction then
    //  getTrans.Commit;
  except
    RollbackTrans;
    // rausgenommen, hoffe es kommt hier nicht zu einem Fehler
    //if getTrans.InTransaction then
    //  getTrans.Rollback;
  end;
end;



      {
procedure TDBObjExt.SetUpdateAsDateTime(const Value: TDateTime);
begin
  FUpdateAsDateTime := Value;
end;
}

end.
