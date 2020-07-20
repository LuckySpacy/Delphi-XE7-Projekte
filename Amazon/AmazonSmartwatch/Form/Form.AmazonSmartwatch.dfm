object frm_AmazonSmartwatch: Tfrm_AmazonSmartwatch
  Left = 0
  Top = 0
  Caption = 'Amazon Smartwatch'
  ClientHeight = 299
  ClientWidth = 635
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
  PixelsPerInch = 96
  TextHeight = 13
  object pnl_TopButton: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnl_TopButton'
    ShowCaption = False
    TabOrder = 0
    object btn_Einlesen: TButton
      Left = 8
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Einlesen'
      TabOrder = 0
      OnClick = btn_EinlesenClick
    end
  end
  object pnl_Link: TPanel
    Left = 0
    Top = 41
    Width = 635
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnl_Top'
    ShowCaption = False
    TabOrder = 1
    object edt_Link: TEdit
      AlignWithMargins = True
      Left = 10
      Top = 3
      Width = 615
      Height = 21
      Margins.Left = 10
      Margins.Right = 10
      Align = alTop
      TabOrder = 0
      Text = 'edt_Link'
    end
  end
  object pnl_Client: TPanel
    Left = 0
    Top = 70
    Width = 635
    Height = 229
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnl_Top'
    ShowCaption = False
    TabOrder = 2
    object Memo1: TMemo
      AlignWithMargins = True
      Left = 10
      Top = 3
      Width = 615
      Height = 223
      Margins.Left = 10
      Margins.Right = 10
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'Memo1')
      ParentFont = False
      TabOrder = 0
    end
  end
  object http: TIdHTTP
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
    Left = 176
  end
  object IdIOHandlerStream1: TIdIOHandlerStream
    MaxLineAction = maException
    Port = 0
    FreeStreams = False
    Left = 296
    Top = 8
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 440
    Top = 86
  end
end
