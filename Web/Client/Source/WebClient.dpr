program WebClient;

uses
  Vcl.Forms,
  Form.WebClient in 'Form\Form.WebClient.pas' {Form1},
  Objekt.WebClient in 'Objekt\Objekt.WebClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
