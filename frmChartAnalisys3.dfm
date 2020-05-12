object AnalisysFrm3: TAnalisysFrm3
  Left = 0
  Top = 0
  Caption = 'Analisys Payees - Subcategories'
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
        Column = 0
        Control = chartCatSubcat
        Row = 0
      end
      item
        Column = 0
        Control = _lvCatSubcat
        Row = 1
      end
      item
        Column = 1
        Control = chartCategoryAvgMM
        Row = 0
      end
      item
        Column = 1
        Control = Chart1
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
    object chartCatSubcat: TChart
      Left = 0
      Top = 0
      Width = 432
      Height = 235
      Legend.Alignment = laTop
      Legend.Visible = False
      Title.Text.Strings = (
        'Expenses x Cat/Subcategory')
      BottomAxis.LabelsAlternate = True
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      DefaultCanvas = 'TGDIPlusCanvas'
      PrintMargins = (
        15
        24
        15
        24)
      ColorPaletteIndex = 19
      object Series2: TBarSeries
        ColorEachPoint = True
        MultiBar = mbSelfStack
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Bar'
        YValues.Order = loNone
      end
    end
    object _lvCatSubcat: TListView
      Left = 0
      Top = 235
      Width = 432
      Height = 235
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      BorderStyle = bsNone
      Color = clBtnFace
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
          Caption = 'Amount'
        end>
      GridLines = True
      Items.ItemData = {
        052E0000000100000000000000FFFFFFFFFFFFFFFF02000000FFFFFFFF000000
        00013100013200185F5D27013300F05A5D27FFFFFFFF}
      ReadOnly = True
      RowSelect = True
      SortType = stText
      TabOrder = 1
      ViewStyle = vsReport
      ExplicitWidth = 344
    end
    object chartCategoryAvgMM: TChart
      Left = 432
      Top = 0
      Width = 432
      Height = 235
      Legend.Alignment = laTop
      Legend.Visible = False
      Title.Text.Strings = (
        'Payee Most Contributed')
      BottomAxis.LabelsAlternate = True
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      DefaultCanvas = 'TGDIPlusCanvas'
      PrintMargins = (
        15
        24
        15
        24)
      ColorPaletteIndex = 19
      object BarSeries1: THorizBarSeries
        BarBrush.Gradient.Direction = gdLeftRight
        BarBrush.Gradient.EndColor = 13408512
        BarBrush.Gradient.Visible = True
        ColorEachPoint = True
        Marks.Frame.Visible = False
        Title = 'In'
        ValueFormat = '#,##0;(#,##0)'
        BarStyle = bsRectGradient
        Gradient.Direction = gdLeftRight
        Gradient.EndColor = 13408512
        Gradient.Visible = True
        XValues.Name = 'Bar'
        XValues.Order = loNone
        YValues.Name = 'Y'
        YValues.Order = loAscending
      end
    end
    object Chart1: TChart
      Left = 432
      Top = 235
      Width = 432
      Height = 235
      Legend.Alignment = laTop
      Legend.Visible = False
      Title.Text.Strings = (
        'Payee Most Used')
      BottomAxis.LabelsAlternate = True
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 3
      DefaultCanvas = 'TGDIPlusCanvas'
      PrintMargins = (
        15
        24
        15
        24)
      ColorPaletteIndex = 19
      object HorizBarSeries1: THorizBarSeries
        BarBrush.Gradient.Direction = gdLeftRight
        BarBrush.Gradient.EndColor = 13408512
        BarBrush.Gradient.Visible = True
        ColorEachPoint = True
        Marks.Frame.Visible = False
        Title = 'In'
        ValueFormat = '#,##0;(#,##0)'
        BarStyle = bsRectGradient
        Gradient.Direction = gdLeftRight
        Gradient.EndColor = 13408512
        Gradient.Visible = True
        XValues.Name = 'Bar'
        XValues.Order = loNone
        YValues.Name = 'Y'
        YValues.Order = loAscending
      end
    end
  end
end
