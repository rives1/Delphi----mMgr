object CategoryFrm: TCategoryFrm
  Left = 0
  Top = 0
  Caption = 'Category'
  ClientHeight = 446
  ClientWidth = 449
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
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
    Height = 427
    ExplicitLeft = 243
    ExplicitHeight = 493
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 427
    Width = 449
    Height = 19
    Panels = <
      item
        Text = 
          'Double click to edit Category/Subcategory - Right click for acti' +
          'ons'
        Width = 50
      end>
    ExplicitTop = 433
    ExplicitWidth = 508
  end
  object Panel3: TPanel
    Left = 184
    Top = 0
    Width = 265
    Height = 427
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 182
    ExplicitWidth = 292
    object Name: TLabel
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
      BorderStyle = bsNone
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
    Height = 427
    Align = alLeft
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    DragMode = dmAutomatic
    Indent = 19
    PopupMenu = PopupMenu1
    ReadOnly = True
    RowSelect = True
    SortType = stBoth
    TabOrder = 2
    OnDblClick = _treeCategoryDblClick
    OnDragDrop = _treeCategoryDragDrop
    OnDragOver = _treeCategoryDragOver
    Items.NodeData = {
      0301000000340000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      0002000000010B680065007200740065006800790072007400680079002A0000
      000000000000000000FFFFFFFFFFFFFFFF000000000000000000000000010636
      0035003400360034003600300000000000000000000000FFFFFFFFFFFFFFFF00
      00000000000000000000000109650068006700670064006400680068006600}
    ExplicitLeft = 2
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
