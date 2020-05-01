object tblBalanceFrm: TtblBalanceFrm
  Left = 0
  Top = 0
  Caption = 'Table Balance YTD'
  ClientHeight = 578
  ClientWidth = 831
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
    Top = 341
    Width = 831
    Height = 7
    Cursor = crVSplit
    Align = alBottom
    ExplicitLeft = 1
    ExplicitTop = 370
    ExplicitWidth = 891
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 559
    Width = 831
    Height = 19
    Panels = <>
  end
  object _fLvBalanceYTD: TListView
    Left = 0
    Top = 38
    Width = 831
    Height = 303
    Align = alClient
    Columns = <
      item
        AutoSize = True
        Caption = 'Category'
      end
      item
        AutoSize = True
        Caption = 'Subcategory'
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = 'Jan'
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = 'Feb'
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = 'Mar'
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = 'Apr'
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = 'May'
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = 'Jun'
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = 'Jul'
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = 'Aug'
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = 'Sep'
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = 'Oct'
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = 'Nov'
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = 'Dec'
      end
      item
        Alignment = taRightJustify
        AutoSize = True
        Caption = 'Total'
      end>
    GridLines = True
    Groups = <
      item
        Header = 'Deposit'
        GroupID = 0
        State = [lgsNormal]
        HeaderAlign = taLeftJustify
        FooterAlign = taLeftJustify
        TitleImage = -1
      end
      item
        Header = 'Expense'
        GroupID = 1
        State = [lgsNormal]
        HeaderAlign = taLeftJustify
        FooterAlign = taLeftJustify
        TitleImage = -1
      end
      item
        Header = 'Balance'
        GroupID = 2
        State = [lgsNormal]
        HeaderAlign = taLeftJustify
        FooterAlign = taLeftJustify
        TitleImage = -1
      end>
    HotTrack = True
    GroupView = True
    RowSelect = True
    SortType = stText
    TabOrder = 1
    ViewStyle = vsReport
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 831
    Height = 38
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
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
    object _btnPrint: TButton
      Left = 498
      Top = 6
      Width = 96
      Height = 26
      Caption = '&Print'
      TabOrder = 1
      OnClick = _btnPrintClick
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
      TabOrder = 2
      OnChange = _fYearChange
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 348
    Width = 831
    Height = 211
    Align = alBottom
    Caption = 'Panel2'
    TabOrder = 3
    object chartInOutMM: TChart
      Left = 1
      Top = 1
      Width = 829
      Height = 209
      Legend.Alignment = laTop
      Legend.FontSeriesColor = True
      Legend.Visible = False
      Title.Text.Strings = (
        'In Out per Month')
      Title.Visible = False
      BottomAxis.LabelsAlternate = True
      BottomAxis.MaximumRound = True
      View3D = False
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      DefaultCanvas = 'TGDIPlusCanvas'
      PrintMargins = (
        15
        37
        15
        37)
      ColorPaletteIndex = 19
      object BarSeries1: TBarSeries
        BarBrush.Gradient.EndColor = 15054131
        BarBrush.Gradient.Visible = True
        Marks.Frame.Visible = False
        Marks.Angle = 90
        Title = 'In'
        ValueFormat = '#,##0;(#,##0)'
        BarStyle = bsRectGradient
        Gradient.EndColor = 15054131
        Gradient.Visible = True
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Bar'
        YValues.Order = loNone
      end
      object BarSeries2: TBarSeries
        Marks.Frame.Visible = False
        Marks.Angle = 90
        Title = 'Out'
        ValueFormat = '#,##0;(#,##0)'
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
