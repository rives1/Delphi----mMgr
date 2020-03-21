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
    Position = 308
    Percent = 60
    HotSpotVisible = True
    SplitterStyle = ssGroove
    SplitterWidth = 10
    Align = alClient
    TabOrder = 0
    VisualStyle = vsClassic
    BarSize = (
      5
      313
      782
      323)
    UpperLeftControls = (
      grdLedger)
    LowerRightControls = (
      Chart1
      Chart2)
    object grdLedger: TJvgStringGrid
      Left = 0
      Top = 0
      Width = 777
      Height = 308
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
    object Chart1: TChart
      Left = 0
      Top = 0
      Width = 313
      Height = 189
      Border.Width = 0
      Legend.Visible = False
      Title.Text.Strings = (
        'TChart')
      View3DOptions.Elevation = 315
      View3DOptions.Orthogonal = False
      View3DOptions.Perspective = 0
      View3DOptions.Rotation = 360
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object Series1: TPieSeries
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
    object Chart2: TChart
      Left = 377
      Top = 0
      Width = 400
      Height = 189
      Legend.Visible = False
      Title.Text.Strings = (
        'TChart')
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object Series2: TLineSeries
        Brush.BackColor = clDefault
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
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
