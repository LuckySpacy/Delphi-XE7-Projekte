unit Form.Smartwatch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, tbButton, Vcl.ExtCtrls, Form.Eigenschaft,
  Objekt.Smartwatch, Form.Artikel, Form.Artikeleigenschaft, Contnrs;

type
  Tfrm_Smartwatch = class(TForm)
    Panel1: TPanel;
    pnl_Client: TPanel;
    btn_Eigenschaft: TTBButton;
    btn_Artikel: TTBButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_EigenschaftClick(Sender: TObject);
    procedure btn_ArtikelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    fFormEigenschaft: Tfrm_Eigenschaft;
    fFormArtikel: Tfrm_Artikel;
    fFormArtikelEigenschaft: Tfrm_ArtikelEigenschaft;
    fFormList: TList;
    fFormIniFile: string;
    procedure ShowEigenschaft;
    procedure ShowArtikel;
    procedure ShowArtikelEigenschaft(aArId: Integer);
    procedure ArNrDblClick(aArId: Integer);
    procedure setAllFormsUnvisble;
  public
  end;

var
  frm_Smartwatch: Tfrm_Smartwatch;

implementation

{$R *.dfm}

uses
  dm.Datenmodul;


procedure Tfrm_Smartwatch.FormCreate(Sender: TObject);
begin
  dam := TDAM.Create(Self);
  fFormEigenschaft := nil;
  fFormArtikel := nil;
  fFormArtikelEigenschaft := nil ;
  Smartwatch := TSmartwatch.Create;
  fFormIniFile := Smartwatch.FormIni;
  fFormList := TList.Create;
end;

procedure Tfrm_Smartwatch.FormDestroy(Sender: TObject);
begin
  if fFormEigenschaft <> nil then
    FreeAndNil(fFormEigenschaft);
  if fFormArtikel <> nil then
    FreeAndNil(fFormArtikel);
  if fFormArtikelEigenschaft <> nil then
    FreeAndNil(fFormArtikelEigenschaft);
  FreeAndNil(dam);
  FreeAndNil(Smartwatch);
  FreeAndNil(fFormList);
end;

procedure Tfrm_Smartwatch.FormShow(Sender: TObject);
var
  iWidth: Integer;
  iHeight: Integer;
begin
  dam.Connect;
  iWidth  := StrToInt(Smartwatch.Ini.ReadIni(fFormIniFile, Self.Name, 'Width', '0'));
  iHeight := StrToInt(Smartwatch.Ini.ReadIni(fFormIniFile, Self.Name, 'Height', '0'));
  if iWidth > 100 then
    Width := iWidth;
  if iHeight > 100 then
    Height := iHeight;
end;

procedure Tfrm_Smartwatch.setAllFormsUnvisble;
var
  i1: Integer;
begin
  for i1 := 0 to fFormList.Count -1 do
    TForm(fFormList.Items[i1]).visible := false;
end;

procedure Tfrm_Smartwatch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Smartwatch.Ini.WriteIni(fFormIniFile, self.Name, 'Width', IntToStr(Self.Width));
  Smartwatch.Ini.WriteIni(fFormIniFile, self.Name, 'Height', IntToStr(Self.Height));
end;


procedure Tfrm_Smartwatch.ShowArtikel;
begin
  setAllFormsUnvisble;
  if fFormArtikel = nil then
  begin
    fFormArtikel := Tfrm_Artikel.Create(nil);
    fFormArtikel.SaId := 1; // Smartwatch
    fFormArtikel.Parent := pnl_Client;
    fFormArtikel.Align := alClient;
    fFormArtikel.OnArtNrDblClick := ArNrDblClick;
    fFormList.Add(fFormArtikel);
  end;
  fFormArtikel.Show;
end;

procedure Tfrm_Smartwatch.ShowArtikelEigenschaft(aArId: Integer);
begin
  setAllFormsUnvisble;
  if fFormArtikelEigenschaft = nil then
  begin
    fFormArtikelEigenschaft := Tfrm_ArtikelEigenschaft.Create(nil);
    fFormArtikelEigenschaft.Parent := pnl_Client;
    fFormArtikelEigenschaft.Align := alClient;
    fFormList.Add(fFormArtikelEigenschaft);
  end;
  fFormArtikelEigenschaft.ArId := aArId;
  fFormArtikelEigenschaft.Show;
end;

procedure Tfrm_Smartwatch.ShowEigenschaft;
begin
  setAllFormsUnvisble;
  if fFormEigenschaft = nil then
  begin
    fFormEigenschaft := Tfrm_Eigenschaft.Create(nil);
    fFormEigenschaft.Parent := pnl_Client;
    fFormEigenschaft.Align := alClient;
    fFormList.Add(fFormEigenschaft);
  end;
  fFormEigenschaft.Show;

end;

procedure Tfrm_Smartwatch.ArNrDblClick(aArId: Integer);
begin
  ShowArtikelEigenschaft(aArId);
end;

procedure Tfrm_Smartwatch.btn_ArtikelClick(Sender: TObject);
begin
  ShowArtikel;
end;

procedure Tfrm_Smartwatch.btn_EigenschaftClick(Sender: TObject);
begin
  ShowEigenschaft;
end;

end.
