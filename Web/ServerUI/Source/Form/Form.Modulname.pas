unit Form.Modulname;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  Tfrm_Modulname = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    btn_Speichern: TButton;
    btn_Abbrechen: TButton;
    edt_Modulname: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_AbbrechenClick(Sender: TObject);
    procedure btn_SpeichernClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fCancel: Boolean;
  public
    property Cancel: Boolean read fCancel;
  end;

var
  frm_Modulname: Tfrm_Modulname;

implementation

{$R *.dfm}



procedure Tfrm_Modulname.FormCreate(Sender: TObject);
begin
  fCancel := true;
  edt_Modulname.Text := '';
end;

procedure Tfrm_Modulname.FormShow(Sender: TObject);
begin
  edt_Modulname.SetFocus;
end;

procedure Tfrm_Modulname.btn_AbbrechenClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_Modulname.btn_SpeichernClick(Sender: TObject);
begin
  fCancel := false;
  close;
end;


end.
