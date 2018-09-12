unit o_BilderList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_Bilder_BaseStrukList;


type
  TBilderList = class(TBilderBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;


implementation

{ TBilderList }

constructor TBilderList.Create(AOwner: TComponent);
begin
  inherited;
  init;
end;

destructor TBilderList.Destroy;
begin

  inherited;
end;

procedure TBilderList.Init;
begin
  inherited;

end;

end.
