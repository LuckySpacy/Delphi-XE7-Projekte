unit DB.IBBasisList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, Objekt.BasisList, TBQuery, IBX.IBQuery;

type
  TDBIBBasisList = class(TBaseList)
  private
  protected
    fTrans: TIBTransaction;
    fTBQuery: TTBQuery;
    fQuery: TIBQuery;
    fWasOpen: Boolean;
    procedure OpenTrans;
    procedure CommitTrans;
    procedure RollbackTrans;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Trans: TIBTransaction read fTrans write fTrans;
    procedure Clear;
  end;


implementation

{ TDBBasisList }

constructor TDBIBBasisList.Create(AOwner: TComponent);
begin
  inherited;
  fTrans := nil;
  fTBQuery := TTBQuery.Create(nil);
  fQuery   := fTBQuery.IBQuery;
end;

destructor TDBIBBasisList.Destroy;
begin
  FreeAndNil(fTBQuery);
  inherited;
end;


procedure TDBIBBasisList.OpenTrans;
begin
  fWasOpen := fTrans.InTransaction;
  if not fTrans.InTransaction then
    fTrans.StartTransaction;
end;


procedure TDBIBBasisList.CommitTrans;
begin
  if (not fTrans.InTransaction) or (fWasOpen) then
    exit;
  fTrans.Commit;
  fWasOpen := false;
end;



procedure TDBIBBasisList.RollbackTrans;
begin
  if (not fTrans.InTransaction) or (fWasOpen) then
    exit;
  fTrans.Rollback;
  fWasOpen := false;
end;


procedure TDBIBBasisList.Clear;
begin
  fList.Clear;
end;

end.
