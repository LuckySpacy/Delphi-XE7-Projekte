program Smartwatch;

uses
  Vcl.Forms,
  Form.Smartwatch in 'Form\Form.Smartwatch.pas' {frm_Smartwatch},
  dm.Datenmodul in 'Form\dm.Datenmodul.pas' {dam: TDataModule},
  Form.Eigenschaft in 'Form\Form.Eigenschaft.pas' {frm_Eigenschaft},
  Objekt.IniEinstellung in 'Objekt\Objekt.IniEinstellung.pas',
  Objekt.Smartwatch in 'Objekt\Objekt.Smartwatch.pas',
  Objekt.Verschluesseln in 'Objekt\Objekt.Verschluesseln.pas',
  Objekt.Logger in 'Objekt\Objekt.Logger.pas',
  Objekt.Ini in 'Objekt\Objekt.Ini.pas',
  Objekt.Filefunction in 'Objekt\Objekt.Filefunction.pas',
  Objekt.Folderlocation in 'Objekt\Objekt.Folderlocation.pas',
  c.Folder in 'const\c.Folder.pas',
  Objekt.BaseList in 'Objekt\Objekt.BaseList.pas',
  DB.Base in 'Datenbank\DB.Base.pas',
  DB.Eigenschaft in 'Datenbank\DB.Eigenschaft.pas',
  DB.BaseList in 'Datenbank\DB.BaseList.pas',
  DB.EigenschaftList in 'Datenbank\DB.EigenschaftList.pas',
  DB.Artikel in 'Datenbank\DB.Artikel.pas',
  DB.ArtikelList in 'Datenbank\DB.ArtikelList.pas',
  DB.FirmaArtikel in 'Datenbank\DB.FirmaArtikel.pas',
  View.Artikel in 'View\View.Artikel.pas',
  View.ArtikelList in 'View\View.ArtikelList.pas',
  Form.Artikel in 'Form\Form.Artikel.pas' {frm_Artikel},
  Form.Memo in 'Form\Form.Memo.pas' {frm_Memo},
  Form.Artikeleigenschaft in 'Form\Form.Artikeleigenschaft.pas' {frm_Artikeleigenschaft},
  DB.ArtikelEigenschaft in 'Datenbank\DB.ArtikelEigenschaft.pas',
  Form.Artikeleigenschaft2 in 'Form\Form.Artikeleigenschaft2.pas' {frm_Artikeleigenschaft2},
  View.Eigenschaft in 'View\View.Eigenschaft.pas',
  View.EigenschaftList in 'View\View.EigenschaftList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_Smartwatch, frm_Smartwatch);
  Application.CreateForm(Tfrm_Artikeleigenschaft2, frm_Artikeleigenschaft2);
  //Application.CreateForm(Tdm, dm);
  Application.Run;
end.
