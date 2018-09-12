inherited fra_Konf_GoogleDrive: Tfra_Konf_GoogleDrive
  Width = 556
  Height = 500
  Font.Height = -12
  Font.Name = 'Verdana'
  ParentFont = False
  ExplicitWidth = 556
  ExplicitHeight = 500
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 59
    Height = 14
    Caption = 'Client-Id:'
  end
  object Label2: TLabel
    Left = 16
    Top = 51
    Width = 69
    Height = 14
    Caption = 'Client-Key:'
  end
  object Label5: TLabel
    Left = 16
    Top = 79
    Width = 108
    Height = 14
    Caption = 'Dokumentenpfad'
  end
  object edt_ClientKey: TEdit
    Left = 152
    Top = 48
    Width = 281
    Height = 22
    TabOrder = 0
    Text = 'Edit1'
  end
  object cbx_GDriveVerwenden: TCheckBox
    Left = 152
    Top = 104
    Width = 321
    Height = 17
    Caption = 'Dokumente immer auf Google-Drive '#252'bertragen'
    TabOrder = 1
  end
  object btn_Testen: TTBButton
    Left = 152
    Top = 140
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
  object btn_Speichern: TTBButton
    Left = 320
    Top = 140
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
  object edt_ClientId: TEdit
    Left = 152
    Top = 21
    Width = 281
    Height = 22
    TabOrder = 4
    Text = 'edt_ClientId'
  end
  object edt_Pfad: TButtonedEdit
    Left = 152
    Top = 76
    Width = 281
    Height = 22
    RightButton.Visible = True
    TabOrder = 5
    Text = 'edt_Pfad'
  end
  object ImageList1: TImageList
    Left = 408
    Top = 216
  end
end
