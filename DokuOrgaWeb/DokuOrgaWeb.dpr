program DokuOrgaWeb;

uses
  FastMM4 in '..\Log4d\FastMM\FastMM4.pas',
  FastMM4Messages in '..\Log4d\FastMM\Translations\German\by Thomas Speck\FastMM4Messages.pas',
  Vcl.Forms,
  Form.DokuOrgaWeb in 'Form\Form.DokuOrgaWeb.pas' {frm_DokuOrgaWeb},
  Objekt.DokuOrga in 'Objekt\Objekt.DokuOrga.pas',
  Form.Ordner in 'Form\Form.Ordner.pas' {frm_Ordner},
  Form.Einstellung in 'Form\Form.Einstellung.pas' {frm_Einstellung},
  DM.Bilder in 'Form\DM.Bilder.pas' {dm_Bilder: TDataModule},
  Form.Login in 'Form\Form.Login.pas' {frm_Login},
  DB.Benutzer in 'Datenbank\DB.Benutzer.pas',
  DB.IBBasisList in 'Datenbank\IB\DB.IBBasisList.pas',
  DB.BenutzerList in 'Datenbank\DB.BenutzerList.pas',
  TBQuery in 'Komponenten\TBQuery\TBQuery.pas',
  TBTrans in 'Komponenten\TBQuery\TBTrans.pas',
  Objekt.IniDokuOrga in 'Objekt\Objekt.IniDokuOrga.pas',
  VW.Ordner in 'Datenbank\VW.Ordner.pas',
  VW.OrdnerList in 'Datenbank\VW.OrdnerList.pas',
  VW.BaseList in 'Datenbank\VW.BaseList.pas',
  Objekt.BtnOrdner in 'Objekt\Objekt.BtnOrdner.pas',
  Field.Icon in 'Field\Field.Icon.pas',
  Form.Zweig in 'Form\Form.Zweig.pas' {frm_Zweig},
  VW.Zweig in 'Datenbank\VW.Zweig.pas',
  VW.ZweigList in 'Datenbank\VW.ZweigList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_DokuOrgaWeb, frm_DokuOrgaWeb);
  Application.CreateForm(Tdm_Bilder, dm_Bilder);
  Application.Run;
end.
