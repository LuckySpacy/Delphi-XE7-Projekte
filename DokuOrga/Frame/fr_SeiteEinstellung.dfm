inherited fra_SeiteEinstellung: Tfra_SeiteEinstellung
  Width = 598
  Height = 420
  Font.Charset = ANSI_CHARSET
  Font.Name = 'Verdana'
  ParentFont = False
  ExplicitWidth = 598
  ExplicitHeight = 420
  object chb_PW: TCheckBox
    Left = 3
    Top = 344
    Width = 217
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Diese Seite verschl'#252'sselt ablegen'
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 592
    Height = 110
    Align = alTop
    Caption = 'Festplatte'
    TabOrder = 1
    DesignSize = (
      592
      110)
    object Label2: TLabel
      Left = 16
      Top = 24
      Width = 63
      Height = 13
      Caption = 'Hauptpfad:'
    end
    object lbl_Hauptpfad: TLabel
      Left = 129
      Top = 24
      Width = 63
      Height = 13
      Caption = 'Hauptpfad:'
    end
    object Label1: TLabel
      Left = 16
      Top = 56
      Width = 107
      Height = 13
      Caption = 'Dokumentenpfad: '
    end
    object edt_Dir: TAdvDirectoryEdit
      Left = 129
      Top = 53
      Width = 453
      Height = 21
      EditorEnabled = False
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
      AllowNewFolder = True
      BrowseDialogText = 'Select Directory'
    end
    object btn_FP_Vorschlagen: TTBButton
      Left = 129
      Top = 78
      Width = 184
      Height = 25
      Flat = True
      SelectColor = clSkyBlue
      DownColor = clSkyBlue
      BtnLabel.HAlign = tbHLeft
      BtnLabel.VAlign = tbVTop
      BtnLabel.HMargin = 3
      BtnLabel.VMargin = 0
      BtnLabel.Caption = 'Pfadstruktur vorschlagen'
      BtnLabel.HTextAlign = tbHTextCenter
      BtnLabel.VTextAlign = tbVTextCenter
      BtnLabel.Font.Charset = DEFAULT_CHARSET
      BtnLabel.Font.Color = clWindowText
      BtnLabel.Font.Height = -11
      BtnLabel.Font.Name = 'Tahoma'
      BtnLabel.Font.Style = []
      BtnLabel.Wordwrap = True
      BtnImage.AlignLeft = False
      BtnImage.AlignRight = True
      BtnImage.Margin = 10
      BtnImage.Height = 16
      BtnImage.Width = 16
      ImageIndex = -1
    end
  end
  object GroupBox2: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 261
    Width = 592
    Height = 112
    Align = alTop
    Caption = 'FTP'
    TabOrder = 2
    ExplicitTop = 224
    DesignSize = (
      592
      112)
    object Label3: TLabel
      Left = 16
      Top = 24
      Width = 63
      Height = 13
      Caption = 'Hauptpfad:'
    end
    object lbl_FTPHauptpfad: TLabel
      Left = 129
      Top = 24
      Width = 63
      Height = 13
      Caption = 'Hauptpfad:'
    end
    object Label5: TLabel
      Left = 16
      Top = 56
      Width = 107
      Height = 13
      Caption = 'Dokumentenpfad: '
    end
    object edt_ftpdir: TAdvDirectoryEdit
      Left = 129
      Top = 52
      Width = 453
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
    object cbx_FTPUebertragen: TCheckBox
      Left = 129
      Top = 79
      Width = 264
      Height = 17
      Caption = 'Dokumente immer '#252'ber FTP '#252'bertragen'
      TabOrder = 1
    end
  end
  object grp_GoogleDrive: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 119
    Width = 592
    Height = 136
    Align = alTop
    Caption = 'Google Drive'
    TabOrder = 3
    DesignSize = (
      592
      136)
    object Label4: TLabel
      Left = 16
      Top = 24
      Width = 63
      Height = 13
      Caption = 'Hauptpfad:'
    end
    object lbl_Hauptpfad_GDrive: TLabel
      Left = 129
      Top = 24
      Width = 63
      Height = 13
      Caption = 'Hauptpfad:'
    end
    object Label7: TLabel
      Left = 16
      Top = 56
      Width = 107
      Height = 13
      Caption = 'Dokumentenpfad: '
    end
    object cbx_GDriveUebertragen: TCheckBox
      Left = 129
      Top = 79
      Width = 328
      Height = 17
      Caption = 'Dokumente immer auf Google Drive '#252'bertragen'
      TabOrder = 0
    end
    object edt_GoogleDrive: TAdvEditBtn
      Left = 129
      Top = 52
      Width = 453
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
      TabOrder = 1
      Text = ''
      Visible = True
      Version = '1.3.5.0'
      ButtonStyle = bsButton
      ButtonWidth = 16
      Etched = False
      Glyph.Data = {
        CE000000424DCE0000000000000076000000280000000C0000000B0000000100
        0400000000005800000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00F00000000FFF
        00000088888880FF00000B088888880F00000BB08888888000000BBB00000000
        00000BBBBBBB0B0F00000BBB00000B0F0000F000BBBBBB0F0000FF0BBBBBBB0F
        0000FF0BBB00000F0000FFF000FFFFFF0000}
    end
    object btn_GDrive_FPUebernehmen: TTBButton
      Left = 129
      Top = 102
      Width = 184
      Height = 25
      Flat = True
      SelectColor = clSkyBlue
      DownColor = clSkyBlue
      BtnLabel.HAlign = tbHLeft
      BtnLabel.VAlign = tbVTop
      BtnLabel.HMargin = 3
      BtnLabel.VMargin = 0
      BtnLabel.Caption = 'Festplattenpfad '#252'bernehmen'
      BtnLabel.HTextAlign = tbHTextCenter
      BtnLabel.VTextAlign = tbVTextCenter
      BtnLabel.Font.Charset = DEFAULT_CHARSET
      BtnLabel.Font.Color = clWindowText
      BtnLabel.Font.Height = -11
      BtnLabel.Font.Name = 'Tahoma'
      BtnLabel.Font.Style = []
      BtnLabel.Wordwrap = True
      BtnImage.AlignLeft = False
      BtnImage.AlignRight = True
      BtnImage.Margin = 10
      BtnImage.Height = 16
      BtnImage.Width = 16
      ImageIndex = -1
    end
  end
end
