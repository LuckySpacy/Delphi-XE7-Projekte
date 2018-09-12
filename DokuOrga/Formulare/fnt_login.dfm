object frm_Login: Tfrm_Login
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Login'
  ClientHeight = 158
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    356
    158)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 40
    Width = 43
    Height = 13
    Caption = 'Benutzer'
  end
  object Label2: TLabel
    Left = 40
    Top = 67
    Width = 44
    Height = 13
    Caption = 'Passwort'
  end
  object edt_Benutzer: TEdit
    Left = 120
    Top = 37
    Width = 177
    Height = 21
    TabOrder = 0
    Text = 'edt_Benutzer'
  end
  object edt_Passwort: TEdit
    Left = 120
    Top = 64
    Width = 177
    Height = 21
    TabOrder = 1
    Text = 'edt_Benutzer'
    OnKeyUp = edt_PasswortKeyUp
  end
  object btn_Ok: TTBButton
    Left = 208
    Top = 120
    Width = 89
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
    OnClick = btn_OkClick
    Anchors = [akTop, akRight]
  end
  object cbx_PWAnzeigen: TCheckBox
    Left = 40
    Top = 91
    Width = 257
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Passwort anzeigen'
    TabOrder = 3
    OnClick = cbx_PWAnzeigenClick
  end
end
