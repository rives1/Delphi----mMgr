object IssueFRM: TIssueFRM
  Left = 324
  Top = 204
  Width = 291
  Height = 280
  ActiveControl = cmbSerie
  Caption = 'Issue'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Serie: TLabel
    Left = 16
    Top = 16
    Width = 24
    Height = 13
    Caption = 'Serie'
  end
  object Label1: TLabel
    Left = 16
    Top = 46
    Width = 25
    Height = 13
    Caption = 'Issue'
  end
  object Label2: TLabel
    Left = 16
    Top = 78
    Width = 20
    Height = 13
    Caption = 'Title'
  end
  object Label3: TLabel
    Left = 16
    Top = 111
    Width = 31
    Height = 13
    Caption = 'Author'
  end
  object Label4: TLabel
    Left = 16
    Top = 141
    Width = 42
    Height = 13
    Caption = 'Designer'
  end
  object Label5: TLabel
    Left = 16
    Top = 171
    Width = 27
    Height = 13
    Caption = 'Editor'
  end
  object shStatus: TLMDShapeControl
    Left = 0
    Top = 230
    Width = 283
    Height = 23
    Align = alBottom
    Bevel.Style = sbInset
    Brush.Color = clBtnFace
    Caption.Font.Charset = ANSI_CHARSET
    Caption.Font.Color = clWindowText
    Caption.Font.Height = -12
    Caption.Font.Name = 'Tahoma'
    Caption.Font.Style = [fsBold]
    Caption.FontFX.LightDepth = 2
    Caption.FontFX.ShadowDepth = 4
    Caption.FontFX.Style = tdSunken
    Caption.FontFX.PosX = 14
    RoundPercent = 50
    Shadow.Depth = 4
    Shadow.Style = hssNone
    Shape = stRoundRect
    Teeth.Height = 10
  end
  object edtID: TEdit
    Left = 133
    Top = 44
    Width = 41
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    Visible = False
  end
  object edtIssue: TEdit
    Left = 66
    Top = 44
    Width = 45
    Height = 21
    TabOrder = 2
  end
  object edtTitle: TEdit
    Left = 66
    Top = 75
    Width = 190
    Height = 21
    TabOrder = 3
  end
  object cmbAut: TComboBox
    Left = 66
    Top = 106
    Width = 145
    Height = 21
    AutoCloseUp = True
    DropDownCount = 13
    ItemHeight = 13
    Sorted = True
    TabOrder = 4
    OnExit = cmbAutExit
  end
  object cmbDes: TComboBox
    Left = 66
    Top = 137
    Width = 145
    Height = 21
    AutoCloseUp = True
    DropDownCount = 13
    ItemHeight = 13
    Sorted = True
    TabOrder = 5
  end
  object cmbEdi: TComboBox
    Left = 66
    Top = 168
    Width = 145
    Height = 21
    AutoCloseUp = True
    DropDownCount = 13
    ItemHeight = 13
    Sorted = True
    TabOrder = 6
  end
  object cmbSerie: TComboBox
    Left = 66
    Top = 13
    Width = 166
    Height = 21
    AutoCloseUp = True
    Ctl3D = True
    DropDownCount = 13
    ItemHeight = 13
    ParentCtl3D = False
    Sorted = True
    TabOrder = 1
    OnExit = cmbSerieExit
  end
  object btnOK: TBitBtn
    Left = 183
    Top = 197
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 8
    TabStop = False
    OnClick = btnOKClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object cbToBuy: TCheckBox
    Left = 15
    Top = 200
    Width = 71
    Height = 17
    Alignment = taLeftJustify
    Caption = 'To Buy'
    TabOrder = 7
  end
end
