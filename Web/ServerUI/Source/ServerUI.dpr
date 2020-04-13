program ServerUI;

uses
  FastMM4 in '..\..\..\Log4d\FastMM\FastMM4.pas',
  FastMM4Messages in '..\..\..\Log4d\FastMM\Translations\German\by Thomas Speck\FastMM4Messages.pas',
  Vcl.Forms,
  Form.ServerUI in 'Form\Form.ServerUI.pas',
  u_RegIni in '..\..\..\Allgemein\Units\u_RegIni.pas',
  Objekt.WebserverXML in 'Objekt\Objekt.WebserverXML.pas',
  Form.Modulname in 'Form\Form.Modulname.pas' {frm_Modulname},
  Objekt.Verschluesseln in '..\..\..\Allgemein\Objekt\Objekt.Verschluesseln.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
