object AnalisysFrm1: TAnalisysFrm1
  Left = 0
  Top = 0
  Caption = 'AnalisysFrm1'
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
        Control = chartExpByCat
        Row = 0
      end
      item
        Column = 0
        Control = chartInOutYY
        Row = 1
      end
      item
        Column = 1
        Control = chartInOutMM
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
    object chartExpByCat: TChart
      Left = 0
      Top = 0
      Width = 432
      Height = 235
      Legend.Visible = False
      Title.Text.Strings = (
        'Expenses by Category')
      View3DOptions.Elevation = 315
      View3DOptions.Orthogonal = False
      View3DOptions.Perspective = 0
      View3DOptions.Rotation = 360
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      DefaultCanvas = 'TGDIPlusCanvas'
      PrintMargins = (
        15
        23
        15
        23)
      ColorPaletteIndex = 19
      object Series1: TPieSeries
        Marks.Frame.Visible = False
        Marks.Callout.Length = 20
        ValueFormat = '#,##0;(#,##0)'
        XValues.Order = loAscending
        YValues.Name = 'Pie'
        YValues.Order = loNone
        Circled = False
        Frame.InnerBrush.BackColor = clRed
        Frame.InnerBrush.Gradient.EndColor = clGray
        Frame.InnerBrush.Gradient.MidColor = clWhite
        Frame.InnerBrush.Gradient.StartColor = 4210752
        Frame.InnerBrush.Gradient.Visible = True
        Frame.MiddleBrush.BackColor = clYellow
        Frame.MiddleBrush.Gradient.EndColor = 8553090
        Frame.MiddleBrush.Gradient.MidColor = clWhite
        Frame.MiddleBrush.Gradient.StartColor = clGray
        Frame.MiddleBrush.Gradient.Visible = True
        Frame.OuterBrush.BackColor = clGreen
        Frame.OuterBrush.Gradient.EndColor = 4210752
        Frame.OuterBrush.Gradient.MidColor = clWhite
        Frame.OuterBrush.Gradient.StartColor = clSilver
        Frame.OuterBrush.Gradient.Visible = True
        Frame.Width = 4
        EdgeStyle = edFlat
        OtherSlice.Legend.Visible = False
      end
    end
    object chartInOutYY: TChart
      Left = 0
      Top = 235
      Width = 432
      Height = 235
      Legend.Alignment = laTop
      Title.Text.Strings = (
        'In Out per Year')
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
      object Series3: TBarSeries
        BarBrush.Gradient.EndColor = 15054131
        BarBrush.Gradient.Visible = True
        Marks.Frame.Visible = False
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
      object Series5: TBarSeries
        Marks.Frame.Visible = False
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
      TabOrder = 2
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
  end
end
