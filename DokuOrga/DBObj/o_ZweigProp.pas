unit o_ZweigProp;

interface

uses
  SysUtils, Classes, o_ZweigProp_BaseStruk, o_ItemList, o_BaumButton, o_Bilder,
  Graphics;

type
  TZweigProp = class(TZweigProp_BaseStruk)
  private
    FBilder: TBilder;
    function getBilder: TBilder;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure MarkAsDelete; override;
    procedure Delete; override;
    property Bilder: TBilder read getBilder write FBilder;
  end;


implementation

{ TZwegProp }

uses
  c_DBTypes;

constructor TZweigProp.Create(AOwner: TComponent);
begin
  FBilder     := TBilder.Create(Self);
  inherited;
  Init;
  FBilder.Trans := getTrans;
end;

destructor TZweigProp.Destroy;
begin
  FreeAndNil(FBilder);
  inherited;
end;

function TZweigProp.getBilder: TBilder;
begin
  Result := FBilder;
  if Id <= 0 then
  begin
    FBilder.Init;
    exit;
  end;
  if FBilder.Id <= 0 then
    FBilder.read(Feld(ZP_BI_ID).AsInteger);
end;

procedure TZweigProp.Init;
begin
  inherited;

end;

procedure TZweigProp.Delete;
begin
  inherited;

end;


procedure TZweigProp.MarkAsDelete;
begin
  inherited;

end;

end.
