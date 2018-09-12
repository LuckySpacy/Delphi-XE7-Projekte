unit fnt_MasterPW;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, fr_konf_masterpw, tbButton;

type
  Tfrm_MasterPW = class(TForm)
    Panel1: TPanel;
    btn_Cancel: TTBButton;
    btn_Ok: TTBButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
  private
    FFrame_MasterPW: Tfra_Konf_MasterPW;
  public
  end;

var
  frm_MasterPW: Tfrm_MasterPW;

implementation

{$R *.dfm}



procedure Tfrm_MasterPW.FormCreate(Sender: TObject);
begin
  FFrame_MasterPW := Tfra_Konf_MasterPW.Create(Self);
  FFrame_MasterPW.Parent := Self;
  FFRame_MasterPW.Align  := alClient;
end;

procedure Tfrm_MasterPW.btn_CancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_MasterPW.btn_OkClick(Sender: TObject);
begin
  close;
end;


end.
