unit DB.ArtikelList;

interface

uses
  SysUtils, Classes, Contnrs, DB.BaseList, DB.Artikel;

type
  TDBArtikelList = class(TDBBaseList)
  private
    function getItem(Index: Integer): TDBArtikel;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Item[Index:Integer]: TDBArtikel read getItem;
    procedure ReadAll(aEI_EN_Id: Integer);
  end;

implementation

{ TDBArtikelList }

constructor TDBArtikelList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TDBArtikelList.Destroy;
begin

  inherited;
end;

function TDBArtikelList.getItem(Index: Integer): TDBArtikel;
begin

end;

procedure TDBArtikelList.ReadAll(aEI_EN_Id: Integer);
begin

end;

end.
