unit fnt_SyntaxHighlighterConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, o_fontobj,
  o_xmlshobj;

type
  Tfrm_SyntaxHighlighterConfig = class(TForm)
    pnl_Top: TPanel;
    pnl_Bottom: TPanel;
    pnl_fontstyle: TPanel;
    pnl_fontstyletop: TPanel;
    pnl_fontstylebutton: TPanel;
    btn_Neu_Fontstyle: TButton;
    btn_Edit_Fontstyle: TButton;
    lsb_Fontstyles: TListBox;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    btn_Up: TSpeedButton;
    btn_Down: TSpeedButton;
    btn_Neu_Kommentar: TButton;
    btn_Del_Kommentar: TButton;
    lsb_Kommentar: TListBox;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    btn_Neu_Bereich: TButton;
    btn_Edit_Bereich: TButton;
    btn_Del_Bereich: TButton;
    lsb_Bereich: TListBox;
    Panel3: TPanel;
    Panel7: TPanel;
    mem_Wortliste: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    mem_Wortendezeichen: TMemo;
    btn_Edit_Kommentar: TButton;
    btn_del_Fontstyle: TButton;
    btn_Testen: TSpeedButton;
    Panel11: TPanel;
    Panel12: TPanel;
    mem_Wortanfangzeichen: TMemo;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    btn_Cancel: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lsb_FontstylesClick(Sender: TObject);
    procedure lsb_BereichClick(Sender: TObject);
    procedure mem_WortlisteExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mem_WortendezeichenExit(Sender: TObject);
    procedure btn_Edit_FontstyleClick(Sender: TObject);
    procedure btn_Neu_KommentarClick(Sender: TObject);
    procedure btn_UpClick(Sender: TObject);
    procedure btn_DownClick(Sender: TObject);
    procedure btn_Del_KommentarClick(Sender: TObject);
    procedure btn_Neu_BereichClick(Sender: TObject);
    procedure btn_Del_BereichClick(Sender: TObject);
    procedure btn_Edit_BereichClick(Sender: TObject);
    procedure btn_Edit_KommentarClick(Sender: TObject);
    procedure btn_Neu_FontstyleClick(Sender: TObject);
    procedure btn_del_FontstyleClick(Sender: TObject);
    procedure btn_TestenClick(Sender: TObject);
    procedure mem_WortanfangzeichenExit(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
  private
    Fxml: TxmlShObj;
    FXMLFile: string;
    FPath: string;
    fCancel: Boolean;
    procedure LadeBereiche;
    procedure LadeKommentar;
    procedure ShowHighlighter;
    function getXMLStream: string;
  public
    property XMLFile: string read fXMLFile;
    property XMLStream: string read getXMLStream;
    property Cancel: Boolean read fCancel;
  end;

var
  frm_SyntaxHighlighterConfig: Tfrm_SyntaxHighlighterConfig;

implementation

{$R *.dfm}

uses
  fnt_SyntaxHighlighterEdit, fnt_Kommentar, o_xmlsh_kommentarnode, o_xmlsh_stylenamenode,
  fnt_SyntaxHighlighter, u_system, c_AllgTypes;



procedure Tfrm_SyntaxHighlighterConfig.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Fxml.save;
end;

procedure Tfrm_SyntaxHighlighterConfig.FormCreate(Sender: TObject);
begin
  fCancel := false;
  mem_Wortliste.Clear;
  mem_Wortendezeichen.Clear;
  mem_Wortanfangzeichen.Clear;
  FPath := IncludeTrailingPathDelimiter(GetShellFolder(cCSIDL_APPDATA)) + 'SyntaxHighlighter\';
  if not DirectoryExists(FPath) then
    ForceDirectories(FPath);
  FXMLFile := FPath + 'syntaxhighlighter.xml';
  Fxml := TxmlShObj.Create(FXMLFile);
end;

procedure Tfrm_SyntaxHighlighterConfig.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(Fxml);
end;

procedure Tfrm_SyntaxHighlighterConfig.FormShow(Sender: TObject);
begin
  Fxml.LadeStyleNames(lsb_Fontstyles.Items);
end;


function Tfrm_SyntaxHighlighterConfig.getXMLStream: string;
begin
  Result :=  Fxml.savetostream;
end;

procedure Tfrm_SyntaxHighlighterConfig.btn_Edit_BereichClick(Sender: TObject);
var
  Form: Tfrm_SyntaxHighlighterEdit;
begin
  if lsb_Fontstyles.ItemIndex < 0 then
  begin
    ShowMessage('Bitte erst einen Fontstyle auswählen');
    exit;
  end;
  Form := Tfrm_SyntaxHighlighterEdit.Create(nil);
  try
    Form.Label1.Caption := 'Bereichname:';
    Form.setFontStr(fxml.XMLStyleNode.XMLBereichNode.FontStr);
    Form.edt.Text := fxml.XMLStyleNode.XMLBereichNode.Bereichname;
    Form.cbx_OhneWortende.Checked := not fxml.XMLStyleNode.XMLBereichNode.WortendeBeachten;
    Form.ShowModal;
    if Form.Cancel then
      exit;
    fxml.XMLStyleNode.XMLBereichNode.Bereichname := Form.edt.Text;
    fxml.XMLStyleNode.XMLBereichNode.FontStr := Form.FontStr;
    fxml.XMLStyleNode.XMLBereichNode.WortendeBeachten := not Form.cbx_OhneWortende.Checked;
  finally
    FreeAndNil(Form);
  end;
  LadeBereiche;
end;

procedure Tfrm_SyntaxHighlighterConfig.btn_Edit_FontstyleClick(Sender: TObject);
var
  Form: Tfrm_SyntaxHighlighterEdit;
begin
  if lsb_Fontstyles.ItemIndex < 0 then
  begin
    ShowMessage('Bitte erst einen Fontstyle auswählen');
    exit;
  end;

  Form := Tfrm_SyntaxHighlighterEdit.Create(nil);
  try
    Form.Label1.Caption := 'Fontstylename:';
    Form.rb_Links.Checked := true;
    Form.SelectFont('Arial');
    Form.edt_Size.Value := 8;
    Form.edt.Text := FXML.XMLStyleNode.Stylename;
    Form.setFontStr(FXML.XMLStyleNode.FontStr);
    Form.cbx_OhneWortende.Visible := false;
    Form.ShowModal;
    if Form.Cancel then
      exit;
    fxml.XMLStyleNode.FontStr := Form.FontStr;
    fxml.XMLStyleNode.StyleName := Form.edt.Text;
    lsb_Fontstyles.Items[lsb_Fontstyles.ItemIndex] := Form.edt.Text;
    //Fxml.SaveFontstyle(lsb_Fontstyles.Items[lsb_Fontstyles.ItemIndex], Form.edt.Text, Form.FontObj);
  finally
    FreeAndNil(Form);
  end;
end;

procedure Tfrm_SyntaxHighlighterConfig.btn_Edit_KommentarClick(Sender: TObject);
var
  Form: Tfrm_Kommentar;
  KommentarNode: TxmlSh_KommentarNode;
  Index: Integer;
begin
  if lsb_Fontstyles.ItemIndex < 0 then
  begin
    ShowMessage('Bitte erst einen Fontstyle auswählen');
    exit;
  end;
  if lsb_Kommentar.ItemIndex < 0 then
  begin
    ShowMessage('Bitte erst eine Kommentarbefehl auswählen');
    exit;
  end;

  Index := lsb_Kommentar.ItemIndex;
  KommentarNode := fxml.XMLStyleNode.XMLKommentarNode(lsb_Kommentar.Items[lsb_Kommentar.ItemIndex]);
  if KommentarNode = nil then
    exit;

  Form := Tfrm_Kommentar.Create(nil);
  try
    Form.setFontStr(KommentarNode.FontStr);
    Form.edt_Startzeichen.Text := KommentarNode.StartZeichen;
    Form.edt_Endezeichen.Text  := KommentarNode.EndeZeichen;
    Form.ShowModal;
    if Form.Cancel then
      exit;
    KommentarNode.FontStr := Form.FontStr;
    KommentarNode.StartZeichen := Form.edt_Startzeichen.Text;
    KommentarNode.EndeZeichen  := Form.edt_Endezeichen.Text;
    LadeKommentar;
    lsb_Kommentar.ItemIndex := Index;
    //Fxml.AddKommentar(lsb_Fontstyles.Items[lsb_Fontstyles.ItemIndex], Form.edt_Startzeichen.Text, Form.edt_Endezeichen.Text, lsb_Kommentar.Count + 1, Form.FontObj);
    //Fxml.save;
  finally
    FreeAndNil(Form);
  end;
end;
procedure Tfrm_SyntaxHighlighterConfig.btn_Neu_BereichClick(Sender: TObject);
var
  Form: Tfrm_SyntaxHighlighterEdit;
begin
  if lsb_Fontstyles.ItemIndex < 0 then
  begin
    ShowMessage('Bitte erst einen Fontstyle auswählen');
    exit;
  end;
  Form := Tfrm_SyntaxHighlighterEdit.Create(nil);
  try
    Form.Label1.Caption := 'Bereichname:';
    Form.rb_Links.Checked := true;
    Form.SelectFont('Arial');
    Form.edt_Size.Value := 8;
    Form.edt.Text := '';
    Form.ShowModal;
    if Form.Cancel then
      exit;
    fxml.XMLStyleNode.AddBereich(Form.edt.Text, Form.FontStr, not Form.OhneWortende);
  finally
    FreeAndNil(Form);
  end;
  LadeBereiche;
end;

procedure Tfrm_SyntaxHighlighterConfig.btn_Neu_FontstyleClick(Sender: TObject);
var
  Form: Tfrm_SyntaxHighlighterEdit;
  StylenameNode: TxmlSh_StylenameNode;
begin
  Form := Tfrm_SyntaxHighlighterEdit.Create(nil);
  try
    Form.Label1.Caption := 'Fontstylename:';
    Form.rb_Links.Checked := true;
    Form.SelectFont('Arial');
    Form.edt_Size.Value := 8;
    Form.edt.Text := '';
    Form.ShowModal;
    if Form.Cancel then
      exit;
    StylenameNode := fxml.AddStyleName;
    StyleNameNode.Stylename := Form.edt.Text;
    StyleNameNode.FontStr := Form.FontStr;
  finally
    FreeAndNil(Form);
  end;
  Fxml.LadeStyleNames(lsb_Fontstyles.Items);
end;

procedure Tfrm_SyntaxHighlighterConfig.btn_Neu_KommentarClick(Sender: TObject);
var
  Form: Tfrm_Kommentar;
begin
  if lsb_Fontstyles.ItemIndex < 0 then
  begin
    ShowMessage('Bitte erst einen Fontstyle auswählen');
    exit;
  end;
  Form := Tfrm_Kommentar.Create(nil);
  try
    Form.rb_Links.Checked := true;
    Form.SelectFont('Arial');
    Form.edt_Size.Value := 8;
    Form.edt_Startzeichen.Text := '';
    Form.edt_Endezeichen.Text  := '';
    Form.ShowModal;
    if Form.Cancel then
      exit;
    Fxml.XMLStyleNode.AddKommentar(Form.edt_Startzeichen.Text, Form.edt_Endezeichen.Text, Form.FontStr, lsb_Kommentar.Count + 1);
    LadeKommentar;
    //Fxml.AddKommentar(lsb_Fontstyles.Items[lsb_Fontstyles.ItemIndex], Form.edt_Startzeichen.Text, Form.edt_Endezeichen.Text, lsb_Kommentar.Count + 1, Form.FontObj);
    //Fxml.save;
  finally
    FreeAndNil(Form);
  end;
end;



procedure Tfrm_SyntaxHighlighterConfig.btn_TestenClick(Sender: TObject);
begin
  Fxml.save;
  if lsb_Fontstyles.ItemIndex < 0 then
  begin
    ShowMessage('Bitte erst den Stylename auswählen');
    exit;
  end;
  ShowHighlighter;
end;

procedure Tfrm_SyntaxHighlighterConfig.LadeBereiche;
begin
  lsb_Bereich.Clear;
  if lsb_FontStyles.ItemIndex < 0 then
    exit;
  Fxml.LadeBereiche(lsb_Bereich.Items);
end;

procedure Tfrm_SyntaxHighlighterConfig.LadeKommentar;
begin
  lsb_Kommentar.Clear;
  if lsb_FontStyles.ItemIndex < 0 then
    exit;
  Fxml.LadeKommentar(lsb_Kommentar.Items);
end;

procedure Tfrm_SyntaxHighlighterConfig.lsb_BereichClick(Sender: TObject);
begin
  if lsb_Bereich.ItemIndex < 0 then
    exit;
  Fxml.XMLStyleNode.setBereich(lsb_Bereich.Items[lsb_Bereich.ItemIndex]);
  mem_Wortliste.Enabled := true;
  mem_Wortliste.Lines.Text := Fxml.XMLStyleNode.XMLBereichNode.WortListe;
  mem_Wortendezeichen.Lines.Text := Fxml.XMLStyleNode.XMLBereichNode.WortendeListe;
  mem_Wortanfangzeichen.Lines.Text := Fxml.XMLStyleNode.XMLBereichNode.WortanfangListe;
end;

procedure Tfrm_SyntaxHighlighterConfig.lsb_FontstylesClick(Sender: TObject);
begin
  mem_Wortliste.Clear;
  mem_Wortendezeichen.Clear;
  mem_Wortendezeichen.Clear;
  if lsb_Fontstyles.ItemIndex < 0 then
    exit;
  Fxml.setStyleName(lsb_Fontstyles.Items[lsb_Fontstyles.ItemIndex]);
  LadeBereiche;
  LadeKommentar;
end;

procedure Tfrm_SyntaxHighlighterConfig.mem_WortanfangzeichenExit(
  Sender: TObject);
begin
  if (Fxml.XMLStyleNode <> nil) and (Fxml.XMLStyleNode.XMLBereichNode <> nil) then
    Fxml.XMLStyleNode.XMLBereichNode.WortanfangListe := mem_Wortanfangzeichen.Lines.Text;
end;

procedure Tfrm_SyntaxHighlighterConfig.mem_WortendezeichenExit(Sender: TObject);
begin
  if (Fxml.XMLStyleNode <> nil) and (Fxml.XMLStyleNode.XMLBereichNode <> nil) then
    Fxml.XMLStyleNode.XMLBereichNode.WortendeListe := mem_Wortendezeichen.Lines.Text;
end;

procedure Tfrm_SyntaxHighlighterConfig.mem_WortlisteExit(Sender: TObject);
begin
  if (Fxml.XMLStyleNode <> nil) and (Fxml.XMLStyleNode.XMLBereichNode <> nil) then
    Fxml.XMLStyleNode.XMLBereichNode.WortListe := mem_Wortliste.Lines.Text;
end;



procedure Tfrm_SyntaxHighlighterConfig.btn_UpClick(Sender: TObject);
begin
  if fxml.XMLStyleNode = nil then
    exit;
  if lsb_Kommentar.ItemIndex <= 0 then
    exit;
  lsb_Kommentar.Items.Exchange(lsb_Kommentar.ItemIndex, lsb_Kommentar.ItemIndex-1);
  fxml.XMLStyleNode.ChangeKommentarPos(lsb_Kommentar.Items);
end;

procedure Tfrm_SyntaxHighlighterConfig.btn_CancelClick(Sender: TObject);
begin
  fCancel := true;
  close;
end;

procedure Tfrm_SyntaxHighlighterConfig.btn_Del_BereichClick(Sender: TObject);
begin
  if lsb_Bereich.ItemIndex < 0 then
  begin
    ShowMessage('Bitte einen Bereich auswählen');
    exit;
  end;
  if not MessageDlg('Möchten Sie diesen Bereich wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
  Fxml.XMLStyleNode.DeleteBereich(lsb_Bereich.Items[lsb_Bereich.ItemIndex]);
  LadeBereiche;
end;

procedure Tfrm_SyntaxHighlighterConfig.btn_del_FontstyleClick(Sender: TObject);
begin
  if lsb_Fontstyles.ItemIndex < 0 then
  begin
    ShowMessage('Bitte erst einen Fontstyle auswählen');
    exit;
  end;
  if MessageDlg('Wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
  lsb_Fontstyles.Clear;
  FXML.DeleteStyle;
  Fxml.LadeStyleNames(lsb_Fontstyles.Items);
end;

procedure Tfrm_SyntaxHighlighterConfig.btn_Del_KommentarClick(Sender: TObject);
begin
  if lsb_Kommentar.ItemIndex < 0 then
  begin
    ShowMessage('Bitte einen Eintrag auswählen');
    exit;
  end;
  fxml.XMLStyleNode.DeleteKommentar(lsb_Kommentar.Items[lsb_Kommentar.ItemIndex]);
  LadeKommentar;
end;

procedure Tfrm_SyntaxHighlighterConfig.btn_DownClick(Sender: TObject);
begin
  if fxml.XMLStyleNode = nil then
    exit;
  if lsb_Kommentar.ItemIndex < 0 then
    exit;
  if (lsb_Kommentar.ItemIndex > -1) and (lsb_Kommentar.ItemIndex < lsb_Kommentar.Items.Count-1) then
    lsb_Kommentar.Items.Exchange(lsb_Kommentar.ItemIndex, lsb_Kommentar.ItemIndex+1);
  fxml.XMLStyleNode.ChangeKommentarPos(lsb_Kommentar.Items);
end;


procedure Tfrm_SyntaxHighlighterConfig.ShowHighlighter;
var
  Form: Tfrm_SyntaxHighlighter;
begin
  Form := Tfrm_SyntaxHighlighter.Create(Self);
  try
    //Form.LoadXML('c:\_e\syntaxhighlighter.xml');
    Form.LoadXML(FXMLFile);
    Form.setStyleName(lsb_Fontstyles.Items[lsb_Fontstyles.ItemIndex]);
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;
end;



end.
