object FrmExtDokumente: TFrmExtDokumente
  Left = 297
  Top = 179
  Caption = 'Externe Dokumente f'#252'r ...'
  ClientHeight = 542
  ClientWidth = 1006
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Pnl_Main: TLMDSimplePanel
    Left = 0
    Top = 82
    Width = 1006
    Height = 460
    Align = alClient
    Bevel.StyleInner = bvRaised
    Bevel.Mode = bmCustom
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Panel4: TPanel
      Left = 840
      Top = 26
      Width = 165
      Height = 433
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      BevelOuter = bvLowered
      TabOrder = 0
      object Button2: TLMDButton
        Left = 25
        Top = 167
        Width = 122
        Height = 21
        Caption = 'per E-Mail verschicken'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Visible = False
        OnClick = Button2Click
        ButtonStyle = ubsDelphi
      end
      object Button1: TLMDButton
        AlignWithMargins = True
        Left = 2
        Top = 26
        Width = 161
        Height = 21
        Margins.Left = 1
        Margins.Top = 1
        Margins.Right = 1
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Dokument aufrufen'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = Button1Click
        ButtonStyle = ubsDelphi
      end
      object Button4: TLMDButton
        AlignWithMargins = True
        Left = 2
        Top = 4
        Width = 161
        Height = 21
        Margins.Left = 1
        Margins.Right = 1
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Eintrag bearbeiten'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = Button4Click
        ButtonStyle = ubsDelphi
      end
      object cmd_SendMail: TLMDButton
        AlignWithMargins = True
        Left = 2
        Top = 48
        Width = 161
        Height = 21
        Margins.Left = 1
        Margins.Top = 1
        Margins.Right = 1
        Margins.Bottom = 0
        Align = alTop
        Caption = 'per E-Mail verschicken'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = cmd_SendMailClick
        ButtonStyle = ubsDelphi
      end
      object Btn_Kategorien: TLMDButton
        AlignWithMargins = True
        Left = 2
        Top = 70
        Width = 161
        Height = 21
        Margins.Left = 1
        Margins.Top = 1
        Margins.Right = 1
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Kategorien'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = Btn_KategorienClick
        ButtonStyle = ubsDelphi
      end
    end
    object Grd_Dokumente: TDBAdvGrid
      AlignWithMargins = True
      Left = 9
      Top = 34
      Width = 823
      Height = 417
      Cursor = crDefault
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alClient
      ColCount = 11
      DefaultRowHeight = 18
      DrawingStyle = gdsClassic
      FixedCols = 0
      RowCount = 5
      FixedRows = 1
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goRowSelect]
      PopupMenu = Pop
      ScrollBars = ssBoth
      TabOrder = 1
      OnMouseDown = Grd_DokumenteMouseDown
      HoverRowCells = [hcNormal, hcSelected]
      OnGetCellColor = Grd_DokumenteGetCellColor
      OnDblClickCell = Grd_DokumenteDblClickCell
      ActiveCellFont.Charset = DEFAULT_CHARSET
      ActiveCellFont.Color = clWindowText
      ActiveCellFont.Height = -11
      ActiveCellFont.Name = 'Tahoma'
      ActiveCellFont.Style = [fsBold]
      CellNode.TreeColor = clSilver
      ControlLook.FixedGradientHoverFrom = clGray
      ControlLook.FixedGradientHoverTo = clWhite
      ControlLook.FixedGradientDownFrom = clGray
      ControlLook.FixedGradientDownTo = clSilver
      ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownHeader.Font.Color = clWindowText
      ControlLook.DropDownHeader.Font.Height = -11
      ControlLook.DropDownHeader.Font.Name = 'Tahoma'
      ControlLook.DropDownHeader.Font.Style = []
      ControlLook.DropDownHeader.Visible = True
      ControlLook.DropDownHeader.Buttons = <>
      ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
      ControlLook.DropDownFooter.Font.Color = clWindowText
      ControlLook.DropDownFooter.Font.Height = -11
      ControlLook.DropDownFooter.Font.Name = 'Tahoma'
      ControlLook.DropDownFooter.Font.Style = []
      ControlLook.DropDownFooter.Visible = True
      ControlLook.DropDownFooter.Buttons = <>
      Filter = <>
      FilterDropDown.Font.Charset = DEFAULT_CHARSET
      FilterDropDown.Font.Color = clWindowText
      FilterDropDown.Font.Height = -11
      FilterDropDown.Font.Name = 'Tahoma'
      FilterDropDown.Font.Style = []
      FilterDropDownClear = '(All)'
      FilterEdit.TypeNames.Strings = (
        'Starts with'
        'Ends with'
        'Contains'
        'Not contains'
        'Equal'
        'Not equal'
        'Clear')
      FixedRowHeight = 18
      FixedFont.Charset = DEFAULT_CHARSET
      FixedFont.Color = clWindowText
      FixedFont.Height = -11
      FixedFont.Name = 'Tahoma'
      FixedFont.Style = [fsBold]
      FloatFormat = '%.2f'
      HoverButtons.Buttons = <>
      HoverButtons.Position = hbLeftFromColumnLeft
      PrintSettings.DateFormat = 'dd/mm/yyyy'
      PrintSettings.Font.Charset = DEFAULT_CHARSET
      PrintSettings.Font.Color = clWindowText
      PrintSettings.Font.Height = -11
      PrintSettings.Font.Name = 'MS Sans Serif'
      PrintSettings.Font.Style = []
      PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
      PrintSettings.FixedFont.Color = clWindowText
      PrintSettings.FixedFont.Height = -11
      PrintSettings.FixedFont.Name = 'MS Sans Serif'
      PrintSettings.FixedFont.Style = []
      PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
      PrintSettings.HeaderFont.Color = clWindowText
      PrintSettings.HeaderFont.Height = -11
      PrintSettings.HeaderFont.Name = 'MS Sans Serif'
      PrintSettings.HeaderFont.Style = []
      PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
      PrintSettings.FooterFont.Color = clWindowText
      PrintSettings.FooterFont.Height = -11
      PrintSettings.FooterFont.Name = 'MS Sans Serif'
      PrintSettings.FooterFont.Style = []
      PrintSettings.PageNumSep = '/'
      ScrollWidth = 16
      SearchFooter.FindNextCaption = 'Find next'
      SearchFooter.FindPrevCaption = 'Find previous'
      SearchFooter.Font.Charset = DEFAULT_CHARSET
      SearchFooter.Font.Color = clWindowText
      SearchFooter.Font.Height = -11
      SearchFooter.Font.Name = 'MS Sans Serif'
      SearchFooter.Font.Style = []
      SearchFooter.HighLightCaption = 'Highlight'
      SearchFooter.HintClose = 'Close'
      SearchFooter.HintFindNext = 'Find next occurence'
      SearchFooter.HintFindPrev = 'Find previous occurence'
      SearchFooter.HintHighlight = 'Highlight occurences'
      SearchFooter.MatchCaseCaption = 'Match case'
      SortSettings.DefaultFormat = ssAutomatic
      Version = '2.3.6.14'
      AutoCreateColumns = True
      AutoRemoveColumns = True
      Columns = <
        item
          Borders = []
          BorderPen.Color = clSilver
          CheckFalse = 'N'
          CheckTrue = 'Y'
          Color = clWindow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header = 'Typ'
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -11
          HeaderFont.Name = 'Tahoma'
          HeaderFont.Style = [fsBold]
          HeaderAlignment = taCenter
          PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
          PrintFont.Charset = DEFAULT_CHARSET
          PrintFont.Color = clWindowText
          PrintFont.Height = -11
          PrintFont.Name = 'Tahoma'
          PrintFont.Style = []
          Width = 64
        end
        item
          Borders = []
          BorderPen.Color = clSilver
          CheckFalse = 'N'
          CheckTrue = 'Y'
          Color = clWindow
          FieldName = 'OUT_ED_TITEL'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header = 'Titel'
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -11
          HeaderFont.Name = 'Tahoma'
          HeaderFont.Style = [fsBold]
          PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
          PrintFont.Charset = DEFAULT_CHARSET
          PrintFont.Color = clWindowText
          PrintFont.Height = -11
          PrintFont.Name = 'Tahoma'
          PrintFont.Style = []
          Width = 179
        end
        item
          Borders = []
          BorderPen.Color = clSilver
          CheckFalse = 'N'
          CheckTrue = 'Y'
          Color = clWindow
          FieldName = 'OUT_MATCH'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header = 'Bezug '#252'ber'
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -11
          HeaderFont.Name = 'Tahoma'
          HeaderFont.Style = [fsBold]
          PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
          PrintFont.Charset = DEFAULT_CHARSET
          PrintFont.Color = clWindowText
          PrintFont.Height = -11
          PrintFont.Name = 'Tahoma'
          PrintFont.Style = []
          Width = 148
        end
        item
          Borders = []
          BorderPen.Color = clSilver
          CheckFalse = 'N'
          CheckTrue = 'Y'
          Color = clWindow
          FieldName = 'OUT_ED_MAILEMPFAENGER'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header = 'Empf'#228'nger'
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -11
          HeaderFont.Name = 'Tahoma'
          HeaderFont.Style = [fsBold]
          PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
          PrintFont.Charset = DEFAULT_CHARSET
          PrintFont.Color = clWindowText
          PrintFont.Height = -11
          PrintFont.Name = 'Tahoma'
          PrintFont.Style = []
          Width = 110
        end
        item
          Borders = []
          BorderPen.Color = clSilver
          CheckFalse = 'N'
          CheckTrue = 'Y'
          Color = clWindow
          FieldName = 'OUT_ED_DOKUMENT'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header = 'Dokument'
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -11
          HeaderFont.Name = 'Tahoma'
          HeaderFont.Style = [fsBold]
          PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
          PrintFont.Charset = DEFAULT_CHARSET
          PrintFont.Color = clWindowText
          PrintFont.Height = -11
          PrintFont.Name = 'Tahoma'
          PrintFont.Style = []
          Width = 64
        end
        item
          Borders = []
          BorderPen.Color = clSilver
          CheckFalse = 'N'
          CheckTrue = 'Y'
          Color = clWindow
          FieldName = 'OUT_ED_DATUM'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header = 'akt. Datum'
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -11
          HeaderFont.Name = 'Tahoma'
          HeaderFont.Style = [fsBold]
          PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
          PrintFont.Charset = DEFAULT_CHARSET
          PrintFont.Color = clWindowText
          PrintFont.Height = -11
          PrintFont.Name = 'Tahoma'
          PrintFont.Style = []
          Width = 64
        end
        item
          Borders = []
          BorderPen.Color = clSilver
          CheckFalse = 'N'
          CheckTrue = 'Y'
          Color = clWindow
          FieldName = 'OUT_ED_MA_ID'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header = 'Mitarbeiter'
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -11
          HeaderFont.Name = 'Tahoma'
          HeaderFont.Style = [fsBold]
          PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
          PrintFont.Charset = DEFAULT_CHARSET
          PrintFont.Color = clWindowText
          PrintFont.Height = -11
          PrintFont.Name = 'Tahoma'
          PrintFont.Style = []
          Width = 64
        end
        item
          Borders = []
          BorderPen.Color = clSilver
          CheckFalse = 'N'
          CheckTrue = 'Y'
          Color = clWindow
          FieldName = 'OUT_ED_IMPORTDATEI'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header = 'Importdatei'
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -11
          HeaderFont.Name = 'Tahoma'
          HeaderFont.Style = [fsBold]
          PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
          PrintFont.Charset = DEFAULT_CHARSET
          PrintFont.Color = clWindowText
          PrintFont.Height = -11
          PrintFont.Name = 'Tahoma'
          PrintFont.Style = []
          Width = 64
        end
        item
          Borders = []
          BorderPen.Color = clSilver
          CheckFalse = 'N'
          CheckTrue = 'Y'
          Color = clWindow
          FieldName = 'OUT_FARBE'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -11
          HeaderFont.Name = 'Tahoma'
          HeaderFont.Style = [fsBold]
          PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
          PrintFont.Charset = DEFAULT_CHARSET
          PrintFont.Color = clWindowText
          PrintFont.Height = -11
          PrintFont.Name = 'Tahoma'
          PrintFont.Style = []
          Width = 59
        end
        item
          Borders = []
          BorderPen.Color = clSilver
          CheckFalse = 'N'
          CheckTrue = 'Y'
          Color = clWindow
          FieldName = 'Typ'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header = 'typtext'
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -11
          HeaderFont.Name = 'Tahoma'
          HeaderFont.Style = [fsBold]
          PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
          PrintFont.Charset = DEFAULT_CHARSET
          PrintFont.Color = clWindowText
          PrintFont.Height = -11
          PrintFont.Name = 'Tahoma'
          PrintFont.Style = []
          Width = 64
        end
        item
          Borders = []
          BorderPen.Color = clSilver
          CheckFalse = 'N'
          CheckTrue = 'Y'
          Color = clWindow
          FieldName = 'OUT_ED_ID'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -11
          HeaderFont.Name = 'Tahoma'
          HeaderFont.Style = [fsBold]
          PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
          PrintFont.Charset = DEFAULT_CHARSET
          PrintFont.Color = clWindowText
          PrintFont.Height = -11
          PrintFont.Name = 'Tahoma'
          PrintFont.Style = []
          Width = 64
        end>
      DataSource = Src_extDokumente
      InvalidPicture.Data = {
        055449636F6E0000010001002020200000000000A81000001600000028000000
        2000000040000000010020000000000000100000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000006A6A6B256A6A6B606A6A6B946A6A6BC06A6A6BE1
        6A6A6BF86A6A6BF86A6A6BE16A6A6BC06A6A6B946A6A6B606A6A6B2500000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000006A6A6B407575769E787879F19F9F9FF6C0C0C0FDDADADAFFEDEDEEFF
        FBFBFBFFFBFBFBFFEDEDEEFFDADADAFFC0C0C0FD9F9F9FF6787879F17575769E
        6A6A6B4000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000000000000000000000006A6A6B22
        7C7C7C98888889F0BDBDBDFCE9E9EBFED9D9E9FEB5B5DDFE8B8BCDFE595AB7FF
        3739A8FF2B2CA4FF4A49B1FF7171C1FFA1A2D7FFD3D3E8FFEAEAEBFEBEBEBFFC
        888889F07C7C7C986A6A6B220000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000006A6A6B43838383D8
        B7B7B8FAECECEFFEC0C0DFFF7977C4FF2221A0FF12129BFF1010A4FF0C0CA8FF
        0A0AACFF0A0AB4FF0A0AB9FF0D0DBEFF0F0FB1FF1111A6FF5656B8FFAEADDCFF
        ECECEFFEB7B7B8FA838383D86A6A6B4300000000000000000000000000000000
        00000000000000000000000000000000000000006A6A6B4E878788EAD3D3D3FE
        CACAE8FF4443B0FF171799FF11119CFF0C0C98FF0B0B9BFF0B0BA0FF0A0AA6FF
        0909ACFF0909B2FF0808BAFF0707BFFF0B09C8FF0D0DCEFF1111CCFF1010AFFF
        4A49B2FFCFCFEBFFD3D3D3FE878788EA6A6A6B4E000000000000000000000000
        000000000000000000000000000000006A6A6B43878788EAE1E1E1FFA8A8DAFF
        2323A0FF15159CFF0D0D92FF0C0C95FF0C0C99FF0B0B9EFF0B0BA0FF0A0AA6FF
        0909ACFF0909B2FF0808B8FF0808BCFF0808C3FF0C0CC9FF0C0CD0FF0D0DD6FF
        1313CFFF2222A9FFAFAFDEFFE1E1E1FF878788EA6A6A6B430000000000000000
        0000000000000000000000006A6A6B22838383D8D3D3D3FEA8A8D9FF2020A4FF
        13139BFF0C0C92FF0C0C95FF0C0C97FF0C0C99FF0B0B9EFF0B0BA0FF0A0AA4FF
        0A0AA9FF0909B0FF0808B4FF0808BBFF0707C0FF0A0AC6FF0909CCFF0C0CD3FF
        0D0DD8FF1313D3FF1A1AA8FFAEADDEFFD4D4D4FE838383D86A6A6B2200000000
        0000000000000000000000007C7C7C98B7B7B8FACACAE8FF2524A3FF13139FFF
        0C0C97FF0C0C95FF0C0C95FF0C0C91FF0C0C95FF0B0B9EFF0B0BA0FF0A0AA4FF
        0A0AA8FF0909ADFF0909B2FF0808B8FF0808BCFF0707C0FF0808BCFF0707C5FF
        0C0CD3FF0D0DD7FF1212D1FF2020A7FFCDCDEBFFB8B8B9FA7C7C7C9800000000
        00000000000000006A6A6B40888889F0ECECEFFE4545B1FF1616A4FF0B0B9BFF
        0C0C99FF0C0C96FF3333A2FFB9B9D0FF393A9BFF0C0C95FF0B0BA1FF0A0AA4FF
        0A0AA7FF0A0AABFF0909B0FF0808B4FF0808B7FF2F2FC2FFAEAEE2FF4B4BBFFF
        0707BEFF0B0BD1FF0C0CD3FF1413CCFF4848B1FFECECEFFE888889F06A6A6B40
        00000000000000007575769EBFBFBFFD9B9BD5FF1C1CA6FF0C0CA1FF0B0B9FFF
        0B0B9AFF3535A7FFB5B5BEFFE6E6DFFFEDEDEFFF3C3C9CFF0C0C97FF0A0AA4FF
        0A0AA6FF0A0AA9FF0909ADFF0909B0FF2626B5FFCECEDEFFFFFFFBFFEEEEF1FF
        4848BAFF0808BCFF0A0ACDFF0B0BCEFF1111ABFFBEC0E0FFBFC0BFFD7575769E
        000000006A6A6B25787879F1E3E3E5FE4646B2FF1414A8FF0A0AA4FF0B0BA0FF
        2121A9FFBDBDCAFFD0D0C8FFC5C5C5FFE3E3E1FFEDEDEFFF3E3E9EFF0C0C98FF
        0A0AA6FF0A0AA8FF0A0AA9FF2B2BB0FFC0C0CDFFEAEAE2FFEBEBEBFFFEFEF8FF
        EDEDEEFF2828BDFF0707C4FF0809C7FF0F0FC4FF8788CBFFEBEBECFE79797AF1
        6A6A6B256A6A6B609D9E9DF6D6D7E4FF3A3AB3FF1212ADFF0A0AA8FF0A0AA4FF
        1313AAFFABABCFFFD6D6CBFFCACACAFFC6C6C6FFE4E4E0FFEEEEEFFF3F3FA0FF
        0C0C99FF0A0AA6FF2828ABFFB2B2BFFFD8D8CEFFD6D6D8FFE0E0E0FFF6F5EDFF
        D1D1EDFF1E1CC0FF0707BEFF0707BFFF0707C0FF2120AAFFD3D5E9FE9FA0A0F6
        6A6A6B606A6A6B94BDBDBDFBBABBDCFF3A39B7FF2F2FB8FF0909ADFF0A0AA9FF
        0A0AA6FF1515ACFFADADCFFFD6D6CBFFCBCBCAFFC6C6C6FFE4E4E1FFEEEEEFFF
        3838A1FF2222A2FFACABB8FFC8C8C0FFC7C7C8FFCDCDCDFFE1E1D9FFC8CAE1FF
        2424BCFF0808B4FF0808B9FF0808BAFF0808BBFF0F0EABFFA1A2D5FEC0C0C0FC
        6A6A6B946A6A6BC0D9D8D7FE9999D1FF3838BBFF3636BCFF2C2CB7FF0909ADFF
        0A0AA9FF0A0AA4FF1C1CAFFFB1B1CFFFD6D6CBFFCCCCCBFFC7C7C7FFE4E4E1FF
        ECECEEFFACACB7FFC2C2BCFFBEBEBFFFC0C0C0FFCFCFC6FFC1C1D5FF2727B8FF
        0909ACFF0909B2FF0909B2FF0909B4FF0808B4FF0E0EB5FF6E6EBFFFD9D9D9FE
        6A6A6BC06A6A6BE1EBEAEBFF7D7CC7FF3838BFFF3434BEFF3536BEFF2A2AB8FF
        0909B0FF0909ACFF0A0AA8FF1C1CB1FFB2B2D0FFD7D7CCFFCBCBCBFFC7C7C8FF
        C8C8C3FFC6C6C3FFBFBFC1FFBDBDBDFFC5C5BCFFB8B8CEFF2929B5FF0A0AA8FF
        0909ACFF0909ADFF0909AFFF0909AFFF0909AFFF0C0CB0FF4747AFFFECECEDFF
        6A6A6BE16A6A6BF8F9F9F9FF6666C1FF3838C4FF3535C2FF3434C0FF3535BEFF
        3030BCFF1313B4FF0909ADFF0A0AA8FF1E1EB3FFAAAAD0FFD3D3CDFFCCCCCCFF
        C8C8C8FFC3C3C3FFC2C2C1FFC4C4BFFFB2B2CBFF2B2BB4FF0A0AA4FF0A0AA8FF
        0A0AA8FF0A0AA9FF0A0AA9FF0A0AA9FF0A0AA9FF0B0BA9FF3131A6FFFAFAFAFF
        6A6A6BF86A6A6BF8FBFBFBFF5959BEFF3B3BCAFF3A3AC8FF3737C4FF3535C2FF
        3636C0FF3636BEFF2323B8FF0909B1FF0A0AA7FF4949BEFFD6D6D4FFD3D3D1FF
        CDCDCDFFC8C8C8FFC4C4C3FFEDEDEDFF5F5FB3FF0C0C98FF0A0AA7FF0A0AA6FF
        0A0AA6FF0A0AA6FF0A0AA4FF0A0AA6FF0A0AA4FF0B0BA4FF2D2DA6FFFBFBFBFF
        6A6A6BF86A6A6BE1EDEDEEFF7F80CBFF4041CCFF3C3CCAFF3A3AC8FF383AC8FF
        3838C4FF3636C2FF3939C0FF2123B7FF4A4AC2FFCBCBDEFFE0E0DCFFD6D6D6FF
        D2D2D3FFCDCDCEFFC9C9C9FFE2E2E1FFF1F1F2FF4242A3FF0C0C99FF0A0AA4FF
        0A0AA4FF0A0AA4FF0B0BA3FF0B0BA3FF0B0BA1FF0E0EA1FF4443B0FFEDEDEEFF
        6A6A6BE16A6A6BC0DADADAFF9C9BD5FE4949CDFF3E3DD0FF3C3DCEFF3C3CCAFF
        3A3AC8FF3B39C7FF2828BDFF5C5CCCFFE5E5EDFFF4F4EDFFE5E5E6FFDEDEDEFF
        DCDCD9FFD9D9D3FFCDCDCDFFC8C8C8FFE5E5E1FFF1F1F3FF3F3FA0FF0C0C99FF
        0A0AA4FF0B0BA1FF0B0BA0FF0B0BA0FF0B0B9FFF1313A2FF6B6BC0FFDADADAFF
        6A6A6BC06A6A6B94C0C0C0FDBDBAE1FE5655CFFF4141D4FF3F3FD2FF3F3FCEFF
        3D3DCCFF2C2AC3FF5E5ED3FFEBEBF6FFFFFFFAFFF1F1F1FFEDEDEEFFF0F0E9FF
        D2D2E6FFBDBDD6FFDADAD3FFCFCFCFFFC9C9CAFFE5E5E2FFF1F1F3FF3A3AA0FF
        0C0C98FF0B0BA3FF0B0B9FFF0B0B9EFF0B0B9EFF1C1CA4FF9C9CD3FFC1C1C1FD
        6A6A6B946A6A6B609F9F9FF6DAD9EAFF6B6BCFFF4444D7FF4143D6FF4242D3FF
        3434CDFF6464DBFFEFEFFFFFFFFFFFFFFCFCFCFFF6F6F6FFFCFCF4FFE2E1F0FF
        5050CCFF4040C1FFC3C3DBFFE1E1D8FFD4D4D5FFCFCFCFFFE8E8E5FFF2F2F4FF
        4040A2FF0C0C99FF0F0FA2FF0F0FA0FF0F0F9DFF302FA9FFD1D1E8FEA0A0A0F6
        6A6A6B606A6A6B25787879F1E9E9EBFEA7A7DAFF6060DBFF4547DBFF3C3CD6FF
        5857DEFFF2F2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8F8FF5B5BD4FF
        2828BDFF2A2BBDFF4949C5FFC3C3DBFFE4E4DAFFD5D5D5FFCECED0FFE8E8E5FF
        F4F4F4FF4949AFFF2121A6FF2A2AA6FF2C2BA9FF5557B8FFEAEAECFE787879F1
        6A6A6B25000000007575769EBEBEBEFDC9CAE6FF7A79DBFF4C4CDFFF4141DBFF
        5757E0FFEAEAFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E7FFFF5B5BD7FF2E2EC6FF
        3E3EC9FF3A3AC5FF2C2EC1FF4A49C8FFC2C2DDFFE3E3DAFFD5D5D4FFDADAD3FF
        CACBD9FF4747BBFF2525ADFF2C2BACFF3332AEFFA5A4D8FFBFBFBFFD7575769E
        00000000000000006A6A6B40888889F0ECECEFFE9696D6FF7B7BE3FF4D4BE0FF
        4141DBFF5F5FE6FFE7E7FFFFFFFFFFFFE9E9FFFF5A5ADCFF3333CAFF4242CFFF
        4040CBFF3D3DC9FF3D3EC8FF3030C2FF4848C9FFC0C0DDFFECEEDEFFD0D0E0FF
        5554C7FF2828B3FF3232B4FF3434B1FF5453B7FFECECEFFE888889F06A6A6B40
        0000000000000000000000007C7C7C98B7B7B8FAD0D0ECFF8F8FDBFF6868E3FF
        4E4EE2FF3E40DBFF6565E9FFB2B2F7FF6565E4FF393BD2FF4646D7FF4343D4FF
        4343D1FF4242CFFF4040CBFF3F3FCAFF3333C4FF4E4ECBFF9E9EE2FF5C5BCFFF
        292ABAFF3636BCFF3938B8FF3F3EB1FFCBCBE9FFB7B7B8FA7C7C7C9800000000
        0000000000000000000000006A6A6B22838383D8D3D3D3FEB5B5E2FF9E9EE4FF
        6766E2FF4E50E6FF4646E0FF3D3DDAFF4444DCFF4B4BDCFF4848DBFF4847D9FF
        4646D5FF4443D3FF4343D1FF4242CFFF4143CDFF3A3AC8FF312FC5FF3535C3FF
        3C3CC3FF3D3DBEFF403FB5FFACACDCFFD3D3D3FE838383D86A6A6B2200000000
        000000000000000000000000000000006A6A6B43878788EAE1E1E1FFB5B5E2FF
        A7A6E4FF7877E5FF5151E5FF4F4FE4FF4E4EE2FF4D4DE0FF4C4CDEFF4B4BDCFF
        4949DBFF4848D7FF4747D5FF4545D3FF4545D1FF4343CFFF4242CCFF3F3FCBFF
        4343C2FF4645B6FFADADDCFFE1E1E1FF878788EA6A6A6B430000000000000000
        00000000000000000000000000000000000000006A6A6B4E878788EAD3D3D3FE
        D0D0ECFFAAA9DFFFA2A2ECFF6565E3FF5151E6FF4F4FE4FF4F4DE4FF4D4DE0FF
        4D4DDFFF4D4DDCFF4C49DBFF4A4AD8FF4749D6FF4747D4FF4949CBFF4B4BC3FF
        8E8ED0FFCDCCE8FFD3D3D3FE878788EA6A6A6B4E000000000000000000000000
        0000000000000000000000000000000000000000000000006A6A6B43838383D8
        B7B7B8FAECECEFFEC3C2E5FFADAEE1FF9E9DE8FF6F6FE0FF5C5CE1FF5452E2FF
        5051E1FF4F4FDFFF4F4FDBFF5150D6FF5151CFFF5F5FC8FFA1A1D3FEC7C8E0FE
        E4E4E7FEB7B7B8FA838383D86A6A6B4300000000000000000000000000000000
        000000000000000000000000000000000000000000000000000000006A6A6B22
        7C7C7C98888889F0BFBFBFFDEBEBECFED8D9EBFEBDBDE4FEA8A7DCFF9695D7FF
        8886D4FF7F7DCEFF8C8BD2FFA1A2D9FFC0BEE1FED9D9EAFEEAEAECFEBFBFBFFD
        888889F07C7C7C986A6A6B220000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000006A6A6B407575769E787879F19F9F9FF6C0C0C0FDDADADAFFEDEDEEFF
        FBFBFBFFFBFBFBFFEDEDEEFFDADADAFFC0C0C0FD9F9F9FF6787879F17575769E
        6A6A6B4000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000006A6A6B256A6A6B606A6A6B946A6A6BC06A6A6BE1
        6A6A6BF86A6A6BF86A6A6BE16A6A6BC06A6A6B946A6A6B606A6A6B2500000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000FFC003FFFF0000FFFC00003FF800001FF000000FE0000007C0000003
        C000000380000001800000010000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000080000001
        80000001C0000003C0000003E0000007F000000FF800001FFC00003FFF0000FF
        FFC003FF}
      ShowUnicode = False
      ExplicitLeft = 10
      ExplicitTop = 35
      ColWidths = (
        64
        179
        148
        110
        64
        64
        64
        64
        59
        64
        64)
      object Memo1: TMemo
        Left = 312
        Top = 192
        Width = 241
        Height = 153
        Lines.Strings = (
          'Memo1')
        TabOrder = 4
        Visible = False
      end
    end
    object Ueberschriftenpanel2: TUeberschriftenpanel
      Left = 1
      Top = 1
      Width = 1004
      Height = 25
      Align = alTop
      BevelOuter = bvNone
      Caption = ' '
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      NF_ImgList = FrmMain.Icons16
      NF_Index = 12
      NF_Text = 'Dokumente f'#252'r'
      NF_Height = 25
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1006
    Height = 47
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Btn_Neu: TLMDSpeedButton
      Left = 0
      Top = 0
      Width = 57
      Height = 47
      Caption = 'Neu'
      ParentFont = False
      AutoSize = False
      OnClick = Btn_NeuClick
      ButtonLayout.AlignText2Glyph = taBottom
      ImageList = FrmMain.IconConnector
      ImageIndex = 58
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Align = alLeft
      ButtonStyle = ubsExplorerColored
    end
    object Btn_Loeschen: TLMDSpeedButton
      Left = 127
      Top = 0
      Width = 60
      Height = 47
      Caption = 'L'#246'schen'
      ParentFont = False
      AutoSize = False
      OnClick = Btn_LoeschenClick
      ButtonLayout.AlignText2Glyph = taBottom
      ImageList = FrmMain.IconConnector
      ImageIndex = 30
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Align = alLeft
      ButtonStyle = ubsExplorerColored
    end
    object Btn_Import: TLMDSpeedButton
      Left = 57
      Top = 0
      Width = 70
      Height = 47
      Caption = 'Importieren'
      ParentFont = False
      AutoSize = False
      OnClick = Btn_ImportClick
      ButtonLayout.AlignText2Glyph = taBottom
      ImageList = FrmMain.IconConnector
      ImageIndex = 93
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Align = alLeft
      ButtonStyle = ubsExplorerColored
    end
    object Btn_Zurueck: TLMDSpeedButton
      AlignWithMargins = True
      Left = 955
      Top = 1
      Width = 50
      Height = 45
      Margins.Left = 1
      Margins.Top = 1
      Margins.Right = 1
      Margins.Bottom = 1
      Caption = 'Zur'#252'ck'
      ParentFont = False
      AutoSize = False
      OnClick = Btn_ZurueckClick
      ButtonLayout.AlignText2Glyph = taBottom
      ButtonLayout.ArrowPosition = apLeftGlyph
      ImageList = FrmMain.IconConnector
      ImageIndex = 81
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Align = alRight
      ButtonStyle = ubsExplorerColored
      DropDownRight = True
    end
    object btn_Speichern: TLMDSpeedButton
      Left = 187
      Top = 0
      Width = 70
      Height = 47
      Caption = 'Speichern'
      ParentFont = False
      AutoSize = False
      OnClick = btn_SpeichernClick
      ButtonLayout.AlignText2Glyph = taBottom
      ImageIndex = 93
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C30E0000C30E00000000000000000000FF00FFFF00FF
        B56E9DAB528DAB528DAB528DAB528DAB528DAB528DAB528DAB528DAB528DAB52
        8DAB528DAB528DAB528DFF00FFB46A9BAB528DAC548EFFFFFFFFFFFFAB538DAE
        5992FFFFFFFFFFFFFFFFFFFFFFFFFEFDFEAB528DAB528DAB528DFF00FFAB538D
        AB528DAC548EFFFFFFFFFFFFAB538DAE5992FFFFFFFFFFFFFFFFFFFFFFFFFEFD
        FEAB528DAB528DAB528DFF00FFAB538DAB528DAC548EFFFFFFFFFFFFAB538DAE
        5992FFFFFFFFFFFFFFFFFFFFFFFFFEFDFEAB528DAB528DAB528DFF00FFAB538D
        AB528DAC548EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFD
        FEAB528DAB528DAB528DFF00FFAB538DAB528DAB528DAB528DAB528DAB528DAB
        528DAB528DAB528DAB528DAB528DAB528DAB528DAB528DAB528DFF00FFAB538D
        AB528DAB528DAB528DAB528DAB528DAB528DAB528DAB528DAB528DAB528DAB52
        8DAB528DAB528DAB528DFF00FFAB538DAB528DE5CADCFEFDFEFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFDFEE7CDDEAB528DAB528DFF00FFAB538D
        AB528DFDFBFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFEFEFEAB528DAB528DFF00FFAB538DAB528DFDFCFDFFFFFFB8B8B8B8B8B8B8
        B8B8B8B8B8B8B8B8B8B8B8B8B8B8FFFFFFFFFFFFAB538DAB528DFF00FFAB538D
        AB528DFDFCFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFAB538DAB528DFF00FFAB538DAB528DFDFCFDFFFFFFB8B8B8B8B8B8B8
        B8B8B8B8B8B8B8B8B8B8B8B8B8B8FFFFFFFFFFFFAB538DAB528DFF00FFAB538D
        AB528DFDFBFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFEFEFEAB528DAB528DFF00FFAB538DAB528DE5CADCFEFDFEFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEE7CEDEAB528DAB528DFF00FFAB538D
        AB528DAB528DAB528DAB528DAB528DAB528DAB528DAB528DAB528DAB528DAB52
        8DAB528DAB528DAB528DFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Align = alLeft
      ButtonStyle = ubsExplorerColored
      ExplicitTop = -5
    end
  end
  object LMDSimplePanel2: TLMDSimplePanel
    Left = 0
    Top = 47
    Width = 1006
    Height = 35
    Align = alTop
    Bevel.Mode = bmCustom
    Bevel.StandardStyle = lsSingle
    Color = clActiveBorder
    TabOrder = 2
    object Lbl_Kategorie: TLabel
      Left = 8
      Top = 11
      Width = 62
      Height = 13
      Caption = 'Kategorien'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object CoB_Kategorie: TNFSComboBox
      Left = 79
      Top = 7
      Width = 210
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnSelect = CoB_KategorieSelect
      SQL.Strings = (
        
          'select DK_ID, DK_BEZ from DOKKATEGORIEN where DK_DELETE != "T"  ' +
          'order by DK_BEZ')
    end
  end
  object IBQ_ExtDokumente: TIBQuery
    Database = DM.IBD
    Transaction = IBT_Dokumenten
    SQL.Strings = (
      
        'select * from Externe_Dokumenten(1, :bezugsid, :bezugstyp, :bezi' +
        'ehung, :bezugsid ) ')
    Left = 32
    Top = 328
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'bezugsid'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'bezugstyp'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'beziehung'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'bezugsid'
        ParamType = ptUnknown
      end>
    object IBQ_ExtDokumenteDummy: TStringField
      FieldKind = fkCalculated
      FieldName = 'Dummy'
      Calculated = True
    end
    object IBQ_ExtDokumenteTyp: TStringField
      FieldKind = fkCalculated
      FieldName = 'Typ'
      OnGetText = IBQ_ExtDokumenteTypGetText
      Size = 255
      Calculated = True
    end
    object IBQ_ExtDokumenteOUT_ED_DATUM: TDateTimeField
      FieldName = 'OUT_ED_DATUM'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_DATUM'
    end
    object IBQ_ExtDokumenteOUT_ED_DELETE: TIBStringField
      FieldName = 'OUT_ED_DELETE'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_DELETE'
      FixedChar = True
      Size = 1
    end
    object IBQ_ExtDokumenteOUT_ED_UPDATE: TIBStringField
      FieldName = 'OUT_ED_UPDATE'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_UPDATE'
      FixedChar = True
      Size = 1
    end
    object IBQ_ExtDokumenteOUT_ED_BEZUGSID: TIntegerField
      FieldName = 'OUT_ED_BEZUGSID'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_BEZUGSID'
    end
    object IBQ_ExtDokumenteOUT_ED_BEZUGSTYP: TIntegerField
      FieldName = 'OUT_ED_BEZUGSTYP'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_BEZUGSTYP'
    end
    object IBQ_ExtDokumenteOUT_ED_ART: TIntegerField
      FieldName = 'OUT_ED_ART'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_ART'
    end
    object IBQ_ExtDokumenteOUT_ED_TITEL: TIBStringField
      FieldName = 'OUT_ED_TITEL'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_TITEL'
      Size = 125
    end
    object IBQ_ExtDokumenteOUT_ED_DOKUMENT: TIBStringField
      FieldName = 'OUT_ED_DOKUMENT'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_DOKUMENT'
      Size = 255
    end
    object IBQ_ExtDokumenteOUT_ED_MA_ID: TIntegerField
      FieldName = 'OUT_ED_MA_ID'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_MA_ID'
      OnGetText = IBQ_ExtDokumenteED_MA_IDGetText
    end
    object IBQ_ExtDokumenteOUT_ED_MAILEMPFAENGER: TIBStringField
      FieldName = 'OUT_ED_MAILEMPFAENGER'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_MAILEMPFAENGER'
      Size = 200
    end
    object IBQ_ExtDokumenteOUT_ED_IMPORTDATEI: TIBStringField
      FieldName = 'OUT_ED_IMPORTDATEI'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_IMPORTDATEI'
      Size = 255
    end
    object IBQ_ExtDokumenteOUT_ED_SM_ID: TIntegerField
      FieldName = 'OUT_ED_SM_ID'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_SM_ID'
    end
    object IBQ_ExtDokumenteOUT_ED_MAILABSENDER: TIBStringField
      FieldName = 'OUT_ED_MAILABSENDER'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_MAILABSENDER'
      Size = 200
    end
    object IBQ_ExtDokumenteOUT_ED_VERZEICHNISINDEX: TIntegerField
      FieldName = 'OUT_ED_VERZEICHNISINDEX'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_VERZEICHNISINDEX'
    end
    object IBQ_ExtDokumenteOUT_ED_BEZUGSSUBID: TIntegerField
      FieldName = 'OUT_ED_BEZUGSSUBID'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_BEZUGSSUBID'
    end
    object IBQ_ExtDokumenteOUT_ED_BEZUGSSUBTYP: TIntegerField
      FieldName = 'OUT_ED_BEZUGSSUBTYP'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_BEZUGSSUBTYP'
    end
    object IBQ_ExtDokumenteOUT_ED_ID: TIntegerField
      FieldName = 'OUT_ED_ID'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_ED_ID'
    end
    object IBQ_ExtDokumenteOUT_EGON: TIntegerField
      FieldName = 'OUT_EGON'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_EGON'
    end
    object IBQ_ExtDokumenteOUT_FARBE: TIntegerField
      FieldName = 'OUT_FARBE'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_FARBE'
    end
    object IBQ_ExtDokumenteOUT_MATCH: TIBStringField
      FieldName = 'OUT_MATCH'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_MATCH'
      Size = 80
    end
    object IBQ_ExtDokumenteOUT_KAT: TIntegerField
      FieldName = 'OUT_KAT'
      Origin = 'EXTERNE_DOKUMENTEN.OUT_KAT'
    end
  end
  object Src_extDokumente: TDataSource
    DataSet = IBQ_ExtDokumente
    OnDataChange = Src_extDokumenteDataChange
    Left = 136
    Top = 328
  end
  object IBT_Edit: TIBTransaction
    DefaultDatabase = DM.IBD
    Left = 232
    Top = 328
  end
  object MainMenu1: TMainMenu
    Left = 248
    Top = 168
    object Funktionen1: TMenuItem
      Caption = 'Funktionen'
      Visible = False
      object NeueLieferadresseanlegen1: TMenuItem
        Caption = 'Neue Dokument anlegen'
        ShortCut = 45
        OnClick = Btn_NeuClick
      end
      object Lieferadresseleschen1: TMenuItem
        Caption = 'Dokument l'#246'eschen'
        ShortCut = 46
        OnClick = Btn_LoeschenClick
      end
      object Standard1: TMenuItem
        Caption = 'Importieren'
        ShortCut = 16457
        OnClick = Btn_ImportClick
      end
      object Schlieen1: TMenuItem
        Caption = 'Schlie'#223'en'
        ShortCut = 27
        OnClick = Schlieen1Click
      end
    end
  end
  object DropSource1: TDropFileSource
    DragTypes = [dtCopy, dtMove, dtLink]
    ShowImage = True
    Left = 736
    Top = 128
  end
  object DropFileTarget1: TDropFileTarget
    DragTypes = [dtCopy, dtLink]
    GetDataOnEnter = True
    OnDrop = DropFileTarget1Drop
    Target = Grd_Dokumente
    MultiTarget = True
    OptimizedMove = True
    Left = 736
    Top = 176
  end
  object DataFormatAdapterBitmap: TDataFormatAdapter
    DragDropComponent = DropFileTarget1
    DataFormatName = 'TBitmapDataFormat'
    Left = 736
    Top = 368
  end
  object DataFormatAdapterText: TDataFormatAdapter
    DragDropComponent = DropFileTarget1
    DataFormatName = 'TTextDataFormat'
    Left = 736
    Top = 320
  end
  object DataFormatAdapterOutlook: TDataFormatAdapter
    DragDropComponent = DropFileTarget1
    DataFormatName = 'TOutlookDataFormat'
    Left = 736
    Top = 224
  end
  object Pop: TPopupMenu
    Images = FrmMain.IconConnector
    Left = 624
    Top = 328
    object mnu_Loeschen: TMenuItem
      Caption = 'L'#246'schen'
      ImageIndex = 30
      OnClick = mnu_LoeschenClick
    end
  end
  object DataFormatAdapterTarget: TDataFormatAdapter
    DragDropComponent = DropFileTarget1
    DataFormatName = 'TVirtualFileStreamDataFormat'
    Left = 736
    Top = 272
  end
  object SaveDialog: TSaveDialog
    Left = 456
    Top = 152
  end
  object IBT_Dokumenten: TIBTransaction
    DefaultDatabase = DM.IBD
    Left = 232
    Top = 272
  end
end
