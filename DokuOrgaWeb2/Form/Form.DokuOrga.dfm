object frm_DokuOrga: Tfrm_DokuOrga
  Left = 0
  Top = 0
  Caption = 'DokuOrga'
  ClientHeight = 392
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    635
    392)
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 185
    Top = 0
    Height = 392
    ExplicitTop = -271
    ExplicitHeight = 550
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 185
    Height = 392
    ActivePage = tbs_Ordner
    Align = alLeft
    TabOrder = 0
    object tbs_Ordner: TTabSheet
      Caption = 'Ordner'
    end
    object TabSheet2: TTabSheet
      Caption = 'Favoriten'
      ImageIndex = 1
    end
  end
  object TBButton1: TTBButton
    Left = 356
    Top = 291
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
    ImageIndex = 0
    Anchors = [akTop, akRight]
  end
  object MainMenu: TMainMenu
    Left = 448
    Top = 88
    object Datei1: TMenuItem
      Caption = 'Ordner'
      object Neu1: TMenuItem
      end
      object Speichern1: TMenuItem
      end
    end
  end
end
