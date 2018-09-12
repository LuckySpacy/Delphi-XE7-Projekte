program Einstellung;

uses
  Vcl.Forms,
  Form.Einstellung in 'Form.Einstellung.pas' {frm_Einstellung},
  Objekt.Ini in '..\Objekt\Objekt.Ini.pas',
  Form.Pfad in 'Form.Pfad.pas' {frm_Pfad},
  Form.Schnittstelle in 'Form.Schnittstelle.pas' {frm_Schnittstelle},
  Datamodul.TSI in 'Datamodul.TSI.pas' {dm: TDataModule},
  Objekt.Global in '..\Objekt\Objekt.Global.pas',
  DBObj.Basis in '..\DBObj\Base\DBObj.Basis.pas',
  Objekt.BasisList in '..\Objekt\Objekt.BasisList.pas',
  Objekt.DBFeld in '..\Objekt\Objekt.DBFeld.pas',
  Objekt.DBFeldList in '..\Objekt\Objekt.DBFeldList.pas',
  DBObj.BasisList in '..\DBObj\Base\DBObj.BasisList.pas',
  Model.Basis in '..\DBObj\Base\Model.Basis.pas',
  Model.BasisList in '..\DBObj\Base\Model.BasisList.pas',
  DBObj.Schnittstelle in '..\DBObj\DBObj.Schnittstelle.pas',
  DBObj.SchnittstelleList in '..\DBObj\DBObj.SchnittstelleList.pas',
  Form.SchnittstelleBearb in 'Form.SchnittstelleBearb.pas' {frm_SchnittstelleBearb},
  Form.AkSt in 'Form.AkSt.pas' {frm_AkSt},
  DBObj.Boersenindex in '..\DBObj\DBObj.Boersenindex.pas',
  DBObj.BoersenindexList in '..\DBObj\DBObj.BoersenindexList.pas',
  DBObj.Aktie in '..\DBObj\DBObj.Aktie.pas',
  DBObj.AktieList in '..\DBObj\DBObj.AktieList.pas',
  DBObj.TSI in '..\DBObj\DBObj.TSI.pas',
  DBObj.AkSt in '..\DBObj\DBObj.AkSt.pas',
  DBObj.AkStList in '..\DBObj\DBObj.AkStList.pas',
  Form.KurseLoeschen in 'Form.KurseLoeschen.pas' {frm_KurseLoeschen},
  Objekt.MySqlBoersenindex in '..\..\..\TSI\Server\Objekt\Objekt.MySqlBoersenindex.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(Tfrm_Einstellung, frm_Einstellung);
  Application.Run;
end.
