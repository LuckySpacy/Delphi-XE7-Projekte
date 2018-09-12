unit o_dblist;

interface

uses
  Classes, IBDatabase, IBQuery, Dialogs, ContNrs, SysUtils, o_db, o_Field, o_aktie;

type TDBList = class(TComponent)
  private
  protected
    FIBT   : TIBTransaction;
    FQuery : TIBQuery;
    FList  : TObjectList;
  published
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Count: Integer;
  end;


implementation

{ TDBList }

uses
  untDM;



constructor TDBList.Create(AOwner: TComponent);
begin
  inherited;
  FList := TObjectList.Create;
  FIBT  := TIBTransaction.Create(AOwner);
  FIBT.DefaultDatabase := dm.IBD;
  FQuery := TIBQuery.Create(AOwner);
  FQuery.Transaction := FIBT;
end;

destructor TDBList.Destroy;
begin
  FreeAndNil(FIBT);
  FreeAndNil(FQuery);
  FreeAndNil(FList);
  inherited;
end;

function TDBList.Count: Integer;
begin
  Result := FList.Count;
end;


end.
