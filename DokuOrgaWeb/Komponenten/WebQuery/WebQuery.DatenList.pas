unit WebQuery.DatenList;

interface

uses
  SysUtils, Classes, WebQuery.BaseList, WebQuery.Feld, Data.DB, System.Contnrs,
  WebQuery.DatenFelder, WebQuery.DatenFelderList;

type
  TWebQueryDatenList = class(TWebQueryBaseList)
  private
    function GetDatenFelderList(Index: Integer): TWebQueryDatenFelderList;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Add: TWebQueryDatenFelderList;
    property Item[Index: Integer]: TWebQueryDatenFelderList read GetDatenFelderList;

  end;

implementation

{ TWebQueryDatenList }

constructor TWebQueryDatenList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TWebQueryDatenList.Destroy;
begin

  inherited;
end;


function TWebQueryDatenList.GetDatenFelderList(
  Index: Integer): TWebQueryDatenFelderList;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TWebQueryDatenFelderList(fList[Index]);
end;

function TWebQueryDatenList.Add: TWebQueryDatenFelderList;
begin
  Result := TWebQueryDatenFelderList.Create(nil);
  fList.Add(Result);
end;


end.
