unit Form.SchnittstelleBearb;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBObj.Schnittstelle, DBObj.SchnittstelleList,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  Tfrm_SchnittstelleBearb = class(TForm)
    Börsenindex: TLabel;
    edt_Bezeichnung: TEdit;
    Panel1: TPanel;
    btn_Ok: TButton;
    btn_Cancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
  private
    fSchnittstelle: TSchnittstelle;
    fCancel: Boolean;
    fSS_ID: Integer;
    procedure setSS_ID(const Value: Integer);
  public
    property Cancel: Boolean read fCancel;
    property SS_ID: Integer read fSS_ID write setSS_ID;
  end;

var
  frm_SchnittstelleBearb: Tfrm_SchnittstelleBearb;

implementation

{$R *.dfm}

uses
  Datamodul.TSI;



procedure Tfrm_SchnittstelleBearb.FormCreate(Sender: TObject);
begin
  fCancel := true;
  fSchnittstelle := TSchnittstelle.Create(nil);
  fSchnittstelle.Trans := dm.IBT;
  edt_Bezeichnung.Text := '';
end;

procedure Tfrm_SchnittstelleBearb.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fSchnittstelle);
end;

procedure Tfrm_SchnittstelleBearb.setSS_ID(const Value: Integer);
begin
  fSS_ID := Value;
  fSchnittstelle.Read(fSS_Id);
  edt_Bezeichnung.Text := fSchnittstelle.Bezeichnung;
end;

procedure Tfrm_SchnittstelleBearb.btn_CancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_SchnittstelleBearb.btn_OkClick(Sender: TObject);
begin
  fCancel := false;
  fSchnittstelle.Bezeichnung := edt_Bezeichnung.Text;
  fSchnittstelle.SaveToDB;
  close;
end;



end.
