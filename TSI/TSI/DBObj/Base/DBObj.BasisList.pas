unit DBObj.BasisList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList;

type
  TBasisListDBObj = class(TBaseList)
  private
  protected
    fTrans: TIBTransaction;
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

constructor TBasisListDBObj.Create(AOwner: TComponent);
begin
  inherited;
  fTrans := nil;
  fQuery := TIBQuery.Create(nil);
end;

destructor TBasisListDBObj.Destroy;
begin
  FreeAndNil(fQuery);
  inherited;
end;

procedure TBasisListDBObj.OpenTrans;
begin
  fWasOpen := fTrans.InTransaction;
  if not fTrans.InTransaction then
    fTrans.StartTransaction;
end;

procedure TBasisListDBObj.CommitTrans;
begin
  if (not fTrans.InTransaction) or (fWasOpen) then
    exit;
  fTrans.Commit;
  fWasOpen := false;
end;

procedure TBasisListDBObj.RollbackTrans;
begin
  if (not fTrans.InTransaction) or (fWasOpen) then
    exit;
  fTrans.Rollback;
  fWasOpen := false;
end;

procedure TBasisListDBObj.Clear;
begin
  fList.Clear;
end;

end.
