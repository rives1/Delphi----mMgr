object AccountFrm: TAccountFrm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Account'
  ClientHeight = 536
  ClientWidth = 485
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
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
    Left = 211
    Top = 0
    Width = 5
    Height = 517
    ExplicitHeight = 493
  end
  object _fLvAccount: TListView
    Left = 0
    Top = 0
    Width = 211
    Height = 517
    Align = alLeft
    BorderStyle = bsNone
    Columns = <
      item
        AutoSize = True
        Caption = 'Account Name'
      end>
    Ctl3D = False
    FlatScrollBars = True
    GridLines = True
    Groups = <
      item
        Header = 'Checking'
        GroupID = 0
        State = [lgsNormal]
        HeaderAlign = taLeftJustify
        FooterAlign = taLeftJustify
        TitleImage = -1
      end
      item
        Header = 'Cash'
        GroupID = 1
        State = [lgsNormal]
        HeaderAlign = taLeftJustify
        FooterAlign = taLeftJustify
        TitleImage = -1
      end
      item
        Header = 'Credit Card'
        GroupID = 2
        State = [lgsNormal]
        HeaderAlign = taLeftJustify
        FooterAlign = taLeftJustify
        TitleImage = -1
      end
      item
        Header = 'Online'
        GroupID = 3
        State = [lgsNormal]
        HeaderAlign = taLeftJustify
        FooterAlign = taLeftJustify
        TitleImage = -1
      end
      item
        Header = 'Closed Account'
        GroupID = 4
        State = [lgsNormal]
        HeaderAlign = taLeftJustify
        FooterAlign = taLeftJustify
        TitleImage = -1
      end>
    Items.ItemData = {
      05500000000200000000000000FFFFFFFFFFFFFFFF00000000FFFFFFFF000000
      0004630061007400330000000000FFFFFFFFFFFFFFFF00000000FFFFFFFF0000
      00000A630061007400650067006F007200690061003100}
    GroupView = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = _fLvAccountDblClick
    ExplicitLeft = -1
    ExplicitHeight = 266
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 517
    Width = 485
    Height = 19
    Panels = <
      item
        Text = 'Double click to edit Account'
        Width = 50
      end>
  end
  object Panel3: TPanel
    Left = 216
    Top = 0
    Width = 269
    Height = 517
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object Name: TLabel
      Left = 10
      Top = 48
      Width = 27
      Height = 13
      Caption = 'Name'
    end
    object Label2: TLabel
      Left = 6
      Top = 103
      Width = 24
      Height = 13
      Caption = 'Type'
    end
    object Label1: TLabel
      Left = 6
      Top = 165
      Width = 31
      Height = 13
      Caption = 'Status'
    end
    object _fName: TEdit
      Left = 18
      Top = 67
      Width = 228
      Height = 21
      TabOrder = 0
    end
    object _fID: TEdit
      Left = 176
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
      Left = 18
      Top = 122
      Width = 178
      Height = 21
      AutoDropDown = True
      TabOrder = 2
      Text = ''
      Items.Strings = (
        'Cash'
        'Checking'
        'CreditCard'
        'Online')
    end
    object btnOK: TJvBitBtn
      Left = 168
      Top = 247
      Width = 75
      Height = 25
      Caption = '&Save'
      TabOrder = 4
      OnClick = btnOKClick
    end
    object _fStatus: TJvComboBox
      Left = 18
      Top = 184
      Width = 118
      Height = 21
      AutoDropDown = True
      TabOrder = 3
      Text = ''
      Items.Strings = (
        'Open'
        'Closed')
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 80
    Top = 165
    object NewAccount1: TMenuItem
      Caption = 'New Account'
      OnClick = NewAccount1Click
    end
    object EditAccount1: TMenuItem
      Caption = 'Edit Account'
      OnClick = EditAccount1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object DeleteAccount1: TMenuItem
      Caption = 'Delete Account'
      OnClick = DeleteAccount1Click
    end
  end
end
