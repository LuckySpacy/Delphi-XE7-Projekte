unit fnt_SyntaxHighlighter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RVStyle, RVScroll, RichView, RVEdit,
  Vcl.Buttons, Vcl.ExtCtrls, o_xmlshobj, o_syntaxhighlighter, o_styleObj;

type
  Tfrm_SyntaxHighlighter = class(TForm)
    pnl_Top: TPanel;
    btn_Testen: TSpeedButton;
    Panel1: TPanel;
    rv: TRichViewEdit;
    RVStyle: TRVStyle;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_TestenClick(Sender: TObject);
  private
    FPath: string;
    FTestTextFilename: string;
    Fxml: TxmlShObj;
    FSyHigh: TSyntaxhighligher;
    FStyleObjList: TStyleObjList;
  public
    procedure LoadXML(aFilename: string);
    procedure setStyleName(aStyleName: string);
  end;

var
  frm_SyntaxHighlighter: Tfrm_SyntaxHighlighter;

implementation

{$R *.dfm}

uses
  o_xmlsh_KommentarNode, rvlinear, u_system, c_AllgTypes;


procedure Tfrm_SyntaxHighlighter.FormCreate(Sender: TObject);
begin
  //FPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  FPath := IncludeTrailingPathDelimiter(GetShellFolder(cCSIDL_APPDATA)) + 'SyntaxHighlighter\';
  FTestTextFilename := FPath + 'TestText.rtf';
  Fxml := nil;
  FSyHigh := TSyntaxhighligher.Create(rv);
  FStyleObjList := TStyleObjList.Create;
end;

procedure Tfrm_SyntaxHighlighter.FormDestroy(Sender: TObject);
begin  //
  if FXML <> nil then
    FreeAndNil(FXML);
  FreeAndNil(FSyHigh);
  FreeAndNil(FStyleObjList);
end;

procedure Tfrm_SyntaxHighlighter.FormShow(Sender: TObject);
begin
  if FileExists(FTestTextFilename) then
  begin
    rv.Clear;
    rv.LoadRTF(FTestTextFilename);
    rv.Format;
   // FSyHigh.StyleText()
  end;
end;

procedure Tfrm_SyntaxHighlighter.LoadXML(aFilename: string);
var
  i1: Integer;
  Liste: TStringList;
begin
  if FXML <> nil then
    FreeAndNil(FXML);
  FXML := TxmlShObj.Create(aFilename);
  Liste := TStringList.Create;
  try
    FXML.LadeBereiche(Liste);
    for i1 := 0 to Liste.Count -1 do
    begin
      FXML.XMLStyleNode.setBereich(Liste.Strings[i1]);
    end;
  finally
    FreeAndNil(Liste);
  end;
end;

procedure Tfrm_SyntaxHighlighter.setStyleName(aStyleName: string);
var
  List: TStringList;
  i1: Integer;
  StyleObj: TStyleObj;
  KommentarNode: TxmlSh_KommentarNode;
begin
  if FXML = nil then
  begin
    ShowMessage('Bitte erst LoadXML aufrufen');
    exit;
  end;
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
    {
    FSyHigh.AddNewStyle('Default', FStyleObjList.FontStr);
    for i1 := 0 to FStyleObjList.Count -1 do
      FSyHigh.AddNewStyle(IntToStr(i1+1), FStyleObjList.Item[i1].FontStr);
      }
  finally
    FreeAndNil(List);
  end;
end;

procedure Tfrm_SyntaxHighlighter.btn_TestenClick(Sender: TObject);
var
  i1, i2, i3: Integer;
  StyleObj: TStyleObj;
  ItemText: string;
  SelLength: Integer;
  StartPos: Integer;
  fi: TFontInfo;
begin
  //rv.Style := FSyHigh.RvStyle;

  rv.BeginUpdate;
  try
    RVGetSelection(rv, StartPos, SelLength);
    if SelLength < 0 then
    begin
      SelLength := SelLength * -1;
      StartPos := StartPos - SelLength;
    end;


    //FSyHigh.setStyleForAll(0, StartPos, SelLength);
    {
    fi := FSyHigh.RvStyle.TextStyles[4];
    if fsUnderline in fi.Style then
      exit;
      }
    FSyHigh.setStyleForAll(FSyHigh.getFontStyleNo(FStyleObjList.FontStr), StartPos, SelLength);

    {
    for i1 := 0 to FStyleObjList.Count -1 do
    begin
      StyleObj := FStyleObjList.Item[i1];
      for i2 := 0 to StyleObj.WortList.Count -1 do
      begin
        if StyleObj.AnfangEndeEgal then
          FSyHigh.setStyle(StyleObj.WortList.Strings[i2], i1+1, StartPos, SelLength)
        else
          FSyHigh.setStyle(StyleObj.WortList.Strings[i2], i1+1, StartPos, SelLength, StyleObj.WortendeList, StyleObj.WortanfangList);
      end;
    end;
     }

    for i1 := 0 to FStyleObjList.Count -1 do
    begin
      StyleObj := FStyleObjList.Item[i1];
      for i2 := 0 to StyleObj.WortList.Count -1 do
      begin
        if StyleObj.AnfangEndeEgal then
          FSyHigh.setStyle(StyleObj.WortList.Strings[i2], FSyHigh.getFontStyleNo(StyleObj.FontStr), StartPos, SelLength)
        else
          FSyHigh.setStyle(StyleObj.WortList.Strings[i2], FSyHigh.getFontStyleNo(StyleObj.FontStr), StartPos, SelLength, StyleObj.WortendeList, StyleObj.WortanfangList);
      end;
    end;


    for i1 := 0 to FStyleObjList.Count -1 do
    begin
      StyleObj := FStyleObjList.Item[i1];
      if StyleObj.Kommandostart > '' then
      begin
        if StyleObj.Kommandoende = '' then
          FSyHigh.setRangeStyleSingle(StyleObj.Kommandostart, FSyHigh.getFontStyleNo(StyleObj.FontStr), StartPos, SelLength)
        else
          FSyHigh.setRangeStyle(StyleObj.Kommandostart, StyleObj.Kommandoende, FSyHigh.getFontStyleNo(StyleObj.FontStr), StartPos, SelLength);
      end;
    end;


  finally
    //rv.Style := RVStyle;
    rv.EndUpdate;
    rv.Format;
    rv.SetFocus;
  end;
end;

procedure Tfrm_SyntaxHighlighter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  rv.SaveRTF(FTestTextFilename, false);
end;


end.
