unit o_SeiteList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_Seite_BaseStrukList;


type
  TSeiteList = class(TSeiteBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;

implementation

{ TSeiteList }

constructor TSeiteList.Create(AOwner: TComponent);
begin
  inherited;
  init;
end;

destructor TSeiteList.Destroy;
begin

  inherited;
end;

procedure TSeiteList.Init;
begin
  inherited;

end;

end.
