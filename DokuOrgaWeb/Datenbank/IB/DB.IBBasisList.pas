unit DB.IBBasisList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, Objekt.BasisList, TBQuery, TBTrans;

type
  TDBIBBasisList = class(TBaseList)
  private
  protected
    fTrans: TTBTrans;
    fTBQuery: TTBQuery;
    fWasOpen: Boolean;
    function getGeneratorName: string; virtual; abstract;
    function getTableName: string; virtual; abstract;
    function getTablePrefix: string; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Trans: TTBTrans read fTrans write fTrans;
    procedure Clear;
    procedure Read(aOrder: string); virtual;
  end;


implementation

{ TDBBasisList }

uses
  Objekt.DokuOrga;

constructor TDBIBBasisList.Create(AOwner: TComponent);
begin
  inherited;
  fTrans := nil;
  fTBQuery := TTBQuery.Create(nil);
  fTBQuery.UseInterbase := DokuOrga.IBDatenbank.UseInterbase;
end;

destructor TDBIBBasisList.Destroy;
begin
  FreeAndNil(fTBQuery);
  inherited;
end;


procedure TDBIBBasisList.Read(aOrder: string);
begin
  fList.Clear;
  fTBQuery.TBTrans := fTrans;
  fTBQuery.Sql.Text := 'select * from ' + getTableName + ' where ' + getTablePrefix + '_Delete != ' + QuotedStr('T');
  if aOrder > '' then
    fTBQuery.Sql.Text := fTBQuery.Sql.Text + ' Order by ' + aOrder;
  fTrans.StartTrans;
  fTBQuery.Open;
end;



procedure TDBIBBasisList.Clear;
begin
  fList.Clear;
end;

end.
