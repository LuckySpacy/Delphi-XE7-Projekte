unit TBQuery;

interface

uses
  IBX.IBQuery, Classes, Objekt.WebClient, WebQuery, SysUtils, IBX.IBDatabase,
  TBTrans;

type
  TTBQuery = class(TComponent)
  private
    fUseInterbase: Boolean;
    fUseWWW: Boolean;
    fWebClient: TWebClient;
    fIBQuery: TIBQuery;
    fWebQuery: TWebQuery;
    fTBTrans: TTBTrans;
    fStartTrans: Boolean;
    fSql: TStringList;
    procedure setUseInterbase(const Value: Boolean);
    procedure setUseWWW(const Value: Boolean);
    procedure setTBTrans(const Value: TTBTrans);
  protected
    fCheckRuntime: boolean;
  public
    property CheckRuntime: boolean read fCheckRuntime write fCheckRuntime;
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure Open;
    procedure Close;
    property UseInterbase: Boolean read fUseInterbase write setUseInterbase;
    property UseWWW: Boolean read fUseWWW write setUseWWW;
    property WebClient: TWebClient read fWebClient write fWebClient;
    property TBTrans: TTBTrans read fTBTrans write setTBTrans;
    function IBQuery: TIBQuery;
    function WebQuery: TWebQuery;
    property Sql: TStringList read fSql write fSql;
  end;

implementation

{ TTBQuery }


constructor TTBQuery.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  fIBQuery  := TIBQuery.Create(nil);
  fWebQuery := TWebQuery.Create(nil);
  fTBTrans  := nil;
  fStartTrans := false;
  fSql := TStringList.Create;
end;

destructor TTBQuery.Destroy;
begin
  FreeAndNil(fIBQuery);
  FreeAndNil(fWebQuery);
  FreeAndNil(fSql);
  inherited;
end;



procedure TTBQuery.Open;
begin
  if fUseInterbase then
  begin
    if fTBTrans = nil then
      exit;
    fTBTrans.StartTrans;
    fIBQuery.SQL.Text := Sql.Text;
    fIBQuery.Open;
  end;
end;


procedure TTBQuery.setTBTrans(const Value: TTBTrans);
begin
  fTBTrans := Value;
  fIBQuery.Transaction := fTBTrans.Trans;
end;

procedure TTBQuery.setUseInterbase(const Value: Boolean);
begin
  fUseInterbase := Value;
  if Value then
    fUseWWW := false;
end;

procedure TTBQuery.setUseWWW(const Value: Boolean);
begin
  if Value then
    fUseInterbase := false;
  fUseWWW := Value;
end;



function TTBQuery.WebQuery: TWebQuery;
begin
  Result := fWebQuery;
end;

function TTBQuery.IBQuery: TIBQuery;
begin
  Result := fIBQuery;
end;



 procedure TTBQuery.Close;
begin
  if fUseInterbase then
  begin
    if fTBTrans = nil then
      exit;
    fTBTrans.RollbackTrans;
  end;
end;





end.
