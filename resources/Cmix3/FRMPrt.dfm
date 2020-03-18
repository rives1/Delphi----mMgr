object PrtFRM: TPrtFRM
  Left = 394
  Top = 285
  BorderStyle = bsSingle
  Caption = 'Report'
  ClientHeight = 136
  ClientWidth = 218
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 14
    Width = 50
    Height = 13
    Caption = 'From Serie'
  end
  object Label2: TLabel
    Left = 4
    Top = 44
    Width = 40
    Height = 13
    Caption = 'To Serie'
  end
  object btnOK: TBitBtn
    Left = 135
    Top = 73
    Width = 75
    Height = 23
    Caption = '&Print'
    TabOrder = 3
    OnClick = btnOKClick
  end
  object cmbFromSer: TComboBox
    Left = 65
    Top = 10
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
  end
  object cmbToSer: TComboBox
    Left = 65
    Top = 40
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
  end
  object rgSelReport: TRadioGroup
    Left = 0
    Top = 95
    Width = 218
    Height = 41
    Align = alBottom
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Issues to Buy'
      'Inventory')
    TabOrder = 2
  end
end
