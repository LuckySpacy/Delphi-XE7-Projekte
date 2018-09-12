unit Form.Einstellung;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Objekt.Ini,
  Form.AkSt, Form.KurseLoeschen;

type
  Tfrm_Einstellung = class(TForm)
    pnl_Button: TPanel;
    btn_Pfad: TButton;
    btn_Schnittstelle: TButton;
    btn_AkSt: TButton;
    btn_KurseLoeschen: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_PfadClick(Sender: TObject);
    procedure btn_SchnittstelleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_AkStClick(Sender: TObject);
    procedure btn_KurseLoeschenClick(Sender: TObject);
  private
    procedure ShowPfad;
    procedure ShowSchnittstelle;
    procedure ShowAktieSchnittstelle;
    procedure ShowKurseLoeschen;
  public
  end;

var
  frm_Einstellung: Tfrm_Einstellung;

implementation

{$R *.dfm}

uses
  Form.Pfad, Form.Schnittstelle, Datamodul.TSI;



// Datenbank:
// C:\Users\TomBa\OneDrive\AppData\TSI\DB\TSI30.FDB




procedure Tfrm_Einstellung.FormCreate(Sender: TObject);
begin
  Ini := TIni.Create(nil);
end;

procedure Tfrm_Einstellung.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Ini);
end;

procedure Tfrm_Einstellung.FormShow(Sender: TObject);
begin
  dm.Connect;
end;

procedure Tfrm_Einstellung.btn_AkStClick(Sender: TObject);
begin
  ShowAktieSchnittstelle;
end;

procedure Tfrm_Einstellung.btn_KurseLoeschenClick(Sender: TObject);
begin
  ShowKurseLoeschen;
end;

procedure Tfrm_Einstellung.btn_PfadClick(Sender: TObject);
begin
  ShowPfad;
end;


procedure Tfrm_Einstellung.btn_SchnittstelleClick(Sender: TObject);
begin
  ShowSchnittstelle;
end;


procedure Tfrm_Einstellung.ShowAktieSchnittstelle;
var
  Form: Tfrm_AkSt;
begin
  Form := Tfrm_AkSt.Create(nil);
  try
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;
end;

procedure Tfrm_Einstellung.ShowKurseLoeschen;
var
  Form: Tfrm_KurseLoeschen;
begin
  Form := Tfrm_KurseLoeschen.Create(nil);
  try
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;

end;

procedure Tfrm_Einstellung.ShowPfad;
var
  Form: Tfrm_Pfad;
begin
  Form := Tfrm_Pfad.Create(nil);
  try
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;
end;

procedure Tfrm_Einstellung.ShowSchnittstelle;
var
  Form: Tfrm_Schnittstelle;
begin
  Form := Tfrm_Schnittstelle.Create(nil);
  try
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;

end;

end.
