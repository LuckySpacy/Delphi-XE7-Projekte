unit VW.BaseList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, Objekt.BasisList, TBQuery, TBTrans;

type
  TVWBasisList = class(TBaseList)
  private
  protected
    fTrans: TTBTrans;
    fTBQuery: TTBQuery;
    fWasOpen: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Trans: TTBTrans read fTrans write fTrans;
    procedure Clear;
  end;

implementation

{ TVWBasisList }

uses
  Objekt.DokuOrga;


constructor TVWBasisList.Create(AOwner: TComponent);
begin
  inherited;
  fTBQuery := TTBQuery.Create(nil);
  fTBQuery.UseInterbase := DokuOrga.IBDatenbank.UseInterbase;
end;

destructor TVWBasisList.Destroy;
begin
  FreeAndNil(fTBQuery);
  inherited;

end;

procedure TVWBasisList.Clear;
begin
  fList.Clear;
end;


end.
