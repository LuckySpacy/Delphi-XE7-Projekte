program Boerse;

uses
  Forms,
  fntBoerse in 'fntBoerse.pas' {frm_Boerse},
  fntLogin in 'fntLogin.pas' {frm_Login},
  o_db in 'db\o_db.pas',
  untDM in 'untDM.pas' {DM: TDataModule},
  o_nf in 'allgemein\o_nf.pas',
  o_func in 'allgemein\o_func.pas',
  o_printer in 'allgemein\o_printer.pas',
  o_RegIni in 'allgemein\o_RegIni.pas',
  o_System in 'allgemein\o_System.pas',
  o_sysfolderlocation in 'allgemein\o_sysfolderlocation.pas',
  o_benutzer in 'db\o_benutzer.pas',
  o_Field in 'allgemein\o_Field.pas',
  md5 in 'allgemein\md5.pas',
  frame_NeueAktie in 'frame_NeueAktie.pas' {fra_NeueAktie: TFrame},
  o_aktie in 'db\o_aktie.pas',
  fntNeuBasis in 'fntNeuBasis.pas' {frm_NeuBasis},
  fntNeuAktie in 'fntNeuAktie.pas' {frm_NeuAktie},
  o_transfer in 'db\o_transfer.pas',
  frameTransfer in 'frameTransfer.pas' {fra_Transfer: TFrame},
  fntTransfer in 'fntTransfer.pas' {frm_Transfer},
  o_aktielist in 'db\o_aktielist.pas',
  o_dblist in 'db\o_dblist.pas',
  fntBestand in 'fntBestand.pas' {frm_Bestand},
  frame_bestand in 'frame_bestand.pas' {fra_Bestand: TFrame},
  frame_Transferlist in 'frame_Transferlist.pas' {fra_Transferlist: TFrame},
  o_guvdetail in 'allgemein\o_guvdetail.pas',
  untCalc in 'untCalc.pas',
  frame_GUVDetail in 'frame_GUVDetail.pas' {fra_GUVDetail: TFrame},
  o_bestand in 'db\o_bestand.pas',
  o_bilanz in 'db\o_bilanz.pas',
  frame_bilanz in 'frame_bilanz.pas' {fra_Bilanz: TFrame},
  fntGutschrift in 'fntGutschrift.pas' {frm_Gutschrift},
  fntSplitt in 'fntSplitt.pas' {frm_Splitt};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(Tfrm_Boerse, frm_Boerse);
  Application.Run;
end.
