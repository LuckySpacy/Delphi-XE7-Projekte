unit o_richvieweditobj;

interface

uses
  SysUtils, Classes, RVScroll, RichView, RVEdit, RVStyle, Forms, controls,
  Graphics;

type
  RStyleId = Record
    Text: Integer;
    Para: Integer;
  End;  

type
  TRichViewEditObj = class(TObject)
  private
    _Edit: TRichViewEdit;
    _StandardTextStyleNo: Integer;
    _StandardTextParaNo: Integer;
  public
    constructor Create(aEditor: TRichViewEdit); reintroduce;
    destructor Destroy; override;
    function HtmlAsString(aEmbeddedPictureList: TStrings): string;
    function RTFAsString: string;
    function AsString: string;
    procedure SetRTF(aValue: string);
    procedure InsertRTF(aValue: string);
    procedure MoveCaretToTheEnd;
    procedure MoveCaretToTheBeginning;
    function  GetTextStyleId(aStyleName: string; const aDefaultValueIfNotFound: Integer = -1): Integer;
    function  GetParaStyleId(aStyleName: string; const aDefaultValueIfNotFound: Integer = -1): Integer;
    procedure SelectText(aStartRow, aPosInStartRow, aEndRow, aPosInEndRow: Integer);
    function  SelectTextTillEnd(aSearchText: string): Boolean;
    procedure DeleteTextTillEnd(aSearchText: string);
    procedure TextPos(aSearchText: string; var aLine, aPosInLine: Integer);
    function isRTFText(aValue: string): Boolean;
    function AddTextStyle(aStylename, aFontname: string; aFontsize: integer): TFontinfo;
    function AddParaStyle(aStylename: string; Alignment: TRvAlignment): TParaInfo;
    function EmptyText: Boolean;
    property Edit: TRichViewEdit read _Edit write _Edit;
    procedure Clear(const aTextStyleNo: Integer = -1; const aParaStyleNo: Integer = -1);
    property StandardTextStyleNo: Integer read _StandardTextStyleNo write _StandardTextStyleNo;
    property StandardParaStyleNo: Integer read _StandardTextParaNo write _StandardTextParaNo;
    procedure SetStandardTextStyle;
    function GetParentForm: TForm;
    function GetFocusedControl: TWinControl;
    class function InsertTextNL(aText, aNewText: string): string;
    class function RTFEmpty(aRTFString: string): Boolean;
    class function Plaintext(aRTFString: string): string;
    class procedure FontFirstSign(aRTFString: string; aFont: TFont; var aAlignment: TAlignment);
    class function MergeRTF(aRTFString1, aRTFString2: string): string;
    class function RTFReplace(aValue, aOldPattern, aNewPattern: string; aFlags: TReplaceFlags): string;
  end;


implementation

{ TRichViewEditObj }

uses
  o_nf, rvGetText, Windows, ComCtrls, RVReport;

constructor TRichViewEditObj.Create(aEditor: TRichViewEdit);
begin
  inherited Create;
  _Edit := aEditor;
  _StandardTextStyleNo := 0;
  _StandardTextParaNo  := 0;
end;


destructor TRichViewEditObj.Destroy;
begin

  inherited;
end;



function TRichViewEditObj.AddParaStyle(aStylename: string;
  Alignment: TRvAlignment): TParaInfo;
begin
  Result := _Edit.Style.ParaStyles.Add;
  Result.StyleName := aStylename;
  Result.Alignment := Alignment;
end;

function TRichViewEditObj.AddTextStyle(aStylename, aFontname: string;
  aFontsize: integer): TFontinfo;
begin
  Result := _Edit.Style.TextStyles.Add;
  Result.StyleName := aStylename;
  Result.FontName  := aFontname;
  Result.Size      := aFontsize;
end;

function TRichViewEditObj.AsString: string;
//var
//  i1: Integer;
begin
  Result := GetAllText(_Edit);
{
  Result := '';
  for i1 := 0 to _Edit.ItemCount - 1 do
    Result := Result + Trim(_Edit.GetItemTextA(i1));
  Result := Trim(Result);
  }
end;

procedure TRichViewEditObj.Clear(const aTextStyleNo: Integer = -1; const aParaStyleNo: Integer = -1);
begin
  _Edit.Clear;
  if aTextStyleNo > -1 then
    _Edit.CurParaStyleNo := aParaStyleNo;
  if aParaStyleNo > -1 then
    _Edit.CurTextStyleNo := aTextStyleNo;
  if aTextStyleNo = -1 then
    _Edit.CurTextStyleNo := _StandardTextStyleNo;
  if aParaStyleNo = -1 then
    _Edit.CurParaStyleNo := _StandardTextParaNo;
end;


procedure TRichViewEditObj.DeleteTextTillEnd(aSearchText: string);
begin
  if SelectTextTillEnd(aSearchText) then
    _Edit.InsertText('');
end;


function TRichViewEditObj.EmptyText: Boolean;
begin
  Result := AsString = '';
end;



function TRichViewEditObj.GetParaStyleId(aStyleName: string;
  const aDefaultValueIfNotFound: Integer): Integer;
var
  i1: Integer;
begin
  Result := aDefaultValueIfNotFound;
  if not Assigned(_Edit.Style) then
    exit;
  for i1 := 0 to _Edit.Style.ParaStyles.Count -1 do
  begin
    if SameText(aStyleName, _Edit.Style.ParaStyles[i1].StyleName) then
    begin
      Result := i1;
      exit;
    end;
  end;
end;


function TRichViewEditObj.GetParentForm: TForm;
var
  wParent: TWinControl;
  bCancel: Boolean;
begin
  Result := nil;
  wParent := _Edit.Parent;
  if not Assigned(wParent) then
    exit;
  bCancel := false;
  while not bCancel do
  begin
    if not Assigned(wParent) then
      exit;
    if wParent is TForm then
    begin
      Result := TForm(wParent);
      exit;
    end;
    wParent := wParent.Parent;
  end;
end;

function TRichViewEditObj.GetFocusedControl: TWinControl;
var
  Form: TForm;
begin
  Result := nil;
  Form := GetParentForm;
  if not Assigned(Form) then
    exit;
  if not Form.Visible then
    exit;
  Result := Form.ActiveControl;
end;


function TRichViewEditObj.GetTextStyleId(aStyleName: string;
  const aDefaultValueIfNotFound: Integer): Integer;
var
  i1: Integer;
begin
  Result := aDefaultValueIfNotFound;
  if not Assigned(_Edit.Style) then
    exit;
  for i1 := 0 to _Edit.Style.TextStyles.Count -1 do
  begin
    if SameText(aStyleName, _Edit.Style.TextStyles[i1].StyleName) then
    begin
      Result := i1;
      exit;
    end;
  end;
end;

function TRichViewEditObj.HtmlAsString(aEmbeddedPictureList: TStrings): string;
var
  Stream : TMemoryStream;
  List   : TStringList;
  Options: TRVSaveOptions;
  i1     : integer;
begin
  Result := '';
  if Assigned(aEmbeddedPictureList) then
    aEmbeddedPictureList.Clear;

  List := TStringList.Create;
  Stream := TMemoryStream.Create;
  try
    Options := [rvsoOverrideImages, rvsoNoHypertextImageBorders, rvsoImageSizes, rvsoUseCheckpointsNames];
    if Assigned(aEmbeddedPictureList) then
    begin
      Tnf.GetInstance.System.GetAllFiles(Tnf.GetInstance.System.GetTempPath, aEmbeddedPictureList, true, false, 'optima_pic*.jpg');
      for i1 := 0 to aEmbeddedPictureList.Count - 1 do
        SysUtils.DeleteFile(aEmbeddedPictureList.Strings[i1]);
       aEmbeddedPictureList.Clear;
    end;
    _Edit.SaveHTMLToStreamEx(Stream, Tnf.GetInstance.System.GetTempPath, '', 'optima_pic', '', '', '', Options);
    Stream.Position := 0;
    List.LoadFromStream(Stream);
    if Assigned(aEmbeddedPictureList) then
      Tnf.GetInstance.System.GetAllFiles(Tnf.GetInstance.System.GetTempPath, aEmbeddedPictureList, true, false, 'optima_pic*.jpg');
    Result := List.Text;
  finally
    FreeAndNil(Stream);
    FreeAndNil(List);
  end;
end;

procedure TRichViewEditObj.InsertRTF(aValue: string);
var
  List: TStringList;
  m   : TMemoryStream;
begin
  if not isRTFText(aValue) then
  begin
    _Edit.InsertText(aValue);
    exit;
  end;  
  List := TStringList.Create;
  m    := TMemoryStream.Create;
  try
    List.Text := aValue;
    List.SaveToStream(m);
    m.Position := 0;
    _Edit.InsertRTFFromStreamEd(m);
  finally
    FreeAndNil(List);
    FreeAndNil(m);
  end;
  _Edit.Format;
end;


function TRichViewEditObj.isRTFText(aValue: string): Boolean;
begin
  Result := Pos('{\rtf1\', aValue) > 0;
end;

procedure TRichViewEditObj.MoveCaretToTheBeginning;
var
  ItemNo, Offs: Integer;
begin
  ItemNo := 0;
  Offs   := _Edit.GetOffsBeforeItem(ItemNo);
  _Edit.SetSelectionBounds(ItemNo,Offs,ItemNo,Offs);
end;

procedure TRichViewEditObj.MoveCaretToTheEnd;
var
  ItemNo, Offs: Integer;
begin
  ItemNo := _Edit.ItemCount-1;
  Offs   := _Edit.GetOffsAfterItem(ItemNo);
  _Edit.SetSelectionBounds(ItemNo,Offs,ItemNo,Offs);
end;


function TRichViewEditObj.RTFAsString: string;
var
  Stream: TMemoryStream;
  List: TStringList;
begin
  List := TStringList.Create;
  Stream := TMemoryStream.Create;
  try
    _Edit.SaveRTFToStream(Stream, false);
    Stream.Position := 0;
    List.LoadFromStream(Stream);
    Result := List.Text;
  finally
    FreeAndNil(Stream);
    FreeAndNil(List);
  end;
end;


procedure TRichViewEditObj.SelectText(aStartRow, aPosInStartRow, aEndRow,
  aPosInEndRow: Integer);
begin
  _Edit.SetSelectionBounds(aStartRow, aPosInStartRow, aEndRow, aPosInEndRow);
end;

function TRichViewEditObj.SelectTextTillEnd(aSearchText: string): Boolean;
var
  StartRow: Integer;
  PosInStartRow: Integer;
  EndRow: Integer;
  PosInEndRow: Integer;
begin
  Result := false;
  MoveCaretToTheBeginning;
  if not _Edit.SearchText(aSearchText, [rvseoDown]) then
    exit;
  StartRow      := _Edit.CurItemNo;
  PosInStartRow := Pos(aSearchText, _Edit.GetItemText(_Edit.CurItemNo));
  EndRow        := _Edit.ItemCount-1;
  PosInEndRow   := Length(_Edit.GetItemText(_Edit.ItemCount-1)) + 1;
  SelectText(StartRow, PosInStartRow, EndRow, PosInEndRow);
  Result := _Edit.GetSelText > '';
end;

procedure TRichViewEditObj.SetRTF(aValue: string);
var
  strList: TStringList;
  m   : TMemoryStream;
  ro  : Boolean;
  FocusedControl: TWinControl;
begin
  FocusedControl := GetFocusedControl;
  ro := _Edit.ReadOnly;
  try
    _Edit.ReadOnly := false;
    Clear(_Edit.CurTextStyleNo, _Edit.CurParaStyleNo);
    if aValue = '' then
      exit;
    if Pos('{\rtf1\', aValue) <= 0 then
    begin
      _Edit.InsertText(aValue);
      MoveCaretToTheBeginning;
      exit;
    end;

    strList := TStringList.Create;
    m    := TMemoryStream.Create;
    try
      strList.Text := aValue;
      strList.SaveToStream(m);
      m.Position := 0;
      _Edit.LoadRTFFromStream(m);
    finally
      FreeAndNil(strList);
      FreeAndNil(m);
    end;
    _Edit.Format;
    MoveCaretToTheBeginning;
  finally
    _Edit.ReadOnly := ro;
    if Assigned(FocusedControl) then
    begin
      if FocusedControl.CanFocus then
      begin
        try
          FocusedControl.SetFocus;
        except
        end;
      end;
    end;
  end;
end;

procedure TRichViewEditObj.SetStandardTextStyle;
begin
  _Edit.CurTextStyleNo := _StandardTextStyleNo;
  _Edit.CurParaStyleNo := _StandardTextParaNo;
end;


procedure TRichViewEditObj.TextPos(aSearchText: string; var aLine,
  aPosInLine: Integer);
begin
  aLine      := 0;
  aPosInLine := 0;
  try
    MoveCaretToTheBeginning;
  except
    exit;
  end;
  if not _Edit.SearchText(aSearchText, [rvseoDown]) then
    exit;

  aLine      := _Edit.CurItemNo;
  aPosInLine := Pos(aSearchText, _Edit.GetItemText(_Edit.CurItemNo));

end;





class function TRichViewEditObj.InsertTextNL(aText, aNewText: string): string;
var
  Form: TForm;
  Style: TRvStyle;
  rv   : TRichViewEdit;
  ro   : TRichViewEditObj;
begin
  Result := aText;
  Form := TForm.Create(nil);
  Style := TRvStyle.Create(nil);
  rv    := TRichViewEdit.Create(Form);
  ro    := TRichViewEditObj.Create(rv);
  try
    rv.Parent := Form;
    rv.Style := Style;
    ro.SetRTF(aText);
    if not ro.EmptyText then
    begin
      ro.MoveCaretToTheEnd;
      rv.InsertText(#13#10 + aNewText);
    end
    else
      rv.InsertText(aNewText);
    Result := ro.RTFAsString;
  finally
    FreeAndNil(ro);
    FreeAndNil(rv);
    FreeAndNil(Style);
    FreeAndNil(Form);
  end;
end;





class function TRichViewEditObj.RTFEmpty(aRTFString: string): Boolean;
var
  Form: TForm;
  Style: TRvStyle;
  rv   : TRichViewEdit;
  ro   : TRichViewEditObj;
begin
  Form := TForm.Create(nil);
  Style := TRvStyle.Create(nil);
  rv    := TRichViewEdit.Create(Form);
  ro    := TRichViewEditObj.Create(rv);
  try
    rv.Parent := Form;
    rv.Style := Style;
    ro.SetRTF(aRTFString);
    Result := Trim(ro.AsString) = '';
  finally
    FreeAndNil(ro);
    FreeAndNil(rv);
    FreeAndNil(Style);
    FreeAndNil(Form);
  end;
end;

class function TRichViewEditObj.Plaintext(aRTFString: string): string;
var
  Form: TForm;
  Style: TRvStyle;
  rv   : TRichViewEdit;
  ro   : TRichViewEditObj;
begin
  Form := TForm.Create(nil);
  Style := TRvStyle.Create(nil);
  rv    := TRichViewEdit.Create(Form);
  ro    := TRichViewEditObj.Create(rv);
  try
    rv.Parent := Form;
    rv.Style := Style;
    ro.SetRTF(aRTFString);
    Result := ro.AsString;
  finally
    FreeAndNil(ro);
    FreeAndNil(rv);
    FreeAndNil(Style);
    FreeAndNil(Form);
  end;
end;



class procedure TRichViewEditObj.FontFirstSign(aRTFString: string; aFont: TFont; var aAlignment: TAlignment);
var
  Form : TForm;
  rv   : TRichEdit;
  strList: TStringList;
  m      : TMemoryStream;
begin
  Form := TForm.Create(nil);
  rv   := TRichEdit.Create(Form);
  strList := TStringList.Create;
  m        := TMemoryStream.Create;
  rv.Parent := Form;
  try
    strList.Text := aRTFString;
    strList.SaveToStream(m);
    m.Position := 0;
    rv.Lines.LoadFromStream(m);
    rv.SelStart  := 1;
    rv.SelLength := 2;
    aFont.Name  := rv.SelAttributes.Name;
    aFont.Size  := rv.SelAttributes.Size;
    aFont.Color := rv.SelAttributes.Color;
    aFont.Style := rv.SelAttributes.Style;
    aAlignment  := rv.Paragraph.Alignment;
  finally
    FreeAndNil(strList);
    FreeAndNil(m);
    FreeAndNil(rv);
    FreeAndNil(Form);
  end;
end;


class function TRichViewEditObj.MergeRTF(aRTFString1, aRTFString2: string): string;
var
  List: TStringList;
  m   : TMemoryStream;
  rh  : TRvReportHelper;
  rv  : TReportRichView;
  Style: TRvStyle;
begin
  rh    := TRvReportHelper.Create(nil);
  List  := TStringList.Create;
  m     := TMemoryStream.Create;
  Style := TRvStyle.Create(nil);
  try
    rv       := rh.RichView;
    rv.RTFReadProperties.TextStyleMode := rvrsAddIfNeeded;
    rv.RTFReadProperties.ParaStyleMode := rvrsAddIfNeeded;
    rv.RVFOptions := rv.RVFOptions + [rvfoSaveTextStyles];
    rv.RVFOptions := rv.RVFOptions + [rvfoSaveParaStyles];
    rv.Style := Style;

    // Load RTFString1
    List.Text := aRTFString1;
    m.Position := 0;
    List.SaveToStream(m);
    m.Position := 0;
    rv.LoadRTFFromStream(m);


    // Load RTFString2
    List.Text := aRTFString2;
    m.Clear;
    m.Position := 0;
    List.SaveToStream(m);
    m.Position := 0;
    rv.LoadRTFFromStream(m);

    // New RTFString
    m.Position := 0;
    rv.SaveRTFToStream(m, false);
    m.Position := 0;
    List.LoadFromStream(m);
    Result := List.Text;

  finally
    FreeAndNil(List);
    FreeAndNil(m);
    FreeAndNil(Style);
    FreeAndNil(rh);
  end;
end;


class function TRichViewEditObj.RTFReplace(aValue, aOldPattern, aNewPattern: string; aFlags: TReplaceFlags): string;
var
  List: TStringList;
  m   : TMemoryStream;
  rh  : TRvReportHelper;
  rv  : TReportRichView;
  Style: TRvStyle;
  Line: Integer;
  PosInLine: Integer;
  i1: Integer;
  s: string;
  iPos: Integer;
begin
  rh    := TRvReportHelper.Create(nil);
  List  := TStringList.Create;
  m     := TMemoryStream.Create;
  Style := TRvStyle.Create(nil);
  try
    rh.RichView.RTFReadProperties.TextStyleMode := rvrsAddIfNeeded;
    rh.RichView.RTFReadProperties.ParaStyleMode := rvrsAddIfNeeded;
    rh.RichView.RVFOptions := rh.RichView.RVFOptions + [rvfoSaveTextStyles];
    rh.RichView.RVFOptions := rh.RichView.RVFOptions + [rvfoSaveParaStyles];
    rv       := rh.RichView;
    rv.Style := Style;

    // Load RTFString1
    List.Text := aValue;
    m.Position := 0;
    List.SaveToStream(m);
    m.Position := 0;
    rv.LoadRTFFromStream(m);

    for i1 := 0 to rv.ItemCount - 1 do
    begin
      s := rv.GetItemText(i1);
      iPos := Pos(aOldPattern, s);
      if iPos > 0 then
      begin
        s := StringReplace(s, aOldPattern, aNewPattern, aFlags);
        rv.SetItemText(i1, s);
        if not (rfReplaceAll in aFlags) then
          break;
      end;
    end;

    // New RTFString
    m.Position := 0;
    rv.SaveRTFToStream(m, false);
    m.Position := 0;
    List.LoadFromStream(m);
    Result := List.Text;

  finally
    FreeAndNil(List);
    FreeAndNil(m);
    FreeAndNil(Style);
    FreeAndNil(rh);
  end;

end;




end.
