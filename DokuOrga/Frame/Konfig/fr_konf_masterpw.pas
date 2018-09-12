unit fr_konf_masterpw;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fr_konf_base, of_konf_masterpw, c_types,
  tbButton, Vcl.StdCtrls;

type
  Tfra_Konf_MasterPW = class(Tfra_Konf_Base)
    Label1: TLabel;
    edt_AktPW: TEdit;
    Label2: TLabel;
    edt_NeuPW: TEdit;
    Label3: TLabel;
    edt_NeuPW2: TEdit;
    btn_Save: TTBButton;
  private
    Fof_konf_MasterPW: Tof_Konf_MasterPW;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;

var
  fra_Konf_MasterPW: Tfra_Konf_MasterPW;

implementation

{$R *.dfm}

{ Tfra_Konf_MasterPW }

constructor Tfra_Konf_MasterPW.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fof_konf_MasterPW := Tof_Konf_MasterPW.Create(Self,AMode);
end;

destructor Tfra_Konf_MasterPW.Destroy;
begin
  FreeAndNil(Fof_konf_MasterPW);
  inherited;
end;

end.
