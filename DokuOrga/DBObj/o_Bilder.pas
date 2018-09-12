unit o_Bilder;

interface

uses
  SysUtils, Classes, o_Bilder_BaseStruk;

type
  TBilder = class(TBilder_BaseStruk)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;


implementation

{ TBilder }

constructor TBilder.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TBilder.Destroy;
begin

  inherited;
end;

procedure TBilder.Init;
begin
  inherited;

end;

end.
