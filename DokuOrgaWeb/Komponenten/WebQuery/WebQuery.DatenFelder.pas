unit WebQuery.DatenFelder;

interface

uses
  SysUtils, Classes, WebQuery.BaseList, WebQuery.Feld, Data.DB, System.Contnrs;

type
  TWebQueryDatenFelder = class(TWebQueryBaseList)
  private
    function GetWebQueryFeld(Index: Integer): TWebQueryFeld;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Add: TWebQueryFeld;
    property Item[Index: Integer]: TWebQueryFeld read GetWebQueryFeld;
  end;

implementation

{ TWebQueryDatenFelder }



constructor TWebQueryDatenFelder.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TWebQueryDatenFelder.Destroy;
begin

  inherited;
end;


function TWebQueryDatenFelder.GetWebQueryFeld(Index: Integer): TWebQueryFeld;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TWebQueryFeld(fList[Index]);
end;

function TWebQueryDatenFelder.Add: TWebQueryFeld;
begin
  Result := TWebQueryFeld.Create(nil);
  fList.Add(Result);
end;


end.
