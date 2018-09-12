inherited fra_Konf_Datenbank: Tfra_Konf_Datenbank
  Width = 511
  ExplicitWidth = 511
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 80
    Height = 13
    Caption = 'Datenbankdatei:'
  end
  object Label2: TLabel
    Left = 16
    Top = 56
    Width = 36
    Height = 13
    Caption = 'Server:'
  end
  object edt_Datenbankfilename: TAdvFileNameEdit
    Left = 112
    Top = 21
    Width = 361
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
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00D00000000DDD
      00000077777770DD00000F077777770D00000FF07777777000000FFF00000000
      00000FFFFFFF0DDD00000FFF00000DDD0000D000DDDDD0000000DDDDDDDDDD00
      0000DDDDD0DDD0D00000DDDDDD000DDD0000}
    FilterIndex = 0
    DialogOptions = []
    DialogKind = fdOpen
  end
  object edt_Server: TEdit
    Left = 112
    Top = 53
    Width = 361
    Height = 21
    TabOrder = 1
    Text = 'edt_Server'
  end
end
