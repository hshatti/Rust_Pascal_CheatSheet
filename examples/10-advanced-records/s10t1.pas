{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s10t1;

type
  TPoint = record
    X, Y: Integer;
    constructor Create(x, y: Integer);
  end;

constructor TPoint.Create(x, y: Integer);
begin
  X := x; Y := y;
end;

var p: TPoint;
begin
  p := TPoint.Create(3, 4);
  WriteLn('t1 = (', p.X, ',', p.Y, ')');   // expect (3,4)
end.
