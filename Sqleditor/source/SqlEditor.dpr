program SqlEditor;

uses
  Vcl.Forms,
  fntSqlEditor in 'fntSqlEditor.pas' {frmSqlEditor},
  DataModul in 'DataModul.pas' {dm: TDataModule},
  nf_RegIni in 'nf_RegIni.pas',
  nf_System in 'nf_System.pas',
  fntConnectIB in 'fntConnectIB.pas' {frmConnectIB},
  fntNewConnectIB in 'fntNewConnectIB.pas' {frmNewConnectIB},
  fntGrid in 'fntGrid.pas' {frmGrid},
  o_richvieweditobj in 'o_richvieweditobj.pas',
  o_nf in 'o_nf.pas',
  o_printer in 'o_printer.pas',
  o_RegIni in 'o_RegIni.pas',
  o_sysfolderlocation in 'o_sysfolderlocation.pas',
  o_System in 'o_System.pas',
  fntSqlEdit in 'fntSqlEdit.pas' {frmSqlEdit},
  tbSqlHighlighterBase in 'tbSqlHighlighterBase.pas',
  tbSqlHighlighter in 'tbSqlHighlighter.pas',
  fntDataChange in 'fntDataChange.pas' {frm_DataChange},
  Vcl.Themes,
  Vcl.Styles,
  o_DBIniObj in 'o_DBIniObj.pas',
  o_DBIni in 'o_DBIni.pas',
  c_types in 'c_types.pas',
  u_Allgfunc in 'u_Allgfunc.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmSqlEditor, frmSqlEditor);
  Application.Run;
end.
