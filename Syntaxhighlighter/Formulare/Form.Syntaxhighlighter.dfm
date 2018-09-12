object frm_Syntaxhighlighter: Tfrm_Syntaxhighlighter
  Left = 0
  Top = 0
  Caption = 'Syntaxhighlighter'
  ClientHeight = 408
  ClientWidth = 821
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 821
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
  end
  object pnl_Stylename: TPanel
    Left = 0
    Top = 33
    Width = 185
    Height = 375
    Align = alLeft
    Caption = 'pnl_Stylename'
    ShowCaption = False
    TabOrder = 1
  end
  object pnl_Kommentar: TPanel
    Left = 185
    Top = 33
    Width = 185
    Height = 375
    Align = alLeft
    Caption = 'pnl_Stylename'
    ShowCaption = False
    TabOrder = 2
    ExplicitLeft = 8
  end
  object IBT: TIBTransaction
    Left = 280
    Top = 56
  end
end
