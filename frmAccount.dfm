object AccountFrm: TAccountFrm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Account'
  ClientHeight = 171
  ClientWidth = 437
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
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
    Height = 22
    AutoDropDown = True
    Style = csOwnerDrawVariable
    Color = clInactiveCaption
    TabOrder = 3
    TabStop = False
    Text = ''
    OnSelect = _fSearchSelect
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
      'CreditCard'
      'Online')
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
    Left = 341
    Top = 126
    Width = 75
    Height = 25
    Caption = '&Save'
    TabOrder = 4
    OnClick = btnOKClick
  end
  object JvBitBtn1: TJvBitBtn
    Left = 341
    Top = 47
    Width = 75
    Height = 25
    Caption = '&New'
    TabOrder = 5
    TabStop = False
    OnClick = JvBitBtn1Click
  end
  object JvBitBtn2: TJvBitBtn
    Left = 341
    Top = 87
    Width = 75
    Height = 25
    Caption = '&Delete'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    TabStop = False
    OnClick = JvBitBtn1Click
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'Tahoma'
    HotTrackFont.Style = []
  end
end
