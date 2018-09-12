program SyntaxHighlighterConfig;

uses
  Vcl.Forms,
  fnt_SyntaxHighlighterConfig in 'fnt_SyntaxHighlighterConfig.pas' {frm_SyntaxHighlighterConfig},
  fnt_SyntaxHighlighterEdit in 'fnt_SyntaxHighlighterEdit.pas' {frm_SyntaxHighlighterEdit},
  o_fontobj in 'o_fontobj.pas',
  fnt_Kommentar in 'fnt_Kommentar.pas' {frm_Kommentar},
  o_xmlshobj in 'XMLSyntaxHighlighter\o_xmlshobj.pas',
  o_xmlsh_StylenameList in 'XMLSyntaxHighlighter\o_xmlsh_StylenameList.pas',
  o_xmlsh_StylenameNode in 'XMLSyntaxHighlighter\o_xmlsh_StylenameNode.pas',
  o_xmlsh_FontNode in 'XMLSyntaxHighlighter\o_xmlsh_FontNode.pas',
  o_xmlsh_BereichList in 'XMLSyntaxHighlighter\o_xmlsh_BereichList.pas',
  o_xmlsh_BereichNode in 'XMLSyntaxHighlighter\o_xmlsh_BereichNode.pas',
  o_xmlsh_KommentarNode in 'XMLSyntaxHighlighter\o_xmlsh_KommentarNode.pas',
  o_xmlsh_KommentarList in 'XMLSyntaxHighlighter\o_xmlsh_KommentarList.pas',
  fnt_SyntaxHighlighter in 'fnt_SyntaxHighlighter.pas' {frm_SyntaxHighlighter},
  u_RegIni in 'Allgemein\Units\u_RegIni.pas',
  o_syntaxhighlighter in 'o_syntaxhighlighter.pas',
  o_styleobj in 'o_styleobj.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_SyntaxHighlighterConfig, frm_SyntaxHighlighterConfig);
  Application.Run;
end.
