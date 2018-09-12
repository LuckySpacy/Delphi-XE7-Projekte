unit fntMessageDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, RVStyle, RVScroll, RichView, RVEdit,
  RVLinear, tbRichviewEdit, Buttons;

type
  Tfrm_MessageDialog = class(TForm)
    bvl_Top: TBevel;
    bvl_Left: TBevel;
    Image: TImage;
    ImageList: TImageList;
    pnl_Button: TPanel;
    Label1: TLabel;
    bvl_Right: TBevel;
    rve: TtbRichviewEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    _ButtonList: TList;
    _DefaultButton: TMsgDlgBtn;
    _UseDefaultButton: Boolean;
    _KeyList: TStringList;
    procedure ButtonClick(Sender: TObject);
    function getAsString: string;
    procedure setAsString(const Value: string);
    procedure SetHeightAndWidth;
    function GetButton(aMsgDlgBtn: TMsgDlgBtn): TBitBtn;
    function CreateButton(aButton: TMsgDlgBtn): TBitBtn;
    procedure CreateButton2(aButton: TMsgDlgBtn);
    procedure CreateButtons(aButtons: Array of TMsgDlgBtn);
    procedure Buttons_An_Form_Ausrichten;
    procedure SetDlgCaption(DlgType: TMsgDlgType);
    procedure SetDlgIcon(DlgType: TMsgDlgType);
  public
    property AsString: string read getAsString write setAsString;
    class function Msg(AOwner: TComponent; aMessageText: string; DlgType: TMsgDlgType; Buttons: Array of TMsgDlgBtn): Integer; overload;
    class function Msg(AOwner: TComponent; aMessageText: string; DlgType: TMsgDlgType; Buttons: Array of TMsgDlgBtn; aDefaultButton: TMsgDlgBtn): Integer; overload;
    class function Msg(AOwner: TComponent; aMessageText: string; DlgType: TMsgDlgType; Buttons: Array of TMsgDlgBtn; aDefaultButton: TMsgDlgBtn; aButtontext: Array of String): Integer; overload; //
    class function Msg(AOwner: TComponent; aMessageText: string; DlgType: TMsgDlgType; Buttons: Array of TMsgDlgBtn; aHelpctx: Integer): Integer; overload;
    class function MsgConfirm(AOwner: TComponent; aMessageText: string; DlgType: TMsgDlgType; Buttons: Array of Integer; aDefaultButton: TMsgDlgBtn): Integer;
  end;

var
  frm_MessageDialog: Tfrm_MessageDialog;

implementation

{$R *.dfm}

{ Tfrm_MessageDialog }

procedure Tfrm_MessageDialog.FormCreate(Sender: TObject);
begin
  _ButtonList := TList.Create;
  _UseDefaultButton := false;
  _KeyList := TStringList.Create;
end;

procedure Tfrm_MessageDialog.FormDestroy(Sender: TObject);
begin
  FreeAndNil(_ButtonList);
  FreeAndNil(_KeyList);
end;

procedure Tfrm_MessageDialog.FormShow(Sender: TObject);
var
  BitBtn: TBitBtn;
begin
  if _UseDefaultButton then
  begin
    BitBtn := GetButton(_DefaultButton);
    if Assigned(BitBtn) then
      BitBtn.SetFocus;
  end;
end;

function Tfrm_MessageDialog.getAsString: string;
begin
  Result := rve.AsRTFString;
end;

procedure Tfrm_MessageDialog.setAsString(const Value: string);
begin
  rve.AsRTFString := Value;
  SetHeightAndWidth;
end;


function Tfrm_MessageDialog.GetButton(aMsgDlgBtn: TMsgDlgBtn): TBitBtn;
var
  iTag: Integer;
  i1  : Integer;
begin
  iTag := mrCancel;
  Result := nil;
  if aMsgDlgBtn = mbYes      then iTag := mrYes;
  if aMsgDlgBtn = mbNo       then iTag := mrNo;
  if aMsgDlgBtn = mbOK       then iTag := mrOk;
  if aMsgDlgBtn = mbCancel   then iTag := mrCancel;
  if aMsgDlgBtn = mbAbort    then iTag := mrAbort;
  if aMsgDlgBtn = mbRetry    then iTag := mrRetry;
  if aMsgDlgBtn = mbIgnore   then iTag := mrIgnore;
  if aMsgDlgBtn = mbAll      then iTag := mrAll;
  if aMsgDlgBtn = mbNoToAll  then iTag := mrNoToAll;
  if aMsgDlgBtn = mbYesToAll then iTag := mrYesToAll;

  for i1 := 0 to _ButtonList.Count - 1 do
  begin
    if TBitBtn(_ButtonList.Items[i1]).Tag = iTag then
    begin
      Result := TBitBtn(_ButtonList.Items[i1]);
      exit;
    end;
  end;

end;



procedure Tfrm_MessageDialog.SetHeightAndWidth;
begin
  rve.ClientWidth  := rve.RVData.TextWidth + rve.LeftMargin + rve.RightMargin;
  rve.ClientHeight := rve.DocumentHeight;
  if rve.ClientHeight < 40 then
    rve.ClientHeight := 40;
  ClientWidth  := bvl_Left.Width + rve.Width + bvl_Right.Width;
  ClientHeight := bvl_Top.Height + pnl_Button.Height + rve.Height;
  Buttons_An_Form_Ausrichten;
end;



function Tfrm_MessageDialog.CreateButton(aButton: TMsgDlgBtn): TBitBtn;
begin
  Result := TBitBtn.Create(Self);
  Result.Parent := pnl_Button;
  Result.Left   := 10;
  if aButton = Dialogs.mbOK then
  begin
    Result.Caption  := 'Ok';
    _KeyList.Add('O=' + IntToStr(mrOk));
  end;
  if aButton = Dialogs.mbYes then
  begin
    Result.Caption := 'Ja';
    _KeyList.Add('J=' + IntToStr(mrYes));
  end;
  if aButton = Dialogs.mbNo then
  begin
    Result.Caption  := 'Nein';
    _KeyList.Add('N=' + IntToStr(mrNo));
  end;
  if aButton = Dialogs.mbCancel then
  begin
    Result.Caption    := 'Abbruch';
    _KeyList.Add('A=' + IntToStr(mrCancel));
  end;
  if aButton = Dialogs.mbAbort then
  begin
    Result.Caption     := 'Abbruch';
    _KeyList.Add('A=' + IntToStr(mrAbort));
  end;
  if aButton = Dialogs.mbRetry then
  begin
    Result.Caption     := 'Wiederholen';
    _KeyList.Add('W=' + IntToStr(mrRetry));
  end;
  if aButton = Dialogs.mbIgnore then
  begin
    Result.Caption    := 'Ignorieren';
    _KeyList.Add('I=' + IntToStr(mrIgnore));
  end;
  if aButton = Dialogs.mbAll then
  begin
    Result.Caption       := 'Alle';
    //_KeyList.Add('A=' + IntToStr(mrAll));
  end;
  if aButton = Dialogs.mbNoToAll then
  begin
    Result.Caption   := 'Alle Nein';
    //_KeyList.Add('A=' + IntToStr(mrNoToAll));
  end;
  if aButton = Dialogs.mbYesToAll then
  begin
    Result.Caption  := 'Alle Ja';
    //_KeyList.Add('A=' + IntToStr(mrYesToAll));
  end;
  if aButton = Dialogs.mbHelp then
  begin
    Result.Caption      := 'Hilfe';
    //_KeyList.Add('H=' + IntToStr(mrNone));
  end;


  if aButton = Dialogs.mbOK then Result.Tag       := mrOk;
  if aButton = Dialogs.mbYes then Result.Tag      := mrYes;
  if aButton = Dialogs.mbNo then Result.Tag       := mrNo;
  if aButton = Dialogs.mbCancel then Result.Tag   := mrCancel;
  if aButton = Dialogs.mbAbort then Result.Tag    := mrAbort;
  if aButton = Dialogs.mbRetry then Result.Tag    := mrRetry;
  if aButton = Dialogs.mbIgnore then Result.Tag   := mrIgnore;
  if aButton = Dialogs.mbAll then Result.Tag      := mrAll;
  if aButton = Dialogs.mbNoToAll then Result.Tag  := mrNoToAll;
  if aButton = Dialogs.mbYesToAll then Result.Tag := mrYesToAll;
  if aButton = Dialogs.mbHelp then Result.Tag     := mrNone;

  Result.OnClick := ButtonClick;
  Result.Top := 8;
end;


procedure Tfrm_MessageDialog.ButtonClick(Sender: TObject);
begin
  ModalResult := TBitBtn(Sender).Tag;
end;

procedure Tfrm_MessageDialog.CreateButton2(aButton: TMsgDlgBtn);
begin
  _ButtonList.Add(CreateButton(aButton));
end;

procedure Tfrm_MessageDialog.CreateButtons(aButtons: Array of TMsgDlgBtn);
var
  B: TMsgDlgBtn;
  i1: Integer;
begin
  for i1 := High(aButtons) downto Low(aButtons) do
  begin
    B := aButtons[i1];
    _ButtonList.Add(CreateButton(B));
  end;
end;


procedure Tfrm_MessageDialog.Buttons_An_Form_Ausrichten;
var
  iLeft: Integer;
  iButtonWidth: Integer;
  i1   : Integer;
  TextBreite: Integer;
begin
  if _ButtonList.Count = 0 then
    exit;

  for i1 := 0 to _ButtonList.Count - 1 do
  begin
    TextBreite := Label1.Canvas.TextWidth(TBitBtn(_ButtonList.Items[i1]).Caption);
    if TextBreite + 8 > TBitBtn(_ButtonList.Items[i1]).ClientWidth then
      TBitBtn(_ButtonList.Items[i1]).ClientWidth := TextBreite + 8;
  end;

  iButtonWidth := 0;
  for i1 := 0 to _ButtonList.Count - 1 do
    iButtonWidth := iButtonWidth + TBitBtn(_ButtonList.Items[i1]).Width + 10;

  if Width < iButtonWidth + bvl_Left.Width + bvl_Right.Width then
    Width := iButtonWidth + bvl_Left.Width + bvl_Right.Width ;

  iLeft := Width - bvl_Right.Width + 4;

  for i1 := 0 to _ButtonList.Count - 1 do
  begin
    iLeft := iLeft - (TBitBtn(_ButtonList.Items[i1]).Width + 10);
    TBitBtn(_ButtonList.Items[i1]).Left := iLeft;
  end;

end;


procedure Tfrm_MessageDialog.SetDlgCaption(DlgType: TMsgDlgType);
var
  iPos: Integer;
begin
  if DlgType = mtInformation then
    Caption := 'Information';
  if DlgType = mtWarning then
    Caption := 'Warnung';
  if DlgType = mtError then
    Caption := 'Fehler';
  if DlgType = mtConfirmation then
    Caption := 'Bestätigen';
  if DlgType = mtCustom then
  begin
    Caption := ExtractFileName(ParamStr(0));
    iPos := Pos('.', Caption);
    Caption := copy(Caption, 1, iPos-1);
  end;
end;

procedure Tfrm_MessageDialog.SetDlgIcon(DlgType: TMsgDlgType);
begin
  if DlgType = mtInformation then
    ImageList.GetIcon(0, Image.Picture.Icon);
  if DlgType = mtWarning then
    ImageList.GetIcon(1, Image.Picture.Icon);
  if DlgType = mtError then
    ImageList.GetIcon(2, Image.Picture.Icon);
  if DlgType = mtConfirmation then
    ImageList.GetIcon(3, Image.Picture.Icon);
  if DlgType = mtCustom then
  begin
    Image.Visible := false;
    bvl_Left.Width := 10;
    Application.ProcessMessages;
  end;
end;




// MessageDialog Aufrufe

class function Tfrm_MessageDialog.Msg(AOwner: TComponent; aMessageText: string; DlgType: TMsgDlgType;
  Buttons: Array of TMsgDlgBtn; aDefaultButton: TMsgDlgBtn): Integer;
var
  Form: Tfrm_MessageDialog;
begin
  Form := Tfrm_MessageDialog.Create(AOwner);
  try
    Form.SetDlgCaption(DlgType);
    Form.SetDlgIcon(DlgType);
    Form.CreateButtons(Buttons);
    Form._DefaultButton := aDefaultButton;
    Form._UseDefaultButton := true;
    Form.AsString := aMessageText;
    Result := Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;
end;


class function Tfrm_MessageDialog.Msg(AOwner: TComponent; aMessageText: string; DlgType: TMsgDlgType;
  Buttons: Array of TMsgDlgBtn): Integer;
var
  Form: Tfrm_MessageDialog;
begin
  Form := Tfrm_MessageDialog.Create(AOwner);
  try
    Form.SetDlgCaption(DlgType);
    Form.SetDlgIcon(DlgType);
    Form.CreateButtons(Buttons);
    Form.AsString := aMessageText;
    Result := Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;
end;


class function Tfrm_MessageDialog.Msg(AOwner: TComponent; aMessageText: string; DlgType: TMsgDlgType;
  Buttons: Array of TMsgDlgBtn; aHelpctx: Integer): Integer;
var
  Form: Tfrm_MessageDialog;
begin
  Form := Tfrm_MessageDialog.Create(AOwner);
  try
    Form.SetDlgCaption(DlgType);
    Form.SetDlgIcon(DlgType);
    Form.CreateButtons(Buttons);
    Form._DefaultButton := mbYes;
    Form._UseDefaultButton := true;
    Form.AsString := aMessageText;
    Result := Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;
end;


class function Tfrm_MessageDialog.Msg(AOwner: TComponent; aMessageText: string; DlgType: TMsgDlgType;
  Buttons: Array of TMsgDlgBtn; aDefaultButton: TMsgDlgBtn; aButtontext: Array of String): Integer;
var
  Form: Tfrm_MessageDialog;
  i1: Integer;
begin
  Form := Tfrm_MessageDialog.Create(AOwner);
  try
    Form.SetDlgCaption(DlgType);
    Form.SetDlgIcon(DlgType);
    Form.CreateButtons(Buttons);
    for i1 := 0 to Form._ButtonList.Count -1 do
      TBitBtn(Form._ButtonList[i1]).Caption := aButtontext[i1];
    Form._DefaultButton := aDefaultButton;
    Form._UseDefaultButton := true;
    Form.AsString := aMessageText;
    Result := Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;
end;

class function Tfrm_MessageDialog.MsgConfirm(AOwner: TComponent; aMessageText: string; DlgType: TMsgDlgType;
  Buttons: array of Integer; aDefaultButton: TMsgDlgBtn): Integer;
var
  Form: Tfrm_MessageDialog;
  i1: Integer;
begin
  Form := Tfrm_MessageDialog.Create(AOwner);
  try
    Form.SetDlgCaption(DlgType);
    Form.SetDlgIcon(DlgType);
    for i1 := High(Buttons) downto Low(Buttons) do
    begin
      case Buttons[i1] of
        mrOk      : Form.CreateButton2(mbOk);
        mrCancel  : Form.CreateButton2(mbCancel);
        mrAbort   : Form.CreateButton2(mbAbort);
        mrRetry   : Form.CreateButton2(mbRetry);
        mrIgnore  : Form.CreateButton2(mbIgnore);
        mrYes     : Form.CreateButton2(mbYes);
        mrNo      : Form.CreateButton2(mbNo);
        mrAll     : Form.CreateButton2(mbAll);
        mrNoToAll : Form.CreateButton2(mbNoToAll);
        mrYesToAll: Form.CreateButton2(mbYesToAll);
      end;
    end;
    Form._DefaultButton := aDefaultButton;
    Form._UseDefaultButton := true;
    Form.AsString := aMessageText;
    Result := Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;
end;









end.
