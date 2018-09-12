unit fnt_Passwort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, tbButton, Vcl.ExtCtrls, Vcl.StdCtrls, of_Passwort;

type
  Tfrm_Passwort = class(TForm)
    pnl_Bottom: TPanel;
    btn_Ok: TTBButton;
    btn_Cancel: TTBButton;
    Label1: TLabel;
    edt_PW: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Fof_Passwort : Tof_Passwort;
  public
    property Passwort: Tof_Passwort read FOf_Passwort write FOf_Passwort;
  end;

var
  frm_Passwort: Tfrm_Passwort;

implementation

{$R *.dfm}

uses
  o_sysobj;

procedure Tfrm_Passwort.FormCreate(Sender: TObject);
begin
  Fof_Passwort := Tof_Passwort.Create(Self, sysobj.Akt.Modus);
end;

procedure Tfrm_Passwort.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FOf_Passwort);
end;

end.
