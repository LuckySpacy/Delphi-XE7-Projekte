object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Server UI'
  ClientHeight = 257
  ClientWidth = 606
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
  object Splitter1: TSplitter
    Left = 145
    Top = 0
    Height = 226
    ExplicitLeft = 232
    ExplicitTop = 48
    ExplicitHeight = 100
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 145
    Height = 226
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    ExplicitHeight = 261
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 145
      Height = 32
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel4'
      ShowCaption = False
      TabOrder = 0
      object btn_Delete: TSpeedButton
        AlignWithMargins = True
        Left = 42
        Top = 3
        Width = 55
        Height = 26
        Align = alLeft
        Caption = 'L'#246'schen'
        OnClick = btn_DeleteClick
      end
      object btn_Neu: TSpeedButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 33
        Height = 26
        Align = alLeft
        Caption = 'Neu'
        OnClick = btn_NeuClick
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitHeight = 41
      end
    end
    object lsb: TListBox
      AlignWithMargins = True
      Left = 3
      Top = 35
      Width = 139
      Height = 188
      Align = alClient
      ItemHeight = 13
      TabOrder = 1
      OnClick = lsbClick
      OnEnter = lsbEnter
      ExplicitHeight = 223
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 226
    Width = 606
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    ExplicitTop = 261
    object btn_Schliessen: TButton
      AlignWithMargins = True
      Left = 528
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'Schlie'#223'en'
      TabOrder = 0
      OnClick = btn_SchliessenClick
    end
  end
  object Panel3: TPanel
    Left = 148
    Top = 0
    Width = 458
    Height = 226
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 2
    ExplicitHeight = 261
    object Panel5: TPanel
      Left = 0
      Top = 0
      Width = 458
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel5'
      ParentShowHint = False
      ShowCaption = False
      ShowHint = False
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 9
        Width = 76
        Height = 13
        Caption = 'Webserver Port'
      end
      object edt_Port: TSpinEdit
        Left = 98
        Top = 6
        Width = 63
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 0
        OnExit = edt_PortExit
      end
    end
    object Panel6: TPanel
      Left = 0
      Top = 41
      Width = 458
      Height = 185
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel5'
      ShowCaption = False
      TabOrder = 1
      ExplicitHeight = 220
      object GroupBox1: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 452
        Height = 182
        Align = alTop
        Caption = 'Datenbank'
        TabOrder = 0
        object Panel7: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 18
          Width = 68
          Height = 159
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel7'
          ShowCaption = False
          TabOrder = 0
          object Label4: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 62
            Height = 13
            Align = alTop
            Caption = 'Art:'
            ExplicitWidth = 19
          end
          object Label2: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 30
            Width = 62
            Height = 13
            Margins.Top = 11
            Align = alTop
            Caption = 'Pfad:'
            ExplicitWidth = 26
          end
          object Label3: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 138
            Width = 62
            Height = 13
            Margins.Top = 11
            Align = alTop
            Caption = 'Passwort:'
            ExplicitWidth = 48
          end
          object Label5: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 57
            Width = 62
            Height = 13
            Margins.Top = 11
            Align = alTop
            Caption = 'Name:'
            ExplicitWidth = 31
          end
          object Label6: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 84
            Width = 62
            Height = 13
            Margins.Top = 11
            Align = alTop
            Caption = 'Port:'
            ExplicitWidth = 24
          end
          object Label7: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 111
            Width = 62
            Height = 13
            Margins.Top = 11
            Align = alTop
            Caption = 'Username:'
            ExplicitWidth = 52
          end
        end
        object Panel8: TPanel
          Left = 76
          Top = 15
          Width = 374
          Height = 165
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel8'
          ShowCaption = False
          TabOrder = 1
          object cbx_Datenbankart: TComboBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 368
            Height = 21
            Align = alTop
            Style = csDropDownList
            ItemIndex = 0
            TabOrder = 0
            Text = 'Firebird'
            Items.Strings = (
              'Firebird'
              'MySql')
          end
          object edt_Datenbankpfad: TAdvDirectoryEdit
            AlignWithMargins = True
            Left = 3
            Top = 30
            Width = 368
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
            Align = alTop
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
            ExplicitWidth = 369
          end
          object edt_Datenbankname: TEdit
            AlignWithMargins = True
            Left = 3
            Top = 57
            Width = 368
            Height = 21
            Align = alTop
            TabOrder = 2
            Text = 'edt_Datenbankname'
          end
          object edt_DatenbankPort: TAdvEdit
            AlignWithMargins = True
            Left = 3
            Top = 84
            Width = 368
            Height = 21
            EditType = etNumeric
            EmptyTextStyle = []
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
            Align = alTop
            Color = clWindow
            TabOrder = 3
            Text = '0'
            Visible = True
            Version = '3.3.2.8'
          end
          object edt_Passwort: TEdit
            AlignWithMargins = True
            Left = 3
            Top = 138
            Width = 368
            Height = 21
            Align = alTop
            TabOrder = 4
            Text = 'edt_Datenbankname'
          end
          object edt_Username: TEdit
            AlignWithMargins = True
            Left = 3
            Top = 111
            Width = 368
            Height = 21
            Align = alTop
            TabOrder = 5
            Text = 'edt_Datenbankname'
          end
        end
      end
    end
  end
end