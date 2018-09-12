object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Ordner automatisch anlegen'
  ClientHeight = 64
  ClientWidth = 707
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
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 707
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      707
      57)
    object Label1: TLabel
      Left = 8
      Top = 7
      Width = 22
      Height = 13
      Caption = 'Pfad'
    end
    object Label2: TLabel
      Left = 8
      Top = 34
      Width = 36
      Height = 13
      Caption = 'Endung'
    end
    object edt_Pfad: TAdvDirectoryEdit
      Left = 56
      Top = 4
      Width = 641
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
    object edt_Endung: TEdit
      Left = 56
      Top = 31
      Width = 57
      Height = 21
      TabOrder = 1
      Text = 'edt_Endung'
    end
    object btn_Execute: TButton
      Left = 144
      Top = 31
      Width = 121
      Height = 25
      Caption = 'Ausf'#252'hren'
      TabOrder = 2
      OnClick = btn_ExecuteClick
    end
  end
end
