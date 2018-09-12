unit fr_SeiteInhalt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fr_Base, obBusinessClasses, obServerClient, RVScroll, RichView,
  RVEdit, tbRichviewEdit, tbToolbar, ExtCtrls, StdCtrls, tbButton, of_SeiteInhalt,
  c_types, Vcl.Menus, tbRvePopUp;

type
  Tfra_SeiteInhalt = class(Tfrm_Base, IObServerClient)
    Toolbar: TTbToolbar;
    pnl_Top: TPanel;
    btn_Edit: TTBButton;
    btn_Delete: TTBButton;
    Splitter1: TSplitter;
    btn_Cancel: TTBButton;
    cbx_KopfzeileAusblenden: TCheckBox;
    tbRvePopUp1: TtbRvePopUp;
    Editor: TtbRichviewEdit;
    Editor_Header: TtbRichviewEdit;
    N1: TMenuItem;
    mnu_Syntaxhighlighter: TMenuItem;
    mnu_HighlighterTesten: TMenuItem;
    N2: TMenuItem;
    procedure EditorDblClick(Sender: TObject);
    procedure Editor_HeaderDblClick(Sender: TObject);
  private
    Fof_SeiteInhalt: Tof_SeiteInhalt;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    property SeiteInhalt: Tof_SeiteInhalt read Fof_SeiteInhalt write Fof_SeiteInhalt;
  end;

var
  fra_SeiteInhalt: Tfra_SeiteInhalt;

implementation

{$R *.dfm}

{ Tfra_SeiteInhalt }

constructor Tfra_SeiteInhalt.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fof_SeiteInhalt := Tof_SeiteInhalt.Create(Self, AMode);
  Toolbar.Visible := false;
end;

destructor Tfra_SeiteInhalt.Destroy;
begin
  FreeAndNil(Fof_SeiteInhalt);
  inherited;
end;

procedure Tfra_SeiteInhalt.EditorDblClick(Sender: TObject);
begin
  inherited;
  ShowMessage('Editor');
end;

procedure Tfra_SeiteInhalt.Editor_HeaderDblClick(Sender: TObject);
begin
  inherited;
  ShowMessage('Header');
end;

end.
