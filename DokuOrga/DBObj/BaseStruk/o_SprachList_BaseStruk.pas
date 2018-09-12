unit o_SprachList_BaseStruk;

interface

uses
  SysUtils, Classes, o_SprachList_Base, IBDatabase, IBQuery;

type
  TSprachList_BaseStruk = class(TSprachList_Base)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function Save: Boolean;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    procedure Read(aGuid: string); reintroduce; overload;
  end;


implementation

{ TSprachList_BaseStruk }

uses
  c_DBTypes;


constructor TSprachList_BaseStruk.Create(AOwner: TComponent);
begin
  inherited;
  FDBList.Add(SL_GUID, SL_GUID);
  FDBList.Add(SL_TEXT, SL_TEXT);
  FDBList.Add(SL_BLOBTEXT, SL_BLOBTEXT);
  FDBList.Add(SL_SP_ID, SL_SP_ID);
  FDBList.Names('Id').Feldname := 'SL_ID';
  Init;
end;

destructor TSprachList_BaseStruk.Destroy;
begin

  inherited;
end;

procedure TSprachList_BaseStruk.Init;
begin
  inherited;
end;

procedure TSprachList_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;

procedure TSprachList_BaseStruk.Read(aGuid: string);
begin
  FQuery.Close;
  FQuery.Transaction := Trans;
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where SL_GUID = ' + QuotedStr(aGuid);
  OpenTrans;
  FQuery.Open;
  LoadByQuery(FQuery);
  RollbackTrans;
end;

function TSprachList_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (SL_ID, SL_GUID, SL_TEXT, SL_BLOBTEXT, SL_SP_ID)' +
          ' values' +
          ' (:SL_ID, :SL_GUID, :SL_TEXT, :SL_BLOBTEXT, :SL_SP_ID)';
  uSql := ' update ' + getTablename +
          ' set SL_GUID = :SL_GUID,' +
          ' SL_TEXT = :SL_TEXT, ' +
          ' SL_BLOBTEXT = :SL_BLOBTEXT, ' +
          ' SL_SP_ID = :SL_SP_ID ' +
          ' where SL_ID = :Id';

  Result := SaveDB(FQuery, iSql, uSql);

end;

end.
