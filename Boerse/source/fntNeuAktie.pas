unit fntNeuAktie;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fntNeuBasis, StdCtrls, ExtCtrls, frame_NeueAktie;

type
  Tfrm_NeuAktie = class(Tfrm_NeuBasis)
    procedure FormCreate(Sender: TObject);
    procedure cmd_OkClick(Sender: TObject);
  private
    FraAktie: Tfra_NeueAktie;
  public
  end;

var
  frm_NeuAktie: Tfrm_NeuAktie;

implementation

{$R *.dfm}

procedure Tfrm_NeuAktie.cmd_OkClick(Sender: TObject);
begin
  inherited;
  FraAktie.Save;
  FCancel := false;
  close;
end;

procedure Tfrm_NeuAktie.FormCreate(Sender: TObject);
begin
  inherited;
  FraAktie := Tfra_NeueAktie.Create(Self);
  FraAktie.Parent := Self;
  FraAktie.Align  := alClient;
end;

end.
