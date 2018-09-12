unit Form.HighlighterEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Frame.Font, Vcl.StdCtrls, Vcl.ExtCtrls,
  nfsButton, Model.Highlighter, IBX.IBDatabase;

type
  Tfrm_HighlighterEdit = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edt: TEdit;
    pnl_Client: TPanel;
    Panel3: TPanel;
    cbx_OhneWortende: TCheckBox;
    btn_Speichern: TnfsButton;
    btn_Abbrechen: TnfsButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_AbbrechenClick(Sender: TObject);
    procedure btn_SpeichernClick(Sender: TObject);
  private
    fFrameFont: Tfra_Font;
    fHighlighter: THighlighter;
  public
    procedure setHighlighterId(aId: Integer);
    procedure setTrans(aTrans: TIBTransaction);
  end;

var
  frm_HighlighterEdit: Tfrm_HighlighterEdit;

implementation

{$R *.dfm}



procedure Tfrm_HighlighterEdit.FormCreate(Sender: TObject);
begin
  fFrameFont := Tfra_Font.Create(nil);
  fFrameFont.Parent := pnl_Client;
  fFrameFont.Align  := alClient;
  fHighlighter := THighlighter.Create(nil);

  edt.Text := '';
end;

procedure Tfrm_HighlighterEdit.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fHighlighter);
  FreeAndNil(fFrameFont);
end;

procedure Tfrm_HighlighterEdit.setHighlighterId(aId: Integer);
begin
  fHighlighter.Read(aId);
  edt.Text := fHighlighter.StyleName;
  fFrameFont.setFontStr(fHighlighter.Font);
end;

procedure Tfrm_HighlighterEdit.setTrans(aTrans: TIBTransaction);
begin
  fHighlighter.Trans := aTrans;
end;

procedure Tfrm_HighlighterEdit.btn_AbbrechenClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_HighlighterEdit.btn_SpeichernClick(Sender: TObject);
begin
  fHighlighter.StyleName := edt.Text;
  fHighlighter.Font := fFrameFont.FontStr;
  fHighlighter.SaveToDB;
  close;
end;

end.
