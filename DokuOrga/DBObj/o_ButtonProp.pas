unit o_ButtonProp;

interface

uses
  SysUtils, Classes, o_ButtonProp_BaseStruk, o_ItemList, o_BaumButton, o_Bilder,
  Graphics;

type
  TButtonProp = class(TButtonProp_BaseStruk)
  private
    FItemList: TDBItemList;
    FBaumButton: TBaumButton;
    FBilder: TBilder;
    function getItemList: TDBItemList;
    function getBaumButton: TBaumButton;
    function getBilder: TBilder;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure MarkAsDelete; override;
    property ItemList: TDBItemList read getItemList write FItemList;
    property BaumButton: TBaumButton read getBaumButton write FBaumButton;
    property Bilder: TBilder read getBilder write FBilder;
    function Icon: TIcon;
    procedure Delete; override;
  end;


implementation

{ TButtonProp }

uses
  c_DBTypes;

constructor TButtonProp.Create(AOwner: TComponent);
begin
  FItemList   := TDBItemList.Create(Self);
  FBaumButton := TBaumButton.Create(Self);
  FBilder     := TBilder.Create(Self);
  inherited;
  init;
  FBaumButton.Trans := getTrans;
  FBilder.Trans := getTrans;
end;

procedure TButtonProp.Delete;
begin
  OpenTrans;
  try
    if getBaumButton.Feld(BB_BP_ID).AsInteger = Id then
      getBaumButton.Delete;
    inherited;
  finally
    CommitTrans;
    //if getTrans.InTransaction then
    //  getTrans.Rollback;
  end;
end;

destructor TButtonProp.Destroy;
begin
  FreeAndNil(FItemList);
  FreeAndNil(FBaumButton);
  FreeAndNil(FBilder);
  inherited;
end;

function TButtonProp.getBaumButton: TBaumButton;
begin
  if FBaumButton.Feld(BB_BP_ID).AsInteger = Id then
  begin
    Result := FBaumButton;
    exit;
  end;
  FBaumButton.Trans := getTrans;
  FBaumButton.ReadFromButtonProp(Id);
  Result := FBaumButton;
end;

function TButtonProp.getBilder: TBilder;
begin
  Result := FBilder;
  if Id <= 0 then
  begin
    FBilder.Init;
    exit;
  end;
  if FBilder.Id <= 0 then
    FBilder.read(Feld(BP_BI_ID).AsInteger);
end;

function TButtonProp.getItemList: TDBItemList;
begin
  FItemList.Trans := Trans;
  Result := FItemList;
  if FItemList.Id <= 0 then
    FItemList.Read(Feld(BP_IT_ID).AsInteger);
end;


procedure TButtonProp.Init;
begin
  inherited;
  FItemList.Init;
  FBaumButton.Init;
  FBilder.Init;
end;


function TButtonProp.Icon: TIcon;
begin
  Result := nil;
  if getBilder.Found then
    Result := getBilder.Feld(BI_BILD).Ico.AsIcon;
end;


procedure TButtonProp.MarkAsDelete;
begin
  inherited;
  OpenTrans;
  try
    FBaumButton.Trans := Trans;
    FBaumButton.ReadFromButtonProp(Id);
    if FBaumButton.Feld(BB_BP_ID).AsInteger = Id then
    begin
      FBaumButton.MarkAsDelete;
      FBaumButton.Save;
    end;
    CommitTrans;
  except
    RollbackTrans;
  end;
end;

end.
