unit o_BaumStruk;

interface

uses
  SysUtils, Classes, o_BaumStruk_BaseStruk, o_baumbutton, o_zweigprop;

type
  TBaumStruk = class(TBaumStruk_BaseStruk)
  private
    FBaumbutton: TBaumButton;
    FZweigProp: TZweigProp;
    function getBaumbutton: TBaumButton;
    function getZweigProp: TZweigProp;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ReadFromZweiProp(aId: Integer);
    property Baumbutton: TBaumButton read getBaumbutton write FBaumButton;
    property ZweigProp: TZweigProp read getZweigProp write FZweigProp;
  end;


implementation

{ TBaumStruk }

uses
  c_DBTypes;


constructor TBaumStruk.Create(AOwner: TComponent);
begin
  FZweigProp  := TZweigProp.Create(AOwner);
  FBaumbutton := TBaumButton.Create(AOwner);
  inherited;
  Init;
  FBaumbutton.Trans := getTrans;
  FZweigProp.Trans  := getTrans;
end;

destructor TBaumStruk.Destroy;
begin
  FreeAndNil(FZweigProp);
  FreeAndNil(FBaumbutton);
  inherited;
end;

procedure TBaumStruk.Init;
begin
  inherited;

end;

procedure TBaumStruk.ReadFromZweiProp(aId: Integer);
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where BS_ZP_ID = ' + IntToStr(aId);
  OpenTrans;
  FQuery.Open;
  LoadByQuery(FQuery);
  RollbackTrans;
end;


function TBaumStruk.getBaumbutton: TBaumButton;
begin
  if FBaumButton.Id = Feld(BS_BB_ID).AsInteger then
  begin
    Result := FBaumButton;
    exit;
  end;
  FBaumButton.Trans := getTrans;
  FBaumbutton.Read(Feld(BS_BB_ID).AsInteger);
  Result := FBaumButton;
end;

function TBaumStruk.getZweigProp: TZweigProp;
begin
  if FZweigProp.Id = Feld(BS_ZP_ID).AsInteger then
  begin
    Result := FZweigProp;
    exit;
  end;
  FZweigProp.Trans := getTrans;
  FZweigProp.Read(Feld(BS_ZP_ID).AsInteger);
  Result := FZweigProp;
end;

end.
