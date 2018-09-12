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
  Allgemein.Funktionen in '..\Allgemein\Allgemein.Funktionen.pas',
  Allgemein.RegIni in '..\Allgemein\Allgemein.RegIni.pas',
  Allgemein.SysFolderlocation in '..\Allgemein\Allgemein.SysFolderlocation.pas',
  Allgemein.System in '..\Allgemein\Allgemein.System.pas',
  Allgemein.Types in '..\Allgemein\Allgemein.Types.pas',
  Datamodul.TSIServer in 'Datamodul.TSIServer.pas' {dm: TDataModule},
  Objekt.Protokoll in '..\Objekt\Objekt.Protokoll.pas',
  DBObj.AktieKurseList in '..\DBObj\DBObj.AktieKurseList.pas',
  Objekt.KursCsv in '..\..\Kurse Laden\Objekt\Objekt.KursCsv.pas',
  Objekt.KursCsvList in '..\..\Kurse Laden\Objekt\Objekt.KursCsvList.pas',
  DBObj.Aktie in '..\..\TSI\DBObj\DBObj.Aktie.pas',
  DBObj.AktieList in '..\..\TSI\DBObj\DBObj.AktieList.pas',
  DBObj.TSI in '..\..\TSI\DBObj\DBObj.TSI.pas',
  Objekt.Aktienimport in '..\Objekt\Objekt.Aktienimport.pas',
  Objekt.Kursimport in '..\Objekt\Objekt.Kursimport.pas',
  DBObj.Kurs in '..\..\TSI\DBObj\DBObj.Kurs.pas',
  Objekt.TSIWerteLaden in '..\Objekt\Objekt.TSIWerteLaden.pas',
  DBObj.TSIList in '..\..\TSI\DBObj\DBObj.TSIList.pas',
  DBObj.KursList in '..\..\TSI\DBObj\DBObj.KursList.pas',
  DBObj.TSILAST in '..\..\TSI\DBObj\DBObj.TSILAST.pas',
  DBObj.SchnittstelleList in '..\..\TSI\DBObj\DBObj.SchnittstelleList.pas',
  DBObj.AkSt in '..\..\..\TSI2\Einstellung\DBObj\DBObj.AkSt.pas',
  DBObj.AkStList in '..\..\..\TSI2\Einstellung\DBObj\DBObj.AkStList.pas',
  Objekt.MySqlAktie in '..\Objekt\Objekt.MySqlAktie.pas',
  Objekt.MySqlKurs in '..\Objekt\Objekt.MySqlKurs.pas',
  Objekt.MySqlTSI in '..\Objekt\Objekt.MySqlTSI.pas',
  Objekt.MySqlTSIAnsicht in '..\Objekt\Objekt.MySqlTSIAnsicht.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_TSIServer, frm_TSIServer);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
