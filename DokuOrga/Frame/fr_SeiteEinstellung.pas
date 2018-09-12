unit fr_SeiteEinstellung;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fr_Base, of_SeiteEinstellung,
  Vcl.StdCtrls, AdvEdit, AdvEdBtn, AdvDirectoryEdit, c_types, tbButton;

type
  Tfra_SeiteEinstellung = class(Tfrm_Base)
    chb_PW: TCheckBox;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    lbl_Hauptpfad: TLabel;
    Label1: TLabel;
    edt_Dir: TAdvDirectoryEdit;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    lbl_FTPHauptpfad: TLabel;
    Label5: TLabel;
    edt_ftpdir: TAdvDirectoryEdit;
    cbx_FTPUebertragen: TCheckBox;
    grp_GoogleDrive: TGroupBox;
    Label4: TLabel;
    lbl_Hauptpfad_GDrive: TLabel;
    Label7: TLabel;
    cbx_GDriveUebertragen: TCheckBox;
    edt_GoogleDrive: TAdvEditBtn;
    btn_FP_Vorschlagen: TTBButton;
    btn_GDrive_FPUebernehmen: TTBButton;
  private
    Fof_SeiteEinstellung: Tof_SeiteEinstellung;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    property SeiteEinstellung: Tof_SeiteEinstellung read Fof_SeiteEinstellung write Fof_SeiteEinstellung;
  end;

var
  fra_SeiteEinstellung: Tfra_SeiteEinstellung;

implementation

{$R *.dfm}

uses
  o_sysObj;


{ Tfra_SeiteEinstellung }

constructor Tfra_SeiteEinstellung.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fof_SeiteEinstellung := Tof_SeiteEinstellung.Create(Self, AMode);
  Fof_SeiteEinstellung.Name := 'of_SeiteEinstellung_' + FormatDateTime('hh_nn_ss_zzz', now);
  lbl_Hauptpfad.Caption := sysObj.Einstellung.DokumentPfad.AsString;
  lbl_FTPHauptpfad.Caption := sysObj.Einstellung.FTP.Pfad.AsString;
  lbl_Hauptpfad_GDrive.Caption := SysObj.Einstellung.GoogleDrive.Pfad.AsString;
end;

destructor Tfra_SeiteEinstellung.Destroy;
begin
  FreeAndNil(Fof_SeiteEinstellung);
  inherited;
end;

end.
