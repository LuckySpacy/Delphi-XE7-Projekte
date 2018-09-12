unit fr_konf_datenbank;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fr_konf_base, Vcl.StdCtrls, AdvEdit,
  AdvEdBtn, AdvFileNameEdit, of_konf_datenbank, c_types;

type
  Tfra_Konf_Datenbank = class(Tfra_Konf_Base)
    Label1: TLabel;
    edt_Datenbankfilename: TAdvFileNameEdit;
    Label2: TLabel;
    edt_Server: TEdit;
  private
    Fof_Konf_Datenbank: Tof_Konf_Datenbank;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;

var
  fra_Konf_Datenbank: Tfra_Konf_Datenbank;

implementation

{$R *.dfm}

{ Tfra_Konf_Datenbank }

constructor Tfra_Konf_Datenbank.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fof_Konf_Datenbank := Tof_Konf_Datenbank.Create(Self, AMode);
end;

destructor Tfra_Konf_Datenbank.Destroy;
begin
  FreeAndNil(Fof_Konf_Datenbank);
  inherited;
end;

end.
