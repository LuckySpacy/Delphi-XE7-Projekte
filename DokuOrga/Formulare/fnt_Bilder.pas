unit fnt_Bilder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fnt_DialogBase, tbButton, ExtCtrls, Grids, tbStringGrid, of_Bilder,
  ExtDlgs;

type
  Tfrm_Bilder = class(Tfrm_DialogBase)
    Grid: TtbStringGrid;
    OpenPictureDialog1: TOpenPictureDialog;
    btn_Add: TTBButton;
    Image: TImage;
  private
    FBilder: Tof_Bilder;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Bilder: Tof_Bilder read FBilder write FBilder;
  end;

var
  frm_Bilder: Tfrm_Bilder;

implementation

{$R *.dfm}

{ Tfrm_Bilder }

uses
  o_sysobj;

constructor Tfrm_Bilder.Create(AOwner: TComponent);
begin
  inherited;
  FBilder := Tof_Bilder.Create(Self, sysobj.Akt.Modus);
end;

destructor Tfrm_Bilder.Destroy;
begin
  FreeAndNil(FBilder);
  inherited;
end;


end.
