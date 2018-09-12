program OrdnerAutomAnlegen;

uses
  Vcl.Forms,
  Form.OrdnerAutomAnlegen in 'Form\Form.OrdnerAutomAnlegen.pas' {Form1},
  Allgemein.Types in 'Allgemein\Allgemein.Types.pas',
  Allgemein.System in 'Allgemein\Allgemein.System.pas',
  Allgemein.Ini in 'Allgemein\Allgemein.Ini.pas',
  Allgemein.Folderlocation in 'Allgemein\Allgemein.Folderlocation.pas',
  Objekt.Global in 'Objekt\Objekt.Global.pas',
  Objekt.Ini in 'Objekt\Objekt.Ini.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
