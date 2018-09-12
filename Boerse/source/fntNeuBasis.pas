unit fntNeuBasis;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  Tfrm_NeuBasis = class(TForm)
    pnl_Button: TPanel;
    cmd_Ok: TButton;
    cmd_Cancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmd_CancelClick(Sender: TObject);
  private
  protected
    FCancel: Boolean;
  public
  end;

var
  frm_NeuBasis: Tfrm_NeuBasis;

implementation

{$R *.dfm}

procedure Tfrm_NeuBasis.cmd_CancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_NeuBasis.FormCreate(Sender: TObject);
begin
  FCancel := true;
end;

end.
