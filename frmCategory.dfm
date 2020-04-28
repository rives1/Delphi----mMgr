object CategoryFrm: TCategoryFrm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Category'
  ClientHeight = 599
  ClientWidth = 459
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 176
    Top = 0
    Width = 8
    Height = 580
    ExplicitLeft = 243
    ExplicitHeight = 493
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 580
    Width = 459
    Height = 19
    Panels = <
      item
        Text = 
          'Double click to edit Category/Subcategory - Right click for acti' +
          'ons'
        Width = 50
      end>
  end
  object Panel3: TPanel
    Left = 184
    Top = 0
    Width = 275
    Height = 580
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object _lblName: TLabel
      Left = 14
      Top = 38
      Width = 53
      Height = 13
      Caption = 'Description'
    end
    object _lblType: TLabel
      Left = 14
      Top = 89
      Width = 24
      Height = 13
      Caption = 'Type'
    end
    object _fName: TEdit
      Left = 25
      Top = 60
      Width = 226
      Height = 21
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
    end
    object _fID: TEdit
      Left = 187
      Top = 8
      Width = 65
      Height = 21
      TabStop = False
      Alignment = taRightJustify
      Color = clBtnFace
      Ctl3D = True
      Enabled = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 1
    end
    object _fType: TJvComboBox
      Left = 25
      Top = 108
      Width = 157
      Height = 21
      AutoDropDown = True
      TabOrder = 2
      Text = ''
      Items.Strings = (
        'Expense'
        'Income')
    end
    object btnOK: TJvBitBtn
      Left = 178
      Top = 156
      Width = 75
      Height = 25
      Caption = '&Save'
      TabOrder = 3
      OnClick = btnOKClick
    end
  end
  object _treeCategory: TTreeView
    Left = 0
    Top = 0
    Width = 176
    Height = 580
    Align = alLeft
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    DragMode = dmAutomatic
    HotTrack = True
    Indent = 19
    PopupMenu = PopupMenu1
    ReadOnly = True
    RowSelect = True
    SortType = stBoth
    TabOrder = 2
    OnCollapsed = _treeCategoryCollapsed
    OnDblClick = _treeCategoryDblClick
    OnDragDrop = _treeCategoryDragDrop
    OnDragOver = _treeCategoryDragOver
    Items.NodeData = {
      0301000000240000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      000200000001036300610074002C0000000000000000000000FFFFFFFFFFFFFF
      FF000000000000000000000000010773007500620063006100740031002C0000
      000000000000000000FFFFFFFFFFFFFFFF000000000000000000000000010773
      00750062006300610074003200}
  end
  object PopupMenu1: TPopupMenu
    Left = 50
    Top = 295
    object NewCategory1: TMenuItem
      Caption = 'New Category'
      OnClick = NewCategory1Click
    end
    object NewSubcategory1: TMenuItem
      Caption = 'New Subcategory'
      OnClick = NewSubcategory1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      OnClick = Edit1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = Delete1Click
    end
  end
end
