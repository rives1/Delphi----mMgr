object PayeeFRM: TPayeeFRM
  Left = 0
  Top = 0
  Caption = 'Payee'
  ClientHeight = 467
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
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
  object Splitter1: TSplitter
    Left = 228
    Top = 0
    Height = 448
    ExplicitLeft = 250
    ExplicitTop = 200
    ExplicitHeight = 100
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 448
    Width = 520
    Height = 19
    Panels = <>
    ExplicitLeft = 310
    ExplicitTop = 245
    ExplicitWidth = 0
  end
  object Panel3: TPanel
    Left = 231
    Top = 0
    Width = 289
    Height = 448
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 237
    ExplicitWidth = 264
    ExplicitHeight = 256
    object Name: TLabel
      Left = 7
      Top = 48
      Width = 27
      Height = 13
      Caption = 'Name'
    end
    object _fID: TEdit
      Left = 176
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
      TabOrder = 0
    end
    object _fName: TEdit
      Left = 15
      Top = 67
      Width = 228
      Height = 21
      BorderStyle = bsNone
      TabOrder = 1
    end
    object JvBitBtn1: TJvBitBtn
      Left = 15
      Top = 116
      Width = 75
      Height = 25
      Caption = '&New'
      TabOrder = 2
      TabStop = False
    end
    object JvBitBtn2: TJvBitBtn
      Left = 15
      Top = 147
      Width = 75
      Height = 25
      Caption = '&Delete'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      TabStop = False
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'Tahoma'
      HotTrackFont.Style = []
    end
    object btnOK: TJvBitBtn
      Left = 165
      Top = 162
      Width = 75
      Height = 25
      Caption = '&Save'
      TabOrder = 4
      OnClick = btnOKClick
    end
  end
  object _flvPayee: TListView
    Left = 0
    Top = 0
    Width = 228
    Height = 448
    Align = alLeft
    BorderStyle = bsNone
    Columns = <
      item
        AutoSize = True
        Caption = 'Payee Name'
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 2
    ViewStyle = vsReport
    OnDblClick = _flvPayeeDblClick
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitHeight = 408
  end
end
