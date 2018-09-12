unit fr_DokumenteToolbar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, obBusinessClasses, obServerClient,
  fr_Base, of_dokumenteToolbar, tbButton, c_types;

type
  Tfra_DokumenteToolbar = class(Tfrm_Base, IObServerClient)
    btn_FileAdd: TTBButton;
    btn_FileDel: TTBButton;
    btn_DokumentRefresh: TTBButton;
    btn_Link: TTBButton;
    btn_LinkEntfernen: TTBButton;
    btn_Link_Add: TTBButton;
    btn_DokuLink_Add: TTBButton;
    btn_DokuLink_Del: TTBButton;
  private
    Fof_DokumenteToolbar: Tof_DokumenteToolbar;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;

var
  fra_DokumenteToolbar: Tfra_DokumenteToolbar;

implementation

{$R *.dfm}

constructor Tfra_DokumenteToolbar.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fof_DokumenteToolbar := Tof_DokumenteToolbar.Create(Self, AMode);
end;

destructor Tfra_DokumenteToolbar.Destroy;
begin
  FreeAndNil(Fof_DokumenteToolbar);
  inherited;
end;

end.
