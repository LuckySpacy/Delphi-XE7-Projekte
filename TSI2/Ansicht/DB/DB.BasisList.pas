unit DB.BasisList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BaseList;

type
  TBasisListModel = class(TBaseListObj)
  private
  protected
    fTrans: TIBTransaction;
    fQuery: TIBQuery;
    fWasOpen: Boolean;
    procedure OpenTrans;
    procedure CommitTrans;
    procedure RollbackTrans;
  public
    constructor Create(AOwner: TComponent); reintroduce; overload; virtual;
    destructor Destroy; override;
    property Trans: TIBTransaction read fTrans write fTrans;
    procedure Clear;
  end;

implementation

{ TBasisListModel }


constructor TBasisListModel.Create(AOwner: TComponent);
begin
  inherited Create;
  fTrans := nil;
  fQuery := TIBQuery.Create(nil);
end;

destructor TBasisListModel.Destroy;
begin
  FreeAndNil(fQuery);
  inherited;
end;


procedure TBasisListModel.Clear;
begin
  fList.Clear;
end;

procedure TBasisListModel.CommitTrans;
begin
  if (not fTrans.InTransaction) or (fWasOpen) then
    exit;
  fTrans.Commit;
  fWasOpen := false;
end;


procedure TBasisListModel.OpenTrans;
begin
  fWasOpen := fTrans.InTransaction;
  if not fTrans.InTransaction then
    fTrans.StartTransaction;
end;

procedure TBasisListModel.RollbackTrans;
begin
  if (not fTrans.InTransaction) or (fWasOpen) then
    exit;
  fTrans.Rollback;
  fWasOpen := false;
end;

end.
