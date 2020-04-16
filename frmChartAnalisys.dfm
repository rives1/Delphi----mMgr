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
  object RzGridPanel1: TRzGridPanel
    Left = 0
    Top = 38
    Width = 864
    Height = 470
    Align = alClient
    ColumnCollection = <
      item
        Value = 50.194083899517330000
      end
      item
        Value = 49.805916100482670000
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
        Value = 52.106760305691280000
      end
      item
        Value = 47.893239694308710000
      end>
    TabOrder = 0
    object chartExpByCat: TChart
      Left = 2
      Top = 2
      Width = 431
      Height = 242
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
      Left = 433
      Top = 2
      Width = 429
      Height = 242
      Title.Text.Strings = (
        'TChart')
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
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
      Left = 2
      Top = 244
      Width = 431
      Height = 224
      Title.Text.Strings = (
        'TChart')
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
      object Series3: TBarSeries
        BarBrush.Gradient.EndColor = 39270
        BarBrush.Gradient.Visible = True
        ColorEachPoint = True
        Title = 'In'
        BarStyle = bsRectGradient
        Gradient.EndColor = 39270
        Gradient.Visible = True
        Sides = 23
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Bar'
        YValues.Order = loNone
        Data = {
          04080000000000000000006140FF04000000436172730000000000988440FF06
          00000050686F6E65730000000000E08A40FF060000005461626C657300000000
          00E08940FF080000004D6F6E69746F72730000000000608E40FF050000004C61
          6D70730000000000508840FF090000004B6579626F617264730000000000E077
          40FF0500000042696B65730000000000407240FF06000000436861697273}
        Detail = {0000000000}
      end
      object Series5: TBarSeries
        DataSource = Series1
        Title = 'Out'
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Bar'
        YValues.Order = loNone
      end
    end
    object Chart5: TChart
      Left = 433
      Top = 244
      Width = 429
      Height = 224
      Title.Text.Strings = (
        'TChart')
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 3
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
    TabOrder = 2
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
end
