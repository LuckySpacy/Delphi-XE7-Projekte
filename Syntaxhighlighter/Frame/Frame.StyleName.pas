unit Frame.StyleName;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Model.Highlighter, Model.HighlighterList, IBX.IBDatabase, Form.HighlighterEdit;

type
  Tfra_StyleName = class(TFrame)
    pnl_fontstyle: TPanel;
    pnl_fontstyletop: TPanel;
    pnl_fontstylebutton: TPanel;
    btn_Neu_Fontstyle: TButton;
    btn_Edit_Fontstyle: TButton;
    btn_del_Fontstyle: TButton;
    lsb_Fontstyles: TListBox;
    procedure btn_Neu_FontstyleClick(Sender: TObject);
    procedure btn_Edit_FontstyleClick(Sender: TObject);
  private
    fHighlighter: THighlighter;
    fHighlighterList: THighlighterList;
    fTrans: TIBTransaction;
    procedure ShowHighlighterEdit(aId: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LadeStyleNames;
    property Trans: TIBTransaction read fTrans write fTrans;
  end;

implementation

{$R *.dfm}

{ Tfra_StyleName }



constructor Tfra_StyleName.Create(AOwner: TComponent);
begin
  inherited;
  fHighlighter     := THighlighter.Create(Self);
  fHighlighterList := THighlighterList.Create(Self);
end;

destructor Tfra_StyleName.Destroy;
begin
  FreeAndNil(fHighlighter);
  FreeAndNil(fHighlighterList);
  inherited;
end;

procedure Tfra_StyleName.LadeStyleNames;
var
  i1: Integer;
begin
  fHighlighter.Trans := fTrans;
  fHighlighterList.Trans := fTrans;
  lsb_Fontstyles.Clear;
  fHighlighterList.ReadAll;
  for i1 := 0 to fHighlighterList.Count -1 do
  begin
    lsb_Fontstyles.Items.AddObject(fHighlighterList.Item[i1].StyleName, TObject(fHighlighterList.Item[i1].Id));
  end;
end;


procedure Tfra_StyleName.btn_Edit_FontstyleClick(Sender: TObject);
var
  id: Integer;
begin
  if lsb_Fontstyles.ItemIndex > -1 then
    Id := Integer(lsb_Fontstyles.Items.Objects[lsb_Fontstyles.ItemIndex])
  else
    Id := 0;
  ShowHighlighterEdit(Id);
end;

procedure Tfra_StyleName.btn_Neu_FontstyleClick(Sender: TObject);
begin
  ShowHighlighterEdit(0);
end;


procedure Tfra_StyleName.ShowHighlighterEdit(aId: Integer);
var
  Form: Tfrm_HighlighterEdit;
begin
  Form := Tfrm_HighlighterEdit.Create(Self);
  try
    Form.setTrans(fTrans);
    if aId > 0 then
      Form.setHighlighterId(aId);
    Form.ShowModal;
    LadeStyleNames;
  finally
    FreeAndNil(Form);
  end;

end;

end.
