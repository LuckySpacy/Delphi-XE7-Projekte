object fra_KurseLaden: Tfra_KurseLaden
  Left = 0
  Top = 0
  Width = 832
  Height = 559
  TabOrder = 0
  object lbl_Pg: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 520
    Width = 826
    Height = 13
    Align = alBottom
    Caption = 'lbl_Pg'
    Visible = False
    ExplicitWidth = 28
  end
  object pg: TProgressBar
    AlignWithMargins = True
    Left = 3
    Top = 539
    Width = 826
    Height = 17
    Align = alBottom
    TabOrder = 0
    Visible = False
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 832
    Height = 517
    ActivePage = tbs_Protokoll
    Align = alClient
    TabOrder = 1
    object tbs_Download: TTabSheet
      Caption = 'Download'
      DesignSize = (
        824
        489)
      object Label2: TLabel
        Left = 8
        Top = 14
        Width = 69
        Height = 13
        Caption = 'Downloadpfad'
      end
      object Label3: TLabel
        Left = 8
        Top = 36
        Width = 38
        Height = 13
        Caption = 'Zielpfad'
      end
      object Label1: TLabel
        Left = 8
        Top = 60
        Width = 58
        Height = 13
        Caption = 'Schnittstelle'
      end
      object edt_Pfad: TAdvDirectoryEdit
        Left = 80
        Top = 11
        Width = 741
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
        OnExit = edt_PfadExit
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
        Left = 80
        Top = 33
        Width = 741
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
        OnExit = edt_ZielpfadExit
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
      object cbo_Schnittstelle: TComboBox
        Left = 80
        Top = 57
        Width = 201
        Height = 21
        Style = csDropDownList
        TabOrder = 2
      end
      object btn_Start: TButton
        Left = 746
        Top = 55
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Start'
        TabOrder = 3
        OnClick = btn_StartClick
      end
    end
    object tbs_Protokoll: TTabSheet
      Caption = 'Protokoll'
      ImageIndex = 1
      object mem: TMemo
        Left = 0
        Top = 0
        Width = 824
        Height = 489
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          'mem')
        ParentFont = False
        TabOrder = 0
      end
    end
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
end
