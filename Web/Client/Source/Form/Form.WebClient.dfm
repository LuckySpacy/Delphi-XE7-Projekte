object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 299
  ClientWidth = 635
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object btn_OptimaChangeLog: TButton
      AlignWithMargins = True
      Left = 11
      Top = 6
      Width = 110
      Height = 29
      Margins.Left = 10
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'OptimaChangeLog'
      TabOrder = 0
      OnClick = btn_OptimaChangeLogClick
    end
    object Button1: TButton
      AlignWithMargins = True
      Left = 134
      Top = 6
      Width = 110
      Height = 29
      Margins.Left = 10
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'OptimaChangeLog'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 635
    Height = 258
    Align = alClient
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    object Memo: TMemo
      Left = 1
      Top = 1
      Width = 633
      Height = 256
      Align = alClient
      Lines.Strings = (
        'Memo')
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
end
