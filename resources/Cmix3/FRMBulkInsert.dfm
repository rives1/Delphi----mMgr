object BulkInsertFRM: TBulkInsertFRM
  Left = 379
  Top = 268
  BorderStyle = bsSingle
  Caption = 'Bulk Insert'
  ClientHeight = 109
  ClientWidth = 197
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 11
    Width = 31
    Height = 13
    Caption = 'Ref.Nr'
  end
  object Label2: TLabel
    Left = 5
    Top = 43
    Width = 40
    Height = 13
    Caption = 'From Nr.'
  end
  object Label3: TLabel
    Left = 105
    Top = 43
    Width = 30
    Height = 13
    Caption = 'To Nr.'
  end
  object sbtnOK: TSpeedButton
    Left = 103
    Top = 68
    Width = 73
    Height = 23
    Caption = '&Insert'
    Flat = True
    OnClick = sbtnOKClick
  end
  object EDT_daNr: TEdit
    Left = 55
    Top = 40
    Width = 36
    Height = 18
    BiDiMode = bdLeftToRight
    BorderStyle = bsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 0
  end
  object EDT_aNr: TEdit
    Left = 140
    Top = 40
    Width = 40
    Height = 18
    BiDiMode = bdLeftToRight
    BorderStyle = bsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 2
  end
  object PrgBAR: TProgressBar
    Left = 0
    Top = 94
    Width = 197
    Height = 15
    Align = alBottom
    TabOrder = 1
  end
  object cmbIssue: TComboBox
    Left = 45
    Top = 7
    Width = 136
    Height = 21
    AutoDropDown = True
    AutoCloseUp = True
    Ctl3D = False
    DropDownCount = 13
    ItemHeight = 13
    ParentCtl3D = False
    Sorted = True
    TabOrder = 3
  end
end
