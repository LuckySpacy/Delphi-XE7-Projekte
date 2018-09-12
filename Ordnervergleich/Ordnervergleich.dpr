program Ordnervergleich;

uses
  Vcl.Forms,
  Form.Ordnervergleich in 'Formular\Form.Ordnervergleich.pas' {frm_Ordnervergleich},
  Objekt.Global in 'Objekt\Objekt.Global.pas',
  Allgemein.Folderlocation in 'Allgemein\Allgemein.Folderlocation.pas',
  Allgemein.Ini in 'Allgemein\Allgemein.Ini.pas',
  Allgemein.System in 'Allgemein\Allgemein.System.pas',
  Allgemein.Types in 'Allgemein\Allgemein.Types.pas',
  Objekt.Ini in 'Objekt\Objekt.Ini.pas',
  Frame.AdvGridBase in 'Frame\Frame.AdvGridBase.pas' {fra_AdvGridBase: TFrame},
  Frame.Ordnervergleich in 'Frame\Frame.Ordnervergleich.pas' {fra_Ordnervergleich: TFrame},
  Objekt.Ordner in 'Objekt\Objekt.Ordner.pas',
  Allgemein.BaseList in 'Allgemein\Allgemein.BaseList.pas',
  Objekt.OrdnerList in 'Objekt\Objekt.OrdnerList.pas',
  Frame.OrdnerIgnorieren in 'Frame\Frame.OrdnerIgnorieren.pas' {fra_OrdnerIgnorieren: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_Ordnervergleich, frm_Ordnervergleich);
  Application.Run;
end.
