unit Form.BoersenindexBearb;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, DBObj.Boersenindex;

type
  Tfrm_BoersenindexBearb = class(TForm)
    Börsenindex: TLabel;
    edt_Bezeichnung: TEdit;
    Panel1: TPanel;
    btn_Ok: TButton;
    btn_Cancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
  private
    fCancel: Boolean;
    fBoersenindex: TBoersenindex;
    fBI_ID: Integer;
    procedure setBI_ID(const Value: Integer);
  public
    property Cancel: Boolean read fCancel;
    property BI_ID: Integer read fBI_ID write setBI_ID;
  end;

var
  frm_BoersenindexBearb: Tfrm_BoersenindexBearb;

implementation

{$R *.dfm}

uses
  Datamodul.TSIKurse;



procedure Tfrm_BoersenindexBearb.FormCreate(Sender: TObject);
begin
  fCancel := true;
  fBoersenindex := TBoersenindex.Create(nil);
  fBoersenindex.Trans := dm.IBT;
  edt_Bezeichnung.Text := '';
end;

procedure Tfrm_BoersenindexBearb.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fBoersenindex);
end;

procedure Tfrm_BoersenindexBearb.setBI_ID(const Value: Integer);
begin
  fBI_ID := Value;
  fBoersenindex.Read(fBI_Id);
  edt_Bezeichnung.Text := fBoersenindex.Bezeichnung;
end;

procedure Tfrm_BoersenindexBearb.btn_CancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_BoersenindexBearb.btn_OkClick(Sender: TObject);
begin
  fCancel := false;
  fBoersenindex.Bezeichnung := edt_Bezeichnung.Text;
  fBoersenindex.SaveToDB;
  close;
end;


end.
