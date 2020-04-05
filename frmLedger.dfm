object LedgerFrm: TLedgerFrm
  Left = 0
  Top = 0
  Caption = 'LedgerFrm'
  ClientHeight = 539
  ClientWidth = 814
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RzSplitter1: TRzSplitter
    Left = 0
    Top = 0
    Width = 814
    Height = 520
    BorderWidth = 2
    FixedPane = fpLowerRight
    Orientation = orVertical
    Position = 350
    Percent = 68
    HotSpotVisible = True
    SplitterStyle = ssBump
    SplitterWidth = 10
    Align = alClient
    TabOrder = 0
    VisualStyle = vsClassic
    BarSize = (
      2
      352
      812
      362)
    UpperLeftControls = (
      _e_grdLedger
      grdLedger)
    LowerRightControls = (
      chTotals
      chHistory)
    object _e_grdLedger: TJvgStringGrid
      Left = 110
      Top = 200
      Width = 305
      Height = 114
      Cursor = crHandPoint
      BorderStyle = bsNone
      Color = clMoneyGreen
      ColCount = 9
      Ctl3D = True
      DefaultColWidth = 70
      DefaultRowHeight = 18
      DefaultDrawing = False
      DoubleBuffered = True
      DrawingStyle = gdsGradient
      FixedCols = 0
      RowCount = 2
      GradientEndColor = clBlack
      GradientStartColor = clMoneyGreen
      GridLineWidth = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goRowSelect]
      ParentCtl3D = False
      ParentDoubleBuffered = False
      PopupMenu = PopupMenu1
      TabOrder = 0
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
      ExtOptions = []
      EditorColor = clBlack
      EditorFont.Charset = DEFAULT_CHARSET
      EditorFont.Color = clWindowText
      EditorFont.Height = -11
      EditorFont.Name = 'Tahoma'
      EditorFont.Style = []
      ColWidths = (
        70
        70
        70
        70
        70
        70
        70
        70
        -255)
    end
    object grdLedger: TStringGrid
      Left = 0
      Top = 0
      Width = 810
      Height = 350
      Align = alClient
      Color = clBtnFace
      ColCount = 9
      Ctl3D = False
      DefaultRowHeight = 17
      DrawingStyle = gdsClassic
      FixedCols = 0
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      OnDblClick = grdLedgerDblClick
      OnDrawCell = grdLedgerDrawCell
      OnKeyDown = grdLedgerKeyDown
    end
    object chTotals: TChart
      Left = 0
      Top = 0
      Width = 377
      Height = 156
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
      Left = 410
      Top = 0
      Width = 400
      Height = 156
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
        Pointer.Visible = False
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
  end
  object RzStatusBar1: TRzStatusBar
    Left = 0
    Top = 520
    Width = 814
    Height = 19
    BorderInner = fsNone
    BorderOuter = fsNone
    BorderSides = [sdLeft, sdTop, sdRight, sdBottom]
    BorderWidth = 0
    TabOrder = 1
  end
  object PopupMenu1: TPopupMenu
    Left = 35
    Top = 265
    object Edit1: TMenuItem
      Caption = '&Insert (INS)'
      OnClick = Edit1Click
    end
    object InsertExpensecontinuous1: TMenuItem
      Caption = 'Insert Expense &bulk (+)'
    end
    object Transfer1: TMenuItem
      Caption = '&Transfer (*)'
    end
    object Edit2: TMenuItem
      Caption = '&Edit (ENTER)'
      OnClick = Edit2Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Delete1: TMenuItem
      Caption = '&Delete (DEL)'
      OnClick = Delete1Click
    end
  end
end
