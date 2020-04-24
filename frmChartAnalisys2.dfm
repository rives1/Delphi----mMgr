object AnalisysFrm2: TAnalisysFrm2
  Left = 0
  Top = 0
  Caption = 'AnalisysFrm2'
  ClientHeight = 527
  ClientWidth = 864
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 508
    Width = 864
    Height = 19
    Panels = <>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 864
    Height = 38
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 20
      Top = 12
      Width = 55
      Height = 13
      Caption = 'Period from'
    end
    object Label2: TLabel
      Left = 216
      Top = 12
      Width = 12
      Height = 13
      Caption = 'To'
    end
    object Label7: TLabel
      Left = 391
      Top = 12
      Width = 39
      Height = 13
      Caption = 'Account'
    end
    object _fdtFrom: TDateTimePicker
      Left = 90
      Top = 9
      Width = 101
      Height = 21
      Date = 43935.000000000000000000
      Time = 0.919114861113484900
      TabOrder = 0
      OnChange = _fdtFromChange
    end
    object _fdtTo: TDateTimePicker
      Left = 243
      Top = 9
      Width = 101
      Height = 21
      Date = 43935.000000000000000000
      Time = 0.919157187498058200
      TabOrder = 1
      OnChange = _fdtToChange
    end
    object _fAccount: TJvComboBox
      Left = 443
      Top = 9
      Width = 164
      Height = 21
      TabOrder = 2
      Text = ''
      OnSelect = _fAccountSelect
    end
  end
  object GridPanel1: TGridPanel
    Left = 0
    Top = 38
    Width = 864
    Height = 470
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 1
        Control = Chart2
        Row = 0
      end
      item
        Column = 1
        Control = chartInOutMM
        Row = 1
      end
      item
        Column = 0
        Control = chartCategoryAvg
        Row = 0
      end
      item
        Column = 0
        Control = _lvAvgCategory
        Row = 1
      end>
    RowCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    TabOrder = 2
    object Chart2: TChart
      Left = 432
      Top = 0
      Width = 432
      Height = 235
      Title.Text.Strings = (
        'TChart')
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      Visible = False
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 19
      object Series2: TLineSeries
        ColorEachPoint = True
        Shadow.Visible = False
        ValueFormat = '#,##0;(#,##0)'
        Brush.BackColor = clDefault
        LinePen.Color = 16777164
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
    object chartInOutMM: TChart
      Left = 432
      Top = 235
      Width = 432
      Height = 235
      Legend.Alignment = laTop
      Title.Text.Strings = (
        'In Out per Month')
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      DefaultCanvas = 'TGDIPlusCanvas'
      PrintMargins = (
        15
        24
        15
        24)
      ColorPaletteIndex = 19
      object BarSeries1: TBarSeries
        BarBrush.Gradient.EndColor = 15054131
        BarBrush.Gradient.Visible = True
        Marks.Angle = 90
        Title = 'In'
        ValueFormat = '#,##0;(#,##0)'
        BarStyle = bsRectGradient
        Gradient.EndColor = 15054131
        Gradient.Visible = True
        Sides = 23
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Bar'
        YValues.Order = loNone
      end
      object BarSeries2: TBarSeries
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
    object chartCategoryAvg: TChart
      Left = 0
      Top = 0
      Width = 432
      Height = 235
      Legend.Alignment = laTop
      Legend.Visible = False
      Title.Text.Strings = (
        'Average per Category')
      BottomAxis.LabelsAlternate = True
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitLeft = 5
      ExplicitTop = 5
      DefaultCanvas = 'TGDIPlusCanvas'
      PrintMargins = (
        15
        24
        15
        24)
      ColorPaletteIndex = 19
      object BarSeries3: TBarSeries
        BarBrush.Gradient.EndColor = 13408512
        BarBrush.Gradient.Visible = True
        ColorEachPoint = True
        Marks.Frame.Visible = False
        Title = 'In'
        ValueFormat = '#,##0;(#,##0)'
        BarStyle = bsRectGradient
        Gradient.EndColor = 13408512
        Gradient.Visible = True
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Bar'
        YValues.Order = loNone
      end
    end
    object _lvAvgCategory: TListView
      Left = 0
      Top = 235
      Width = 432
      Height = 235
      Align = alClient
      BorderStyle = bsNone
      Color = clBtnFace
      Columns = <
        item
          AutoSize = True
          Caption = 'Category'
        end
        item
          Alignment = taRightJustify
          AutoSize = True
          Caption = 'Avg'
        end
        item
          Alignment = taRightJustify
          AutoSize = True
          Caption = 'Count'
        end>
      GridLines = True
      Items.ItemData = {
        052E0000000100000000000000FFFFFFFFFFFFFFFF02000000FFFFFFFF000000
        00013100013200185F5D27013300F05A5D27FFFFFFFF}
      ReadOnly = True
      RowSelect = True
      SortType = stText
      TabOrder = 3
      ViewStyle = vsReport
      ExplicitWidth = 344
    end
  end
end
