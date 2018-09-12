unit Frame.Konf;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Frame.Konf.Datenbank,
  Vcl.ComCtrls, Frame.Konf.CSVPfad;

type
  Tfra_Konf = class(TFrame)
    PageControl1: TPageControl;
    tbs_Datenbank: TTabSheet;
    tbs_CsvPfad: TTabSheet;
  private
    fFrameDatenbank: Tfra_Konf_Datenbank;
    fFrameCSVPfad: Tfra_Konf_CSVPfad;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{ Tfra_Konf }

constructor Tfra_Konf.Create(AOwner: TComponent);
begin
  inherited;
  fFrameDatenbank := Tfra_Konf_Datenbank.Create(nil);
  fFrameDatenbank.Parent := tbs_Datenbank;
  fFrameDatenbank.Align  := alClient;
  fFrameCSVPfad := Tfra_Konf_CSVPfad.Create(nil);
  fFrameCSVPfad.Parent := tbs_CsvPfad;
  fFrameCSVPfad.Align  := alClient;
end;

destructor Tfra_Konf.Destroy;
begin
  FreeAndNil(fFrameDatenbank);
  inherited;
end;

end.
