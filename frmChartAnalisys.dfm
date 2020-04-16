object AnalisysFrm: TAnalisysFrm
  Left = 0
  Top = 0
  Caption = 'AnalisysFrm'
  ClientHeight = 527
  ClientWidth = 864
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
  end
  object GridPanel1: TGridPanel
    Left = 0
    Top = 38
    Width = 864
    Height = 470
    Align = alClient
    Caption = 'GridPanel1'
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
        Column = 1
        Control = Chart2
        Row = 0
      end
      item
        Column = 0
        Control = chartInOutYY
        Row = 1
      end
      item
        Column = 1
        Control = Chart5
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
    ExplicitLeft = 20
    ExplicitTop = 52
    ExplicitWidth = 731
    ExplicitHeight = 394
    object chartExpByCat: TChart
      Left = 1
      Top = 1
      Width = 431
      Height = 234
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
      ExplicitTop = 6
      ExplicitHeight = 242
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 19
      object Series1: TPieSeries
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
    object Chart2: TChart
      Left = 432
      Top = 1
      Width = 431
      Height = 234
      Title.Text.Strings = (
        'TChart')
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 274
      ExplicitTop = 11
      ExplicitWidth = 267
      ExplicitHeight = 139
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 19
      object Series2: TLineSeries
        ColorEachPoint = True
        Shadow.Visible = False
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
    object chartInOutYY: TChart
      Left = 1
      Top = 235
      Width = 431
      Height = 234
      Title.Text.Strings = (
        'In Out per Year')
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitLeft = 0
      ExplicitTop = 240
      ExplicitWidth = 267
      ExplicitHeight = 140
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
        Title = 'In'
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
        Title = 'Out'
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
    object Chart5: TChart
      Left = 432
      Top = 235
      Width = 431
      Height = 234
      Title.Text.Strings = (
        'TChart')
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 3
      ExplicitLeft = 268
      ExplicitTop = 140
      ExplicitWidth = 193
      ExplicitHeight = 81
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 20
      object Series4: TBarSeries
        BarBrush.Gradient.EndColor = 9875024
        ColorEachPoint = True
        BarStyle = bsCilinder
        Gradient.EndColor = 9875024
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Bar'
        YValues.Order = loNone
      end
    end
  end
end
