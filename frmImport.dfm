object ImportFrm: TImportFrm
  Left = 0
  Top = 0
  Caption = 'ImportFrm'
  ClientHeight = 226
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 11
    Top = 56
    Width = 87
    Height = 13
    Caption = 'Import to Account'
  end
  object Label1: TLabel
    Left = 11
    Top = 21
    Width = 16
    Height = 13
    Caption = 'File'
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 207
    Width = 381
    Height = 19
    Panels = <
      item
        Text = 
          'Double click to edit Category/Subcategory - Right click for acti' +
          'ons'
        Width = 50
      end>
    ExplicitTop = 280
    ExplicitWidth = 459
  end
  object Panel1: TPanel
    Left = 0
    Top = 113
    Width = 381
    Height = 94
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 160
    ExplicitWidth = 453
  end
  object _fAccountTo: TJvComboBox
    Left = 123
    Top = 53
    Width = 198
    Height = 21
    Enabled = False
    TabOrder = 2
    Text = ''
  end
  object btnBrowse: TJvBitBtn
    Left = 327
    Top = 16
    Width = 36
    Height = 25
    Caption = '...'
    TabOrder = 3
  end
  object _fImportFileName: TEdit
    Left = 40
    Top = 18
    Width = 281
    Height = 21
    TabOrder = 4
    Text = '_fImportFileName'
    Visible = False
  end
  object _btnImport: TJvBitBtn
    Left = 288
    Top = 82
    Width = 75
    Height = 25
    Caption = 'Import'
    TabOrder = 5
  end
end
