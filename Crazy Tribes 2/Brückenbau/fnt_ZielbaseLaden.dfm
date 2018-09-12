object frm_ZielbaseLaden: Tfrm_ZielbaseLaden
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Zielbase'
  ClientHeight = 163
  ClientWidth = 403
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 66
    Height = 16
    Caption = 'Basename'
  end
  object Label2: TLabel
    Left = 24
    Top = 54
    Width = 85
    Height = 16
    Caption = 'X-Koordinate'
  end
  object Label3: TLabel
    Left = 24
    Top = 86
    Width = 85
    Height = 16
    Caption = 'Y-Koordinate'
  end
  object edt_Basename: TEdit
    Left = 118
    Top = 13
    Width = 272
    Height = 24
    TabOrder = 0
    Text = 'edt_Basename'
  end
  object edt_Y: TSpinEdit
    Left = 120
    Top = 83
    Width = 97
    Height = 26
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 0
  end
  object edt_X: TSpinEdit
    Left = 120
    Top = 51
    Width = 97
    Height = 26
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object pnl_Bottom: TPanel
    Left = 0
    Top = 122
    Width = 403
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'pnl_Bottom'
    ShowCaption = False
    TabOrder = 3
    DesignSize = (
      403
      41)
    object btn_Ok: TTBButton
      Left = 295
      Top = 8
      Width = 98
      Height = 25
      Flat = True
      SelectColor = clSkyBlue
      DownColor = clSkyBlue
      BtnLabel.HAlign = tbHLeft
      BtnLabel.VAlign = tbVTop
      BtnLabel.HMargin = 3
      BtnLabel.VMargin = 0
      BtnLabel.Caption = #214'ffnen'
      BtnLabel.HTextAlign = tbHTextCenter
      BtnLabel.VTextAlign = tbVTextCenter
      BtnLabel.Font.Charset = ANSI_CHARSET
      BtnLabel.Font.Color = clWindowText
      BtnLabel.Font.Height = -13
      BtnLabel.Font.Name = 'Verdana'
      BtnLabel.Font.Style = []
      BtnLabel.Wordwrap = True
      BtnImage.AlignLeft = True
      BtnImage.AlignRight = False
      BtnImage.Margin = 10
      BtnImage.Height = 16
      BtnImage.Width = 16
      ImageIndex = -1
      OnClick = btn_OkClick
      Anchors = [akTop, akRight]
    end
    object btn_Cancel: TTBButton
      Left = 8
      Top = 8
      Width = 113
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
      BtnLabel.Font.Height = -13
      BtnLabel.Font.Name = 'Verdana'
      BtnLabel.Font.Style = []
      BtnLabel.Wordwrap = True
      BtnImage.AlignLeft = True
      BtnImage.AlignRight = False
      BtnImage.Margin = 10
      BtnImage.Height = 16
      BtnImage.Width = 16
      ImageIndex = -1
    end
  end
  object FileOpenDialog: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 240
    Top = 48
  end
end
