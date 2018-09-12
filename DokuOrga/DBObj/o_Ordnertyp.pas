unit o_Ordnertyp;

interface

uses
  SysUtils, Classes, o_ItemList;

type
  TOrdnertyp = class(TDBItemList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;


implementation

{ TOrdnertyp }

constructor TOrdnertyp.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TOrdnertyp.Destroy;
begin

  inherited;
end;

procedure TOrdnertyp.Init;
begin
  inherited;
end;


end.
