unit Form.TSI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Objekt.Global, Datamodul.TSI,
  Vcl.ExtCtrls, Vcl.StdCtrls, Frame.Konf, Contnrs, Frame.Aktie, Frame.Kurse;

type
  Tfrm_TSI = class(TForm)
    Panel1: TPanel;
    btn_Aktie: TButton;
    btn_Einstellung: TButton;
    btn_KurseLaden: TButton;
    btn_KurseAnzeigen: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_EinstellungClick(Sender: TObject);
    procedure btn_KurseLadenClick(Sender: TObject);
    procedure btn_AktieClick(Sender: TObject);
    procedure btn_KurseAnzeigenClick(Sender: TObject);
  private
    fFrameList: TObjectList;
    fFrameKonf: Tfra_Konf;
    fFrameAktie: Tfra_Aktie;
    fFrameKurse: Tfra_Kurse;
    procedure ClearFrames;
    procedure ShowKurseLaden;
  public
  end;

var
  frm_TSI: Tfrm_TSI;

implementation

{$R *.dfm}

uses
  Objekt.Aktienimport, Form.KurseLaden;

procedure Tfrm_TSI.FormCreate(Sender: TObject);
begin //
  Global := TGlobal.Create(nil);
  fFrameList := TObjectList.Create;
  fFrameKonf := nil;
  fFrameAktie := nil;
  fFrameKurse := nil;
  dm.connect;
end;

procedure Tfrm_TSI.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fFrameList);
  FreeAndNil(Global);
end;



procedure Tfrm_TSI.btn_AktieClick(Sender: TObject);
begin
  ClearFrames;
  if fFrameAktie = nil then
  begin
    fFrameAktie := Tfra_Aktie.Create(nil);
    fFrameAktie.Parent := Self;
    fFrameAktie.Align  := alClient;
    fFrameList.Add(fFrameAktie);
  end;
  fFrameAktie.Visible := true;
end;

procedure Tfrm_TSI.btn_EinstellungClick(Sender: TObject);
begin
  ClearFrames;
  if fFrameKonf = nil then
  begin
    fFrameKonf := Tfra_Konf.Create(nil);
    fFrameKonf.Parent := Self;
    fFrameKonf.Align  := alClient;
    fFrameList.Add(fFrameKonf);
  end;
  fFrameKonf.Visible := true;
end;

procedure Tfrm_TSI.btn_KurseAnzeigenClick(Sender: TObject);
begin
  ClearFrames;
  if fFrameKurse = nil then
  begin
    fFrameKurse := Tfra_Kurse.Create(nil);
    fFrameKurse.Parent := Self;
    fFrameKurse.Align  := alClient;
    fFrameList.Add(fFrameKurse);
  end;
  fFrameKurse.Visible := true;
end;

procedure Tfrm_TSI.btn_KurseLadenClick(Sender: TObject);
begin
  if MessageDlg('Möchtest du wirklich alle Kurse einlesen?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    ShowKurseLaden;
end;

procedure Tfrm_TSI.ClearFrames;
var
  i1: Integer;
  x: TFrame;
begin
  for i1 := 0 to fFrameList.Count -1 do
  begin
    x := TFrame(fFrameList.Items[i1]);
    if x <> nil then
      x.Visible := false;
  end;
end;


procedure Tfrm_TSI.ShowKurseLaden;
var
  Form: Tfrm_KurseLaden;
begin
  Form := Tfrm_KurseLaden.Create(Self);
  try
    Form.doAktienImport := true;
    Form.doKurseImport := true;
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;

end;


end.
