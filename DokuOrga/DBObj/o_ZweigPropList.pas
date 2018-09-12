unit o_ZweigPropList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_ZweigProp_BaseStrukList;


type
  TZweigPropList = class(TZweigPropBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;


implementation

{ TZweigPropList }

constructor TZweigPropList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TZweigPropList.Destroy;
begin

  inherited;
end;

procedure TZweigPropList.Init;
begin
  inherited;

end;

end.
