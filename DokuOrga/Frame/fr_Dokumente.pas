unit fr_Dokumente;

interface

{$WARN SYMBOL_PLATFORM OFF}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fr_Base, obBusinessClasses, obServerClient, of_Dokumente,
  Vcl.Grids, tbStringGrid, Vcl.ExtCtrls, fr_DokumenteToolbar, Vcl.Menus,
  IdComponent, IdBaseComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP, c_types, Vcl.ComCtrls, DragDrop,
  DropTarget, DragDropFile;

type
  Tfra_Dokumente = class(Tfrm_Base, IObServerClient)
    grd_Dokumente: TtbStringGrid;
    pnl_DokumenteToolbar: TPanel;
    FileOpenDialog1: TFileOpenDialog;
    pop: TPopupMenu;
    pop_Bez: TMenuItem;
    N1: TMenuItem;
    pop_FTP: TMenuItem;
    IdFTP1: TIdFTP;
    N2: TMenuItem;
    pop_Delete: TMenuItem;
    pop_link: TPopupMenu;
    pop_DokumentLink: TMenuItem;
    pop_Auf_Festplatte: TMenuItem;
    N3: TMenuItem;
    mnu_GDrive: TMenuItem;
    pg: TProgressBar;
    mnu_CopyToFP: TMenuItem;
    N4: TMenuItem;
    DataFormatAdapterTarget: TDataFormatAdapter;
    DropFileTarget: TDropFileTarget;
  private
    Fof_Dokumente: Tof_Dokumente;
    FDokumenteToolbar: Tfra_DokumenteToolbar;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    property Doku: Tof_Dokumente read Fof_Dokumente write Fof_Dokumente;
  end;

var
  fra_Dokumente: Tfra_Dokumente;

implementation

{$R *.dfm}

{ Tfra_Dokumente }

constructor Tfra_Dokumente.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fof_Dokumente := Tof_Dokumente.Create(Self, AMode);
  FDokumenteToolbar := Tfra_DokumenteToolbar.Create(Self);
  FDokumenteToolbar.Parent := pnl_DokumenteToolbar;
  FDokumenteToolbar.Align := alClient;
end;

destructor Tfra_Dokumente.Destroy;
begin
  FreeAndNil(Fof_Dokumente);
  FreeAndNil(FDokumenteToolbar);
  inherited;
end;

end.
