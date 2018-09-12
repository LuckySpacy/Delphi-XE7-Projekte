unit o_SpracheList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_Sprache_BaseStrukList;


type
  TSpracheList = class(TSpracheBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;


implementation

{ TSpracheList }

constructor TSpracheList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSpracheList.Destroy;
begin

  inherited;
end;

procedure TSpracheList.Init;
begin
  inherited;

end;

end.
