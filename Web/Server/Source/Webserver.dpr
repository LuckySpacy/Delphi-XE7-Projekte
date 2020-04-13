program Webserver;

uses
  FastMM4 in '..\..\..\Log4d\FastMM\FastMM4.pas',
  FastMM4Messages in '..\..\..\Log4d\FastMM\Translations\German\by Thomas Speck\FastMM4Messages.pas',
  Vcl.Forms,
  Form.Webserver in 'Form\Form.Webserver.pas' {,
  Objekt.Webserver in 'Objekt\Objekt.Webserver.pas',
  Objekt.Logger in 'Objekt\Objekt.Logger.pas',
  Log4D in '..\..\..\Log4d\Log4D.pas';

{$R *.res},
  Objekt.Webserver in 'Objekt\Objekt.Webserver.pas',
  Objekt.Logger in 'Objekt\Objekt.Logger.pas',
  Log4D in '..\..\..\Log4d\Log4D.pas',
  Objekt.WebserverXML in '..\..\ServerUI\Source\Objekt\Objekt.WebserverXML.pas',
  Datenmodul.DM in 'Form\Datenmodul.DM.pas' {DM: TDataModule},
  Objekt.Verschluesseln in '..\..\..\Allgemein\Objekt\Objekt.Verschluesseln.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_Webserver, frm_Webserver);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
