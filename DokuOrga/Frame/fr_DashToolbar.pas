unit fr_DashToolbar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fr_Base, tbButton, u_DM, obBusinessClasses, obServerClient,
  of_DashToolbar, ExtCtrls, c_types;

type
  Tfra_DashToolbar = class(Tfrm_Base, IObServerClient)
    pnl_Button: TPanel;
    btn_Neu: TTBButton;
    btn_Save: TTBButton;
    btn_Return: TTBButton;
    btn_Export: TTBButton;
    btn_Import: TTBButton;
    btn_Eigenschaften: TTBButton;
  private
    FDashToolbar: Tof_DashToolbar;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;

var
  fra_DashToolbar: Tfra_DashToolbar;

implementation

{$R *.dfm}

{ Tfra_DashToolbar }

constructor Tfra_DashToolbar.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner,AMode);
  FDashToolbar := Tof_DashToolbar.Create(Self, AMode);
end;

destructor Tfra_DashToolbar.Destroy;
begin
  FreeAndNil(FDashToolbar);
  inherited;
end;

end.
