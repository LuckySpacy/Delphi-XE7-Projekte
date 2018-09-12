inherited fra_Konf_Ftp: Tfra_Konf_Ftp
  Width = 531
  Height = 458
  Font.Height = -12
  Font.Name = 'Verdana'
  ParentFont = False
  ExplicitWidth = 531
  ExplicitHeight = 458
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 34
    Height = 14
    Caption = 'Host:'
  end
  object Label2: TLabel
    Left = 16
    Top = 51
    Width = 69
    Height = 14
    Caption = 'Username:'
  end
  object Label3: TLabel
    Left = 16
    Top = 79
    Width = 64
    Height = 14
    Caption = 'Passwort:'
  end
  object Label4: TLabel
    Left = 16
    Top = 109
    Width = 107
    Height = 14
    Caption = 'Passwort (Wdh):'
  end
  object Label5: TLabel
    Left = 16
    Top = 137
    Width = 108
    Height = 14
    Caption = 'Dokumentenpfad'
  end
  object Label6: TLabel
    Left = 16
    Top = 244
    Width = 133
    Height = 14
    Caption = 'Verbindungsprotokoll'
  end
  object edt_Host: TEdit
    Left = 152
    Top = 21
    Width = 281
    Height = 22
    TabOrder = 0
    Text = 'edt_Host'
  end
  object edt_Username: TEdit
    Left = 152
    Top = 48
    Width = 281
    Height = 22
    TabOrder = 1
    Text = 'Edit1'
  end
  object edt_Passwort: TEdit
    Left = 152
    Top = 76
    Width = 281
    Height = 22
    TabOrder = 2
    Text = 'edt_Passwort'
  end
  object edt_PW2: TEdit
    Left = 152
    Top = 106
    Width = 281
    Height = 22
    TabOrder = 3
    Text = 'edt_Passwort'
  end
  object btn_Speichern: TTBButton
    Left = 320
    Top = 196
    Width = 113
    Height = 25
    Flat = True
    SelectColor = clSkyBlue
    DownColor = clSkyBlue
    BtnLabel.HAlign = tbHLeft
    BtnLabel.VAlign = tbVTop
    BtnLabel.HMargin = 3
    BtnLabel.VMargin = 0
    BtnLabel.Caption = 'Speichern'
    BtnLabel.HTextAlign = tbHTextCenter
    BtnLabel.VTextAlign = tbVTextCenter
    BtnLabel.Font.Charset = DEFAULT_CHARSET
    BtnLabel.Font.Color = clWindowText
    BtnLabel.Font.Height = -11
    BtnLabel.Font.Name = 'Tahoma'
    BtnLabel.Font.Style = []
    BtnLabel.Wordwrap = True
    BtnImage.AlignLeft = True
    BtnImage.AlignRight = False
    BtnImage.Margin = 10
    BtnImage.Height = 16
    BtnImage.Width = 16
    ImageIndex = -1
  end
  object edt_Pfad: TEdit
    Left = 152
    Top = 134
    Width = 281
    Height = 22
    TabOrder = 5
    Text = 'edt_Passwort'
  end
  object btn_Testen: TTBButton
    Left = 152
    Top = 196
    Width = 162
    Height = 25
    Flat = True
    SelectColor = clSkyBlue
    DownColor = clSkyBlue
    BtnLabel.HAlign = tbHLeft
    BtnLabel.VAlign = tbVTop
    BtnLabel.HMargin = 3
    BtnLabel.VMargin = 0
    BtnLabel.Caption = 'Verbindung Testen'
    BtnLabel.HTextAlign = tbHTextCenter
    BtnLabel.VTextAlign = tbVTextCenter
    BtnLabel.Font.Charset = DEFAULT_CHARSET
    BtnLabel.Font.Color = clWindowText
    BtnLabel.Font.Height = -11
    BtnLabel.Font.Name = 'Tahoma'
    BtnLabel.Font.Style = []
    BtnLabel.Wordwrap = True
    BtnImage.AlignLeft = True
    BtnImage.AlignRight = False
    BtnImage.Margin = 10
    BtnImage.Height = 16
    BtnImage.Width = 16
    ImageIndex = -1
  end
  object Memo1: TMemo
    Left = 16
    Top = 264
    Width = 417
    Height = 177
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    TabOrder = 7
  end
  object cbx_FTPVerwenden: TCheckBox
    Left = 152
    Top = 162
    Width = 281
    Height = 17
    Caption = 'Dokumente immer '#252'ber FTP '#252'bertragen'
    TabOrder = 8
  end
end
