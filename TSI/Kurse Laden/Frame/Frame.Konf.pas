unit Frame.Konf;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Frame.Konf.Datenbank;

type
  Tfra_Konf = class(TFrame)
  private
    fFrameDatenbank: Tfra_Konf_Datenbank;
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
  fFrameDatenbank.Parent := Self;
  fFrameDatenbank.Align  := alClient;
end;

destructor Tfra_Konf.Destroy;
begin
  FreeAndNil(fFrameDatenbank);
  inherited;
end;

end.
