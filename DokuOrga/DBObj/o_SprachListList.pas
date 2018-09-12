unit o_SprachListList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_SprachList_BaseStrukList;


type
  TSprachListList = class(TSprachListBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;


implementation

{ TSprachListList }

constructor TSprachListList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSprachListList.Destroy;
begin

  inherited;
end;

procedure TSprachListList.Init;
begin
  inherited;

end;

end.
