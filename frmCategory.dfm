object CategoryFrm: TCategoryFrm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Category'
  ClientHeight = 512
  ClientWidth = 642
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
  object _fSearch: TJvComboBox
    Left = 324
    Top = 441
    Width = 168
    Height = 22
    AutoDropDown = True
    Style = csOwnerDrawVariable
    Color = clInactiveCaption
    TabOrder = 0
    TabStop = False
    Text = ''
    OnSelect = _fSearchSelect
  end
  object ListView1: TListView
    Left = 8
    Top = 8
    Width = 211
    Height = 376
    Checkboxes = True
    Columns = <
      item
        AutoSize = True
        Caption = 'nome'
      end
      item
        AutoSize = True
        Caption = 'subc'
      end>
    GridLines = True
    Groups = <
      item
        Header = 'gruppo'
        GroupID = 0
        State = [lgsNormal]
        HeaderAlign = taLeftJustify
        FooterAlign = taLeftJustify
        TitleImage = -1
      end>
    Items.ItemData = {
      05C80000000400000000000000FFFFFFFFFFFFFFFF0000000000000000000000
      0004630061007400330000000000FFFFFFFFFFFFFFFF01000000000000000000
      0000046300610074003300057300750062003400340010F7331C00000000FFFF
      FFFFFFFFFFFF00000000FFFFFFFF000000000A630061007400650067006F0072
      0069006100310000000000FFFFFFFFFFFFFFFF01000000FFFFFFFF000000000A
      630061007400650067006F0072006900610031000873006F00740074006F0063
      002000310080F0331CFFFFFFFF}
    GroupView = True
    RowSelect = True
    SortType = stText
    TabOrder = 1
    ViewStyle = vsReport
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 493
    Width = 642
    Height = 19
    Panels = <>
  end
  object Panel3: TPanel
    Left = 300
    Top = 22
    Width = 311
    Height = 284
    TabOrder = 3
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
      Left = 217
      Top = 206
      Width = 75
      Height = 25
      Caption = '&Save'
      TabOrder = 3
      OnClick = btnOKClick
    end
    object JvBitBtn1: TJvBitBtn
      Left = 217
      Top = 127
      Width = 75
      Height = 25
      Caption = '&New'
      TabOrder = 4
      TabStop = False
      OnClick = JvBitBtn1Click
    end
    object JvBitBtn2: TJvBitBtn
      Left = 217
      Top = 167
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
  end
end
