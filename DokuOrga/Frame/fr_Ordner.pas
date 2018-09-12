unit fr_Ordner;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fr_Base, obBusinessClasses, obServerClient, of_Ordner, c_types;

type
  Tfra_Ordner = class(Tfrm_Base, IObServerClient)
    ScrollBox: TScrollBox;
  private
    FOrdner: Tof_Ordner;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    property Ordner: Tof_Ordner read FOrdner write FOrdner;
  end;

var
  fra_Ordner: Tfra_Ordner;

implementation

{$R *.dfm}

{ Tfra_Ordner }

constructor Tfra_Ordner.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  FOrdner := Tof_Ordner.Create(Self, AMode);
end;

destructor Tfra_Ordner.Destroy;
begin
  FreeAndNil(FOrdner);
  inherited;
end;

end.
