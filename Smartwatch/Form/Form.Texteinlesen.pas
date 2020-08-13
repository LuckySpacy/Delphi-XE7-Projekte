unit Form.Texteinlesen;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, tbButton, Vcl.StdCtrls, Vcl.ExtCtrls,
  DB.Artikel, Objekt.TextEinlesen;

type
  Tfrm_TextEinlesen = class(TForm)
    pnl_Artikel: TPanel;
    Memo1: TMemo;
    btn_Starten: TTBButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_StartenClick(Sender: TObject);
  private
    fArId: Integer;
    fArtikel: TDBArtikel;
    fTextEinlesen: TTextEinlesen;
    fUpdateTime: TDateTime;
    procedure ShowUebersicht;
  public
    property ArId: Integer read fArId write fArId;
    property UpdateTime: TDateTime read fUpdateTime write fUpdateTime;
  end;

var
  frm_TextEinlesen: Tfrm_TextEinlesen;

implementation

{$R *.dfm}

uses
  Form.ArtikeleigenschaftUebersicht;

procedure Tfrm_TextEinlesen.btn_StartenClick(Sender: TObject);
begin
  fTextEinlesen.ArId := fArId;
  fTextEinlesen.EigenschaftText := Memo1.Text;
  fTextEinlesen.UpdateTime := fUpdateTime;
  fTextEinlesen.Start;
  fArtikel.ErsetzText := Memo1.Text;
  fArtikel.Save;
  ShowUebersicht;
end;

procedure Tfrm_TextEinlesen.FormCreate(Sender: TObject);
begin
  fArtikel := TDBArtikel.Create(nil);
  fTextEinlesen := TTextEinlesen.Create;
end;

procedure Tfrm_TextEinlesen.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fArtikel);
  FreeAndNil(fTextEinlesen);
end;

procedure Tfrm_TextEinlesen.FormShow(Sender: TObject);
begin
  fArtikel.Read(fArId);
  pnl_Artikel.Caption := fArtikel.Match;
  Memo1.Text := fArtikel.ErsetzText;
end;

procedure Tfrm_TextEinlesen.ShowUebersicht;
var
  Form: Tfrm_ArtikeleigenschaftUebersicht;
begin
  Form := Tfrm_ArtikeleigenschaftUebersicht.Create(nil);
  try
    Form.ArId := fArId;
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;
end;

end.
