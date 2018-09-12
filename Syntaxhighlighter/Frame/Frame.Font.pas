unit Frame.Font;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Samples.Spin, Objekt.Font;

type
  Tfra_Font = class(TFrame)
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
  private
    fFontObj: TFontObj;
    procedure SelectFontname(aValue: string);
    procedure SelectColor(aColor: TColor);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FontStr: string;
    procedure setFontStr(aFontStr: string);
  end;

implementation

{$R *.dfm}

{ Tfra_Font }

constructor Tfra_Font.Create(AOwner: TComponent);
begin
  inherited;
  fFontObj := TFontObj.Create;
  cbo_Font.Items := Screen.Fonts;
end;

destructor Tfra_Font.Destroy;
begin
  FreeAndNil(fFontObj);
  inherited;
end;

function Tfra_Font.FontStr: string;
begin
  fFontObj.Fontname := cbo_Font.Text;

  if cbo_Farbe.ItemIndex > -1 then
    fFontObj.Color := cbo_Farbe.Colors[cbo_Farbe.ItemIndex];;

  fFontObj.Size     := edt_Size.Value;
  fFontObj.Style    := [];


  if cbx_Bold.Checked then
    fFontObj.Style := fFontObj.Style + [fsBold];
  if cbx_Italic.Checked then
    fFontObj.Style := fFontObj.Style + [fsItalic];
  if cbx_Underline.Checked then
    fFontObj.Style := fFontObj.Style + [fsUnderline];
  if cbx_StrikeOut.Checked then
    fFontObj.Style := fFontObj.Style + [fsStrikeOut];

  if rb_Links.Checked then
    fFontObj.Alignment := taLeftJustify;

  if rb_Rechts.Checked then
    fFontObj.Alignment := taRightJustify;

  if rb_Zentriert.Checked then
    fFontObj.Alignment := taCenter;

  Result := fFontObj.FontStr;

end;

procedure Tfra_Font.SelectColor(aColor: TColor);
var
  i1: Integer;
begin
  for i1 := 0 to cbo_Farbe.Items.Count -1 do
  begin
    if cbo_Farbe.Colors[i1] = aColor then
    begin
      cbo_Farbe.ItemIndex := i1;
      break;
    end;
  end;
end;

procedure Tfra_Font.SelectFontname(aValue: string);
var
  i1: Integer;
begin
  for i1 := 0 to cbo_Font.Items.Count -1 do
  begin
    if SameText(cbo_Font.Items[i1], aValue) then
    begin
      cbo_Font.ItemIndex := i1;
      exit;
    end;
  end;
end;

procedure Tfra_Font.setFontStr(aFontStr: string);
begin
  fFontObj.FontStr := aFontStr;
  SelectFontname(fFontObj.Fontname);
  SelectColor(fFontObj.Color);
  //cbo_Font.Text   := fFontObj.Fontname;
  //cbo_Farbe.Color := fFontObj.Color;
  edt_Size.Value  := fFontObj.Size;
  cbx_Bold.Checked := fsBold in fFontObj.Style;
  cbx_Italic.Checked := fsItalic in fFontObj.Style;
  cbx_Underline.Checked := fsUnderline in fFontObj.Style;
  cbx_StrikeOut.Checked := fsStrikeOut in fFontObj.Style;
  rb_Links.Checked := fFontObj.Alignment = taLeftJustify;
  rb_Rechts.Checked := fFontObj.Alignment = taRightJustify;
  rb_Zentriert.Checked := fFontObj.Alignment = taCenter;
end;

end.
