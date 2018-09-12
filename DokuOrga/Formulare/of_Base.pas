unit of_Base;

interface

uses
  SysUtils, Classes, StdCtrls, Buttons, ExtCtrls, tbRichviewEdit, of_BaseCustom,
  c_Types, c_TypesEvent, tbButton, o_propertyform, forms;

type
  Tof_Base = class(Tof_BaseCustom)
  private
  protected
    FBearbart: TBearbArt;
    FObjectId: Integer;
    FBtn_Ok: TTBButton;
    FPropertyform: TPropertyForm;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    procedure VisibleChanged(aValue: Boolean); override;
    property BearbArt: TBearbArt read FBearbart write FBearbart;
    property ObjectId: Integer read FObjectId write FObjectId;
    procedure DoChangeBearbArt(Sender: TObject; aBearbArt: TBearbArt);
  end;


implementation

{ Tof_Base }

uses
  c_DBTypes, u_system, o_sysobj;


constructor Tof_Base.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  FBearbart := cUndefiniert;
  FObjectId := -1;
  FBtn_Ok := gettbButton('btn_Ok');
  FPropertyform := TPropertyform.Create(nil);
  if FForm <> nil then
  begin
    FPropertyform.Read(FForm.Name);
    if FPropertyform.Found then
    begin
      if SameText(FPropertyform.Feld(PF_WINDOWSTATE).AsString, 'wsNormal') then
      begin
        FForm.Top := FPropertyform.Feld(PF_TOP).AsInteger;
        FForm.Height := FPropertyform.Feld(PF_HEIGHT).AsInteger;
        FForm.Width  := FPropertyform.Feld(PF_WIDTH).AsInteger;
        FForm.Left   := FPropertyform.Feld(PF_LEFT).AsInteger;
      end;
    end;
  end;
end;

destructor Tof_Base.Destroy;
//var
//  sWindowState: string;
begin
  if FForm <> nil then
  begin
    if FForm.WindowState = wsNormal then
      FPropertyform.Feld(PF_WINDOWSTATE).AsString := 'wsNormal';
    if FForm.WindowState = wsMinimized then
      FPropertyform.Feld(PF_WINDOWSTATE).AsString := 'wsMinimized';
    if FForm.WindowState = wsMaximized then
      FPropertyform.Feld(PF_WINDOWSTATE).AsString := 'wsMaximized';
    FPropertyform.Feld(PF_NAME).AsString := FForm.Name;
    FPropertyform.Feld(PF_PC).AsString := getComputername;
    FPropertyform.Feld(PF_BE_ID).AsInteger := SysObj.Benutzer.Id;
    FPropertyform.Feld(PF_TOP).AsInteger := FForm.Top;
    FPropertyform.Feld(PF_HEIGHT).AsInteger := FForm.Height;
    FPropertyform.Feld(PF_WIDTH).AsInteger := FForm.Width;
    FPropertyform.Feld(PF_LEFT).AsInteger := FForm.Left;
    FPropertyform.Save;
  end;
  FreeAndNil(FPropertyform);
  inherited;
end;


procedure Tof_Base.DoChangeBearbArt(Sender: TObject;
  aBearbArt: TBearbArt);
begin
  FBearbArt := aBearbArt;
end;


procedure Tof_Base.VisibleChanged(aValue: Boolean);
begin
  inherited;

end;

end.
