unit o_ButtonPropList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_ButtonProp_BaseStrukList;


type
  TButtonPropList = class(TButtonPropBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;



implementation

{ TButtonPropList }

constructor TButtonPropList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TButtonPropList.Destroy;
begin

  inherited;
end;

procedure TButtonPropList.Init;
begin
  inherited;

end;

end.
