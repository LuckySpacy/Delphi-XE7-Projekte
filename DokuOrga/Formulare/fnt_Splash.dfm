object frm_Splash: Tfrm_Splash
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frm_Splash'
  ClientHeight = 184
  ClientWidth = 324
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
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 32
    Width = 215
    Height = 51
    Caption = 'Doku Orga'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -40
    Font.Name = 'Tarzan'
    Font.Style = []
    ParentFont = False
  end
  object lblInfo: TLabel
    Left = 4
    Top = 151
    Width = 30
    Height = 13
    Caption = 'lblInfo'
  end
  object gg: TGauge
    Left = 0
    Top = 166
    Width = 324
    Height = 18
    Align = alBottom
    Progress = 0
    ExplicitTop = 164
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 232
    Top = 96
  end
end
