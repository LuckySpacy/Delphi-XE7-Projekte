unit fnt_Passwort_festlegen;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, tbButton, Vcl.ExtCtrls, of_Passwort_festlegen;

type
  Tfrm_Passwort_festlegen = class(TForm)
    pnl_Bottom: TPanel;
    btn_Ok: TTBButton;
    btn_Cancel: TTBButton;
    Label1: TLabel;
    edt_PW: TEdit;
    Label2: TLabel;
    edt_PW2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Fof_Passwort_festlegen: Tof_Passwort_festlegen;
  public
    property Passwort: Tof_Passwort_festlegen read Fof_Passwort_festlegen write Fof_Passwort_festlegen;
  end;

var
  frm_Passwort_festlegen: Tfrm_Passwort_festlegen;

implementation

{$R *.dfm}

procedure Tfrm_Passwort_festlegen.FormCreate(Sender: TObject);
begin
  Fof_Passwort_festlegen := Tof_Passwort_festlegen.Create(Self);
end;

procedure Tfrm_Passwort_festlegen.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Fof_Passwort_festlegen);
end;

end.
