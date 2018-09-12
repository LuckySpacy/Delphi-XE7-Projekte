unit o_xmlHighlighter;

interface

uses
  SysUtils, Classes, o_xmlshobj, o_styleObj, o_xmlsh_kommentarnode,
  RVStyle, RVScroll, RichView, RVEdit, o_syntaxhighlighter;

type
  TXMLHighlighter = class
  private
    fxml: TxmlShObj;
    fStyleObjList: TStyleObjList;
  public
    constructor Create(aFilenname: string);
    destructor Destroy; override;
    procedure FontStyleNames(aValue: TStrings);
    procedure setStyleName(aStyleName: string);
    procedure StyleIt(aRv: TRichViewEdit; aStyleName: string);
  end;

implementation

{ TXMLHighlighter }

uses
  rvlinear;

constructor TXMLHighlighter.Create(aFilenname: string);
begin
  fxml := TxmlShObj.Create(aFilenname);
  fStyleObjList := TStyleObjList.Create;
end;

destructor TXMLHighlighter.Destroy;
begin
  FreeAndNil(fxml);
  FreeAndNil(FStyleObjList);
  inherited;
end;

procedure TXMLHighlighter.FontStyleNames(aValue: TStrings);
begin
  Fxml.LadeStyleNames(aValue);
end;

procedure TXMLHighlighter.setStyleName(aStyleName: string);
var
  List: TStringList;
  i1: Integer;
  StyleObj: TStyleObj;
  KommentarNode: TxmlSh_KommentarNode;
begin
  FXML.setStyleName(aStylename);
  List := TStringList.Create;
  try
    FStyleObjList.FontStr := Fxml.XMLStyleNode.FontStr;
    FXML.LadeBereiche(List);
    for i1 := 0 to List.Count -1 do
    begin
      Fxml.XMLStyleNode.setBereich(List.Strings[i1]);
      StyleObj := FStyleObjList.Add;
      StyleObj.FontStr := Fxml.XMLStyleNode.XMLBereichNode.FontStr;
      StyleObj.WortList.Text := Fxml.XMLStyleNode.XMLBereichNode.WortListe;
      StyleObj.WortEndeList.Text := Fxml.XMLStyleNode.XMLBereichNode.WortendeListe;
      StyleObj.WortanfangList.Text := Fxml.XMLStyleNode.XMLBereichNode.WortanfangListe;
      if SameText(List.Strings[i1], 'Klammern') then
        StyleObj.AnfangEndeEgal := true;
    end;
    List.Clear;
    FXML.LadeKommentar(List);
    for i1 := 0 to List.Count -1 do
    begin
      KommentarNode := fxml.XMLStyleNode.XMLKommentarNode(List.Strings[i1]);
      if KommentarNode = nil then
       continue;
      StyleObj := FStyleObjList.Add;
      StyleObj.FontStr := KommentarNode.FontStr;
      StyleObj.Kommandostart := KommentarNode.StartZeichen;
      StyleObj.Kommandoende  := KommentarNode.EndeZeichen;
    end;
  finally
    FreeAndNil(List);
  end;
end;

procedure TXMLHighlighter.StyleIt(aRv: TRichViewEdit; aStyleName: string);
var
  i1, i2, i3: Integer;
  StyleObj: TStyleObj;
  ItemText: string;
  SelLength: Integer;
  StartPos: Integer;
  fi: TFontInfo;
  SyHigh: TSyntaxhighligher;
begin
  setStyleName(aStyleName);

  SyHigh := TSyntaxhighligher.Create(aRv);
  arv.BeginUpdate;
  try
    RVGetSelection(arv, StartPos, SelLength);
    if SelLength < 0 then
    begin
      SelLength := SelLength * -1;
      StartPos := StartPos - SelLength;
    end;

    SyHigh.setStyleForAll(SyHigh.getFontStyleNo(FStyleObjList.FontStr), StartPos, SelLength);

    for i1 := 0 to FStyleObjList.Count -1 do
    begin
      StyleObj := FStyleObjList.Item[i1];
      for i2 := 0 to StyleObj.WortList.Count -1 do
      begin
        if StyleObj.AnfangEndeEgal then
          SyHigh.setStyle(StyleObj.WortList.Strings[i2], SyHigh.getFontStyleNo(StyleObj.FontStr), StartPos, SelLength)
        else
          SyHigh.setStyle(StyleObj.WortList.Strings[i2], SyHigh.getFontStyleNo(StyleObj.FontStr), StartPos, SelLength, StyleObj.WortendeList, StyleObj.WortanfangList);
      end;
    end;


    for i1 := 0 to FStyleObjList.Count -1 do
    begin
      StyleObj := FStyleObjList.Item[i1];
      if StyleObj.Kommandostart > '' then
      begin
        if StyleObj.Kommandoende = '' then
          SyHigh.setRangeStyleSingle(StyleObj.Kommandostart, SyHigh.getFontStyleNo(StyleObj.FontStr), StartPos, SelLength)
        else
          SyHigh.setRangeStyle(StyleObj.Kommandostart, StyleObj.Kommandoende, SyHigh.getFontStyleNo(StyleObj.FontStr), StartPos, SelLength);
      end;
    end;


  finally
    //rv.Style := RVStyle;
    arv.EndUpdate;
    arv.Format;
    arv.SetFocus;
  end;



end;

end.
