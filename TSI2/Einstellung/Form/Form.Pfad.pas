unit Form.Pfad;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvEdit, AdvEdBtn,
  AdvDirectoryEdit, AdvFileNameEdit;

type
  Tfrm_Pfad = class(TForm)
    Label1: TLabel;
    edt_DatenbankTSI: TAdvFileNameEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frm_Pfad: Tfrm_Pfad;

implementation

{$R *.dfm}

uses
  Objekt.Ini;


procedure Tfrm_Pfad.FormCreate(Sender: TObject);
begin
  edt_DatenbankTSI.Text := Ini.TSIFDB;
end;

procedure Tfrm_Pfad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Ini.TSIFDB := edt_DatenbankTSI.Text;
end;


end.
