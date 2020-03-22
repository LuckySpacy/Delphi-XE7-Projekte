object frm_TSIServer: Tfrm_TSIServer
  Left = 0
  Top = 0
  Caption = 'TSI-Server'
  ClientHeight = 362
  ClientWidth = 491
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
  object pg: TPageControl
    Left = 0
    Top = 0
    Width = 491
    Height = 276
    ActivePage = tbs_Protokoll
    Align = alClient
    TabOrder = 0
    object tbs_Einstellung: TTabSheet
      Caption = 'Einstellungen'
      object GroupBox1: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 477
        Height = 54
        Align = alTop
        Caption = 'Interval'
        TabOrder = 0
        object Label1: TLabel
          Left = 9
          Top = 22
          Width = 38
          Height = 13
          Caption = 'Uhrzeit:'
        end
        object Label5: TLabel
          Left = 145
          Top = 22
          Width = 62
          Height = 13
          Caption = 'Schnittstelle:'
        end
        object edt_Uhrzeit: TDateTimePicker
          Left = 53
          Top = 18
          Width = 76
          Height = 21
          Date = 43162.654688981480000000
          Time = 43162.654688981480000000
          Kind = dtkTime
          TabOrder = 0
          OnExit = EditExit
        end
        object cbo_Schnittstelle: TComboBox
          Left = 213
          Top = 18
          Width = 236
          Height = 21
          Style = csDropDownList
          TabOrder = 1
          OnExit = cbo_SchnittstelleExit
        end
      end
      object GroupBox2: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 63
        Width = 477
        Height = 74
        Align = alTop
        Caption = 'Pfade'
        TabOrder = 1
        DesignSize = (
          477
          74)
        object lbl_Downloadpfad: TLabel
          Left = 9
          Top = 22
          Width = 73
          Height = 13
          Caption = 'Downloadpfad:'
        end
        object lbl_Zielpfad: TLabel
          Left = 9
          Top = 49
          Width = 42
          Height = 13
          Caption = 'Zielpfad:'
        end
        object edt_Downloadpfad: TAdvDirectoryEdit
          Left = 88
          Top = 19
          Width = 381
          Height = 21
          EmptyTextStyle = []
          Flat = False
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          Lookup.Font.Charset = DEFAULT_CHARSET
          Lookup.Font.Color = clWindowText
          Lookup.Font.Height = -11
          Lookup.Font.Name = 'Arial'
          Lookup.Font.Style = []
          Lookup.Separator = ';'
          Anchors = [akLeft, akTop, akRight]
          Color = clWindow
          ReadOnly = False
          TabOrder = 0
          Text = ''
          Visible = True
          OnExit = EditExit
          Version = '1.3.5.0'
          ButtonStyle = bsButton
          ButtonWidth = 18
          Etched = False
          Glyph.Data = {
            CE000000424DCE0000000000000076000000280000000C0000000B0000000100
            0400000000005800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00F00000000FFF
            00000088888880FF00000B088888880F00000BB08888888000000BBB00000000
            00000BBBBBBB0B0F00000BBB00000B0F0000F000BBBBBB0F0000FF0BBBBBBB0F
            0000FF0BBB00000F0000FFF000FFFFFF0000}
          BrowseDialogText = 'Select Directory'
        end
        object edt_Zielpfad: TAdvDirectoryEdit
          Left = 88
          Top = 46
          Width = 381
          Height = 21
          EmptyTextStyle = []
          Flat = False
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          Lookup.Font.Charset = DEFAULT_CHARSET
          Lookup.Font.Color = clWindowText
          Lookup.Font.Height = -11
          Lookup.Font.Name = 'Arial'
          Lookup.Font.Style = []
          Lookup.Separator = ';'
          Anchors = [akLeft, akTop, akRight]
          Color = clWindow
          ReadOnly = False
          TabOrder = 1
          Text = ''
          Visible = True
          OnExit = EditExit
          Version = '1.3.5.0'
          ButtonStyle = bsButton
          ButtonWidth = 18
          Etched = False
          Glyph.Data = {
            CE000000424DCE0000000000000076000000280000000C0000000B0000000100
            0400000000005800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00F00000000FFF
            00000088888880FF00000B088888880F00000BB08888888000000BBB00000000
            00000BBBBBBB0B0F00000BBB00000B0F0000F000BBBBBB0F0000FF0BBBBBBB0F
            0000FF0BBB00000F0000FFF000FFFFFF0000}
          BrowseDialogText = 'Select Directory'
        end
      end
      object GroupBox3: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 143
        Width = 477
        Height = 106
        Align = alTop
        Caption = 'Datenbank'
        TabOrder = 2
        DesignSize = (
          477
          106)
        object Label2: TLabel
          Left = 9
          Top = 50
          Width = 31
          Height = 13
          Caption = 'Kurse:'
        end
        object Label3: TLabel
          Left = 9
          Top = 77
          Width = 20
          Height = 13
          Caption = 'TSI:'
        end
        object Label4: TLabel
          Left = 9
          Top = 23
          Width = 36
          Height = 13
          Caption = 'Server:'
        end
        object edt_KurseFDB: TAdvDirectoryEdit
          Left = 88
          Top = 47
          Width = 381
          Height = 21
          EmptyTextStyle = []
          Flat = False
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          Lookup.Font.Charset = DEFAULT_CHARSET
          Lookup.Font.Color = clWindowText
          Lookup.Font.Height = -11
          Lookup.Font.Name = 'Arial'
          Lookup.Font.Style = []
          Lookup.Separator = ';'
          Anchors = [akLeft, akTop, akRight]
          Color = clWindow
          ReadOnly = False
          TabOrder = 0
          Text = ''
          Visible = True
          OnExit = EditExit
          Version = '1.3.5.0'
          ButtonStyle = bsButton
          ButtonWidth = 18
          Etched = False
          Glyph.Data = {
            CE000000424DCE0000000000000076000000280000000C0000000B0000000100
            0400000000005800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00F00000000FFF
            00000088888880FF00000B088888880F00000BB08888888000000BBB00000000
            00000BBBBBBB0B0F00000BBB00000B0F0000F000BBBBBB0F0000FF0BBBBBBB0F
            0000FF0BBB00000F0000FFF000FFFFFF0000}
          BrowseDialogText = 'Select Directory'
        end
        object edt_TSIFDB: TAdvDirectoryEdit
          Left = 88
          Top = 74
          Width = 381
          Height = 21
          EmptyTextStyle = []
          Flat = False
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'Tahoma'
          LabelFont.Style = []
          Lookup.Font.Charset = DEFAULT_CHARSET
          Lookup.Font.Color = clWindowText
          Lookup.Font.Height = -11
          Lookup.Font.Name = 'Arial'
          Lookup.Font.Style = []
          Lookup.Separator = ';'
          Anchors = [akLeft, akTop, akRight]
          Color = clWindow
          ReadOnly = False
          TabOrder = 1
          Text = ''
          Visible = True
          OnExit = EditExit
          Version = '1.3.5.0'
          ButtonStyle = bsButton
          ButtonWidth = 18
          Etched = False
          Glyph.Data = {
            CE000000424DCE0000000000000076000000280000000C0000000B0000000100
            0400000000005800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00F00000000FFF
            00000088888880FF00000B088888880F00000BB08888888000000BBB00000000
            00000BBBBBBB0B0F00000BBB00000B0F0000F000BBBBBB0F0000FF0BBBBBBB0F
            0000FF0BBB00000F0000FFF000FFFFFF0000}
          BrowseDialogText = 'Select Directory'
        end
        object edt_Server: TEdit
          Left = 88
          Top = 20
          Width = 381
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          OnExit = EditExit
        end
      end
    end
    object tbs_Protokoll: TTabSheet
      Caption = 'Protokoll'
      ImageIndex = 1
      OnShow = tbs_ProtokollShow
      object mem_Protokoll: TMemo
        Left = 0
        Top = 0
        Width = 483
        Height = 248
        Align = alClient
        Lines.Strings = (
          'mem_Protokoll')
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 321
    Width = 491
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    object btn_Start: TButton
      Left = 401
      Top = 7
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 0
      OnClick = btn_StartClick
    end
    object btn_ClearProtokoll: TButton
      Left = 4
      Top = 6
      Width = 101
      Height = 25
      Caption = 'Protokoll l'#246'schen'
      TabOrder = 1
      OnClick = btn_ClearProtokollClick
    end
  end
  object pnl_Progress: TPanel
    Left = 0
    Top = 276
    Width = 491
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'pnl_Progress'
    ShowCaption = False
    TabOrder = 2
    Visible = False
    object lbl_pg: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 485
      Height = 13
      Align = alTop
      Caption = 'lbl_pg'
      ExplicitWidth = 28
    end
    object pgBar: TProgressBar
      AlignWithMargins = True
      Left = 3
      Top = 22
      Width = 485
      Height = 17
      Align = alTop
      TabOrder = 0
    end
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 280
    Top = 152
  end
  object Http: TIdHTTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL1
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 344
    Top = 136
  end
  object Timer: TTimer
    Interval = 60000
    OnTimer = TimerTimer
    Left = 271
    Top = 155
  end
end
