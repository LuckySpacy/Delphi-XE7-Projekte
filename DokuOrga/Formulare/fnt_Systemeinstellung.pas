unit fnt_Systemeinstellung;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, of_Systemeinstellung;

type
  Tfrm_Systemeinstellung = class(TForm)
    lsb_Einstellung: TListBox;
    pnl_Client: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Fof_Systemeinstellung: Tof_Systemeinstellung;
  public
  end;

var
  frm_Systemeinstellung: Tfrm_Systemeinstellung;

implementation

{$R *.dfm}

uses
  o_sysobj;

procedure Tfrm_Systemeinstellung.FormCreate(Sender: TObject);
begin
  Fof_Systemeinstellung := Tof_Systemeinstellung.Create(Self, sysobj.akt.Modus);
end;

procedure Tfrm_Systemeinstellung.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Fof_Systemeinstellung);
end;

end.
