object InsEditFrm: TInsEditFrm
  Left = 0
  Top = 0
  Caption = 'Insert/Edit Record'
  ClientHeight = 250
  ClientWidth = 462
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 209
    Top = 24
    Width = 23
    Height = 13
    Caption = 'Date'
  end
  object Label2: TLabel
    Left = 16
    Top = 24
    Width = 24
    Height = 13
    Caption = 'Type'
  end
  object Label3: TLabel
    Left = 16
    Top = 99
    Width = 30
    Height = 13
    Caption = 'Payee'
  end
  object Label4: TLabel
    Left = 16
    Top = 134
    Width = 45
    Height = 13
    Caption = 'Category'
  end
  object Label5: TLabel
    Left = 16
    Top = 169
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object Label6: TLabel
    Left = 16
    Top = 211
    Width = 37
    Height = 13
    Caption = 'Amount'
  end
  object Label7: TLabel
    Left = 16
    Top = 62
    Width = 66
    Height = 13
    Caption = 'From Account'
  end
  object Label8: TLabel
    Left = 238
    Top = 62
    Width = 12
    Height = 13
    Caption = 'To'
  end
  object _fType: TJvComboBox
    Left = 88
    Top = 21
    Width = 97
    Height = 21
    AutoDropDown = True
    TabOrder = 1
    Text = ''
    OnExit = _fTypeExit
    Items.Strings = (
      'Pay'
      'Deposit'
      'Transfer')
  end
  object btnOK: TJvBitBtn
    Left = 328
    Top = 211
    Width = 75
    Height = 25
    Caption = '&Save'
    TabOrder = 10
    OnClick = btnOKClick
  end
  object _fID: TEdit
    Left = 378
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
  object _fDescription: TEdit
    Left = 88
    Top = 166
    Width = 339
    Height = 21
    TabOrder = 8
  end
  object _fPayee: TJvComboBox
    Left = 88
    Top = 96
    Width = 248
    Height = 21
    AutoDropDown = True
    TabOrder = 5
    Text = ''
    OnCloseUp = _fPayeeCloseUp
  end
  object _fCategory: TJvComboBox
    Left = 88
    Top = 131
    Width = 169
    Height = 21
    AutoDropDown = True
    TabOrder = 6
    Text = ''
    OnExit = _fCategoryExit
  end
  object _fSubCategory: TJvComboBox
    Left = 263
    Top = 131
    Width = 164
    Height = 21
    TabOrder = 7
    Text = ''
    OnExit = _fSubCategoryExit
  end
  object _fDate: TJvDateTimePicker
    Left = 247
    Top = 21
    Width = 99
    Height = 21
    Date = 43911.000000000000000000
    Time = 0.726759432873223000
    TabOrder = 2
    DropDownDate = 43911.000000000000000000
  end
  object _fAmount: TJvValidateEdit
    Left = 88
    Top = 208
    Width = 81
    Height = 21
    CriticalPoints.MaxValueIncluded = False
    CriticalPoints.MinValueIncluded = False
    DisplayFormat = dfCurrency
    DecimalPlaces = 2
    TabOrder = 9
  end
  object _fAccountTo: TJvComboBox
    Left = 263
    Top = 59
    Width = 164
    Height = 21
    Enabled = False
    TabOrder = 4
    Text = ''
    OnExit = _fSubCategoryExit
  end
  object _fAccountFrom: TJvComboBox
    Left = 88
    Top = 59
    Width = 128
    Height = 21
    Enabled = False
    TabOrder = 3
    Text = ''
    OnExit = _fSubCategoryExit
  end
end
