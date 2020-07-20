program AmazonSmartwatch;

uses
  Vcl.Forms,
  Form.AmazonSmartwatch in 'Form\Form.AmazonSmartwatch.pas' {frm_AmazonSmartwatch},
  dm.Datenmodul in '..\..\Smartwatch\Form\dm.Datenmodul.pas' {dam: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_AmazonSmartwatch, frm_AmazonSmartwatch);
  Application.Run;
end.
