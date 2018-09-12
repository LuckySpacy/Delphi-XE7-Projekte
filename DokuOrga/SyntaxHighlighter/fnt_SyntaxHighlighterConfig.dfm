object frm_SyntaxHighlighterConfig: Tfrm_SyntaxHighlighterConfig
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Einstellung f'#252'r den Syntaxhighlighter'
  ClientHeight = 535
  ClientWidth = 1022
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnl_Top: TPanel
    Left = 0
    Top = 0
    Width = 1022
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnl_Top'
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 1005
    object btn_Testen: TSpeedButton
      Left = 14
      Top = 9
      Width = 93
      Height = 22
      Caption = 'Testen'
      OnClick = btn_TestenClick
    end
    object btn_Cancel: TSpeedButton
      Left = 907
      Top = 9
      Width = 93
      Height = 22
      Caption = 'Abbrechen'
      OnClick = btn_CancelClick
    end
  end
  object pnl_Bottom: TPanel
    Left = 0
    Top = 494
    Width = 1022
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 1005
  end
  object pnl_fontstyle: TPanel
    Left = 0
    Top = 41
    Width = 185
    Height = 453
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'pnl_fontstyle'
    ShowCaption = False
    TabOrder = 2
    object pnl_fontstyletop: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 179
      Height = 16
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Fontstyle'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object pnl_fontstylebutton: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 22
      Width = 179
      Height = 24
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnl_fontstyletop'
      ShowCaption = False
      TabOrder = 1
      object btn_Neu_Fontstyle: TButton
        Left = 0
        Top = 0
        Width = 40
        Height = 24
        Align = alLeft
        Caption = 'Neu'
        TabOrder = 0
        OnClick = btn_Neu_FontstyleClick
      end
      object btn_Edit_Fontstyle: TButton
        Left = 40
        Top = 0
        Width = 64
        Height = 24
        Align = alLeft
        Caption = 'Bearbeiten'
        TabOrder = 1
        OnClick = btn_Edit_FontstyleClick
      end
      object btn_del_Fontstyle: TButton
        Left = 104
        Top = 0
        Width = 56
        Height = 24
        Align = alLeft
        Caption = 'L'#246'schen'
        TabOrder = 2
        OnClick = btn_del_FontstyleClick
      end
    end
    object lsb_Fontstyles: TListBox
      AlignWithMargins = True
      Left = 3
      Top = 49
      Width = 179
      Height = 401
      Align = alClient
      ItemHeight = 13
      TabOrder = 2
      OnClick = lsb_FontstylesClick
    end
  end
  object Panel4: TPanel
    Left = 185
    Top = 41
    Width = 216
    Height = 453
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'pnl_fontstyle'
    ShowCaption = False
    TabOrder = 3
    object Panel5: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 210
      Height = 16
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Kommentare'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object Panel6: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 22
      Width = 210
      Height = 24
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnl_fontstyletop'
      ShowCaption = False
      TabOrder = 1
      object btn_Up: TSpeedButton
        Left = 160
        Top = 0
        Width = 23
        Height = 24
        Align = alLeft
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C30E0000C30E00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFB3783FB3783EB3783FFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB3
          783EB3783EB3783EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFB3783EB3783EB3783EFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB3
          783EB3783EB3783EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFB3783EB3783EB3783EFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB3
          783EB3783EB3783EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          B3783EFF00FFFF00FFFF00FFFF00FFB3783EB3783EB3783EFF00FFFF00FFFF00
          FFFF00FFB3783EFF00FFFF00FFFF00FFB3783EB3783EFF00FFFF00FFFF00FFB3
          783EB3783EB3783EFF00FFFF00FFFF00FFB3783EB3783EFF00FFFF00FFFF00FF
          B3783EB3783EB3783EFF00FFFF00FFB3783EB3783EB3783EFF00FFFF00FFB378
          3EB3783EB3783EFF00FFFF00FFFF00FFB1773EB3783EB3783EB3783EFF00FFB3
          783EB3783EB3783EFF00FFB3783EB3783EB3783EB1773EFF00FFFF00FFFF00FF
          FF00FFB1773EB3783EB3783EB3783EB3783EB3783EB3783EB3783EB3783EB378
          3EB1773EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB1773EB3783EB3783EB3
          783EB3783EB3783EB3783EB3783EB1773EFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFB1773EB3783EB3783EB3783EB3783EB3783EB1773EFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB1773EB3
          783EB3783EB3783EB1773EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFB1773EB3783EB1773EFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFB1773EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        OnClick = btn_UpClick
        ExplicitLeft = 103
        ExplicitTop = 1
        ExplicitHeight = 22
      end
      object btn_Down: TSpeedButton
        Left = 183
        Top = 0
        Width = 23
        Height = 24
        Align = alLeft
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C30E0000C30E00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFB1773EFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB1773EB3
          783EB1773EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFB1773EB3783EB3783EB3783EB1773EFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB1773EB3783EB3783EB3
          783EB3783EB3783EB1773EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFB1773EB3783EB3783EB3783EB3783EB3783EB3783EB3783EB1773EFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFB1773EB3783EB3783EB3783EB3783EB3
          783EB3783EB3783EB3783EB3783EB1773EFF00FFFF00FFFF00FFFF00FFB1773E
          B3783EB3783EB3783EFF00FFB3783EB3783EB3783EFF00FFB3783EB3783EB378
          3EB1773EFF00FFFF00FFFF00FFB3783EB3783EB3783EFF00FFFF00FFB3783EB3
          783EB3783EFF00FFFF00FFB3783EB3783EB3783EFF00FFFF00FFFF00FFB3783E
          B3783EFF00FFFF00FFFF00FFB3783EB3783EB3783EFF00FFFF00FFFF00FFB378
          3EB3783EFF00FFFF00FFFF00FFB3783EFF00FFFF00FFFF00FFFF00FFB3783EB3
          783EB3783EFF00FFFF00FFFF00FFFF00FFB3783EFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFB3783EB3783EB3783EFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB3783EB3
          783EB3783EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFB3783EB3783EB3783EFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB3783EB3
          783EB3783EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFB3783EB3783EB3783EFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB3783FB3
          783EB3783FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        OnClick = btn_DownClick
        ExplicitLeft = 149
        ExplicitTop = 6
        ExplicitHeight = 22
      end
      object btn_Neu_Kommentar: TButton
        Left = 0
        Top = 0
        Width = 40
        Height = 24
        Align = alLeft
        Caption = 'Neu'
        TabOrder = 0
        OnClick = btn_Neu_KommentarClick
      end
      object btn_Del_Kommentar: TButton
        Left = 104
        Top = 0
        Width = 56
        Height = 24
        Align = alLeft
        Caption = 'L'#246'schen'
        TabOrder = 1
        OnClick = btn_Del_KommentarClick
      end
      object btn_Edit_Kommentar: TButton
        Left = 40
        Top = 0
        Width = 64
        Height = 24
        Align = alLeft
        Caption = 'Bearbeiten'
        TabOrder = 2
        OnClick = btn_Edit_KommentarClick
      end
    end
    object lsb_Kommentar: TListBox
      AlignWithMargins = True
      Left = 3
      Top = 49
      Width = 210
      Height = 401
      Align = alClient
      ItemHeight = 13
      TabOrder = 2
    end
  end
  object Panel8: TPanel
    Left = 401
    Top = 41
    Width = 185
    Height = 453
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'pnl_fontstyle'
    ShowCaption = False
    TabOrder = 4
    object Panel9: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 179
      Height = 16
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Bereich'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object Panel10: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 22
      Width = 179
      Height = 24
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnl_fontstyletop'
      ShowCaption = False
      TabOrder = 1
      object btn_Neu_Bereich: TButton
        Left = 0
        Top = 0
        Width = 40
        Height = 24
        Align = alLeft
        Caption = 'Neu'
        TabOrder = 0
        OnClick = btn_Neu_BereichClick
      end
      object btn_Edit_Bereich: TButton
        Left = 40
        Top = 0
        Width = 64
        Height = 24
        Align = alLeft
        Caption = 'Bearbeiten'
        TabOrder = 1
        OnClick = btn_Edit_BereichClick
      end
      object btn_Del_Bereich: TButton
        Left = 104
        Top = 0
        Width = 64
        Height = 24
        Align = alLeft
        Caption = 'L'#246'schen'
        TabOrder = 2
        OnClick = btn_Del_BereichClick
      end
    end
    object lsb_Bereich: TListBox
      AlignWithMargins = True
      Left = 3
      Top = 49
      Width = 179
      Height = 401
      Align = alClient
      ItemHeight = 13
      TabOrder = 2
      OnClick = lsb_BereichClick
    end
  end
  object Panel3: TPanel
    Left = 586
    Top = 41
    Width = 185
    Height = 453
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'pnl_fontstyle'
    ShowCaption = False
    TabOrder = 5
    object Panel7: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 179
      Height = 16
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Wortliste'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object mem_Wortliste: TMemo
      AlignWithMargins = True
      Left = 3
      Top = 49
      Width = 179
      Height = 401
      Align = alClient
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'Memo1')
      ParentFont = False
      TabOrder = 1
      OnExit = mem_WortlisteExit
    end
    object Panel13: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 22
      Width = 179
      Height = 24
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnl_fontstyletop'
      ShowCaption = False
      TabOrder = 2
    end
  end
  object Panel1: TPanel
    Left = 771
    Top = 41
    Width = 110
    Height = 453
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'pnl_fontstyle'
    ShowCaption = False
    TabOrder = 6
    object Panel2: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 104
      Height = 16
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Wortendezeichen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object mem_Wortendezeichen: TMemo
      AlignWithMargins = True
      Left = 3
      Top = 49
      Width = 104
      Height = 401
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'Memo1')
      ParentFont = False
      TabOrder = 1
      OnExit = mem_WortendezeichenExit
    end
    object Panel14: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 22
      Width = 104
      Height = 24
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnl_fontstyletop'
      ShowCaption = False
      TabOrder = 2
    end
  end
  object Panel11: TPanel
    Left = 881
    Top = 41
    Width = 122
    Height = 453
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'pnl_fontstyle'
    ShowCaption = False
    TabOrder = 7
    object Panel12: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 116
      Height = 16
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Wortanfangzeichen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object mem_Wortanfangzeichen: TMemo
      AlignWithMargins = True
      Left = 3
      Top = 49
      Width = 116
      Height = 401
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'Memo1')
      ParentFont = False
      TabOrder = 1
      OnExit = mem_WortanfangzeichenExit
    end
    object Panel15: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 22
      Width = 116
      Height = 24
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnl_fontstyletop'
      ShowCaption = False
      TabOrder = 2
    end
  end
end
