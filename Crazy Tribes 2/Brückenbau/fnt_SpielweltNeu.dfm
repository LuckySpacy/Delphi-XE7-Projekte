object frm_SpielweltNeu: Tfrm_SpielweltNeu
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Neue Spielwelt'
  ClientHeight = 134
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 91
    Height = 13
    Caption = 'Name der Spielwelt'
  end
  object edt_Name: TEdit
    Left = 16
    Top = 43
    Width = 377
    Height = 21
    TabOrder = 0
    Text = 'edt_Name'
  end
  object btn_Schliessen: TTBButton
    Left = 272
    Top = 86
    Width = 121
    Height = 34
    Flat = True
    SelectColor = clSkyBlue
    DownColor = clSkyBlue
    BtnLabel.HAlign = tbHLeft
    BtnLabel.VAlign = tbVTop
    BtnLabel.HMargin = 3
    BtnLabel.VMargin = 0
    BtnLabel.Caption = 'Schlie'#223'en'
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
    BtnImage.Margin = 0
    BtnImage.Height = 0
    BtnImage.Width = 0
    ImageIndex = -1
    OnClick = btn_SchliessenClick
  end
end
