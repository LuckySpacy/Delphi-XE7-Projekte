object frm_Link_Entf: Tfrm_Link_Entf
  Left = 0
  Top = 0
  Caption = 'Verlinkung entfernen'
  ClientHeight = 475
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 527
    Height = 20
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object btn_LinkEntfernen: TTBButton
      Left = 0
      Top = 0
      Width = 20
      Height = 20
      Flat = False
      SelectColor = clSkyBlue
      DownColor = clSkyBlue
      BtnLabel.HAlign = tbHLeft
      BtnLabel.VAlign = tbVTop
      BtnLabel.HMargin = 0
      BtnLabel.VMargin = 0
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
      BtnImage.Margin = 2
      BtnImage.Height = 16
      BtnImage.Width = 16
      Images = dm.Img_Small
      ImageIndex = 20
      OnClick = btn_LinkEntfernenClick
      Align = alLeft
    end
  end
  object Grid_Link_Entf: TtbStringGrid
    Left = 0
    Top = 20
    Width = 527
    Height = 455
    Align = alClient
    ColCount = 1
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goFixedRowClick]
    TabOrder = 1
    AutosizeCol = -1
    AutosizeColMinWidth = 3
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = [fsBold]
  end
  object vt: TVirtualStringTree
    Left = 0
    Top = 20
    Width = 527
    Height = 455
    Align = alClient
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = [fsBold]
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    TabOrder = 2
    OnDrawText = vtDrawText
    OnFocusChanged = vtFocusChanged
    OnFreeNode = vtFreeNode
    OnGetText = vtGetText
    OnGetImageIndex = vtGetImageIndex
    OnInitNode = vtInitNode
    Columns = <
      item
        Position = 0
        Width = 145
        WideText = 'Seite/Bezeichnung'
      end
      item
        Position = 1
        Width = 281
        WideText = 'Dateiname'
      end>
  end
end
