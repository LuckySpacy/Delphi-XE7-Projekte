unit fnt_Kommentar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Samples.Spin, o_fontobj;

type
  Tfrm_Kommentar = class(TForm)
    Label1: TLabel;
    edt_Startzeichen: TEdit;
    Label2: TLabel;
    edt_Endezeichen: TEdit;
    grb_Font: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
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
    btn_Ok: TButton;
    btn_Abbruch: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
    procedure btn_AbbruchClick(Sender: TObject);
  private
    FCancel: Boolean;
    FFontObj: TFontObj;
  public
    property Cancel: Boolean read FCancel;
    procedure SelectFont(aFontName: string);
    property FontObj: TFontObj read FFontObj write FFontObj;
    function FontStr: string;
    procedure setFontStr(aFontStr: string);
  end;

var
  frm_Kommentar: Tfrm_Kommentar;

implementation

{$R *.dfm}


procedure Tfrm_Kommentar.FormCreate(Sender: TObject);
begin
  FCancel := true;
  cbo_Font.Items := Screen.Fonts;
  FFontObj := TFontObj.Create;
end;

procedure Tfrm_Kommentar.FormDestroy(Sender: TObject);
begin
  FreeandNil(FFontObj);
end;


procedure Tfrm_Kommentar.SelectFont(aFontName: string);
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

procedure Tfrm_Kommentar.setFontStr(aFontStr: string);
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

procedure Tfrm_Kommentar.btn_AbbruchClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_Kommentar.btn_OkClick(Sender: TObject);
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


function Tfrm_Kommentar.FontStr: string;
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


end.
