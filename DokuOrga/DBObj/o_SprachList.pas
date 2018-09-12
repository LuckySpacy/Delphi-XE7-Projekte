unit o_SprachList;

interface

uses
  SysUtils, Classes, o_SprachList_BaseStruk;

type
  TSprachList = class(TSprachList_BaseStruk)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;


implementation

{ TSprachList }

constructor TSprachList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSprachList.Destroy;
begin

  inherited;
end;

procedure TSprachList.Init;
begin
  inherited;

end;

end.
