program ClientUI;

uses
  Vcl.Forms,
  Form.ClientUI in 'Form\Form.ClientUI.pas' {frm_ClientUI},
  Objekt.Verschluesseln in '..\..\..\Allgemein\Objekt\Objekt.Verschluesseln.pas',
  u_RegIni in '..\..\..\Allgemein\Units\u_RegIni.pas',
  Objekt.ClientUIEinstellung in 'Objekt\Objekt.ClientUIEinstellung.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_ClientUI, frm_ClientUI);
  Application.Run;
end.
