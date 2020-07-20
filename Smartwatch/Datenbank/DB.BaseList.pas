unit DB.BaseList;

interface

uses
  SysUtils, Classes, Contnrs, Objekt.BaseList, Data.DB, mySQLDbTables;

type
  TDBBaseList = class(TBaseList)
  private
  protected
    fQuery : TMySqlQuery;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


implementation

{ TDBBaseList }

uses
  dm.Datenmodul;

constructor TDBBaseList.Create(AOwner: TComponent);
begin
  inherited;
  fQuery := TMySqlQuery.Create(nil);
  fQuery.Database := dam.db;
end;

destructor TDBBaseList.Destroy;
begin
  FreeAndNil(fQuery);
  inherited;
end;

end.
