inherited fra_Konf_MasterPW: Tfra_Konf_MasterPW
  Width = 289
  Height = 286
  Font.Name = 'Verdana'
  ParentFont = False
  ExplicitWidth = 289
  ExplicitHeight = 286
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 112
    Height = 13
    Caption = 'Aktuelles Passwort:'
  end
  object Label2: TLabel
    Left = 16
    Top = 104
    Width = 95
    Height = 13
    Caption = 'Neues Passwort:'
  end
  object Label3: TLabel
    Left = 16
    Top = 160
    Width = 158
    Height = 13
    Caption = 'Neues Passwort best'#228'tigen:'
  end
  object edt_AktPW: TEdit
    Left = 16
    Top = 43
    Width = 258
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    PasswordChar = '*'
    TabOrder = 0
    Text = 'edt_AktPW'
  end
  object edt_NeuPW: TEdit
    Left = 16
    Top = 120
    Width = 258
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    PasswordChar = '*'
    TabOrder = 1
    Text = 'edt_AktPW'
  end
  object edt_NeuPW2: TEdit
    Left = 16
    Top = 175
    Width = 258
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    PasswordChar = '*'
    TabOrder = 2
    Text = 'edt_AktPW'
  end
  object btn_Save: TTBButton
    Left = 16
    Top = 224
    Width = 258
    Height = 25
    Flat = True
    SelectColor = clSkyBlue
    DownColor = clSkyBlue
    BtnLabel.HAlign = tbHLeft
    BtnLabel.VAlign = tbVTop
    BtnLabel.HMargin = 3
    BtnLabel.VMargin = 0
    BtnLabel.Caption = 'Passwort speichern'
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
    Anchors = [akLeft, akTop, akRight]
  end
end
