object frm_Passwort_festlegen: Tfrm_Passwort_festlegen
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Passwort festlegen'
  ClientHeight = 171
  ClientWidth = 310
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    310
    171)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 16
    Width = 51
    Height = 13
    Caption = 'Passwort'
  end
  object Label2: TLabel
    Left = 32
    Top = 72
    Width = 92
    Height = 13
    Caption = 'Passwort pr'#252'fen'
  end
  object pnl_Bottom: TPanel
    Left = 0
    Top = 130
    Width = 310
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 91
    ExplicitWidth = 324
    DesignSize = (
      310
      41)
    object btn_Ok: TTBButton
      Left = 226
      Top = 8
      Width = 75
      Height = 25
      Flat = True
      SelectColor = clSkyBlue
      DownColor = clSkyBlue
      BtnLabel.HAlign = tbHLeft
      BtnLabel.VAlign = tbVTop
      BtnLabel.HMargin = 0
      BtnLabel.VMargin = 0
      BtnLabel.Caption = 'Ok'
      BtnLabel.HTextAlign = tbHTextCenter
      BtnLabel.VTextAlign = tbVTextCenter
      BtnLabel.Font.Charset = ANSI_CHARSET
      BtnLabel.Font.Color = clWindowText
      BtnLabel.Font.Height = -11
      BtnLabel.Font.Name = 'Verdana'
      BtnLabel.Font.Style = []
      BtnLabel.Wordwrap = True
      BtnImage.AlignLeft = True
      BtnImage.AlignRight = False
      BtnImage.Margin = 15
      BtnImage.Height = 16
      BtnImage.Width = 16
      Images = dm.Img_Small
      ImageIndex = 0
      Anchors = [akTop, akRight]
      ExplicitLeft = 240
    end
    object btn_Cancel: TTBButton
      Left = 121
      Top = 8
      Width = 99
      Height = 25
      Flat = True
      SelectColor = clSkyBlue
      DownColor = clSkyBlue
      BtnLabel.HAlign = tbHLeft
      BtnLabel.VAlign = tbVTop
      BtnLabel.HMargin = 3
      BtnLabel.VMargin = 0
      BtnLabel.Caption = 'Abbrechen'
      BtnLabel.HTextAlign = tbHTextCenter
      BtnLabel.VTextAlign = tbVTextCenter
      BtnLabel.Font.Charset = ANSI_CHARSET
      BtnLabel.Font.Color = clWindowText
      BtnLabel.Font.Height = -11
      BtnLabel.Font.Name = 'Verdana'
      BtnLabel.Font.Style = []
      BtnLabel.Wordwrap = True
      BtnImage.AlignLeft = True
      BtnImage.AlignRight = False
      BtnImage.Margin = 10
      BtnImage.Height = 16
      BtnImage.Width = 16
      Images = dm.Img_Small
      ImageIndex = 1
      Anchors = [akTop, akRight]
      ExplicitLeft = 135
    end
  end
  object edt_PW: TEdit
    Left = 32
    Top = 35
    Width = 271
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'edt_PW'
    ExplicitWidth = 282
  end
  object edt_PW2: TEdit
    Left = 32
    Top = 91
    Width = 271
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = 'edt_PW'
    ExplicitWidth = 282
  end
end
