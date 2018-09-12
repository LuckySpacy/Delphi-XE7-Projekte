unit fnt_DialogDokumentBez;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fnt_Dialog, tbButton, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  Tfrm_DialogDokumentBez = class(Tfrm_Dialog)
    edt_Bez: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edt_Dateiname: TEdit;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frm_DialogDokumentBez: Tfrm_DialogDokumentBez;

implementation

{$R *.dfm}

end.
