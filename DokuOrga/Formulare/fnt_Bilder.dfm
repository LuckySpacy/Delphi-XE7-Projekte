inherited frm_Bilder: Tfrm_Bilder
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeable
  Caption = 'Bilder'
  ClientHeight = 333
  ClientWidth = 545
  ExplicitWidth = 561
  ExplicitHeight = 372
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnl_Bottom: TPanel
    Top = 292
    Width = 545
    ExplicitTop = 292
    ExplicitWidth = 545
    object Image: TImage [0]
      Left = 152
      Top = 0
      Width = 49
      Height = 41
      AutoSize = True
    end
    inherited btn_Ok: TTBButton
      Left = 456
      ExplicitLeft = 456
    end
    inherited btn_Cancel: TTBButton
      Left = 351
      ExplicitLeft = 351
    end
    object btn_Add: TTBButton
      Left = 239
      Top = 8
      Width = 106
      Height = 25
      Flat = True
      SelectColor = clSkyBlue
      DownColor = clSkyBlue
      BtnLabel.HAlign = tbHLeft
      BtnLabel.VAlign = tbVTop
      BtnLabel.HMargin = 3
      BtnLabel.VMargin = 0
      BtnLabel.Caption = 'Hinzuf'#252'gen'
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
      ImageIndex = 4
      OnClick = btn_CancelClick
    end
    object btn_Del: TTBButton
      Left = 5
      Top = 8
      Width = 84
      Height = 25
      Flat = True
      SelectColor = clSkyBlue
      DownColor = clSkyBlue
      BtnLabel.HAlign = tbHLeft
      BtnLabel.VAlign = tbVTop
      BtnLabel.HMargin = 3
      BtnLabel.VMargin = 0
      BtnLabel.Caption = 'L'#246'schen'
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
      ImageIndex = 5
      OnClick = btn_CancelClick
    end
  end
  object Grid: TtbStringGrid
    Left = 0
    Top = 0
    Width = 545
    Height = 292
    Align = alClient
    ColCount = 8
    DefaultRowHeight = 64
    FixedCols = 0
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goFixedRowClick]
    TabOrder = 1
    AutosizeCol = -1
    AutosizeColMinWidth = -1
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = [fsBold]
    ColWidths = (
      64
      64
      64
      64
      64
      115
      0
      64)
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 384
    Top = 224
  end
end
