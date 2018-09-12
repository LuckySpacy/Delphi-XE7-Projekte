object frm_Ordnervergleich: Tfrm_Ordnervergleich
  Left = 0
  Top = 0
  Caption = 'Ordnervergleich'
  ClientHeight = 527
  ClientWidth = 733
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnl_Button: TPanel
    Left = 0
    Top = 0
    Width = 733
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnl_Button'
    ShowCaption = False
    TabOrder = 0
    ExplicitLeft = 496
    ExplicitTop = 160
    ExplicitWidth = 185
    object btn_Einlesen: TButton
      AlignWithMargins = True
      Left = 10
      Top = 8
      Width = 75
      Height = 25
      Margins.Left = 10
      Margins.Top = 8
      Margins.Bottom = 8
      Align = alLeft
      Caption = 'Einlesen'
      TabOrder = 0
      OnClick = btn_EinlesenClick
      ExplicitLeft = -6
      ExplicitTop = 5
    end
    object btn_Delete: TButton
      AlignWithMargins = True
      Left = 648
      Top = 8
      Width = 75
      Height = 25
      Margins.Top = 8
      Margins.Right = 10
      Margins.Bottom = 8
      Align = alRight
      Caption = 'L'#246'schen'
      TabOrder = 1
      OnClick = btn_DeleteClick
      ExplicitLeft = 170
    end
    object btn_UnterstrichWeg: TButton
      AlignWithMargins = True
      Left = 98
      Top = 8
      Width = 119
      Height = 25
      Margins.Left = 10
      Margins.Top = 8
      Margins.Bottom = 8
      Align = alLeft
      Caption = 'Unterstrich entfernen'
      TabOrder = 2
      OnClick = btn_UnterstrichWegClick
    end
  end
  object pnl_Ordner: TPanel
    Left = 0
    Top = 41
    Width = 733
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    object ScrollBox1: TScrollBox
      Left = 0
      Top = 0
      Width = 733
      Height = 48
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      TabOrder = 0
      ExplicitWidth = 763
      ExplicitHeight = 41
      DesignSize = (
        716
        48)
      object Label1: TLabel
        Left = 16
        Top = 6
        Width = 22
        Height = 13
        Caption = 'Pfad'
      end
      object Label2: TLabel
        Left = 16
        Top = 30
        Width = 22
        Height = 13
        Caption = 'Pfad'
      end
      object Label3: TLabel
        Left = 16
        Top = 56
        Width = 22
        Height = 13
        Caption = 'Pfad'
      end
      object Label4: TLabel
        Left = 16
        Top = 78
        Width = 22
        Height = 13
        Caption = 'Pfad'
      end
      object edt_Pfad1: TAdvDirectoryEdit
        Left = 44
        Top = 3
        Width = 662
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
      object edt_Pfad2: TAdvDirectoryEdit
        Left = 44
        Top = 27
        Width = 662
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
      object edt_Pfad3: TAdvDirectoryEdit
        Left = 44
        Top = 51
        Width = 662
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
        TabOrder = 2
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
      object edt_Pfad4: TAdvDirectoryEdit
        Left = 44
        Top = 75
        Width = 662
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
        TabOrder = 3
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
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 89
    Width = 733
    Height = 438
    ActivePage = tbs_Liste
    Align = alClient
    TabOrder = 2
    object tbs_Liste: TTabSheet
      Caption = 'Liste'
      ExplicitWidth = 281
      ExplicitHeight = 165
    end
    object tbs_OrdnerIgnorieren: TTabSheet
      Caption = 'Ordner Ingorierlist'
      ImageIndex = 1
    end
  end
end
