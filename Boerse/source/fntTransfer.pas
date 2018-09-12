unit fntTransfer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fntNeuBasis, StdCtrls, ExtCtrls, frameTransfer;

type
  Tfrm_Transfer = class(Tfrm_NeuBasis)
    procedure FormCreate(Sender: TObject);
    procedure cmd_OkClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FraTransfer: Tfra_Transfer;
  public
  end;

var
  frm_Transfer: Tfrm_Transfer;

implementation

{$R *.dfm}

procedure Tfrm_Transfer.cmd_OkClick(Sender: TObject);
begin
  inherited;
  FraTransfer.Save;
  Close;
end;

procedure Tfrm_Transfer.FormCreate(Sender: TObject);
begin
  inherited;
  FraTransfer := Tfra_Transfer.Create(Self);
  FraTransfer.Parent := Self;
  FraTransfer.Align  := alClient;
end;

procedure Tfrm_Transfer.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FraTransfer);
  inherited;
end;


end.
