object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Printer IP Finder 0.9.0'
  ClientHeight = 346
  ClientWidth = 658
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 304
    Top = 327
    Width = 50
    Height = 13
    Caption = 'By Delutto'
  end
  object lbl_GitHub: TLabel
    Left = 617
    Top = 327
    Width = 32
    Height = 13
    Cursor = crHandPoint
    Caption = 'GitHub'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = lbl_GitHubClick
    OnMouseEnter = lbl_GitHubMouseEnter
    OnMouseLeave = lbl_GitHubMouseLeave
  end
  object ListView1: TListView
    Left = 8
    Top = 8
    Width = 641
    Height = 313
    Columns = <
      item
        Caption = 'IP'
        Width = 100
      end
      item
        Caption = 'MAC'
        Width = 110
      end
      item
        Caption = 'Tipo'
        Width = 100
      end
      item
        AutoSize = True
        Caption = 'Fornecedor'
      end>
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    ViewStyle = vsReport
  end
  object PopupMenu1: TPopupMenu
    Left = 192
    Top = 144
    object PMI_Copy: TMenuItem
      Caption = 'Copiar IP'
      OnClick = PMI_CopyClick
    end
    object PMI_Browser: TMenuItem
      Caption = 'Abrir no navegador padr'#227'o'
      OnClick = PMI_BrowserClick
    end
  end
end
