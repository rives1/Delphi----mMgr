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
        Control = Chart1
        Row = 0
      end
      item
        Column = 1
        Control = Chart2
        Row = 0
      end
      item
        Column = 0
        Control = Chart4
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
    ExplicitLeft = 18
    ExplicitTop = 42
    ExplicitWidth = 718
    ExplicitHeight = 459
    object Chart1: TChart
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
      ExplicitLeft = 0
      ExplicitTop = -1
      ExplicitWidth = 282
      ExplicitHeight = 168
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
      ExplicitLeft = 264
      ExplicitTop = 37
      ExplicitWidth = 164
      ExplicitHeight = 109
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
    object Chart4: TChart
      Left = 2
      Top = 244
      Width = 431
      Height = 224
      Title.Text.Strings = (
        'TChart')
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitLeft = 35
      ExplicitTop = 188
      ExplicitWidth = 184
      ExplicitHeight = 100
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 19
      object Series3: TBarSeries
        BarBrush.Gradient.EndColor = 13408512
        BarBrush.Gradient.Visible = True
        ColorEachPoint = True
        BarStyle = bsRectGradient
        Gradient.EndColor = 13408512
        Gradient.Visible = True
        Sides = 23
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
      ExplicitLeft = 242
      ExplicitTop = 141
      ExplicitWidth = 174
      ExplicitHeight = 95
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
    ExplicitLeft = 530
    ExplicitTop = 240
    ExplicitWidth = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 864
    Height = 38
    Align = alTop
    TabOrder = 2
    ExplicitWidth = 837
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
    end
    object _fdtTo: TDateTimePicker
      Left = 243
      Top = 9
      Width = 101
      Height = 21
      Date = 43935.000000000000000000
      Time = 0.919157187498058200
      TabOrder = 1
    end
  end
end
