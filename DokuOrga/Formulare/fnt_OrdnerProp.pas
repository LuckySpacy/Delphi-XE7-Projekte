unit fnt_OrdnerProp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fnt_DialogBase, tbButton, ExtCtrls, StdCtrls, of_OrdnerProp,
  obBusinessClasses, obServerClient, o_OrdnerTypList;

type
  Tfrm_OrdnerProp = class(Tfrm_DialogBase, IObServerClient)
    Label1: TLabel;
    edt_Text: TEdit;
    Label2: TLabel;
    cmb_Typ: TComboBox;
    btn_Bild: TTBButton;
    chb_PW: TCheckBox;
  private
    FOrdnerProp: Tof_OrdnerProp;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property OrdnerProp: Tof_OrdnerProp read FOrdnerProp write FOrdnerProp;
  end;

var
  frm_OrdnerProp: Tfrm_OrdnerProp;

implementation

{$R *.dfm}

{ Tfrm_OrdnerProp }

uses
  fnt_Bilder, o_Bilder, c_DBTypes, o_sysobj;

constructor Tfrm_OrdnerProp.Create(AOwner: TComponent);
begin
  inherited;
  FOrdnerProp := Tof_OrdnerProp.Create(Self, sysobj.Akt.Modus);
  OnChangeBearbArt := FOrdnerProp.DoChangeBearbArt;
end;

destructor Tfrm_OrdnerProp.Destroy;
begin
  FreeAndNil(FOrdnerProp);
  inherited;
end;

end.
