unit o_SysSprache;

interface

uses
  SysUtils, Classes, o_SysSprache_BaseStruk;

type
  TSysSprache = class(TSysSprache_BaseStruk)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;




implementation

{ TSysSprache }

constructor TSysSprache.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSysSprache.Destroy;
begin

  inherited;
end;

procedure TSysSprache.Init;
begin
  inherited;

end;

end.
