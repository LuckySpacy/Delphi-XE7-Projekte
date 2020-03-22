program TSIServer;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Vcl.Forms,
  Form.TSIServer in 'Form.TSIServer.pas' {frm_TSIServer},
  Objekt.Ini in '..\Objekt\Objekt.Ini.pas',
  Datamodul.TSIServer in 'Datamodul.TSIServer.pas' {dm: TDataModule},
  Objekt.Protokoll in '..\Objekt\Objekt.Protokoll.pas',
  Objekt.Aktienimport in '..\Objekt\Objekt.Aktienimport.pas',
  Objekt.Kursimport in '..\Objekt\Objekt.Kursimport.pas',
  Objekt.TSIWerteLaden in '..\Objekt\Objekt.TSIWerteLaden.pas',
  Objekt.MySqlAktie in '..\Objekt\Objekt.MySqlAktie.pas',
  Objekt.MySqlKurs in '..\Objekt\Objekt.MySqlKurs.pas',
  Objekt.MySqlTSI in '..\Objekt\Objekt.MySqlTSI.pas',
  Objekt.MySqlTSIAnsicht in '..\Objekt\Objekt.MySqlTSIAnsicht.pas',
  Objekt.KursCsv in '..\Objekt\Objekt.KursCsv.pas',
  Objekt.KursCsvList in '..\Objekt\Objekt.KursCsvList.pas',
  Allgemein.Funktionen in '..\..\..\Allgemein\Allgemein.Funktionen.pas',
  Allgemein.RegIni in '..\..\..\Allgemein\Allgemein.RegIni.pas',
  Allgemein.SysFolderlocation in '..\..\..\Allgemein\Allgemein.SysFolderlocation.pas',
  Allgemein.System in '..\..\..\Allgemein\Allgemein.System.pas',
  Allgemein.Types in '..\..\..\Allgemein\Allgemein.Types.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_TSIServer, frm_TSIServer);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
