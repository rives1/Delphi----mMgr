object LedgerFrm: TLedgerFrm
  Left = 0
  Top = 0
  Caption = 'LedgerFrm'
  ClientHeight = 536
  ClientWidth = 787
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
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RzSplitter1: TRzSplitter
    Left = 0
    Top = 0
    Width = 787
    Height = 517
    BorderWidth = 5
    Orientation = orVertical
    Position = 350
    Percent = 68
    HotSpotVisible = True
    SplitterStyle = ssGroove
    SplitterWidth = 10
    Align = alClient
    TabOrder = 0
    VisualStyle = vsClassic
    BarSize = (
      5
      355
      782
      365)
    UpperLeftControls = (
      grdLedger)
    LowerRightControls = (
      chTotals
      chHistory)
    object grdLedger: TJvgStringGrid
      Left = 0
      Top = 0
      Width = 777
      Height = 350
      Align = alClient
      BorderStyle = bsNone
      Color = clMoneyGreen
      ColCount = 9
      DefaultColWidth = 80
      DefaultRowHeight = 18
      DrawingStyle = gdsGradient
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goRowSelect, goFixedColClick]
      ScrollBars = ssVertical
      TabOrder = 0
      OnDrawCell = grdLedgerDrawCell
      OnKeyDown = grdLedgerKeyDown
      TextAlignment = taRightJustify
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'Tahoma'
      CaptionFont.Style = [fsBold]
      Captions.Strings = (
        'ID'
        'Type'
        'Date'
        'Payee'
        'Category'
        'In'
        'Out'
        'Balance'
        'Description')
      ExtOptions = [fsgHottrack, fsgWordWrap, fsgCellHeightAutoSize, fsgTabThroughCells]
      EditorColor = clTeal
      EditorFont.Charset = DEFAULT_CHARSET
      EditorFont.Color = clWindowText
      EditorFont.Height = -11
      EditorFont.Name = 'Tahoma'
      EditorFont.Style = []
      ExplicitHeight = 308
      ColWidths = (
        80
        80
        80
        80
        80
        80
        80
        80
        137)
    end
    object chTotals: TChart
      Left = 0
      Top = 0
      Width = 377
      Height = 147
      Border.Width = 0
      Legend.Alignment = laBottom
      Title.Text.Strings = (
        'TChart')
      Title.Visible = False
      View3DOptions.Elevation = 315
      View3DOptions.Orthogonal = False
      View3DOptions.Perspective = 0
      View3DOptions.Rotation = 360
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitHeight = 189
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object Series1: TPieSeries
        Marks.Visible = False
        Title = 'Totals'
        XValues.Order = loAscending
        YValues.Name = 'Pie'
        YValues.Order = loNone
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
        OtherSlice.Legend.Visible = False
      end
    end
    object chHistory: TChart
      Left = 377
      Top = 0
      Width = 400
      Height = 147
      Legend.Visible = False
      MarginRight = 8
      MarginTop = 10
      Title.Text.Strings = (
        'TChart')
      Title.Visible = False
      BottomAxis.Axis.Color = clDefault
      BottomAxis.Axis.Width = 0
      BottomAxis.StartPosition = 1.000000000000000000
      Chart3DPercent = 1
      View3D = False
      View3DOptions.Orthogonal = False
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitHeight = 189
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object Series2: TAreaSeries
        Marks.Frame.Visible = False
        Marks.Visible = True
        Marks.Callout.Length = 20
        Title = 'Historical Value'
        AreaChartBrush.Color = clGray
        AreaChartBrush.BackColor = clDefault
        AreaLinesPen.Visible = False
        DrawArea = True
        LinePen.Fill.Gradient.StartColor = clRed
        LinePen.Fill.Gradient.Visible = True
        Pointer.HorizSize = 3
        Pointer.InflateMargins = True
        Pointer.Style = psDownTriangle
        Pointer.VertSize = 3
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
  end
  object RzStatusBar1: TRzStatusBar
    Left = 0
    Top = 517
    Width = 787
    Height = 19
    BorderInner = fsNone
    BorderOuter = fsNone
    BorderSides = [sdLeft, sdTop, sdRight, sdBottom]
    BorderWidth = 0
    TabOrder = 1
  end
end
