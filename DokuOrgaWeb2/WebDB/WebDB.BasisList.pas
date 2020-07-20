unit WebDB.BasisList;

interface

uses
  SysUtils, Classes, Objekt.BasisList, WebQuery, Objekt.WebClient, vcl.Dialogs,
  System.UITypes;

type
  TWebDBBasisList = class(TBaseList)
  private
  protected
    //fTrans: TIBTransaction;
    fQuery: TWebQuery;
    fWasOpen: Boolean;
    fWebClient: TWebClient;
    fData: TStringList;
    procedure OpenTrans;
    procedure CommitTrans;
    procedure RollbackTrans;
    procedure SendSql(aSql: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //property Trans: TIBTransaction read fTrans write fTrans;
    property WebClient: TWebClient read fWebClient write fWebClient;
    procedure Clear;
  end;

implementation

{ TTabelleBasisList }

constructor TWebDBBasisList.Create(AOwner: TComponent);
begin
  inherited;
  //fTrans := nil;
  fWebClient := nil;
  fData := TStringList.Create;
  fQuery := TWebQuery.Create(nil);
end;

destructor TWebDBBasisList.Destroy;
begin
  FreeAndNil(fQuery);
  FreeAndNil(fData);
  inherited;
end;

procedure TWebDBBasisList.OpenTrans;
begin
{
  fWasOpen := fTrans.InTransaction;
  if not fTrans.InTransaction then
    fTrans.StartTransaction;
}
end;

procedure TWebDBBasisList.CommitTrans;
begin
{
  if (not fTrans.InTransaction) or (fWasOpen) then
    exit;
  fTrans.Commit;
  fWasOpen := false;
  }
end;


procedure TWebDBBasisList.Clear;
begin
  fList.Clear;
end;


procedure TWebDBBasisList.RollbackTrans;
begin
{
  if (not fTrans.InTransaction) or (fWasOpen) then
    exit;
  fTrans.Rollback;
  fWasOpen := false;
  }
end;


procedure TWebDBBasisList.SendSql(aSql: string);
var
  stream: TMemoryStream;
begin
  fData.Clear;
  stream := TMemoryStream.Create;
  try
    fWebClient.get(fWebClient.Url, 'OptimaChangeLog', aSql, Stream);
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


end.
