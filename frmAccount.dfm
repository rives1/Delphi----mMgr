object AccountFrm: TAccountFrm
  Left = 0
  Top = 0
  Caption = 'Account'
  ClientHeight = 186
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 19
    Top = 59
    Width = 24
    Height = 13
    Caption = 'Type'
  end
  object Label1: TLabel
    Left = 19
    Top = 126
    Width = 33
    Height = 13
    Caption = 'Search'
  end
  object Name: TLabel
    Left = 19
    Top = 24
    Width = 27
    Height = 13
    Caption = 'Name'
  end
  object Shape1: TShape
    Left = 35
    Top = 105
    Width = 296
    Height = 1
  end
  object _fSearch: TJvComboBox
    Left = 78
    Top = 123
    Width = 168
    Height = 21
    AutoDropDown = True
    Color = clInactiveCaption
    TabOrder = 3
    TabStop = False
    Text = ''
    Items.Strings = (
      'Pay'
      'Deposit'
      'Transfer')
  end
  object _fType: TJvComboBox
    Left = 78
    Top = 56
    Width = 138
    Height = 21
    AutoDropDown = True
    TabOrder = 2
    Text = ''
    Items.Strings = (
      'Cash'
      'Cheching'
      'CreditCard')
  end
  object _fName: TEdit
    Left = 78
    Top = 21
    Width = 198
    Height = 21
    TabOrder = 1
  end
  object _fID: TEdit
    Left = 286
    Top = 8
    Width = 65
    Height = 21
    TabStop = False
    Alignment = taRightJustify
    BorderStyle = bsNone
    Color = clBtnFace
    Enabled = False
    ReadOnly = True
    TabOrder = 0
  end
  object btnOK: TJvBitBtn
    Left = 276
    Top = 136
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 4
  end
end
