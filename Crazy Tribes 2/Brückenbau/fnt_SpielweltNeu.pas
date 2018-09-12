unit fnt_SpielweltNeu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, tbButton, Vcl.StdCtrls;

type
  Tfrm_SpielweltNeu = class(TForm)
    Label1: TLabel;
    edt_Name: TEdit;
    btn_Schliessen: TTBButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_SchliessenClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frm_SpielweltNeu: Tfrm_SpielweltNeu;

implementation

{$R *.dfm}


procedure Tfrm_SpielweltNeu.FormCreate(Sender: TObject);
begin
  edt_Name.Text := '';
end;

procedure Tfrm_SpielweltNeu.btn_SchliessenClick(Sender: TObject);
begin
  close;
end;


end.
