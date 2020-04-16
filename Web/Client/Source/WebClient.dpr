program WebClient;

uses
  Vcl.Forms,
  Form.WebClient in 'Form\Form.WebClient.pas' {Form1},
  Objekt.WebClient in 'Objekt\Objekt.WebClient.pas',
  WebQuery.Feld in '..\..\WebQuery\WebQuery.Feld.pas',
  WebQuery.FeldList in '..\..\WebQuery\WebQuery.FeldList.pas',
  WebQuery.BaseList in '..\..\WebQuery\WebQuery.BaseList.pas',
  WebQuery in '..\..\WebQuery\WebQuery.pas',
  WebQuery.DatenFelderList in '..\..\WebQuery\WebQuery.DatenFelderList.pas',
  WebQuery.DatenFelder in '..\..\WebQuery\WebQuery.DatenFelder.pas',
  WebQuery.DatenList in '..\..\WebQuery\WebQuery.DatenList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
