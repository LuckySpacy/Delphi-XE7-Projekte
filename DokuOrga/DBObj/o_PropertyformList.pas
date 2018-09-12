unit o_PropertyformList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_Propertyform_BaseStrukList;


type
  TProeprtyformList = class(TPropertyformBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;

implementation

{ TProeprtyformList }

constructor TProeprtyformList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TProeprtyformList.Destroy;
begin

  inherited;
end;

procedure TProeprtyformList.Init;
begin
  inherited;

end;

end.
