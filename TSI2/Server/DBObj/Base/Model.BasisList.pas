unit Model.BasisList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Objekt.BasisList;

type
  TBasisListModel = class(TBaseList)
  private
  protected
    _Trans: TIBTransaction;
    _Query: TIBQuery;
    _WasOpen: Boolean;
    procedure OpenTrans;
    procedure CommitTrans;
    procedure RollbackTrans;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Trans: TIBTransaction read _Trans write _Trans;
    procedure Clear;
  end;


implementation

{ TBasisListModel }

constructor TBasisListModel.Create(AOwner: TComponent);
begin
  inherited;
  _Trans := nil;
  _Query := TIBQuery.Create(nil);
end;

destructor TBasisListModel.Destroy;
begin
  FreeAndNil(_Query);
  inherited;
end;

procedure TBasisListModel.OpenTrans;
begin
  _WasOpen := _Trans.InTransaction;
  if not _Trans.InTransaction then
    _Trans.StartTransaction;
end;


procedure TBasisListModel.CommitTrans;
begin
  if (not _Trans.InTransaction) or (_WasOpen) then
    exit;
  _Trans.Commit;
  _WasOpen := false;
end;


procedure TBasisListModel.RollbackTrans;
begin
  if (not _Trans.InTransaction) or (_WasOpen) then
    exit;
  _Trans.Rollback;
  _WasOpen := false;
end;


procedure TBasisListModel.Clear;
begin
  _List.Clear;
end;


end.
