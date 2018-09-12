unit of_BaseCustom;

interface

uses
  SysUtils, Classes, StdCtrls, Buttons, ExtCtrls, tbRichviewEdit, Forms, tbStringGrid,
  tbButton, VirtualTrees, tbEditFile, Menus, tbtoolbar, AdvFileNameEdit,
  AdvEdBtn, AdvDirectoryEdit, Vcl.ComCtrls, c_types, Vcl.ImgList, Vcl.Controls, DragDrop,
  DropTarget, DragDropFile, tbRvePopUp;

type
  Tof_BaseCustom = class(TComponent)
  private
  protected
    FForm: TForm;
    FNeu: Boolean;
    FCustomEditFields: TList;
    FListboxList: TList;
    FSpeedButtonList: TList;
    FPanelList: TList;
    FLabelList: TList;
    FButtonList: TList;
    FComboboxList: TList;
    FtbRichviewEditList: TList;
    FtbStringGridList: TList;
    FtbButtonList: TList;
    FListBox: TListBox;
    FStrGrid: TtbStringGrid;
    FAllList: TList;
    FMode: TModus;
    function getCustomEdit(aName: string): TCustomEdit;
    function getCustomEditText(aName: string): string;
    procedure setCustomEditText(aName: string; aValue: string);
    function getLabel(aName: string): TLabel;
    procedure setLabelText(aName, aValue: string);
    procedure AbleAllCustomEditFields(aValue: Boolean);
    function getSpeedButton(aName: string): TSpeedButton;
    procedure setSpeedButtonEnabled(aName: string; aValue: Boolean);
    function getButton(aName: string): TButton;
    function getEdit(aName: string): TEdit;
    function getCombobox(aName: string): TCombobox;
    function getListbox(aName: string): TListbox;
    function getrve(aName: string): TtbRichviewEdit;
    function gettbStringGrid(aName: string): TtbStringGrid;
    function gettbButton(aName: string): TTBButton;
    function getScrollbox(aName: string): TScrollbox;
    function getImage(aName: string): TImage;
    function getImageList(aName: string): TImageList;
    function getVirtualStringTree(aName: string): TVirtualStringTree;
    function gettbEditFile(aName: string): TtbEditFile;
    function getPopUpMenu(aName: string): TPopUpMenu;
    function gettbToolbar(aName: string): TTbToolbar;
    function gettbRichViewEdit(aName: string): TtbRichViewEdit;
    function getPanel(aName: string): TPanel;
    function getAdvDirectoryEdit(aName: string): TAdvDirectoryEdit;
    function getAdvEditBtn(aName: string): TAdvEditBtn;
    function getCheckbox(aName: string): TCheckBox;
    function getSplitter(aName: string): TSplitter;
    function getDateTimePicker(aName: string): TDateTimePicker;
    function getMemo(aName: String): TMemo;
    function getAdvFileNameEdit(aName: string): TAdvFileNameEdit;
    function getButtonedEdit(aName: string): TButtonedEdit;
    function getProgressbar(aName: string): TProgressbar;
    function getDropFileTarget(aName: string): TDropFileTarget;
    function getDataFormatAdapter(aName: string): TDataFormatAdapter;
    function gettbRvePopUp(aName: string): TtbRvePopUp;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); reintroduce; overload; virtual;
    constructor Create(AOwner: TComponent); reintroduce; overload;
    destructor Destroy; override;
    procedure ClearAllEditFields;
    procedure VisibleChanged(aValue: Boolean); virtual; abstract;
    property Form: TForm read FForm write FForm;
  end;


implementation

{ Tof_Base }

uses
  Dialogs;


constructor Tof_BaseCustom.Create(AOwner: TComponent; AMode: TModus);
var
  i1: Integer;
begin
  inherited Create(AOwner);
  FMode := AMode;
  FForm := nil;
  if AOwner is TForm then
    FForm := TForm(AOwner);
  FNeu := false;
  FCustomEditFields := TList.Create;
  FListboxList := TList.Create;
  FSpeedButtonList := TList.Create;
  FPanelList := TList.Create;
  FLabelList := TList.Create;
  FButtonList := TList.Create;
  FtbRichviewEditList := TList.Create;
  FComboboxList := TList.Create;
  FtbStringGridList := TList.Create;
  FtbButtonList := TList.Create;
  FAllList := TList.Create;


  for i1 := 0 to AOwner.ComponentCount - 1 do
  begin
    if AOwner.Components[i1] is TCustomEdit then
      FCustomEditFields.Add(AOwner.Components[i1]);
    if AOwner.Components[i1] is TListBox then
      FListboxList.Add(AOwner.Components[i1]);
    if AOwner.Components[i1] is TSpeedButton then
      FSpeedbuttonList.Add(AOwner.Components[i1]);
    if AOwner.Components[i1] is TPanel then
      FPanelList.Add(AOwner.Components[i1]);
    if AOwner.Components[i1] is TLabel then
      FLabelList.Add(AOwner.Components[i1]);
    if AOwner.Components[i1] is TButton then
      FButtonList.Add(AOwner.Components[i1]);
    if AOwner.Components[i1] is TtbRichviewEdit then
      FtbRichviewEditList.Add(AOwner.Components[i1]);
    if AOwner.Components[i1] is TCombobox then
      FComboboxList.Add(AOwner.Components[i1]);
    if AOwner.Components[i1] is TtbStringGrid then
      FtbStringGridList.Add(AOwner.Components[i1]);
    if AOwner.Components[i1] is TtbButton then
      FtbButtonList.Add(AOwner.Components[i1]);

    FAllList.Add(AOwner.Components[i1]);

  end;
end;

constructor Tof_BaseCustom.Create(AOwner: TComponent);
begin
  inherited;
  ShowMessage('Falscher Constructor');
end;


destructor Tof_BaseCustom.Destroy;
begin
  FreeAndNil(FCustomEditFields);
  FreeAndNil(FListboxList);
  FreeAndNil(FSpeedbuttonList);
  FreeAndNil(FPanelList);
  FreeAndNil(FLabelList);
  FreeAndNil(FButtonList);
  FreeAndNil(FtbRichviewEditList);
  FreeAndNil(FtbStringGridList);
  FreeAndNil(FtbButtonList);
  FreeAndNil(FAllList);
  inherited;
end;



function Tof_BaseCustom.getCombobox(aName: string): TCombobox;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FComboboxList.Count - 1 do
  begin
    if SameText(TCombobox(FComboboxList.Items[i1]).Name, aName) then
    begin
      Result := TComboBox(FComboboxList.Items[i1]);
      exit;
    end;
  end;
end;

function Tof_BaseCustom.getCustomEdit(aName: string): TCustomEdit;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FCustomEditFields.Count - 1 do
  begin
    if SameText(TCustomEdit(FCustomEditFields.Items[i1]).Name, aName) then
    begin
      Result := TCustomEdit(FCustomEditFields.Items[i1]);
      exit;
    end;
  end;
end;

function Tof_BaseCustom.getCustomEditText(aName: string): string;
var
  x: TCustomEdit;
begin
  Result := '';
  x := getCustomEdit(aName);
  if x = nil then
    exit;
  Result := x.Text;
end;



function Tof_BaseCustom.getDataFormatAdapter(aName: string): TDataFormatAdapter;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TDataFormatAdapter) then
    begin
      if SameText(aName, TDataFormatAdapter(FAllList.Items[i1]).Name) then
      begin
        Result := TDataFormatAdapter(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;

function Tof_BaseCustom.getDateTimePicker(aName: string): TDateTimePicker;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TDateTimePicker) then
    begin
      if SameText(aName, TDateTimePicker(FAllList.Items[i1]).Name) then
      begin
        Result := TDateTimePicker(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;

function Tof_BaseCustom.getDropFileTarget(aName: string): TDropFileTarget;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TDropFileTarget) then
    begin
      if SameText(aName, TDropFileTarget(FAllList.Items[i1]).Name) then
      begin
        Result := TDropFileTarget(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;

function Tof_BaseCustom.getImage(aName: string): TImage;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TImage) then
    begin
      if SameText(aName, TImage(FAllList.Items[i1]).Name) then
      begin
        Result := TImage(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;


function Tof_BaseCustom.getImageList(aName: string): TImageList;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TImageList) then
    begin
      if SameText(aName, TImageList(FAllList.Items[i1]).Name) then
      begin
        Result := TImageList(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;


function Tof_BaseCustom.getLabel(aName: string): TLabel;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FLabelList.Count - 1 do
  begin
    if SameText(aName, TLabel(FLabelList.Items[i1]).Name) then
    begin
      Result := TLabel(FLabelList.Items[i1]);
      exit;
    end;
  end;
end;

function Tof_BaseCustom.getListbox(aName: string): TListbox;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FListBoxList.Count - 1 do
  begin
    if SameText(aName, TListbox(FListBoxList.Items[i1]).Name) then
    begin
      Result := TListbox(FListBoxList.Items[i1]);
      exit;
    end;
  end;
end;

function Tof_BaseCustom.getMemo(aName: String): TMemo;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TMemo) then
    begin
      if SameText(aName, TMemo(FAllList.Items[i1]).Name) then
      begin
        Result := TMemo(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;

function Tof_BaseCustom.getrve(aName: string): TtbRichviewEdit;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FtbRichviewEditList.Count - 1 do
  begin
    if SameText(aName, TtbRichviewEdit(FtbRichviewEditList.Items[i1]).Name) then
    begin
      Result := TtbRichviewEdit(FtbRichviewEditList.Items[i1]);
      exit;
    end;
  end;
end;

function Tof_BaseCustom.getScrollbox(aName: string): TScrollbox;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TScrollbox) then
    begin
      if SameText(aName, TScrollbox(FAllList.Items[i1]).Name) then
      begin
        Result := TScrollbox(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;

function Tof_BaseCustom.getVirtualStringTree(aName: string): TVirtualStringTree;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TVirtualStringTree) then
    begin
      if SameText(aName, TVirtualStringTree(FAllList.Items[i1]).Name) then
      begin
        Result := TVirtualStringTree(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;

function Tof_BaseCustom.getPanel(aName: string): TPanel;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TPanel) then
    begin
      if SameText(aName, TPanel(FAllList.Items[i1]).Name) then
      begin
        Result := TPanel(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;

function Tof_BaseCustom.getPopUpMenu(aName: string): TPopUpMenu;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TPopUpMenu) then
    begin
      if SameText(aName, TPopUpMenu(FAllList.Items[i1]).Name) then
      begin
        Result := TPopUpMenu(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;

function Tof_BaseCustom.getProgressbar(aName: string): TProgressbar;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TProgressbar) then
    begin
      if SameText(aName, TProgressbar(FAllList.Items[i1]).Name) then
      begin
        Result := TProgressbar(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;



function Tof_BaseCustom.getAdvDirectoryEdit(aName: string): TAdvDirectoryEdit;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TAdvDirectoryEdit) then
    begin
      if SameText(aName, TAdvDirectoryEdit(FAllList.Items[i1]).Name) then
      begin
        Result := TAdvDirectoryEdit(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;


function Tof_BaseCustom.getAdvEditBtn(aName: string): TAdvEditBtn;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TAdvEditBtn) then
    begin
      if SameText(aName, TAdvEditBtn(FAllList.Items[i1]).Name) then
      begin
        Result := TAdvEditBtn(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;

function Tof_BaseCustom.getAdvFileNameEdit(aName: string): TAdvFileNameEdit;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TAdvFileNameEdit) then
    begin
      if SameText(aName, TAdvFileNameEdit(FAllList.Items[i1]).Name) then
      begin
        Result := TAdvFileNameEdit(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;





function Tof_BaseCustom.getSpeedButton(aName: string): TSpeedButton;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FSpeedButtonList.Count - 1 do
  begin
    if SameText(aName, TSpeedbutton(FSpeedButtonList.Items[i1]).Name) then
    begin
      Result := TSpeedbutton(FSpeedButtonList.Items[i1]);
      exit;
    end;
  end;
end;

function Tof_BaseCustom.getSplitter(aName: string): TSplitter;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TSplitter) then
    begin
      if SameText(aName, TSplitter(FAllList.Items[i1]).Name) then
      begin
        Result := TSplitter(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;

function Tof_BaseCustom.gettbButton(aName: string): TTBButton;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FtbButtonList.Count - 1 do
  begin
    if SameText(aName, TTBButton(FtbButtonList.Items[i1]).Name) then
    begin
      Result := TtbButton(FtbButtonList.Items[i1]);
      exit;
    end;
  end;
end;

function Tof_BaseCustom.gettbEditFile(aName: string): TtbEditFile;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TtbEditFile) then
    begin
      if SameText(aName, TtbEditFile(FAllList.Items[i1]).Name) then
      begin
        Result := TtbEditFile(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;

function Tof_BaseCustom.gettbRichViewEdit(aName: string): TtbRichViewEdit;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TtbRichViewEdit) then
    begin
      if SameText(aName, TtbRichViewEdit(FAllList.Items[i1]).Name) then
      begin
        Result := TtbRichViewEdit(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;

function Tof_BaseCustom.gettbStringGrid(aName: string): TtbStringGrid;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FtbStringGridList.Count - 1 do
  begin
    if SameText(aName, TButton(FtbStringGridList.Items[i1]).Name) then
    begin
      Result := TtbStringGrid(FtbStringGridList.Items[i1]);
      exit;
    end;
  end;
end;

function Tof_BaseCustom.gettbToolbar(aName: string): TTbToolbar;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TTbToolbar) then
    begin
      if SameText(aName, TTbToolbar(FAllList.Items[i1]).Name) then
      begin
        Result := TTbToolbar(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;

function Tof_BaseCustom.getCheckbox(aName: string): TCheckBox;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if (TObject(FAllList.Items[i1]) is TCheckBox) then
    begin
      if SameText(aName, TCheckBox(FAllList.Items[i1]).Name) then
      begin
        Result := TCheckbox(FAllList.Items[i1]);
        exit;
      end;
    end;
  end;
end;


function Tof_BaseCustom.getButton(aName: string): TButton;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FButtonList.Count - 1 do
  begin
    if SameText(aName, TButton(FButtonList.Items[i1]).Name) then
    begin
      Result := TButton(FButtonList.Items[i1]);
      exit;
    end;
  end;
end;


function Tof_BaseCustom.getButtonedEdit(aName: string): TButtonedEdit;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if SameText(aName, TButtonedEdit(FAllList.Items[i1]).Name) then
    begin
      Result := TButtonedEdit(FAllList.Items[i1]);
      exit;
    end;
  end;
end;

function Tof_BaseCustom.getEdit(aName: string): TEdit;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if SameText(aName, TEdit(FAllList.Items[i1]).Name) then
    begin
      Result := TEdit(FAllList.Items[i1]);
      exit;
    end;
  end;
end;

function Tof_BaseCustom.gettbRvePopUp(aName: string): TtbRvePopUp;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to FAllList.Count - 1 do
  begin
    if SameText(aName, TtbRvePopUp(FAllList.Items[i1]).Name) then
    begin
      Result := TtbRvePopUp(FAllList.Items[i1]);
      exit;
    end;
  end;
end;




procedure Tof_BaseCustom.setCustomEditText(aName: string; aValue: string);
var
  x: TCustomEdit;
begin
  x := getCustomEdit(aName);
  if x = nil then
    exit;
  x.Text := aValue;
end;


procedure Tof_BaseCustom.setLabelText(aName, aValue: string);
var
  x: TLabel;
begin
  x := getLabel(aName);
  if x = nil then
    exit;
  x.Caption := aValue;
end;

procedure Tof_BaseCustom.setSpeedButtonEnabled(aName: string; aValue: Boolean);
var
  x: TSpeedButton;
begin
  x := getSpeedButton(aName);
  if x = nil then
    exit;
  x.Enabled := aValue;
end;

procedure Tof_BaseCustom.AbleAllCustomEditFields(aValue: Boolean);
var
  i1: Integer;
begin
  for i1 := 0 to FCustomEditFields.Count - 1 do
    TCustomEdit(FCustomEditFields.Items[i1]).Enabled := aValue;
end;

procedure Tof_BaseCustom.ClearAllEditFields;
var
  i1: Integer;
begin
  for i1 := 0 to FCustomEditFields.Count - 1 do
    TCustomEdit(FCustomEditFields.Items[i1]).Text := '';
end;



end.
