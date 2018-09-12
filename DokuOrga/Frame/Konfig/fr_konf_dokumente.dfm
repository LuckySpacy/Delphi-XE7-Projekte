inherited fra_Konf_Dokumente: Tfra_Konf_Dokumente
  Width = 330
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Verdana'
  ParentFont = False
  ExplicitWidth = 330
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 71
    Height = 13
    Caption = 'Dokumente:'
  end
  object edt_Dir: TAdvDirectoryEdit
    Left = 96
    Top = 21
    Width = 225
    Height = 21
    EmptyTextStyle = []
    Flat = False
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
    Lookup.Font.Charset = DEFAULT_CHARSET
    Lookup.Font.Color = clWindowText
    Lookup.Font.Height = -11
    Lookup.Font.Name = 'Arial'
    Lookup.Font.Style = []
    Lookup.Separator = ';'
    Anchors = [akLeft, akTop, akRight]
    Color = clWindow
    ReadOnly = False
    TabOrder = 0
    Text = ''
    Visible = True
    Version = '1.3.5.0'
    ButtonStyle = bsButton
    ButtonWidth = 18
    Etched = False
    Glyph.Data = {
      CE000000424DCE0000000000000076000000280000000C0000000B0000000100
      0400000000005800000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00F00000000FFF
      00000088888880FF00000B088888880F00000BB08888888000000BBB00000000
      00000BBBBBBB0B0F00000BBB00000B0F0000F000BBBBBB0F0000FF0BBBBBBB0F
      0000FF0BBB00000F0000FFF000FFFFFF0000}
    BrowseDialogText = 'Select Directory'
  end
end
