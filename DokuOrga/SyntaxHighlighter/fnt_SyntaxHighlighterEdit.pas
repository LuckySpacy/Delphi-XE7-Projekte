unit fnt_SyntaxHighlighterEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Samples.Spin, o_fontobj;

type
  Tfrm_SyntaxHighlighterEdit = class(TForm)
    Label1: TLabel;
    edt: TEdit;
    grb_Font: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cbx_Bold: TCheckBox;
    cbx_Italic: TCheckBox;
    cbx_Underline: TCheckBox;
    cbx_StrikeOut: TCheckBox;
    edt_Size: TSpinEdit;
    cbo_Font: TComboBox;
    cbo_Farbe: TColorBox;
    grb_Ausrichtung: TGroupBox;
    rb_Links: TRadioButton;
    rb_Zentriert: TRadioButton;
    rb_Rechts: TRadioButton;
    cbx_OhneWortende: TCheckBox;
    btn_Abbruch: TButton;
    btn_Ok: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_AbbruchClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
  private
    FCancel: Boolean;
    FFontObj: TFontObj;
    FOhneWortende: Boolean;
    procedure setOhneWortende(const Value: Boolean);
  public
    property Cancel: Boolean read FCancel;
    procedure SelectFont(aFontName: string);
    function FontStr: string;
    procedure setFontStr(aFontStr: string);
    property FontObj: TFontObj read FFontObj write FFontObj;
    property OhneWortende: Boolean read FOhneWortende write setOhneWortende;
  end;

var
  frm_SyntaxHighlighterEdit: Tfrm_SyntaxHighlighterEdit;

implementation

{$R *.dfm}


procedure Tfrm_SyntaxHighlighterEdit.FormCreate(Sender: TObject);
begin
  FCancel := true;
  cbo_Font.Items := Screen.Fonts;
  FFontObj := TFontObj.Create;
end;

procedure Tfrm_SyntaxHighlighterEdit.FormDestroy(Sender: TObject);
begin
  FreeandNil(FFontObj);
end;

procedure Tfrm_SyntaxHighlighterEdit.btn_AbbruchClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_SyntaxHighlighterEdit.btn_OkClick(Sender: TObject);
begin
  FCancel := false;
  FFontObj.Fontname := cbo_Font.Text;
  FFontObj.Color    := cbo_Farbe.Selected;
  FFontObj.Size     := edt_Size.Value;
  FFontObj.Style    := [];

  if cbx_Bold.Checked then
    FFontObj.Style := FFontObj.Style + [fsBold];
  if cbx_Italic.Checked then
    FFontObj.Style := FFontObj.Style + [fsItalic];
  if cbx_Underline.Checked then
    FFontObj.Style := FFontObj.Style + [fsUnderline];
  if cbx_StrikeOut.Checked then
    FFontObj.Style := FFontObj.Style + [fsStrikeOut];

  if rb_Links.Checked then
    FFontObj.Alignment := taLeftJustify;
  if rb_Rechts.Checked then
    FFontObj.Alignment := taRightJustify;
  if rb_Zentriert.Checked then
    FFontObj.Alignment := taCenter;

  close;
end;

function Tfrm_SyntaxHighlighterEdit.FontStr: string;
begin
  if cbx_Bold.Checked then
    FFontObj.Style := FFontObj.Style + [fsBold];
  if cbx_Italic.Checked then
    FFontObj.Style := FFontObj.Style + [fsItalic];
  if cbx_Underline.Checked then
    FFontObj.Style := FFontObj.Style + [fsUnderline];
  if cbx_StrikeOut.Checked then
    FFontObj.Style := FFontObj.Style + [fsStrikeOut];

  if rb_Links.Checked then
    FFontObj.Alignment := taLeftJustify;
  if rb_Rechts.Checked then
    FFontObj.Alignment := taRightJustify;
  if rb_Zentriert.Checked then
    FFontObj.Alignment := taCenter;
  Result := FFontObj.FontStr;
end;


procedure Tfrm_SyntaxHighlighterEdit.SelectFont(aFontName: string);
var
  i1: Integer;
begin
  for i1 := 0 to cbo_Font.Items.Count -1 do
  begin
    if SameText(aFontName, cbo_Font.Items[i1]) then
    begin
      cbo_Font.ItemIndex := i1;
      exit;
    end;
  end;
end;

procedure Tfrm_SyntaxHighlighterEdit.setFontStr(aFontStr: string);
begin
  FFontObj.FontStr := aFontStr;
  SelectFont(FFontObj.Fontname);
  cbo_Farbe.Selected := FFontObj.Color;
  edt_Size.Value  := FFontObj.Size;
  cbx_Bold.Checked := fsBold in FFontObj.Style;
  cbx_Italic.Checked := fsItalic in FFontObj.Style;
  cbx_Underline.Checked := fsUnderline in FFontObj.Style;
  cbx_StrikeOut.Checked := fsStrikeOut in FFontObj.Style;
  rb_Links.Checked := FFontObj.Alignment = taLeftJustify;
  rb_Rechts.Checked := FFontObj.Alignment = taRightJustify;
  rb_Zentriert.Checked := FFontObj.Alignment = taCenter;
end;

procedure Tfrm_SyntaxHighlighterEdit.setOhneWortende(const Value: Boolean);
begin
  FOhneWortende := Value;
  cbx_OhneWortende.Checked := Value;
end;

end.
