unit fnt_ZweigProp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fnt_DialogBase, tbButton, ExtCtrls, StdCtrls, obBusinessClasses,
  obServerClient, of_ZweigProp, c_types;

type
  Tfrm_ZweigProp = class(Tfrm_DialogBase, IObServerClient)
    Label1: TLabel;
    edt_Text: TEdit;
  private
    { Private-Deklarationen }
    FZweigProp: Tof_ZweigProp;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ZweigProp: Tof_ZweigProp read FZweigProp write FZweigProp;
  end;

var
  frm_ZweigProp: Tfrm_ZweigProp;

implementation

{$R *.dfm}

{ Tfrm_ZweigProp }

constructor Tfrm_ZweigProp.Create(AOwner: TComponent);
begin
  inherited;
  FZweigProp := Tof_ZweigProp.Create(Self, cNormal);
end;

destructor Tfrm_ZweigProp.Destroy;
begin
  FreeAndNil(FZweigProp);
  inherited;
end;

end.
