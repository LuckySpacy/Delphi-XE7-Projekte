unit o_syntaxhighlighter;

interface

uses
  sysutils, Classes, rvStyle, o_fontobj, vcl.Graphics, RichView, RVEdit;

type
  TSyntaxhighligher = class
  private
    rv: TRichViewedit;
    //FStyle: TRVStyle;
    FFontobj: TFontObj;
    function GetTextLengthFromCurPosInCurLine: Integer;
    procedure GoToEndOfLine(rve: TCustomRichViewEdit);
  public
    constructor Create(ARV: TRichviewedit);
    destructor Destroy; override;
    procedure AddNewStyle(aName: string; aFontStr: string);
    function getFontStyleNo(aFontStr: string): Integer;
    //property RvStyle: TRVStyle read FStyle write FStyle;
    function StyleText(aRTF, aStylename, aWord: string; const aCanvas: TCanvas = nil; aPageWidth: Integer = 800): string;
    procedure MoveCaretToTheBeginning;
    procedure setRangeStyleSingle(aSearchText: string; aStyleNo, aStartPos, aLength: Integer);
    procedure setStyle(aSearchText: string; aStyleNo, aStartPos, aLength: Integer; aWortendeList, aWortanfangList: TStrings); overload;
    procedure setStyle(aSearchText: string; aStyleNo, aStartPos, aLength: Integer); overload;
    procedure setStyleForAll(aStyleNo, aStartPos, aLength: Integer);
    procedure setRangeStyle(aStartText, aEndText: string; aStyleNo, aStartPos, aLength: Integer);
  end;


implementation

{ TSyntaxhighligher }

uses
  rvGetText, Windows, ComCtrls, RVReport, Dialogs,
  crvdata, rvrvdata, rvtypes, rvlinear, rvitem, CRVFData, RVERVData;


constructor TSyntaxhighligher.Create(ARV: TRichviewedit);
begin
  rv := aRV;
  FFontobj := TFontObj.Create;
  //FStyle := TRVStyle.Create(nil);
  //FStyle.TextStyles.Clear;
end;


destructor TSyntaxhighligher.Destroy;
begin
  FreeAndNil(FFontObj);
  //FreeAndNil(FStyle);
  inherited;
end;



procedure TSyntaxhighligher.AddNewStyle(aName, aFontStr: string);
var
  fi: TFontInfo;
begin
  fi := rv.Style.TextStyles.Add;
  fi.StyleName := aName;
  FFontobj.FontStr := aFontStr;
  fi.FontName := FFontObj.Fontname;
  Fi.Color := FFontObj.Color;
  fi.Size  := FFontobj.Size;
  {
  fi.BackColor := clWhite;
  fi.HoverBackColor := clWhite;
  fi.HoverColor := clWhite;
  fi.StyleEx := [];
  fi.UnderlineColor := clWhite;
  fi.Standard:= true;
  }
  fi.Style := [];
  if fsBold in FFontObj.Style then
    fi.Style := fi.Style + [fsBold];
  if fsUnderline in FFontObj.Style then
    fi.Style := fi.Style + [fsUnderline];
  if fsStrikeOut in FFontObj.Style then
    fi.Style := fi.Style + [fsStrikeOut];
  if fsItalic in FFontObj.Style then
    fi.Style := fi.Style + [fsItalic];

end;

function TSyntaxhighligher.getFontStyleNo(aFontStr: string): Integer;
var
  StyleName: string;
  i1: Integer;
begin

  StyleName := aFontStr;

  for i1 := 0 to rv.Style.TextStyles.Count -1 do
  begin
    if rv.Style.TextStyles[i1].StyleName = StyleName then
    begin
      Result := i1;
      exit;
    end;
  end;

  AddNewStyle(aFontStr, aFontStr);
  Result := rv.Style.TextStyles.Count -1;

end;



function TSyntaxhighligher.StyleText(aRTF, aStylename, aWord: string; const aCanvas: TCanvas = nil; aPageWidth: Integer = 800): string;
var
  List: TStringList;
  m   : TMemoryStream;
  rh  : TRvReportHelper;
  rv  : TReportRichView;
begin
  rh    := TRvReportHelper.Create(nil);
  m     := TMemoryStream.Create;
  List  := TStringList.Create;
  try
    rv       := rh.RichView;
    rv.RTFReadProperties.TextStyleMode := rvrsAddIfNeeded;
    rv.RTFReadProperties.ParaStyleMode := rvrsAddIfNeeded;
    rv.RVFOptions := rv.RVFOptions + [rvfoSaveTextStyles];
    rv.RVFOptions := rv.RVFOptions + [rvfoSaveParaStyles];
    //rv.Style := FStyle;

    List.Text := aRTF;
    m.Position := 0;
    List.SaveToStream(m);
    m.Position := 0;
    rv.LoadRTFFromStream(m);

    m.Clear;
    m.Position;
    rv.SaveRTFToStream(m, false);
    m.Position := 0;
    List.LoadFromStream(m);

    Result := List.Text;

  finally
    FreeAndNil(List);
    FreeAndNil(m);
    FreeAndNil(rh);
  end;
end;


procedure TSyntaxhighligher.MoveCaretToTheBeginning;
var
  ItemNo, Offs: Integer;
begin
  if rv = nil then
    exit;
  ItemNo := 0;
  Offs   := rv.GetOffsBeforeItem(ItemNo);
  rv.SetSelectionBounds(ItemNo,Offs,ItemNo,Offs);
end;



procedure TSyntaxhighligher.GoToEndOfLine(rve: TCustomRichViewEdit);
var DItemNo, DOffs, ItemNo, Offs: Integer;
    RVData: TRVEditRVData;
begin
  RVData := TRVEditRVData(rve.TopLevelEditor.RVData);
  DItemNo := RVData.CaretDrawItemNo+1;
  while (DItemNo<RVData.DrawItems.Count) and not RVData.DrawItems[DItemNo].FromNewLine do
    inc(DItemNo);
  dec(DItemNo);
  DOffs := RVData.GetOffsAfterDrawItem(DItemNo);
  RVData.DrawItem2Item(DItemNo, DOffs, ItemNo, Offs);
  RVData.SetSelectionBounds(ItemNo, Offs, ItemNo, Offs);
end;


function TSyntaxhighligher.GetTextLengthFromCurPosInCurLine: Integer;
var
  CurPos: Integer;
  CurPos2: Integer;
  ItemNo: Integer;
  i1: Integer;
  s : string;
begin
  Result := 0;
  CurPos  := RVGetLinearCaretPos(rv);
  GoToEndOfLine(rv);
  CurPos2 := RVGetLinearCaretPos(rv);
  Result := CurPos2 -CurPos;
  RVSetLinearCaretPos(rv, CurPos);
end;


procedure TSyntaxhighligher.setRangeStyleSingle(aSearchText: string; aStyleNo, aStartPos, aLength: Integer);
var
  CurPos: Integer;
  SelLength: Integer;
begin

  while rv.SearchText(aSearchText, [rvseoDown]) do
  begin
    CurPos    := RVGetLinearCaretPos(rv);
    SelLength := GetTextLengthFromCurPosInCurLine;
    if CurPos > aStartPos + aLength then
      break;
    RVSetSelection(rv, CurPos, SelLength);
    rv.ApplyTextStyle(aStyleNo);
  end;

  RVSetSelection(rv, 0,0);
  rv.Format;

end;


procedure TSyntaxhighligher.setStyle(aSearchText: string; aStyleNo, aStartPos, aLength: Integer);
var
  CurPos: Integer;
begin
  try
    while rv.SearchText(aSearchText, [rvseoDown]) do
    begin
      if aLength > 0 then
      begin
        CurPos := RVGetLinearCaretPos(rv);
        if CurPos < aStartPos then
          continue;
        if CurPos > aStartPos + aLength then
          exit;
      end;
      rv.ApplyTextStyle(aStyleNo);
    end;
  finally
    RVSetSelection(rv, 0,0);
    rv.Format;
  end;
end;



procedure TSyntaxhighligher.setStyle(aSearchText: string; aStyleNo, aStartPos, aLength: Integer; aWortendeList, aWortanfangList: TStrings);
var
  CurPos: Integer;
  s: string;
  canChange: Boolean;
  i1: Integer;
  mSelStart: Integer;
  mSelLength: Integer;
  LeftChar: string;
  RightChar: string;
  sText: string;
  RightOk: Boolean;
  LeftOk: Boolean;
begin
  try
    while rv.SearchText(aSearchText, [rvseoDown]) do
    begin
      s := '';
      if aLength > 0 then
      begin
        CurPos := RVGetLinearCaretPos(rv);
        if CurPos < aStartPos then
          continue;
        RVGetSelection(rv, mSelStart, mSelLength);
        s := trim(rv.GetSelText);
        RVSetSelection(rv, mSelStart-1, 1);
        LeftChar := trim(rv.GetSelText);
        RVSetSelection(rv, mSelStart+mSelLength, 1);
        RightChar := trim(rv.GetSelText);
        RVSetSelection(rv, mSelStart, mSelLength);

        {
        if aWortendeList.Count > 0 then
        begin
          RVSetSelection(rv, mSelStart-1, mSelLength + 2);
          s := Trim(rv.GetSelText);
          RVSetSelection(rv, mSelStart, mSelLength);
        end
        else
        begin
          RVSetSelection(rv, mSelStart-1, mSelLength+1);
          s := Trim(rv.GetSelText);
          RVSetSelection(rv, mSelStart, mSelLength);
        end;
        }
        if CurPos > aStartPos + aLength then
          exit;
      end;
      canChange := false;
      RightOk := false;
      LeftOk  := false;
      sText := Trim(LeftChar+s+RightChar);
      if SameText(aSearchtext, sText) then
        canChange := true;

      if not canChange then
      begin
        if RightChar = '' then
          RightOk := true;

        sText := s + RightChar;
        for i1 := 0 to aWortendeList.Count -1 do
        begin
          if SameText(aSearchtext + aWortendeList.Strings[i1], sText) then
            RightOk := true;
          if RightOk then
            break;
        end;

        if aWortendeList.Count = 0 then
          RightOk := true;


        if LeftChar = '' then
          LeftOk := true;

        sText := LeftChar + s;

        for i1 := 0 to aWortanfangList.Count -1 do
        begin
          if SameText(aWortanfangList.Strings[i1] + aSearchtext, sText) then
            LeftOk := true;
          if LeftOk then
            break;
        end;

        if aWortanfangList.Count = 0 then
          LeftOk := true;

        if (aWortendeList.Count > 0) or (aWortanfangList.Count > 0) then
          canChange := RightOk and LeftOk;

      end;


      if canChange then
        rv.ApplyTextStyle(aStyleNo);
    end;
  finally
    RVSetSelection(rv, 0,0);
    rv.Format;
  end;
end;


procedure TSyntaxhighligher.setStyleForAll(aStyleNo, aStartPos, aLength: Integer);
begin
  if aLength = 0 then
    rv.SelectAll
  else
    RVSetSelection(rv, aStartPos, aLength);
  rv.ApplyTextStyle(aStyleNo);
  rv.ApplyParaStyle(0);
  RVSetSelection(rv, 0,0);
  rv.Format;
end;


procedure TSyntaxhighligher.setRangeStyle(aStartText, aEndText: string; aStyleNo, aStartPos, aLength: Integer);
var
  StartPos: Integer;
  EndPos: Integer;
  SelLength: Integer;
  BereichVon: Integer;
  BereichEnde: Integer;
begin
  try
    EndPos := 0;
    BereichVon := aStartPos;
    BereichEnde := aStartPos + aLength;
    while rv.SearchText(aStartText, [rvseoDown]) do
    begin
      StartPos := RVGetLinearCaretPos(rv);
      if StartPos <= EndPos then
        continue;
      if StartPos < BereichVon then
        continue;
      EndPos   := 0;
      if rv.SearchText(aEndText, [rvseoDown]) then
        EndPos := RVGetLinearCaretPos(rv);

      if StartPos > BereichEnde then
        break;


      if EndPos > StartPos then
      begin
        SelLength := EndPos - StartPos -1;
        RVSetSelection(rv, StartPos, SelLength);
        rv.ApplyTextStyle(aStyleNo);
      end;
    end;
  finally
    RVSetSelection(rv, 0,0);
    rv.Format;
  end;


end;










end.
