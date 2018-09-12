program Test;

uses
  Forms,
  fntTest in 'fntTest.pas' {frm_Test},
  fntMessageDialog in 'fntMessageDialog.pas' {frm_MessageDialog};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_Test, frm_Test);
  Application.CreateForm(Tfrm_MessageDialog, frm_MessageDialog);
  Application.Run;
end.
