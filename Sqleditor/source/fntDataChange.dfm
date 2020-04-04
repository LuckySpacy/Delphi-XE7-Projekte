object frm_DataChange: Tfrm_DataChange
  Left = 0
  Top = 0
  Caption = 'Daten '#228'ndern'
  ClientHeight = 230
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 189
    Width = 500
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      500
      41)
    object btn_Ok: TButton
      Left = 8
      Top = 8
      Width = 85
      Height = 25
      Caption = 'Ok'
      TabOrder = 0
      OnClick = btn_OkClick
    end
    object btn_Cancel: TButton
      Left = 396
      Top = 8
      Width = 85
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Abbrechen'
      TabOrder = 1
      OnClick = btn_CancelClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 500
    Height = 31
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 1
  end
  object Panel3: TPanel
    Left = 0
    Top = 31
    Width = 81
    Height = 158
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 2
    object Label1: TLabel
      Left = 40
      Top = 9
      Width = 30
      Height = 14
      Caption = 'Wert'
    end
  end
  object Panel4: TPanel
    Left = 81
    Top = 31
    Width = 419
    Height = 158
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel4'
    ShowCaption = False
    TabOrder = 3
    DesignSize = (
      419
      158)
    object edt_Integer: TSpinEdit
      Left = 0
      Top = 6
      Width = 410
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
      Visible = False
    end
    object edt_String: TEdit
      Left = 0
      Top = 35
      Width = 410
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      Text = 'edt_String'
      Visible = False
    end
    object edt_Float: TAdvEdit
      Left = 0
      Top = 63
      Width = 410
      Height = 22
      EditType = etFloat
      EmptyTextStyle = []
      Precision = 15
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
      Signed = True
      TabOrder = 2
      Text = '0,000000000000000'
      Visible = False
      Version = '3.3.2.8'
    end
    object edt_Date: TDateTimePicker
      Left = 0
      Top = 91
      Width = 113
      Height = 22
      Date = 42501.568021793980000000
      Time = 42501.568021793980000000
      TabOrder = 3
      Visible = False
    end
    object edt_Time: TDateTimePicker
      Left = 119
      Top = 91
      Width = 90
      Height = 22
      Date = 42501.568021793980000000
      Time = 42501.568021793980000000
      Kind = dtkTime
      TabOrder = 4
      Visible = False
    end
  end
  object qry: TIBQuery
    Database = dm.IBDatabase
    Transaction = IBT
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
  end
  object IBT: TIBTransaction
    DefaultDatabase = dm.IBDatabase
    Top = 48
  end
end
