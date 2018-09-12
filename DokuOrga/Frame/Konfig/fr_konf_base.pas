unit fr_konf_base;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs, fr_Base, Menus, obBusinessClasses, obServerClient, c_types,
  StdCtrls, of_konf_base;

type
  Tfra_Konf_Base = class(Tfrm_Base, IObServerClient)
  private
    Fof_Konf_Base: Tof_Konf_Base;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;

var
  fra_Konf_Base: Tfra_Konf_Base;

implementation

{$R *.dfm}

{ Tfra_Konf_Base }

constructor Tfra_Konf_Base.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fof_Konf_Base := Tof_Konf_Base.Create(Self, AMode);
end;

destructor Tfra_Konf_Base.Destroy;
begin
  FreeAndNil(FOf_Konf_Base);
  inherited;
end;


end.
