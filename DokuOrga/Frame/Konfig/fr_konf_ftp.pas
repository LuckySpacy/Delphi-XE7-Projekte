unit fr_konf_ftp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fr_konf_base, of_konf_ftp, Vcl.StdCtrls, c_types,
  tbButton;

type
  Tfra_Konf_Ftp = class(Tfra_Konf_Base)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edt_Host: TEdit;
    edt_Username: TEdit;
    edt_Passwort: TEdit;
    edt_PW2: TEdit;
    btn_Speichern: TTBButton;
    Label5: TLabel;
    edt_Pfad: TEdit;
    btn_Testen: TTBButton;
    Memo1: TMemo;
    Label6: TLabel;
    cbx_FTPVerwenden: TCheckBox;
  private
    Fof_Konf_ftp: Tof_Konf_FTP;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;

var
  fra_Konf_Ftp: Tfra_Konf_Ftp;

implementation

{$R *.dfm}

{ Tfra_Konf_Ftp }

constructor Tfra_Konf_Ftp.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fof_Konf_ftp := Tof_Konf_FTP.Create(Self, AMode);
end;

destructor Tfra_Konf_Ftp.Destroy;
begin
  FreeAndNil(Fof_Konf_ftp);
  inherited;
end;

end.
