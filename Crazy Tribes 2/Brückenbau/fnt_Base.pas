unit fnt_Base;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, tbButton, o_Base;

type
  Tfrm_Base = class(TForm)
    pnl_Bottom: TPanel;
    btn_Ok: TTBButton;
    btn_Cancel: TTBButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edt_Basename: TEdit;
    edt_X: TSpinEdit;
    edt_Y: TSpinEdit;
    Label4: TLabel;
    edt_Punkte: TSpinEdit;
    cbx_Rauchsignal: TCheckBox;
    cbx_Sprechfunk: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
  private
    FCancel: Boolean;
    FBase: TBase;
    procedure setBase(const Value: TBase);
  public
    property Cancel: Boolean read FCancel;
    property Base: TBase read FBase write setBase;
  end;

var
  frm_Base: Tfrm_Base;

implementation

{$R *.dfm}


procedure Tfrm_Base.FormCreate(Sender: TObject);
begin
  FCancel := true;
  edt_Basename.Text := '';;
  edt_X.Value       := 0;
  edt_Y.Value       := 0;
  edt_Punkte.Value   := 0;
 cbx_Rauchsignal.Checked := false;
 cbx_Sprechfunk.Checked  := false;
 edt_X.Enabled := false;
 edt_Y.Enabled := false;
 FBase := nil;
end;


procedure Tfrm_Base.setBase(const Value: TBase);
begin
  FBase := Value;
  if FBase = nil then
  begin
    edt_X.Enabled := true;
    edt_Y.Enabled := true;
    exit;
  end;
  edt_Basename.Text := FBase.Basename;
  edt_X.Value       := FBase.Koordinate.X;
  edt_Y.Value       := FBase.Koordinate.Y;
  edt_Punkte.Value   := FBase.Punkte;
 cbx_Rauchsignal.Checked := FBase.Rauchsignal;
 cbx_Sprechfunk.Checked  := FBase.Sprechfunk;
end;

procedure Tfrm_Base.btn_CancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_Base.btn_OkClick(Sender: TObject);
begin
  FCancel := false;
  if FBase <> nil then
  begin
    FBase.Basename := edt_Basename.Text;
    FBase.Koordinate.X := edt_X.Value;
    FBase.Koordinate.Y := edt_Y.Value;
    FBase.Punkte       := edt_Punkte.Value;
    FBase.Rauchsignal  := cbx_Rauchsignal.Checked;
    FBase.Sprechfunk   := cbx_Sprechfunk.Checked;
  end;
  close;
end;


end.
