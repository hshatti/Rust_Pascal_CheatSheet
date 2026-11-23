{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s10_p;

uses SysUtils;

type
  TPoint = record
    X, Y: Integer;
    constructor Create(AX, AY: Integer);   // record constructor — A-prefixed params avoid case-insensitive collision with fields X/Y
    function DistSq: Integer;            // method inside a record
    procedure MoveBy(dx, dy: Integer);
    class operator Add(P1, P2: TPoint): TPoint;           // +
    class operator Subtract(P1, P2: TPoint): TPoint;      // -
    class operator Multiply(P: TPoint; F: Double): TPoint; // * scalar (mixed-type)
  end;

constructor TPoint.Create(AX, AY: Integer);
begin
  X := AX; Y := AY;
end;

function TPoint.DistSq: Integer;
begin
  Result := X * X + Y * Y;
end;

procedure TPoint.MoveBy(dx, dy: Integer);
begin
  Inc(X, dx); Inc(Y, dy);
end;

class operator TPoint.Add(P1, P2: TPoint): TPoint;
begin
  Result.X := P1.X + P2.X;
  Result.Y := P1.Y + P2.Y;
end;

class operator TPoint.Subtract(P1, P2: TPoint): TPoint;
begin
  Result.X := P1.X - P2.X;
  Result.Y := P1.Y - P2.Y;
end;

class operator TPoint.Multiply(P: TPoint; F: Double): TPoint;
begin
  Result.X := Round(P.X * F);
  Result.Y := Round(P.Y * F);
end;

type
  TBox = record
    private
      FVal: Integer;                     // inaccessible outside the type
    public
      constructor Create(v: Integer);
      function Get: Integer;
  end;

constructor TBox.Create(v: Integer);
begin
  FVal := v;
end;

function TBox.Get: Integer;
begin
  Result := FVal;
end;

type
  TPointHelper = record helper for TPoint   // record helper (Delphi 2010+) — adds methods to an existing type
    function Text: string;
  end;

function TPointHelper.Text: string;
begin
  Result := Format('(%d, %d)', [X, Y]);
end;

var
  p, a, b: TPoint;
  box: TBox;
begin
  p := TPoint.Create(3, 4);
  WriteLn('dist sq = ', p.DistSq);                 // dist sq = 25
  p.MoveBy(1, 1);
  WriteLn('moved = (', p.X, ',', p.Y, ')');        // moved = (4,5)

  box := TBox.Create(7);
  WriteLn('box = ', box.Get);                      // box = 7

  WriteLn('helper text = ', p.Text);               // helper text = (4, 5) — helper method called directly on the instance

  a := TPoint.Create(1, 2);
  b := TPoint.Create(10, 20);
  WriteLn('sum = (', (a + b).X, ',', (a + b).Y, ')');        // sum = (11,22) — a and b still usable afterwards
  WriteLn('diff = (', (b - a).X, ',', (b - a).Y, ')');       // diff = (9,18)
  WriteLn('scaled = (', (a * 3.0).X, ',', (a * 3.0).Y, ')'); // scaled = (3,6)
end.
