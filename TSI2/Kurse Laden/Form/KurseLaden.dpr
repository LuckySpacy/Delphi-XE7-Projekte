program KurseLaden;

uses
  Vcl.Forms,
  Form.KurseLaden in 'Form.KurseLaden.pas' {frm_KurseLaden},
  Objekt.DBFeld in '..\Objekt\Objekt.DBFeld.pas',
  Objekt.DBFeldList in '..\Objekt\Objekt.DBFeldList.pas',
  Objekt.BasisList in '..\Objekt\Objekt.BasisList.pas',
  DBObj.Basis in '..\DBObj\Base\DBObj.Basis.pas',
  DBObj.BasisList in '..\DBObj\Base\DBObj.BasisList.pas',
  Frame.Aktie in '..\Frame\Frame.Aktie.pas' {fra_Aktie: TFrame},
  DBObj.Aktie in '..\DBObj\DBObj.Aktie.pas',
  DBObj.AktieList in '..\DBObj\DBObj.AktieList.pas',
  Form.AktieBearb in 'Form.AktieBearb.pas' {frm_Aktiebearb},
  Objekt.Global in '..\Objekt\Objekt.Global.pas',
  Allgemein.Funktionen in '..\Allgemein\Allgemein.Funktionen.pas',
  Allgemein.RegIni in '..\Allgemein\Allgemein.RegIni.pas',
  Allgemein.SysFolderlocation in '..\Allgemein\Allgemein.SysFolderlocation.pas',
  Allgemein.System in '..\Allgemein\Allgemein.System.pas',
  Allgemein.Types in '..\Allgemein\Allgemein.Types.pas',
  Datamodul.TSIKurse in 'Datamodul.TSIKurse.pas' {dm: TDataModule},
  Frame.Konf.Datenbank in '..\Frame\Frame.Konf.Datenbank.pas' {fra_Konf_Datenbank: TFrame},
  Frame.Konf in '..\Frame\Frame.Konf.pas' {fra_Konf: TFrame},
  DBObj.Boersenindex in '..\DBObj\DBObj.Boersenindex.pas',
  Form.BoersenindexBearb in 'Form.BoersenindexBearb.pas' {frm_BoersenindexBearb},
  DBObj.BoersenindexList in '..\DBObj\DBObj.BoersenindexList.pas',
  DBObj.Schnittstelle in '..\DBObj\DBObj.Schnittstelle.pas',
  DBObj.SchnittstelleList in '..\DBObj\DBObj.SchnittstelleList.pas',
  Frame.Schnittstelle in '..\Frame\Frame.Schnittstelle.pas' {fra_Schnittstelle: TFrame},
  Form.SchnittstelleBearb in 'Form.SchnittstelleBearb.pas' {frm_SchnittstelleBearb},
  Frame.KurseLaden in '..\Frame\Frame.KurseLaden.pas' {fra_KurseLaden: TFrame},
  Objekt.KursCsv in '..\Objekt\Objekt.KursCsv.pas',
  Objekt.KursCsvList in '..\Objekt\Objekt.KursCsvList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(Tfrm_KurseLaden, frm_KurseLaden);
  Application.Run;
end.
