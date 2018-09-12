object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 469
  ClientWidth = 821
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 821
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    ExplicitLeft = 88
    ExplicitTop = 48
    ExplicitWidth = 185
    object Button1: TButton
      Left = 24
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 41
    Width = 821
    Height = 89
    Align = alTop
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
    ExplicitLeft = 8
    ExplicitTop = 80
    ExplicitWidth = 185
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 130
    Width = 821
    Height = 339
    Align = alClient
    DataSource = DataSource1
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DBMySqlTSI: TMySQLDatabase
    DatabaseName = 'tsi'
    UserName = 'thomas'
    UserPassword = 'thomas1'
    Host = 'localhost'
    ConnectOptions = [coCompress]
    Params.Strings = (
      'Port=3306'
      'TIMEOUT=30'
      'DatabaseName=tsi'
      'Host=localhost'
      'UID=thomas'
      'PWD=thomas1')
    OnConnectionFailure = DBMySqlTSIConnectionFailure
    DatasetOptions = []
    Left = 248
    Top = 64
  end
  object MySQLQuery1: TMySQLQuery
    Database = DBMySqlTSI
    Left = 432
    Top = 152
  end
  object DataSource1: TDataSource
    DataSet = MySQLQuery1
    Left = 520
    Top = 264
  end
end
