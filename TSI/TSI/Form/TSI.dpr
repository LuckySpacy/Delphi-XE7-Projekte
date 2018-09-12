program TSI;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Vcl.Forms,
  Form.TSI in 'Form.TSI.pas' {frm_TSI},
  Datamodul.TSI in 'Datamodul.TSI.pas' {dm: TDataModule},
  Objekt.Global in '..\Objekt\Objekt.Global.pas',
  Allgemein.Funktionen in '..\Allgemein\Allgemein.Funktionen.pas',
  Allgemein.RegIni in '..\Allgemein\Allgemein.RegIni.pas',
  Allgemein.SysFolderlocation in '..\Allgemein\Allgemein.SysFolderlocation.pas',
  Allgemein.System in '..\Allgemein\Allgemein.System.pas',
  Allgemein.Types in '..\Allgemein\Allgemein.Types.pas',
  Frame.Konf in '..\Frame\Frame.Konf.pas' {fra_Konf: TFrame},
  Frame.Konf.Datenbank in '..\Frame\Frame.Konf.Datenbank.pas' {fra_Konf_Datenbank: TFrame},
  Frame.Konf.CSVPfad in '..\Frame\Frame.Konf.CSVPfad.pas' {fra_Konf_CSVPfad: TFrame},
  Objekt.Aktienimport in '..\Objekt\Objekt.Aktienimport.pas',
  DBObj.Aktie in '..\DBObj\DBObj.Aktie.pas',
  DBObj.AktieList in '..\DBObj\DBObj.AktieList.pas',
  DBObj.Basis in '..\DBObj\Base\DBObj.Basis.pas',
  DBObj.BasisList in '..\DBObj\Base\DBObj.BasisList.pas',
  Model.Basis in '..\DBObj\Base\Model.Basis.pas',
  Model.BasisList in '..\DBObj\Base\Model.BasisList.pas',
  DBObj.Boersenindex in '..\DBObj\DBObj.Boersenindex.pas',
  DBObj.BoersenindexList in '..\DBObj\DBObj.BoersenindexList.pas',
  Objekt.DBFeldList in '..\Objekt\Objekt.DBFeldList.pas',
  Objekt.DBFeld in '..\Objekt\Objekt.DBFeld.pas',
  Objekt.BasisList in '..\Objekt\Objekt.BasisList.pas',
  Form.KurseLaden in 'Form.KurseLaden.pas' {frm_KurseLaden},
  DBObj.Kurs in '..\DBObj\DBObj.Kurs.pas',
  Objekt.Kursimport in '..\Objekt\Objekt.Kursimport.pas',
  DBObj.KursList in '..\DBObj\DBObj.KursList.pas',
  Frame.Aktie in '..\Frame\Frame.Aktie.pas' {fra_Aktie: TFrame},
  Frame.Kurse in '..\Frame\Frame.Kurse.pas' {fra_Kurse: TFrame},
  Frame.Kursliste in '..\Frame\Frame.Kursliste.pas' {fra_Kursliste: TFrame},
  Frame.ChartVariabel in '..\Frame\Frame.ChartVariabel.pas' {fra_ChartVariable: TFrame},
  DBObj.TSI in '..\DBObj\DBObj.TSI.pas',
  DBObj.TSIList in '..\DBObj\DBObj.TSIList.pas',
  Form.TSIWerteLaden in 'Form.TSIWerteLaden.pas' {frm_TSIWerteLaden},
  Frame.TSIChart in '..\Frame\Frame.TSIChart.pas' {fra_TSIChart: TFrame},
  DBObj.TSILAST in '..\DBObj\DBObj.TSILAST.pas',
  DBObj.TSILASTList in '..\DBObj\DBObj.TSILASTList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(Tfrm_TSI, frm_TSI);
  Application.Run;
end.
