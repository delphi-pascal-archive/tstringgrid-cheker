object Form11: TForm11
  Left = 247
  Top = 128
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'TStringGridCheker'
  ClientHeight = 247
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object StringGridCheck1: TStringGridCheck
    Left = 0
    Top = 0
    Width = 405
    Height = 247
    Align = alClient
    ColCount = 3
    DefaultColWidth = 20
    DefaultRowHeight = 18
    RowCount = 10
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goRowSizing, goColSizing, goRowMoving, goColMoving, goEditing, goTabs]
    TabOrder = 0
    CheckCollIndex = 2
    ColWidths = (
      20
      221
      70)
    RowHeights = (
      18
      18
      19
      18
      18
      18
      18
      18
      18
      18)
  end
end
