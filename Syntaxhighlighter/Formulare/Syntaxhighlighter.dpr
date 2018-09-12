program Syntaxhighlighter;

uses
  Vcl.Forms,
  Form.Syntaxhighlighter in 'Form.Syntaxhighlighter.pas' {frm_Syntaxhighlighter},
  Objekt.System in '..\Objekt\Objekt.System.pas',
  c_AllgTypes in '..\..\Allgemein\Units\c_AllgTypes.pas',
  o_sysfolderlocation in '..\..\Allgemein\Units\o_sysfolderlocation.pas',
  o_System in '..\..\Allgemein\Units\o_System.pas',
  rcx in '..\..\Allgemein\Units\rcx.pas',
  u_Allgfunc in '..\..\Allgemein\Units\u_Allgfunc.pas',
  u_RegIni in '..\..\Allgemein\Units\u_RegIni.pas',
  u_RTF in '..\..\Allgemein\Units\u_RTF.pas',
  u_System in '..\..\Allgemein\Units\u_System.pas',
  Objekt.DBFeld in '..\Objekt\Objekt.DBFeld.pas',
  Objekt.DBFeldList in '..\Objekt\Objekt.DBFeldList.pas',
  Model.BasisList in '..\Model\Model.BasisList.pas',
  Objekt.BasisList in '..\Objekt\Objekt.BasisList.pas',
  Model.Highlighter in '..\Model\Model.Highlighter.pas',
  Model.Basis in '..\Model\Model.Basis.pas',
  Model.HighlighterList in '..\Model\Model.HighlighterList.pas',
  Frame.StyleName in '..\Frame\Frame.StyleName.pas' {fra_StyleName: TFrame},
  Frame.Font in '..\Frame\Frame.Font.pas' {fra_Font: TFrame},
  Objekt.Font in '..\Objekt\Objekt.Font.pas',
  Form.HighlighterEdit in 'Form.HighlighterEdit.pas' {frm_HighlighterEdit},
  Frame.Kommentar in '..\Frame\Frame.Kommentar.pas' {fra_Kommentar: TFrame},
  Form.KommentarEdit in 'Form.KommentarEdit.pas' {frm_KommentarEdit},
  Model.Kommentar in '..\Model\Model.Kommentar.pas',
  Model.KommentarList in '..\Model\Model.KommentarList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_Syntaxhighlighter, frm_Syntaxhighlighter);
  Application.Run;
end.
