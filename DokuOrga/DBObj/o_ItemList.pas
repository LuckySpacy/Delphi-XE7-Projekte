unit o_ItemList;

interface

uses
  SysUtils, Classes, o_ItemList_BaseStruk;

type
  TDBItemList = class(TItemList_BaseStruk)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;


implementation

{ TDBItemList }

constructor TDBItemList.Create(AOwner: TComponent);
begin
  inherited;
  init;
end;

destructor TDBItemList.Destroy;
begin

  inherited;
end;

procedure TDBItemList.Init;
begin
  inherited;

end;

end.
