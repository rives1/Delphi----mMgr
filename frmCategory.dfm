object CategoryFrm: TCategoryFrm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Category'
  ClientHeight = 512
  ClientWidth = 609
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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 493
    Width = 609
    Height = 19
    Panels = <>
    ExplicitWidth = 642
  end
  object Panel3: TPanel
    Left = 249
    Top = 8
    Width = 354
    Height = 253
    TabOrder = 1
    object Name: TLabel
      Left = 24
      Top = 48
      Width = 27
      Height = 13
      Caption = 'Name'
    end
    object Label2: TLabel
      Left = 24
      Top = 86
      Width = 24
      Height = 13
      Caption = 'Type'
    end
    object _fName: TEdit
      Left = 93
      Top = 45
      Width = 198
      Height = 21
      TabOrder = 0
    end
    object _fID: TEdit
      Left = 226
      Top = 8
      Width = 65
      Height = 21
      TabStop = False
      Alignment = taRightJustify
      Color = clBtnFace
      Ctl3D = True
      Enabled = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 1
    end
    object _fType: TJvComboBox
      Left = 93
      Top = 83
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
    object btnOK: TJvBitBtn
      Left = 252
      Top = 201
      Width = 75
      Height = 25
      Caption = '&Save'
      TabOrder = 3
      OnClick = btnOKClick
    end
    object JvBitBtn1: TJvBitBtn
      Left = 252
      Top = 122
      Width = 75
      Height = 25
      Caption = '&New'
      TabOrder = 4
      TabStop = False
      OnClick = JvBitBtn1Click
    end
    object JvBitBtn2: TJvBitBtn
      Left = 252
      Top = 162
      Width = 75
      Height = 25
      Caption = '&Delete'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      TabStop = False
      OnClick = JvBitBtn1Click
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'Tahoma'
      HotTrackFont.Style = []
    end
    object _fSubCat: TEdit
      Left = 248
      Top = 83
      Width = 43
      Height = 21
      TabOrder = 6
    end
  end
  object _treeCategory: TTreeView
    Left = 0
    Top = 0
    Width = 243
    Height = 493
    Align = alLeft
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Indent = 19
    ReadOnly = True
    RowSelect = True
    SortType = stBoth
    TabOrder = 2
    Items.NodeData = {
      0301000000340000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      0002000000010B680065007200740065006800790072007400680079002A0000
      000000000000000000FFFFFFFFFFFFFFFF000000000000000001000000010636
      0035003400360034003600300000000000000000000000FFFFFFFFFFFFFFFF00
      0000000000000000000000010972007400790072007400790072007400790030
      0000000000000000000000FFFFFFFFFFFFFFFF00000000000000000000000001
      09650068006700670064006400680068006600}
  end
end
