object AnalisysFrm4: TAnalisysFrm4
  Left = 0
  Top = 0
  Caption = 'Analisys Payees'
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
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = chartPayeeSpent
        Row = 0
      end
      item
        Column = 0
        Control = chartPayeeMost
        Row = 1
      end>
    RowCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end
      item
        SizeStyle = ssAuto
      end>
    TabOrder = 2
    ExplicitTop = 36
    object chartPayeeSpent: TChart
      Left = 0
      Top = 0
      Width = 864
      Height = 235
      Legend.Alignment = laTop
      Legend.Visible = False
      Title.Text.Strings = (
        'Payee Most Contributed')
      BottomAxis.LabelsAlternate = True
      View3D = False
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
      object Series1: THorizBarSeries
        BarBrush.Gradient.Direction = gdLeftRight
        ColorEachPoint = True
        Marks.Margins.Left = 17
        Marks.Margins.Right = 13
        Marks.Style = smsLabelPercent
        Marks.TextAlign = taLeftJustify
        Gradient.Direction = gdLeftRight
        XValues.Name = 'Bar'
        XValues.Order = loNone
        YValues.Name = 'Y'
        YValues.Order = loAscending
      end
    end
    object chartPayeeMost: TChart
      Left = 0
      Top = 235
      Width = 864
      Height = 235
      Legend.Alignment = laTop
      Legend.Visible = False
      Title.Text.Strings = (
        'Payee Most Used')
      BottomAxis.LabelsAlternate = True
      Panning.InsideBounds = True
      View3D = False
      View3DOptions.Elevation = 315
      View3DOptions.Orthogonal = False
      View3DOptions.Perspective = 0
      View3DOptions.Rotation = 360
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 516
      DefaultCanvas = 'TGDIPlusCanvas'
      PrintMargins = (
        15
        23
        15
        23)
      ColorPaletteIndex = 19
      object Series2: TPieSeries
        Legend.Visible = False
        Selected.Hover.Visible = False
        ShowInLegend = False
        XValues.Order = loAscending
        YValues.Name = 'Pie'
        YValues.Order = loDescending
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
        Bevel.Percent = 5
        BevelPercent = 5
        ExplodeBiggest = 15
        OtherSlice.Legend.Visible = False
        OtherSlice.Style = poBelowPercent
        OtherSlice.Value = 5.000000000000000000
        PiePen.Visible = False
      end
    end
  end
end
