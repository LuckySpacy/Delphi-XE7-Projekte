unit fnt_Dialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, tbButton, Vcl.ExtCtrls, of_Dialog;

type
  Tfrm_Dialog = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btn_Ok: TTBButton;
    btn_Cancel: TTBButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FDialog: Tof_Dialog;
    function getCancel: Boolean;
  public
    property Cancel: Boolean read getCancel;
  end;

var
  frm_Dialog: Tfrm_Dialog;

implementation

{$R *.dfm}

uses
  c_types;

procedure Tfrm_Dialog.FormCreate(Sender: TObject);
begin
  FDialog := Tof_Dialog.Create(Self, cNormal);
end;

procedure Tfrm_Dialog.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FDialog);
end;

function Tfrm_Dialog.getCancel: Boolean;
begin
  Result := FDialog.Cancel;
end;

end.
