unit o_SeiteverbindenList;

interface
uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_Seiteverbinden_BaseStrukList;


type
  TSeiteverbindenList = class(TSeiteverbindenBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;

implementation

{ TSeiteDokumentList }

constructor TSeiteverbindenList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSeiteverbindenList.Destroy;
begin

  inherited;
end;

procedure TSeiteverbindenList.Init;
begin
  inherited;

end;



end.
