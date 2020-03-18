object Form1: TForm1
  Left = 0
  Top = 0
  ActiveControl = Chart1
  Caption = 'mMgr'
  ClientHeight = 632
  ClientWidth = 965
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 305
    Height = 609
    TabOrder = 0
    object Panel2: TPanel
      Left = 16
      Top = 393
      Width = 281
      Height = 201
      Caption = 'Panel2'
      TabOrder = 0
      object Chart1: TChart
        Left = 24
        Top = 16
        Width = 217
        Height = 169
        Title.Text.Strings = (
          'TChart')
        TabOrder = 0
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
      end
    end
    object treeMenu: TTreeView
      Left = 48
      Top = 48
      Width = 185
      Height = 257
      Indent = 19
      TabOrder = 1
      Items.NodeData = {
        0302000000260000000000000000000000FFFFFFFFFFFFFFFF00000000000000
        0000000000010472006F006F0074001E0000000000000000000000FFFFFFFFFF
        FFFFFF0000000000000000000000000100}
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 608
    Width = 965
    Height = 24
    Panels = <>
  end
  object BitBtn1: TBitBtn
    Left = 496
    Top = 424
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    TabOrder = 2
  end
  object ImageList1: TImageList
    Left = 328
    Top = 352
  end
  object sqlite_conn: TSQLConnection
    DriverName = 'Sqlite'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DbxSqlite'
      
        'DriverPackageLoader=TDBXSqliteDriverLoader,DBXSqliteDriver260.bp' +
        'l'
      
        'MetaDataPackageLoader=TDBXSqliteMetaDataCommandFactory,DbxSqlite' +
        'Driver260.bpl'
      'FailIfMissing=True'
      'Database=')
    Left = 424
    Top = 536
  end
  object MainMenu1: TMainMenu
    Left = 328
    Top = 8
    object File1: TMenuItem
      Caption = '&File'
    end
  end
end
