unit Form.KommentarEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, nfsButton, Vcl.StdCtrls, Vcl.ExtCtrls, IBX.IBDatabase,
  Frame.Font, Model.Kommentar, Objekt.Font;

type
  Tfrm_KommentarEdit = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edt_Startzeichen: TEdit;
    Label2: TLabel;
    edt_Endezeichen: TEdit;
    pnl_Client: TPanel;
    Panel3: TPanel;
    btn_Speichern: TnfsButton;
    btn_Abbrechen: TnfsButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_AbbrechenClick(Sender: TObject);
    procedure btn_SpeichernClick(Sender: TObject);
  private
    fFrameFont: Tfra_Font;
    fSortIndex: Integer;
    fTrans : TIBTransaction;
    fKommentar: TKommentar;
    fFontObj: TFontObj;
  public
    procedure setKommentarId(aId: Integer);
    procedure setSortIndex(aId: Integer);
    procedure setTrans(aTrans: TIBTransaction);
  end;

var
  frm_KommentarEdit: Tfrm_KommentarEdit;

implementation

{$R *.dfm}



procedure Tfrm_KommentarEdit.FormCreate(Sender: TObject);
begin
  edt_Startzeichen.Text := '';
  edt_Endezeichen.Text  := '';
  fFrameFont := Tfra_Font.Create(nil);
  fFrameFont.Parent := pnl_Client;
  fFrameFont.Align  := alClient;
  fTrans := nil;
  fSortIndex := -1;
  fKommentar := TKommentar.Create(nil);
  fFontObj := TFontObj.Create;
end;

procedure Tfrm_KommentarEdit.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fFrameFont);
  FreeAndNil(fKommentar);
  FreeAndNil(fFontObj);
end;

procedure Tfrm_KommentarEdit.setKommentarId(aId: Integer);
begin
  fKommentar.Read(aId);
  fFontObj.FontStr := fKommentar.Font;
  edt_Startzeichen.Text := fKommentar.StartZeichen;
  edt_Endezeichen.Text  := fKommentar.EndeZeichen;
end;

procedure Tfrm_KommentarEdit.setSortIndex(aId: Integer);
begin
  fSortIndex := aId;
end;

procedure Tfrm_KommentarEdit.setTrans(aTrans: TIBTransaction);
begin
  fTrans := aTrans;
  fKommentar.Trans := fTrans;
end;

procedure Tfrm_KommentarEdit.btn_AbbrechenClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_KommentarEdit.btn_SpeichernClick(Sender: TObject);
begin
  FKommentar.StartZeichen := edt_Startzeichen.Text;
  FKommentar.EndeZeichen  := edt_Endezeichen.Text;
  fKommentar.Font         := fFontObj.FontStr;
  if fSortIndex > -1 then
    fKommentar.Sort := fSortIndex;
  fKommentar.SaveToDB;
  close;
end;



end.
