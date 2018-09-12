object frm_KurseLaden: Tfrm_KurseLaden
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Kurse laden'
  ClientHeight = 171
  ClientWidth = 362
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_Progress: TLabel
    Left = 8
    Top = 45
    Width = 58
    Height = 13
    Caption = 'lbl_Progress'
  end
  object Panel1: TPanel
    Left = 0
    Top = 130
    Width = 362
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
  end
  object pg: TProgressBar
    Left = 3
    Top = 64
    Width = 354
    Height = 17
    TabOrder = 1
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 216
    Top = 16
  end
end
