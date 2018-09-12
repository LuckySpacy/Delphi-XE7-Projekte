unit fntGutschrift;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, ComCtrls;

type
  Tfrm_Gutschrift = class(TForm)
    pnl_Button: TPanel;
    cmd_Ok: TButton;
    cmd_Cancel: TButton;
    Label4: TLabel;
    Label1: TLabel;
    edt_Datum: TDateTimePicker;
    Label2: TLabel;
    edt_Stueck: TSpinEdit;
    Label7: TLabel;
    edt_Wert: TEdit;
    edt_Aktie: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure cmd_OkClick(Sender: TObject);
    procedure cmd_CancelClick(Sender: TObject);
  private
    FCancel: Boolean;
  public
    property Cancel: Boolean read FCancel;
  end;

var
  frm_Gutschrift: Tfrm_Gutschrift;

implementation

{$R *.dfm}


procedure Tfrm_Gutschrift.FormCreate(Sender: TObject);
begin
  FCancel := true;
  edt_Datum.DateTime := trunc(now);
end;

procedure Tfrm_Gutschrift.cmd_CancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_Gutschrift.cmd_OkClick(Sender: TObject);
begin
  FCancel := false;
  close;
end;


end.
