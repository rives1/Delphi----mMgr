object LedgerFrm: TLedgerFrm
  Left = 0
  Top = 0
  Caption = 'LedgerFrm'
  ClientHeight = 625
  ClientWidth = 744
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
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RzSplitter1: TRzSplitter
    Left = 0
    Top = 0
    Width = 744
    Height = 606
    BorderWidth = 2
    FixedPane = fpLowerRight
    Orientation = orVertical
    Position = 430
    Percent = 72
    HotSpotVisible = True
    SplitterStyle = ssBump
    SplitterWidth = 10
    Align = alClient
    TabOrder = 0
    VisualStyle = vsClassic
    BarSize = (
      2
      432
      742
      442)
    UpperLeftControls = (
      grdLedger
      pnlCaption)
    LowerRightControls = (
      chTotals
      chHistory)
    object grdLedger: TStringGrid
      Left = 0
      Top = 21
      Width = 740
      Height = 409
      Align = alClient
      Color = clBtnFace
      ColCount = 11
      Ctl3D = False
      DefaultColWidth = 80
      DefaultRowHeight = 18
      DoubleBuffered = True
      DrawingStyle = gdsClassic
      FixedCols = 0
      RowCount = 2
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
      ParentCtl3D = False
      ParentDoubleBuffered = False
      ParentFont = False
      PopupMenu = PopupMenu1
      TabOrder = 0
      StyleElements = [seFont, seBorder]
      OnDblClick = grdLedgerDblClick
      OnDrawCell = grdLedgerDrawCell
      ExplicitTop = 25
    end
    object pnlCaption: TPanel
      Left = 0
      Top = 0
      Width = 740
      Height = 21
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object chTotals: TChart
      Left = 0
      Top = 0
      Width = 151
      Height = 162
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
      PrintMargins = (
        15
        29
        15
        29)
      ColorPaletteIndex = 13
      object Series1: TPieSeries
        Marks.Visible = False
        Title = 'Totals'
        ValueFormat = '#,##0;(#,##0)'
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
      Left = 151
      Top = 0
      Width = 589
      Height = 162
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
      Pages.MaxPointsPerPage = 26
      View3D = False
      View3DOptions.Orthogonal = False
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object Series2: TAreaSeries
        Marks.Frame.Visible = False
        Marks.Visible = True
        Marks.Callout.Length = 20
        Title = 'Historical Value'
        ValueFormat = '#,##0;(#,##0)'
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
  object sBar: TStatusBar
    Left = 0
    Top = 606
    Width = 744
    Height = 19
    Panels = <
      item
        Text = 'Lines NR'
        Width = 50
      end>
  end
  object PopupMenu1: TPopupMenu
    Left = 35
    Top = 265
    object Edit1: TMenuItem
      Caption = '&Insert (INS)'
      OnClick = Edit1Click
    end
    object InsertDeposit: TMenuItem
      Caption = 'Insert Deposit (+)'
      OnClick = InsertDepositClick
    end
    object InsertExpense1: TMenuItem
      Caption = 'Insert Expense (-)'
      OnClick = InsertExpense1Click
    end
    object Transfer1: TMenuItem
      Caption = '&Transfer (*)'
      OnClick = Transfer1Click
    end
    object Edit2: TMenuItem
      Caption = '&Edit (ENTER)'
      OnClick = Edit2Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ReconcileR1: TMenuItem
      Caption = 'Toggle Reconcile (R)'
      OnClick = ReconcileR1Click
    end
    object oggleBookmarkB1: TMenuItem
      Caption = 'Toggle Bookmark (B)'
      OnClick = oggleBookmarkB1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Delete1: TMenuItem
      Caption = '&Delete (DEL)'
      OnClick = Delete1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object CSVexport1: TMenuItem
      Caption = 'CSV export'
      OnClick = CSVexport1Click
    end
  end
end
