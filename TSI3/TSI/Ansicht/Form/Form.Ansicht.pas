unit Form.Ansicht;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Frame.Ansicht,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Objekt.Global,
  Vcl.StdCtrls, Frame.Kurs;

type
  Tfrm_TsiAnsicht = class(TForm)
    PageControl1: TPageControl;
    tbs_TSI: TTabSheet;
    tbs_Kurs: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AktieDblClick(Sender: TObject; aAK_ID: Integer; aWKN, aAktie: string);
  private
    fAnsicht: Tfra_Ansicht;
    fKurs: Tfra_Kurs;
  public
  end;

var
  frm_TsiAnsicht: Tfrm_TsiAnsicht;

implementation

{$R *.dfm}


procedure Tfrm_TsiAnsicht.FormCreate(Sender: TObject);
begin
  Global := TGlobal.Create;
  fAnsicht := Tfra_Ansicht.Create(Self);
  fAnsicht.Parent := tbs_TSI;
  fAnsicht.OnAktieDblClick := AktieDblClick;
  fAnsicht.Align := alClient;
  fKurs := Tfra_Kurs.Create(Self);
  fKurs.Parent := tbs_Kurs;
  fKurs.Align  := alClient;
end;

procedure Tfrm_TsiAnsicht.FormDestroy(Sender: TObject);
begin  //
  FreeAndNil(Global);
end;

procedure Tfrm_TsiAnsicht.FormShow(Sender: TObject);
begin
  fAnsicht.LeseDaten;
  fKurs.LadeDaten;
end;

procedure Tfrm_TsiAnsicht.AktieDblClick(Sender: TObject; aAK_ID: Integer; aWKN, aAktie: string);
begin
  PageControl1.ActivePage := tbs_Kurs;
  fKurs.LoadKurs(Self, aAK_Id, aWKN, aAktie);
end;


end.
