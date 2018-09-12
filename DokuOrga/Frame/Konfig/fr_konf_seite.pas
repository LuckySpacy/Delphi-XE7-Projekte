unit fr_konf_seite;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fr_konf_base, of_konf_seite, tbToolbar,
  tbButton, Vcl.ExtCtrls, RVScroll, RichView, RVEdit, tbRichviewEdit, c_types,
  Vcl.StdCtrls;

type
  Tfra_Konf_Seite = class(Tfra_Konf_Base)
    pnl_Top: TPanel;
    btn_Edit: TTBButton;
    btn_Delete: TTBButton;
    btn_Cancel: TTBButton;
    Toolbar: TTbToolbar;
    Editor_Header: TtbRichviewEdit;
    Splitter1: TSplitter;
    Editor: TtbRichviewEdit;
    cbx_KopfzeileAusblenden: TCheckBox;
  private
    Fof_Konf_Seite: Tof_Konf_Seite;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;

var
  fra_Konf_Seite: Tfra_Konf_Seite;

implementation

{$R *.dfm}

{ Tfra_Konf_Base1 }

constructor Tfra_Konf_Seite.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fof_Konf_Seite := Tof_Konf_Seite.Create(Self, AMode);
end;

destructor Tfra_Konf_Seite.Destroy;
begin
  FreeAndNil(Fof_Konf_Seite);
  inherited;
end;

end.
