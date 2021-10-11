unit StringGridCheker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls,
  ToolWin, Menus, Themes, Grids, XPMan;

type

  TChekedGridEvent = procedure(Sender: TObject; const ARow: Integer;
    const RowChecked: Boolean) of object;

  TStringGridCheck = class(TStringGrid)
  private
    fOptions: TGridOptions;
    OptEdition: Boolean;
    OldCellR: Integer;
    OldCellC: Integer;
    OldButton: TMouseButton;
    OldMouseCell: TPoint;
    fCheckCollIndex: Integer;
    fOnCheked: TChekedGridEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnMouseUp: TMouseEvent;
    FOnMouseDown: TMouseEvent;
    FOnKeyPress: TKeyPressEvent;
    FOnDrawCell: TDrawCellEvent;
    FOnDrawingCell: TDrawCellEvent;
    FOnColumnMoved: TMovedEvent;
    FOnSelectCell: TSelectCellEvent;
    procedure CheckDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState); overload;
    procedure CheckDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState; Moused: Boolean); overload;
    procedure CheckMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure CheckMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckColumnMoved(Sender: TObject; FromIndex, ToIndex: Integer);
    procedure CheckKeyPress(Sender: TObject; var Key: Char);
    procedure CheckSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure CheckResize(Sender: TObject);
    function GetChecked(Index: Integer): Boolean;
    procedure PutChecked(Index: Integer; const B: Boolean);
    procedure SetOptions(Value: TGridOptions);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    function IsCellSelected(X, Y: Longint): Boolean;
    property Checked[Index: Integer]: Boolean read GetChecked write PutChecked;
  published
    property CheckCollIndex
      : Integer read fCheckCollIndex write fCheckCollIndex default 0;
    property OnCheked: TChekedGridEvent read fOnCheked write fOnCheked;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnKeyPress: TKeyPressEvent read FOnKeyPress write FOnKeyPress;
    property OnDrawCell: TDrawCellEvent read FOnDrawCell write FOnDrawCell;
    property OnDrawingCell
      : TDrawCellEvent read FOnDrawingCell write FOnDrawingCell;
    property OnColumnMoved
      : TMovedEvent read FOnColumnMoved write FOnColumnMoved;
    property OnSelectCell
      : TSelectCellEvent read FOnSelectCell write FOnSelectCell;
    property Options: TGridOptions read fOptions write SetOptions;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('BuBa Group', [TStringGridCheck]);
end;

procedure TStringGridCheck.CheckDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Hot: Boolean;
  c, r: Integer;
  s: string;
begin
  if Assigned(FOnDrawingCell) then // запускаем событие "ƒо прорисовки"
    FOnDrawingCell(Sender, ACol, ARow, Rect, State);
  begin // если €чейка находис€ в "чек"столбике...
    MouseToCell(Mouse.CursorPos.X - ClientOrigin.X,
      Mouse.CursorPos.Y - ClientOrigin.Y, c, r); // определ€ем положение мыши
    Hot := (ACol = c) and (ARow = r); // определ€ем наведена ли мышь на перерисовываемую €чейку
    if (ThemeServices.ThemesEnabled) then
    begin // если используетс€ тема оформлени€ виндовс, то рисуем чекбоксы
      if (ARow < FixedRows) and (ACol < FixedCols) then
      begin
        if Hot then // мышь над €чейкой
          ThemeServices.DrawElement(Canvas.Handle, // рисуем подсвеченную галку
            ThemeServices.GetElementDetails(thHeaderItemLeftHot), Rect)
        else
          ThemeServices.DrawElement(Canvas.Handle, // рисуем обычную галку
            ThemeServices.GetElementDetails(thHeaderItemLeftNormal), Rect)
      end
      else
      if (ARow < FixedRows) or (ACol < FixedCols) then
      begin
        if Hot then // мышь над €чейкой
          ThemeServices.DrawElement(Canvas.Handle, // рисуем подсвеченную галку
            ThemeServices.GetElementDetails(thHeaderItemHot), Rect)
        else
          ThemeServices.DrawElement(Canvas.Handle, // рисуем обычную галку
            ThemeServices.GetElementDetails(thHeaderItemNormal), Rect)
      end
      else
      begin
        if gdSelected in State then
          Canvas.Brush.Color := GetSysColor(COLOR_MENUHILIGHT)
        else
          Canvas.Brush.Color := GetSysColor(COLOR_WINDOW);
        Canvas.Pen.Style := psClear;
        Canvas.Rectangle(Classes.Rect(Rect.Left + 1, Rect.Top + 1, Rect.Right - 2, Rect.Bottom - 2));// затираем фон
      end;
      if (ACol = CheckCollIndex) and (ARow >= FixedRows) then
      begin
        if Checked[ARow] then // стоит галочка
        begin
          if Hot then // мышь над €чейкой
            ThemeServices.DrawElement(Canvas.Handle, // рисуем подсвеченную галку
              ThemeServices.GetElementDetails(tbCheckBoxCheckedHot), Rect)
          else
            ThemeServices.DrawElement(Canvas.Handle, // рисуем обычную галку
              ThemeServices.GetElementDetails(tbCheckBoxCheckedNormal), Rect)
        end
        else // иначе рисуем пустой чек по аналогии
          if Hot then
          ThemeServices.DrawElement(Canvas.Handle, ThemeServices.GetElementDetails
              (tbCheckBoxUncheckedHot), Rect)
        else
          ThemeServices.DrawElement(Canvas.Handle, ThemeServices.GetElementDetails
              (tbCheckBoxUncheckedNormal), Rect);
      end
    else // если тема оформлени€ не используетс€, выводим текст
    begin
      Canvas.Brush.Style := bsClear;
      s := Cells[ACol, ARow];
      Canvas.Font.Color := clBlack ;
      Canvas.TextRect(Rect, Rect.Left, Rect.Top, s);
    end;
    end;
  end;
  if Assigned(FOnDrawCell) then // запускаем  обработчик
    FOnDrawCell(Sender, ACol, ARow, Rect, State);
end;

procedure TStringGridCheck.CheckDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; Moused: Boolean);
var
  opt: TGridDrawState;
begin
  if (OldCellC <> ACol) or (OldCellR <> ARow) then
  begin
    opt := [];
    if Focused and (OldCellC = Row) and (OldCellR = Col)  then
      Include(opt, gdFocused);
    if IsCellSelected(OldCellC, OldCellR) then
      Include(opt, gdSelected);
    CheckDrawCell(Sender, OldCellC, OldCellR, CellRect(OldCellC, OldCellR), opt);
  end;
  CheckDrawCell(Sender, ACol, ARow, CellRect(ACol, ARow), State);
  OldCellC := ACol; // запоминаем текущую
  OldCellR := ARow; // €чейку
end;


procedure TStringGridCheck.CheckMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  c, r: Integer;
  opt: TGridDrawState;
begin
  MouseToCell(Mouse.CursorPos.X - ClientOrigin.X,
    Mouse.CursorPos.Y - ClientOrigin.Y, c, r); // определ€ем €чейку
  if IsCellSelected(c, r) then
    opt := opt + [gdSelected]
  else
    opt := opt - [gdSelected];
  if (c > -1) and (r > -1) then // если €чейка существует перерисовываем
    CheckDrawCell(Sender, c, r, CellRect(c, r), opt, True);
  if Assigned(FOnMouseMove) then // вызываем событие
    FOnMouseMove(Sender, Shift, X, Y);
end;

procedure TStringGridCheck.CheckMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  c, r: Integer;
begin
  MouseToCell(Mouse.CursorPos.X - ClientOrigin.X,
    Mouse.CursorPos.Y - ClientOrigin.Y, c, r);
  if (r >= FixedRows) and (c = CheckCollIndex) then
    if (c > -1) and (RowCount > r) and (r > -1) and (OldButton = Button) and
      (Button = mbLeft) and (OldMouseCell.X = c) and (OldMouseCell.Y = r) then
      Checked[r] := not(Checked[r]); // мен€ем состо€ни€ чека, на случай если условие вдруг вернет истину))
  if Assigned(FOnMouseUp) then // событие
    FOnMouseUp(Sender, Button, Shift, X, Y);
end;

procedure TStringGridCheck.CheckMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  c, r: Integer;
begin
  MouseToCell(Mouse.CursorPos.X - ClientOrigin.X,
    Mouse.CursorPos.Y - ClientOrigin.Y, c, r);
  OldButton := Button; // запоминаем кнопку
  OldMouseCell := Point(c, r); // и €чейку
  if Assigned(FOnMouseDown) then // передаем событие дальше в обработку
    FOnMouseDown(Sender, Button, Shift, X, Y);
end;

procedure TStringGridCheck.CheckColumnMoved(Sender: TObject;
  FromIndex, ToIndex: Integer);
begin
  if FromIndex = CheckCollIndex then
    CheckCollIndex := ToIndex
  else if ToIndex = CheckCollIndex then
    CheckCollIndex := FromIndex;
  if Assigned(FOnColumnMoved) then
    FOnColumnMoved(Sender, FromIndex, ToIndex);
end;

procedure TStringGridCheck.CheckKeyPress(Sender: TObject; var Key: Char);
var
  c, r: Integer;
begin
  if (Key = char(VK_RETURN)) or (Key = char(VK_SPACE)) then
  begin
    for c := 0 to ColCount - 1 do
      for r := 0 to RowCount - 1 do
        if (c = CheckCollIndex) and (IsCellSelected(c, r)) then
          Checked[r] := not(Checked[r]);
  end;
  if Assigned(FOnKeyPress) then
    FOnKeyPress(Sender, Key);
end;

procedure TStringGridCheck.CheckSelectCell
  (Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if OptEdition then
    if ACol = CheckCollIndex then
      inherited Options := fOptions - [goEditing]
    else
      inherited Options := fOptions;
  if Assigned(FOnSelectCell) then
    FOnSelectCell(Sender, ACol, ARow, CanSelect);
end;

procedure TStringGridCheck.CheckResize(Sender: TObject);
var
  r: Integer;
  opt: TGridDrawState;
begin
  for r := 0 to RowCount - 1 do
  begin
    if IsCellSelected(CheckCollIndex, r) then
      opt := opt + [gdSelected]
    else
      opt := opt - [gdSelected];
    CheckDrawCell(Self, CheckCollIndex, r, CellRect(CheckCollIndex, r), opt);
  end;
end;

function TStringGridCheck.GetChecked(Index: Integer): Boolean;
begin
  Result := (RowCount > Index) and (Index >= FixedRows) and
    (ColCount > CheckCollIndex) and // возвращаем chek-статус строки
    (Cells[CheckCollIndex, Index] = '-1');
end;

procedure TStringGridCheck.PutChecked(Index: Integer; const B: Boolean);
begin
  if (RowCount > Index) and (Index >= FixedRows) and
    (ColCount > CheckCollIndex) and (CheckCollIndex > -1) then
  begin // устанавливаем новое значение €чейке
    Cells[CheckCollIndex, Index] := BoolToStr(B, False);
    if Assigned(fOnCheked) then
      fOnCheked(Self, Index, B);
  end;
end;

procedure TStringGridCheck.SetOptions(Value: TGridOptions);
begin
  OptEdition := goEditing in Value;
  fOptions := Value - [goFixedHorzLine, goFixedVertLine, goHorzLine, goVertLine];
  inherited Options := Options ;
  CheckResize(Self);
end;

constructor TStringGridCheck.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited OnMouseMove := CheckMouseMove; // "перехватываем" на обработку
  inherited OnMouseUp := CheckMouseUp; // необходимые событие предка
  inherited OnMouseDown := CheckMouseDown;
  inherited OnDrawCell := CheckDrawCell;
  inherited OnColumnMoved := CheckColumnMoved;
  inherited OnSelectCell := CheckSelectCell;
  inherited OnResize := CheckResize;
  inherited OnKeyPress := CheckKeyPress;
end;

function TStringGridCheck.IsCellSelected(X, Y: Longint): Boolean;
 begin
   Result := False;
   try
     if (X >= Selection.Left) and (X <= Selection.Right) and
       (Y >= Selection.Top) and (Y <= Selection.Bottom) then
       Result := True;
   except
   end;
 end;
end.
