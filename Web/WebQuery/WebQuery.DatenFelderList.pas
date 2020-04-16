unit WebQuery.DatenFelderList;

interface

uses
  SysUtils, Classes, WebQuery.BaseList, WebQuery.Feld, Data.DB, System.Contnrs,
  WebQuery.DatenFelder;

type
  TWebQueryDatenFelderList = class(TWebQueryBaseList)
  private
    function GetDatenFelder(Index: Integer): TWebQueryDatenFelder;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Add: TWebQueryDatenFelder;
    property Item[Index: Integer]: TWebQueryDatenFelder read GetDatenFelder;
  end;

implementation

{ TWebQueryDatenList }



constructor TWebQueryDatenFelderList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TWebQueryDatenFelderList.Destroy;
begin

  inherited;
end;


function TWebQueryDatenFelderList.GetDatenFelder(
  Index: Integer): TWebQueryDatenFelder;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TWebQueryDatenFelder(fList[Index]);
end;

function TWebQueryDatenFelderList.Add: TWebQueryDatenFelder;
begin
  Result := TWebQueryDatenFelder.Create(nil);
  fList.Add(Result);
end;



end.
