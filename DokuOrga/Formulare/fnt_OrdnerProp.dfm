inherited frm_OrdnerProp: Tfrm_OrdnerProp
  Caption = 'Ordner Eigenschaften'
  ClientHeight = 236
  ClientWidth = 427
  ExplicitWidth = 433
  ExplicitHeight = 265
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 16
    Top = 16
    Width = 24
    Height = 13
    Caption = 'Text'
  end
  object Label2: TLabel [1]
    Left = 16
    Top = 42
    Width = 20
    Height = 13
    Caption = 'Typ'
  end
  inherited pnl_Bottom: TPanel
    Top = 195
    Width = 427
    ExplicitTop = 195
    ExplicitWidth = 427
    DesignSize = (
      427
      41)
    inherited btn_Ok: TTBButton
      Left = 343
      ExplicitLeft = 343
    end
    inherited btn_Cancel: TTBButton
      Left = 238
      ExplicitLeft = 238
    end
  end
  object edt_Text: TEdit
    Left = 46
    Top = 13
    Width = 281
    Height = 21
    TabOrder = 1
    Text = 'edt_Text'
  end
  object cmb_Typ: TComboBox
    Left = 46
    Top = 39
    Width = 281
    Height = 21
    Style = csDropDownList
    TabOrder = 2
  end
  object btn_Bild: TTBButton
    Left = 46
    Top = 66
    Width = 116
    Height = 39
    Flat = True
    SelectColor = clSkyBlue
    DownColor = clSkyBlue
    BtnLabel.HAlign = tbHLeft
    BtnLabel.VAlign = tbVTop
    BtnLabel.HMargin = 10
    BtnLabel.VMargin = 0
    BtnLabel.Caption = 'Bild laden'
    BtnLabel.HTextAlign = tbHTextLeft
    BtnLabel.VTextAlign = tbVTextCenter
    BtnLabel.Font.Charset = ANSI_CHARSET
    BtnLabel.Font.Color = clWindowText
    BtnLabel.Font.Height = -11
    BtnLabel.Font.Name = 'Verdana'
    BtnLabel.Font.Style = []
    BtnLabel.Wordwrap = True
    BtnImage.AlignLeft = False
    BtnImage.AlignRight = True
    BtnImage.Margin = 8
    BtnImage.Height = 32
    BtnImage.Width = 32
    ImageIndex = -1
  end
  object chb_PW: TCheckBox
    Left = 46
    Top = 120
    Width = 155
    Height = 17
    Caption = 'Passwort gesichert'
    TabOrder = 4
  end
end
