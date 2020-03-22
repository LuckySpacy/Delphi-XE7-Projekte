program Einstellung;

uses
  Vcl.Forms,
  Form.Einstellung in 'Form.Einstellung.pas' {frm_Einstellung},
  Objekt.Ini in '..\Objekt\Objekt.Ini.pas',
  Form.Pfad in 'Form.Pfad.pas' {frm_Pfad},
  Form.Schnittstelle in 'Form.Schnittstelle.pas' {frm_Schnittstelle},
  Datamodul.TSI in 'Datamodul.TSI.pas' {dm: TDataModule},
  Objekt.Global in '..\Objekt\Objekt.Global.pas',
  Objekt.BasisList in '..\Objekt\Objekt.BasisList.pas',
  Objekt.DBFeld in '..\Objekt\Objekt.DBFeld.pas',
  Objekt.DBFeldList in '..\Objekt\Objekt.DBFeldList.pas',
  Form.SchnittstelleBearb in 'Form.SchnittstelleBearb.pas' {frm_SchnittstelleBearb},
  Form.AkSt in 'Form.AkSt.pas' {frm_AkSt},
  Form.KurseLoeschen in 'Form.KurseLoeschen.pas' {frm_KurseLoeschen},
  Objekt.MySqlBoersenindex in '..\..\Server\Objekt\Objekt.MySqlBoersenindex.pas',
  Form.Aktien in 'Form.Aktien.pas' {frm_Aktien};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(Tfrm_Einstellung, frm_Einstellung);
  Application.Run;
end.
