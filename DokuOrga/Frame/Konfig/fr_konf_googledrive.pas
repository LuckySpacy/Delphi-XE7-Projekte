unit fr_konf_googledrive;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fr_konf_base, tbButton, Vcl.StdCtrls, of_konf_googledrive,
  c_Types, AdvEdit, AdvEdBtn, AdvDirectoryEdit, Vcl.ExtCtrls, tbEditFile,
  Vcl.ImgList;

type
  Tfra_Konf_GoogleDrive = class(Tfra_Konf_Base)
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    edt_ClientKey: TEdit;
    cbx_GDriveVerwenden: TCheckBox;
    btn_Testen: TTBButton;
    btn_Speichern: TTBButton;
    edt_ClientId: TEdit;
    edt_Pfad: TButtonedEdit;
    ImageList1: TImageList;
  private
    Fof_Konf_GoogleDrive: Tof_Konf_GoogleDrive;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;

var
  fra_Konf_GoogleDrive: Tfra_Konf_GoogleDrive;

implementation

{$R *.dfm}

{ Tfra_Konf_GoogleDrive }

constructor Tfra_Konf_GoogleDrive.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fof_Konf_GoogleDrive := Tof_Konf_GoogleDrive.Create(Self, AMode);
end;

destructor Tfra_Konf_GoogleDrive.Destroy;
begin
  FreeAndNil(Fof_Konf_GoogleDrive);
  inherited;
end;

end.
