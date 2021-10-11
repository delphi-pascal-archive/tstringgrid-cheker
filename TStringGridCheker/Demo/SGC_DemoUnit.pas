unit SGC_DemoUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Grids, StringGridCheker;

type
  TForm11 = class(TForm)
    StringGridCheck1: TStringGridCheck;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form11: TForm11;

implementation

{$R *.dfm}

procedure TForm11.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  with StringGridCheck1 do
  begin
    Cells[0, 0] := '№';
    Cells[1, 0] := 'Наименование пункта';
    Cells[2, 0] := 'Статус';
    RowCount := 14;
    for i := 1 to RowCount - 1 do
    begin
      Cells[0, i] := IntToStr(i);
      Cells[1, i] := 'Пункт ' + IntToStr(i);
      Checked[i] := StrToBool(IntToStr(Random(2)-1));
    end;
  end;
end;

end.
