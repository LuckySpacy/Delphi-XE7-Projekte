unit Form.KurseLaden;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Frame.Aktie, Objekt.Global, Frame.Konf, Datamodul.tsikurse, Frame.Schnittstelle,
  Frame.KurseLaden;

type
  Tfrm_KurseLaden = class(TForm)
    Panel1: TPanel;
    btn_Aktie: TButton;
    btn_Einstellung: TButton;
    btn_Schnittstelle: TButton;
    btn_KurseLaden: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_AktieClick(Sender: TObject);
    procedure btn_EinstellungClick(Sender: TObject);
    procedure btn_SchnittstelleClick(Sender: TObject);
    procedure btn_KurseLadenClick(Sender: TObject);
  private
    fFrameAktie: Tfra_Aktie;
    fFrameKonf: Tfra_Konf;
    fFrameSchnittstelle: Tfra_Schnittstelle;
    fFrameKurseLaden: Tfra_KurseLaden;
    fFrameList: TList;
    procedure ClearFrames;
  public
  end;

var
  frm_KurseLaden: Tfrm_KurseLaden;

implementation

{$R *.dfm}



procedure Tfrm_KurseLaden.FormCreate(Sender: TObject);
begin
  Global := TGlobal.Create(nil);
  fFrameKonf := nil;
  fFrameSchnittstelle := nil;
  fFrameAktie := nil;
  fFrameKurseLaden := nil;
  fFrameList := TList.Create;

  dm.connect;
end;

procedure Tfrm_KurseLaden.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fFrameList);
  if fFrameAktie <> nil then
    FreeAndNil(fFrameAktie);
  if fFrameKonf <> nil then
    FreeAndNil(fFrameKonf);
  if fFrameSchnittstelle <> nil then
    FreeAndNil(fFrameSchnittstelle);
  if fFrameKurseLaden <> nil then
    FreeAndNil(fFrameKurseLaden);
  FreeAndNil(Global);
end;

procedure Tfrm_KurseLaden.btn_AktieClick(Sender: TObject);
begin
  ClearFrames;

  if fFrameAktie = nil then
  begin
    fFrameAktie := Tfra_Aktie.Create(nil);
    fFrameAktie.Parent  := Self;
    fFrameAktie.Align   := alClient;
    fFrameList.Add(fFrameAktie);
    fFrameAktie.LadeGrid;
    fFrameAktie.LadeBoersenindex;
  end;

  fFrameAktie.Visible := true;
  fFrameAktie.LadeGrid;
end;

procedure Tfrm_KurseLaden.btn_EinstellungClick(Sender: TObject);
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

procedure Tfrm_KurseLaden.btn_KurseLadenClick(Sender: TObject);
begin

  ClearFrames;
  if fFrameKurseLaden = nil then
  begin
    fFrameKurseLaden := Tfra_KurseLaden.Create(nil);
    fFrameKurseLaden.Parent := Self;
    fFrameKurseLaden.Align  := alClient;
    fFrameKurseLaden.LadeCombobox;
    fFrameList.Add(fFrameKurseLaden);
  end;
  fFrameKurseLaden.Visible := true;
end;

procedure Tfrm_KurseLaden.btn_SchnittstelleClick(Sender: TObject);
begin
  ClearFrames;
  if fFrameSchnittstelle = nil then
  begin
    fFrameSchnittstelle := Tfra_Schnittstelle.Create(nil);
    fFrameSchnittstelle.Parent := Self;
    fFrameSchnittstelle.Align  := alClient;
    fFrameSchnittstelle.LadeCombobox;
    fFrameList.Add(fFrameSchnittstelle);
  end;
  fFrameSchnittstelle.Visible := true;
end;

procedure Tfrm_KurseLaden.ClearFrames;
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



end.
