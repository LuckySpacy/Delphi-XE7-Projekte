program TSIAnsicht;

uses
  Vcl.Forms,
  Form.Ansicht in 'Form\Form.Ansicht.pas' {frm_TsiAnsicht},
  Frame.Boersenindex in 'Frame\Frame.Boersenindex.pas' {fra_Boersenindex: TFrame},
  Frame.Ansicht in 'Frame\Frame.Ansicht.pas' {fra_Ansicht: TFrame},
  MySql.Base in 'MySql\MySql.Base.pas',
  Objekt.Global in 'Objekt\Objekt.Global.pas',
  Objekt.Ini in 'Objekt\Objekt.Ini.pas',
  Objekt.MySqlSettings in 'Objekt\Objekt.MySqlSettings.pas',
  MySql.Boersenindex in 'MySql\MySql.Boersenindex.pas',
  MySql.Baselist in 'MySql\MySql.Baselist.pas',
  MySql.Boersenindexlist in 'MySql\MySql.Boersenindexlist.pas',
  MySql.TSIAnsicht in 'MySql\MySql.TSIAnsicht.pas',
  DB.Feld in 'DB\DB.Feld.pas',
  DB.Basis in 'DB\DB.Basis.pas',
  DB.Feldlist in 'DB\DB.Feldlist.pas',
  DB.BasisList in 'DB\DB.BasisList.pas',
  Objekt.BasisList in 'Objekt\Objekt.BasisList.pas',
  Objekt.Baselist in 'Objekt\Objekt.Baselist.pas',
  Feld.Feld in 'Feld\Feld.Feld.pas',
  Feld.Feldlist in 'Feld\Feld.Feldlist.pas',
  MySql.TSIAnsichtlist in 'MySql\MySql.TSIAnsichtlist.pas',
  Objekt.DateTime in 'Objekt\Objekt.DateTime.pas',
  Frame.Aktie in 'Frame\Frame.Aktie.pas' {fra_Aktie: TFrame},
  Frame.Kurs in 'Frame\Frame.Kurs.pas' {fra_Kurs: TFrame},
  MySql.Aktie in 'MySql\MySql.Aktie.pas',
  MySql.Aktielist in 'MySql\MySql.Aktielist.pas',
  MySql.Kurs in 'MySql\MySql.Kurs.pas',
  MySql.Kurslist in 'MySql\MySql.Kurslist.pas',
  MySql.Kurselist in 'MySql\MySql.Kurselist.pas',
  Frame.ChartKurs in 'Frame\Frame.ChartKurs.pas' {fra_ChartKurs: TFrame},
  MySql.TSI in 'MySql\MySql.TSI.pas',
  MySql.TSIList in 'MySql\MySql.TSIList.pas',
  Frame.ChartTSI in 'Frame\Frame.ChartTSI.pas' {fra_ChartTSI: TFrame},
  MySql.TSIListe in 'MySql\MySql.TSIListe.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_TsiAnsicht, frm_TsiAnsicht);
  Application.Run;
end.
