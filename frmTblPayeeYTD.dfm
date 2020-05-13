object tblPayeeFrm: TtblPayeeFrm
  Left = 0
  Top = 0
  Caption = 'Table Balance YTD'
  ClientHeight = 613
  ClientWidth = 627
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 376
    Width = 627
    Height = 7
    Cursor = crVSplit
    Align = alBottom
    ExplicitLeft = 1
    ExplicitTop = 370
    ExplicitWidth = 891
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 594
    Width = 627
    Height = 19
    Panels = <>
    ExplicitTop = 559
    ExplicitWidth = 831
  end
  object _fLvPayeeYTD: TListView
    Left = 0
    Top = 38
    Width = 627
    Height = 338
    Align = alClient
    Columns = <
      item
        AutoSize = True
        Caption = 'Payee'
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = 'Amount'
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = 'Percentage %'
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = 'Frequency'
      end>
    GridLines = True
    HotTrack = True
    Items.ItemData = {
      05450000000100000000000000FFFFFFFFFFFFFFFF03000000FFFFFFFF000000
      0005700061007900650065000331003200330048ACC9080235003000B8ACC908
      01330040A9F21BFFFFFFFFFFFF}
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnClick = _fLvPayeeYTDClick
    ExplicitLeft = 40
    ExplicitTop = 36
    ExplicitHeight = 303
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 627
    Height = 38
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 831
    object Label1: TLabel
      Left = 30
      Top = 12
      Width = 55
      Height = 13
      Caption = 'Period from'
    end
    object Label7: TLabel
      Left = 251
      Top = 12
      Width = 39
      Height = 13
      Caption = 'Account'
    end
    object _fAccount: TJvComboBox
      Left = 308
      Top = 9
      Width = 164
      Height = 21
      TabOrder = 0
      Text = ''
      OnSelect = _fAccountSelect
    end
    object _fYear: TDatePicker
      Left = 105
      Top = 9
      Width = 120
      Height = 21
      Date = 43949.000000000000000000
      DateFormat = 'yyyy'
      DropDownCount = 10
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      TabOrder = 1
      OnChange = _fYearChange
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 383
    Width = 627
    Height = 211
    Align = alBottom
    Caption = 'Panel2'
    TabOrder = 3
    ExplicitTop = 348
    ExplicitWidth = 831
    object chartPayeeMM: TChart
      Left = 1
      Top = 1
      Width = 625
      Height = 209
      Legend.Alignment = laTop
      Legend.FontSeriesColor = True
      Legend.Visible = False
      Title.Text.Strings = (
        'In Out per Month')
      Title.Visible = False
      BottomAxis.MaximumRound = True
      View3D = False
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 829
      DefaultCanvas = 'TGDIPlusCanvas'
      PrintMargins = (
        15
        37
        15
        37)
      ColorPaletteIndex = 19
      object BarSeries2: TBarSeries
        BarBrush.Gradient.EndColor = 13408512
        BarBrush.Gradient.Visible = True
        ColorEachPoint = True
        Marks.Frame.Visible = False
        Marks.Angle = 90
        Title = 'Out'
        ValueFormat = '#,##0;(#,##0)'
        BarStyle = bsRectGradient
        Gradient.EndColor = 13408512
        Gradient.Visible = True
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Bar'
        YValues.Order = loNone
        Data = {
          00060000000000000000E66C403333333333146B409999999999536D40CCCCCC
          CCCCCD7040CCCCCCCC4C127140FEFFFFFFFFE56C40}
        Detail = {0000000000}
      end
    end
  end
end
