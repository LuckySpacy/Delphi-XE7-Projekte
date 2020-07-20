program DokuOrgaWeb;

uses
  FastMM4 in '..\Log4d\FastMM\FastMM4.pas',
  FastMM4Messages in '..\Log4d\FastMM\Translations\German\by Thomas Speck\FastMM4Messages.pas',
  Vcl.Forms,
  Form.DokuOrga in 'Form\Form.DokuOrga.pas' {frm_DokuOrga},
  Objekt.DokuOrga in 'Objekt\Objekt.DokuOrga.pas',
  Objekt.Verschluesseln in 'Objekt\Objekt.Verschluesseln.pas',
  Objekt.Logger in 'Objekt\Objekt.Logger.pas',
  Objekt.WebClient in 'Objekt\Objekt.WebClient.pas',
  WebQuery in 'Komponenten\WebQuery\WebQuery.pas',
  WebDB.Basis in 'WebDB\WebDB.Basis.pas',
  Objekt.DBFeld in 'Objekt\Objekt.DBFeld.pas',
  Objekt.DBFeldList in 'Objekt\Objekt.DBFeldList.pas',
  Objekt.BasisList in 'Objekt\Objekt.BasisList.pas',
  WebDB.BasisList in 'WebDB\WebDB.BasisList.pas',
  Form.Ordner in 'Form\Form.Ordner.pas' {frm_Ordner},
  Objekt.WebserverIni in 'Objekt\Objekt.WebserverIni.pas',
  Objekt.Ini in 'Objekt\Objekt.Ini.pas',
  TBQuery in 'Komponenten\TBQuery\TBQuery.pas',
  DB.Basis in 'Datenbank\DB.Basis.pas',
  DB.IBBasisList in 'Datenbank\IB\DB.IBBasisList.pas',
  c.Historie in 'const\c.Historie.pas',
  DB.IBZugriff in 'Datenbank\IB\DB.IBZugriff.pas',
  DB.SqlStatement in 'Datenbank\DB.SqlStatement.pas',
  TBTrans in 'Komponenten\TBQuery\TBTrans.pas',
  DB.Historie in 'Datenbank\DB.Historie.pas',
  DB.Historietext in 'Datenbank\DB.Historietext.pas',
  DB.BasisHistorie in 'Datenbank\DB.BasisHistorie.pas',
  DB.Benutzer in 'Datenbank\DB.Benutzer.pas',
  DB.IBDatenbank in 'Datenbank\IB\DB.IBDatenbank.pas',
  Objekt.IniEinstellung in 'Objekt\Objekt.IniEinstellung.pas',
  Objekt.Filefunction in 'Objekt\Objekt.Filefunction.pas',
  Objekt.Folderlocation in 'Objekt\Objekt.Folderlocation.pas',
  c.Folder in 'const\c.Folder.pas',
  Form.Einstellung in 'Form\Form.Einstellung.pas' {frm_Einstellung};

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_DokuOrga, frm_DokuOrga);
  Application.Run;
end.
