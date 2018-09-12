unit fr_konf_dokumente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, obBusinessClasses, obServerClient, fr_konf_base, c_types,
  Vcl.StdCtrls, AdvEdit, AdvEdBtn, AdvDirectoryEdit, of_konf_dokumente;

type
  Tfra_Konf_Dokumente = class(Tfra_Konf_Base)
    Label1: TLabel;
    edt_Dir: TAdvDirectoryEdit;
  private
    Fof_Konf_Dokumente: Tof_Konf_Dokumente;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;

var
  fra_Konf_Dokumente: Tfra_Konf_Dokumente;

implementation

{$R *.dfm}

{ Tfra_Konf_Base1 }

constructor Tfra_Konf_Dokumente.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fof_Konf_Dokumente := Tof_Konf_Dokumente.Create(Self, AMode);
end;

destructor Tfra_Konf_Dokumente.Destroy;
begin
  FreeAndNil(Fof_Konf_Dokumente);
  inherited;
end;

end.
