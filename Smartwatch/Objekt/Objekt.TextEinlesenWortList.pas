unit Objekt.TextEinlesenWortList;

interface

uses
  SysUtils, Types, Windows, Classes, Objekt.BaseList, Objekt.TextEinlesenWort;


type
  TTextEinlesenWortList = class(TBaseList)
  private
    function getItem(Index: Integer): TTextEinlesenWort;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Item[Index:Integer]: TTextEinlesenWort read getItem;
    function Add: TTextEinlesenWort;
  end;

implementation

{ TTextEinlesenWortList }

function TTextEinlesenWortList.Add: TTextEinlesenWort;
begin
  Result := TTextEinlesenWort.Create;
  fList.Add(Result);
end;

constructor TTextEinlesenWortList.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TTextEinlesenWortList.Destroy;
begin

  inherited;
end;

function TTextEinlesenWortList.getItem(Index: Integer): TTextEinlesenWort;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TTextEinlesenWort(fList.Items[Index]);
end;

end.
