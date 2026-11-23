{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s10t2;

type
  TPoint = record
    X, Y: Integer;
    constructor Create(x, y: Integer);
    class operator Add(P1, P2: TPoint): TPoint;
  end;

constructor TPoint.Create(x, y: Integer);
begin
  X := x; Y := y;
end;

class operator TPoint.Add(P1, P2: TPoint): TPoint;
begin
  Result.X := P1.X + P2.X;
  Result.Y := P1.Y + P2.Y;
end;

var a, b: TPoint;
begin
  a := TPoint.Create(3, 4);
  WriteLn('t2a = (', a.X, ',', a.Y, ')');   // expect (3,4)
  b := TPoint.Create(10, 20);
  WriteLn('t2b = (', b.X, ',', b.Y, ')');   // expect (10,20)
  WriteLn('t2sum = (', (a + b).X, ',', (a + b).Y, ')'); // expect (13,24)
end.
