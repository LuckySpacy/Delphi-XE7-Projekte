unit o_Benutzer;

interface

uses
  SysUtils, Classes, o_Benutzer_BaseStruk;

type
  TBenutzer = class(TBenutzer_BaseStruk)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;

implementation

{ TBenutzer }

constructor TBenutzer.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TBenutzer.Destroy;
begin

  inherited;
end;



procedure TBenutzer.Init;
begin
  inherited;

end;

end.
