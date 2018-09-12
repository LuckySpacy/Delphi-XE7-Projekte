unit o_DBGuid;

interface

uses
  SysUtils, Classes, o_DBGuid_BaseStruk;

type
  TDBGuid = class(TDBGuid_BaseStruk)
  private
  protected
    function getNotifyIndex: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ReadData(aRefKey, aTabelle: string; aRefId: Integer);
    procedure ReadByGuid(aValue: string);
    procedure LoadImportValues(aStrings: TStrings);
  end;


implementation

{ TDBGuid }

uses
  c_DBTypes;

constructor TDBGuid.Create(AOwner: TComponent);
begin
  inherited;
  init;
end;

destructor TDBGuid.Destroy;
begin

  inherited;
end;


procedure TDBGuid.Init;
begin
  inherited;

end;

function TDBGuid.getNotifyIndex: Integer;
begin
  Result := 0;
end;


procedure TDBGuid.LoadImportValues(aStrings: TStrings);
begin
  Init;
  FDBList.Names(GU_GUID).AsString   := aStrings[0];
  FDBList.Names(GU_INSERT).AsString := aStrings[1];
  FDBList.Names(GU_UPDATE).AsString := aStrings[2];
  FDBList.Names(GU_USERID_INSERT).AsString := aStrings[3];
  FDBList.Names(GU_USERID_UPDATE).AsString := aStrings[4];
  FDBList.Names(GU_DELETE).AsString := aStrings[5];
  aStrings.Delete(0);
  aStrings.Delete(0);
  aStrings.Delete(0);
  aStrings.Delete(0);
  aStrings.Delete(0);
  aStrings.Delete(0);
end;

procedure TDBGuid.ReadByGuid(aValue: string);
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where gu_guid = ' + QuotedStr(aValue);
  OpenTrans;
  FQuery.Open;
  LoadByQuery(FQuery);
  RollbackTrans;
end;

procedure TDBGuid.ReadData(aRefKey, aTabelle: string; aRefId: Integer);
begin
  FQuery.Close;
  {
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where gu_refkey = ' + QuotedStr(aRefKey) +
                     ' and gu_tabelle = ' + QuotedStr(aTabelle) +
                     ' and gu_refid = ' + IntToStr(aRefId);
                     }
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where gu_refkey = ' + QuotedStr(aRefKey) +
                     ' and gu_tabelle = ' + QuotedStr(aTabelle) +
                     ' and gu_refid = ' + IntToStr(aRefId);
  FQuery.Transaction := getTrans;
  OpenTrans;
  FQuery.Open;
  LoadByQuery(FQuery);
  RollbackTrans;
end;


end.
