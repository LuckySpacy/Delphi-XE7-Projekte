unit TBTrans;

interface

uses
  IBX.IBQuery, Classes, SysUtils, IBX.IBDatabase;

type
  TTBTrans = class(TComponent)
  private
    fTrans: TIBTransaction;
    fWasOpen: Boolean;
  protected
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure OpenTrans;
    procedure StartTrans;
    procedure CommitTrans;
    procedure RollbackTrans;
    function Trans: TIBTransaction;
  end;

implementation

{ TTBTrans }


constructor TTBTrans.Create(aOwner: TComponent);
begin
  inherited;
  fTrans := TIBTransaction.Create(aOwner);
  fWasOpen := false;
end;

destructor TTBTrans.Destroy;
begin
  FreeAndNil(fTrans);
  inherited;
end;


procedure TTBTrans.OpenTrans;
begin
  StartTrans;
end;

procedure TTBTrans.CommitTrans;
begin
  if (fWasOpen) and (fTrans.InTransaction) then
  begin
    fTrans.Commit;
    fWasOpen := false;
  end;
end;


procedure TTBTrans.RollbackTrans;
begin
  if (fWasOpen) and (fTrans.InTransaction) then
  begin
    fTrans.Rollback;
    fWasOpen := false;
  end;
end;

procedure TTBTrans.StartTrans;
begin
  if not fTrans.InTransaction then
  begin
    fWasOpen := true;
    fTrans.StartTransaction;
  end;
end;

function TTBTrans.Trans: TIBTransaction;
begin
  Result := fTrans;
end;

end.
