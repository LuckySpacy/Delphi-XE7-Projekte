object frm_HighlighterEdit: Tfrm_HighlighterEdit
  Left = 0
  Top = 0
  Caption = 'Fonteingabe'
  ClientHeight = 395
  ClientWidth = 442
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
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 436
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      436
      57)
    object Label1: TLabel
      Left = 3
      Top = 7
      Width = 22
      Height = 13
      Caption = 'Text'
    end
    object edt: TEdit
      Left = 3
      Top = 26
      Width = 419
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = 'edt'
    end
  end
  object pnl_Client: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 66
    Width = 436
    Height = 279
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnl_Client'
    ShowCaption = False
    TabOrder = 1
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 351
    Width = 436
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel3'
    ShowCaption = False
    TabOrder = 2
    object cbx_OhneWortende: TCheckBox
      Left = 18
      Top = 8
      Width = 175
      Height = 17
      Caption = 'Wortende nicht beachten'
      TabOrder = 0
    end
    object btn_Speichern: TnfsButton
      Left = 353
      Top = 6
      Width = 75
      Height = 25
      ImagePos.Left = 8
      ImagePos.Right = 8
      ImagePos.Top = 0
      TextPos.Left = 0
      TextPos.Right = 0
      TextPos.Top = 0
      Caption1 = 'Speichern'
      OnClick = btn_SpeichernClick
      NumGlyphs = 1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      RoundRect = 0
      NotificationText.CirclePos.Left = 0
      NotificationText.CirclePos.Right = 0
      NotificationText.CirclePos.Top = 0
      NotificationText.CircleMarginX = 3
      NotificationText.CircleMarginY = 3
      NotificationText.Font.Charset = DEFAULT_CHARSET
      NotificationText.Font.Color = clWhite
      NotificationText.Font.Height = -9
      NotificationText.Font.Name = 'Tahoma'
      NotificationText.Font.Style = []
    end
    object btn_Abbrechen: TnfsButton
      Left = 272
      Top = 6
      Width = 75
      Height = 25
      ImagePos.Left = 8
      ImagePos.Right = 8
      ImagePos.Top = 0
      TextPos.Left = 0
      TextPos.Right = 0
      TextPos.Top = 0
      Caption1 = 'Abbrechen'
      OnClick = btn_AbbrechenClick
      NumGlyphs = 1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      RoundRect = 0
      NotificationText.CirclePos.Left = 0
      NotificationText.CirclePos.Right = 0
      NotificationText.CirclePos.Top = 0
      NotificationText.CircleMarginX = 3
      NotificationText.CircleMarginY = 3
      NotificationText.Font.Charset = DEFAULT_CHARSET
      NotificationText.Font.Color = clWhite
      NotificationText.Font.Height = -9
      NotificationText.Font.Name = 'Tahoma'
      NotificationText.Font.Style = []
    end
  end
end