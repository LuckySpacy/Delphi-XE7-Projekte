object frm_Artikeleigenschaft: Tfrm_Artikeleigenschaft
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frm_Artikeleigenschaft'
  ClientHeight = 401
  ClientWidth = 657
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnl_Top: TPanel
    Left = 0
    Top = 0
    Width = 657
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnl_Top'
    ShowCaption = False
    TabOrder = 0
    object lbl_Artikel: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 637
      Height = 13
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Align = alTop
      Caption = 'lbl_Artikel'
      ExplicitWidth = 46
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 41
    Width = 657
    Height = 360
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object pnl_Bottom: TPanel
        Left = 0
        Top = 291
        Width = 649
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'pnl_Top'
        ShowCaption = False
        TabOrder = 0
        ExplicitTop = 294
        object btn_Einlesen: TTBButton
          AlignWithMargins = True
          Left = 116
          Top = 3
          Width = 107
          Height = 35
          Flat = True
          SelectColor = clSkyBlue
          DownColor = clSkyBlue
          BtnLabel.HAlign = tbHLeft
          BtnLabel.VAlign = tbVTop
          BtnLabel.HMargin = 3
          BtnLabel.VMargin = 0
          BtnLabel.Caption = 'Text einlesen'
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
          OnClick = btn_EinlesenClick
          Align = alLeft
          ExplicitLeft = 11
          ExplicitTop = 6
        end
        object btn_Uebersicht: TTBButton
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 107
          Height = 35
          Flat = True
          SelectColor = clSkyBlue
          DownColor = clSkyBlue
          BtnLabel.HAlign = tbHLeft
          BtnLabel.VAlign = tbVTop
          BtnLabel.HMargin = 3
          BtnLabel.VMargin = 0
          BtnLabel.Caption = #220'bersicht'
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
          OnClick = btn_UebersichtClick
          Align = alLeft
          ExplicitLeft = 11
          ExplicitTop = 6
        end
      end
      object pnl_Left: TPanel
        Left = 0
        Top = 0
        Width = 649
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        Caption = 'pnl_Top'
        ShowCaption = False
        TabOrder = 1
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 89
          Height = 41
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel1'
          ShowCaption = False
          TabOrder = 0
          object Label1: TLabel
            AlignWithMargins = True
            Left = 10
            Top = 10
            Width = 69
            Height = 13
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Align = alTop
            Caption = 'Eigenschaften'
            ExplicitWidth = 68
          end
        end
        object Panel2: TPanel
          Left = 89
          Top = 0
          Width = 560
          Height = 41
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel1'
          ShowCaption = False
          TabOrder = 1
          object cbo_Eigenschaftname: TComboBox
            AlignWithMargins = True
            Left = 0
            Top = 6
            Width = 550
            Height = 21
            Margins.Left = 0
            Margins.Top = 6
            Margins.Right = 10
            Align = alTop
            Style = csDropDownList
            TabOrder = 0
            OnChange = cbo_EigenschaftnameChange
          end
        end
      end
      object pnl_Client: TPanel
        Left = 0
        Top = 41
        Width = 649
        Height = 250
        Align = alClient
        BevelOuter = bvNone
        Caption = 'pnl_Top'
        ShowCaption = False
        TabOrder = 2
        object grd: TAdvStringGrid
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 643
          Height = 244
          Cursor = crDefault
          Align = alClient
          DrawingStyle = gdsClassic
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 0
          HoverRowCells = [hcNormal, hcSelected]
          OnGetAlignment = grdGetAlignment
          OnCheckBoxClick = grdCheckBoxClick
          ActiveCellFont.Charset = DEFAULT_CHARSET
          ActiveCellFont.Color = clWindowText
          ActiveCellFont.Height = -11
          ActiveCellFont.Name = 'Tahoma'
          ActiveCellFont.Style = [fsBold]
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
          FilterDropDown.TextChecked = 'Checked'
          FilterDropDown.TextUnChecked = 'Unchecked'
          FilterDropDownClear = '(All)'
          FilterEdit.TypeNames.Strings = (
            'Starts with'
            'Ends with'
            'Contains'
            'Not contains'
            'Equal'
            'Not equal'
            'Clear')
          FixedRowHeight = 22
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
          PrintSettings.Font.Name = 'Tahoma'
          PrintSettings.Font.Style = []
          PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
          PrintSettings.FixedFont.Color = clWindowText
          PrintSettings.FixedFont.Height = -11
          PrintSettings.FixedFont.Name = 'Tahoma'
          PrintSettings.FixedFont.Style = []
          PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
          PrintSettings.HeaderFont.Color = clWindowText
          PrintSettings.HeaderFont.Height = -11
          PrintSettings.HeaderFont.Name = 'Tahoma'
          PrintSettings.HeaderFont.Style = []
          PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
          PrintSettings.FooterFont.Color = clWindowText
          PrintSettings.FooterFont.Height = -11
          PrintSettings.FooterFont.Name = 'Tahoma'
          PrintSettings.FooterFont.Style = []
          PrintSettings.PageNumSep = '/'
          SearchFooter.FindNextCaption = 'Find &next'
          SearchFooter.FindPrevCaption = 'Find &previous'
          SearchFooter.Font.Charset = DEFAULT_CHARSET
          SearchFooter.Font.Color = clWindowText
          SearchFooter.Font.Height = -11
          SearchFooter.Font.Name = 'Tahoma'
          SearchFooter.Font.Style = []
          SearchFooter.HighLightCaption = 'Highlight'
          SearchFooter.HintClose = 'Close'
          SearchFooter.HintFindNext = 'Find next occurrence'
          SearchFooter.HintFindPrev = 'Find previous occurrence'
          SearchFooter.HintHighlight = 'Highlight occurrences'
          SearchFooter.MatchCaseCaption = 'Match case'
          SortSettings.DefaultFormat = ssAutomatic
          Version = '7.4.6.3'
        end
      end
    end
    object tbs_Artikeleigenschaft2: TTabSheet
      Caption = 'Eigenschaft 2'
      ImageIndex = 1
    end
  end
end
