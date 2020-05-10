object InsEditFrm: TInsEditFrm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Insert/Edit Record'
  ClientHeight = 289
  ClientWidth = 459
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 227
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
    Top = 166
    Width = 45
    Height = 13
    Caption = 'Category'
  end
  object Label5: TLabel
    Left = 16
    Top = 201
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object Label6: TLabel
    Left = 16
    Top = 133
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
    Top = 198
    Width = 273
    Height = 21
    TabOrder = 9
  end
  object _fPayee: TJvComboBox
    Left = 88
    Top = 96
    Width = 248
    Height = 21
    AutoDropDown = True
    DropDownCount = 20
    Sorted = True
    TabOrder = 5
    Text = ''
    OnExit = _fPayeeExit
  end
  object _fCategory: TJvComboBox
    Left = 88
    Top = 163
    Width = 169
    Height = 21
    AutoDropDown = True
    DropDownCount = 20
    Sorted = True
    TabOrder = 7
    Text = ''
    OnExit = _fCategoryExit
    OnSelect = _fCategorySelect
  end
  object _fSubCategory: TJvComboBox
    Left = 263
    Top = 163
    Width = 164
    Height = 21
    AutoDropDown = True
    DropDownCount = 14
    Sorted = True
    TabOrder = 8
    Text = ''
    OnEnter = _fSubCategoryEnter
    OnExit = _fSubCategoryExit
  end
  object _fAmount: TJvValidateEdit
    Left = 88
    Top = 130
    Width = 81
    Height = 21
    Flat = False
    ParentFlat = False
    CriticalPoints.MaxValueIncluded = False
    CriticalPoints.MinValueIncluded = False
    TrimDecimals = True
    DisplayFormat = dfCurrency
    DecimalPlaces = 2
    TabOrder = 6
    KeepPrefixSuffixIntact = True
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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 270
    Width = 459
    Height = 19
    Panels = <
      item
        Text = 
          'F12 - save record / ESC - Close Mask - Clik on ledger form to up' +
          'date'
        Width = 50
      end>
  end
  object _fDate: TRzDateTimeEdit
    Left = 263
    Top = 21
    Width = 109
    Height = 21
    EditType = etDate
    TabOrder = 2
    OnEnter = _fDateEnter
  end
  object btnOK: TJvBitBtn
    Left = 376
    Top = 209
    Width = 75
    Height = 25
    Caption = '&Save'
    TabOrder = 10
    OnClick = btnOKClick
  end
  object _fLastTransaction: TEdit
    Left = 16
    Top = 239
    Width = 427
    Height = 21
    BorderStyle = bsNone
    Color = clBtnFace
    TabOrder = 12
  end
end
