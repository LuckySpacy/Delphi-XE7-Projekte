unit Frame.Konf.CSVPfad;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvEdit,
  AdvEdBtn, AdvFileNameEdit;

type
  Tfra_Konf_CSVPfad = class(TFrame)
    Label1: TLabel;
    edt_CSVPfad: TAdvFileNameEdit;
    procedure edt_CSVPfadExit(Sender: TObject);
  private
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{ Tfra_Konf_CSVPfad }

uses
  Objekt.Global;

constructor Tfra_Konf_CSVPfad.Create(AOwner: TComponent);
begin
  inherited;
  edt_CSVPfad.Text := Global.CSVPfad;
end;

destructor Tfra_Konf_CSVPfad.Destroy;
begin

  inherited;
end;

procedure Tfra_Konf_CSVPfad.edt_CSVPfadExit(Sender: TObject);
begin
  if DirectoryExists(edt_CSVPfad.Text) then
    Global.CSVPfad := edt_CSVPfad.Text;
end;

end.
