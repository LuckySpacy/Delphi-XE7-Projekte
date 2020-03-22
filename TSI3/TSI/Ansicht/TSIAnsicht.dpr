program TSIAnsicht;

uses
  Vcl.Forms,
  Form.Ansicht in 'Form\Form.Ansicht.pas' {frm_TsiAnsicht},
  Frame.Boersenindex in 'Frame\Frame.Boersenindex.pas' {fra_Boersenindex: TFrame},
  Frame.Ansicht in 'Frame\Frame.Ansicht.pas' {fra_Ansicht: TFrame},
  Objekt.Global in 'Objekt\Objekt.Global.pas',
  Objekt.Ini in 'Objekt\Objekt.Ini.pas',
  Objekt.MySqlSettings in 'Objekt\Objekt.MySqlSettings.pas',
  DB.Feld in 'DB\DB.Feld.pas',
  DB.Basis in 'DB\DB.Basis.pas',
  DB.Feldlist in 'DB\DB.Feldlist.pas',
  DB.BasisList in 'DB\DB.BasisList.pas',
  Objekt.BasisList in 'Objekt\Objekt.BasisList.pas',
  Objekt.Baselist in 'Objekt\Objekt.Baselist.pas',
  Feld.Feld in 'Feld\Feld.Feld.pas',
  Feld.Feldlist in 'Feld\Feld.Feldlist.pas',
  Objekt.DateTime in 'Objekt\Objekt.DateTime.pas',
  Frame.Aktie in 'Frame\Frame.Aktie.pas' {fra_Aktie: TFrame},
  Frame.Kurs in 'Frame\Frame.Kurs.pas' {fra_Kurs: TFrame},
  Frame.ChartKurs in 'Frame\Frame.ChartKurs.pas' {fra_ChartKurs: TFrame},
  Frame.ChartTSI in 'Frame\Frame.ChartTSI.pas' {fra_ChartTSI: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_TsiAnsicht, frm_TsiAnsicht);
  Application.Run;
end.
