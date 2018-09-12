unit o_Sprache;

interface

uses
  SysUtils, Classes, o_Sprache_BaseStruk;

type
  TSprache = class(TSprache_BaseStruk)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;


implementation

{ TSprache }

constructor TSprache.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSprache.Destroy;
begin

  inherited;
end;

procedure TSprache.Init;
begin
  inherited;

end;

end.
