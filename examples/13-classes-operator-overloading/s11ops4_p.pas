{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s11ops4_p;

type
  TFlag = record
    FBits: Integer;
    class operator Add(F1, F2: TFlag): TFlag;
    class operator Subtract(F1, F2: TFlag): TFlag;
    class operator Multiply(F1, F2: TFlag): TFlag;
    class operator Divide(F1, F2: TFlag): TFlag;
    class operator IntDivide(F1, F2: TFlag): TFlag;
    class operator Modulus(F1, F2: TFlag): TFlag;
    class operator BitwiseAnd(F1, F2: TFlag): TFlag;
    class operator BitwiseOr(F1, F2: TFlag): TFlag;
    class operator BitwiseXor(F1, F2: TFlag): TFlag;
    class operator LeftShift(F: TFlag; N: Integer): TFlag;
    class operator RightShift(F: TFlag; N: Integer): TFlag;
    class operator LessThan(F1, F2: TFlag): Boolean;
    class operator GreaterThan(F1, F2: TFlag): Boolean;
    class operator Equal(F1, F2: TFlag): Boolean;
    class operator NotEqual(F1, F2: TFlag): Boolean;
    class operator Implicit(A: Integer): TFlag;   // implicit typecast — f := 42
    class operator Explicit(A: Double): TFlag;    // explicit typecast — TFlag(3.9)
  end;

class operator TFlag.Add(F1, F2: TFlag): TFlag;
begin Result.FBits := F1.FBits + F2.FBits; end;

class operator TFlag.Subtract(F1, F2: TFlag): TFlag;
begin Result.FBits := F1.FBits - F2.FBits; end;

class operator TFlag.Multiply(F1, F2: TFlag): TFlag;
begin Result.FBits := F1.FBits * F2.FBits; end;

class operator TFlag.Divide(F1, F2: TFlag): TFlag;
begin Result.FBits := Trunc(F1.FBits / F2.FBits); end;

class operator TFlag.IntDivide(F1, F2: TFlag): TFlag;
begin Result.FBits := F1.FBits div F2.FBits; end;

class operator TFlag.Modulus(F1, F2: TFlag): TFlag;
begin Result.FBits := F1.FBits mod F2.FBits; end;

class operator TFlag.BitwiseAnd(F1, F2: TFlag): TFlag;
begin Result.FBits := F1.FBits and F2.FBits; end;

class operator TFlag.BitwiseOr(F1, F2: TFlag): TFlag;
begin Result.FBits := F1.FBits or F2.FBits; end;

class operator TFlag.BitwiseXor(F1, F2: TFlag): TFlag;
begin Result.FBits := F1.FBits xor F2.FBits; end;

class operator TFlag.LeftShift(F: TFlag; N: Integer): TFlag;
begin Result.FBits := F.FBits shl N; end;

class operator TFlag.RightShift(F: TFlag; N: Integer): TFlag;
begin Result.FBits := F.FBits shr N; end;

class operator TFlag.LessThan(F1, F2: TFlag): Boolean;
begin Result := F1.FBits < F2.FBits; end;

class operator TFlag.GreaterThan(F1, F2: TFlag): Boolean;
begin Result := F1.FBits > F2.FBits; end;

class operator TFlag.Equal(F1, F2: TFlag): Boolean;
begin Result := F1.FBits = F2.FBits; end;

class operator TFlag.NotEqual(F1, F2: TFlag): Boolean;
begin Result := F1.FBits <> F2.FBits; end;

class operator TFlag.Implicit(A: Integer): TFlag;
begin Result.FBits := A; end;

class operator TFlag.Explicit(A: Double): TFlag;
begin Result.FBits := Trunc(A); end;

var a, b, f: TFlag;
begin
  a.FBits := 7; b.FBits := 3;
  WriteLn('add = ', (a + b).FBits);        // add = 10
  WriteLn('sub = ', (a - b).FBits);        // sub = 4
  WriteLn('mul = ', (a * b).FBits);        // mul = 21
  WriteLn('div = ', (a div b).FBits);      // div = 2 — IntDivide
  WriteLn('mod = ', (a mod b).FBits);      // mod = 1 — Modulus
  WriteLn('and = ', (a and b).FBits);      // and = 3 — BitwiseAnd
  WriteLn('or  = ', (a or b).FBits);       // or  = 7 — BitwiseOr
  WriteLn('xor = ', (a xor b).FBits);      // xor = 4 — BitwiseXor
  WriteLn('shl = ', (a shl 2).FBits);      // shl = 28 — LeftShift
  WriteLn('shr = ', (b shr 1).FBits);      // shr = 1 — RightShift
  WriteLn('lt  = ', a < b);                // lt  = False — LessThan
  WriteLn('gt  = ', a > b);                // gt  = True — GreaterThan
  WriteLn('eq  = ', a = b);                // eq  = False — Equal
  WriteLn('neq = ', a <> b);               // neq = True — NotEqual

  f := 42;                                 // Implicit conversion from Integer
  WriteLn('implicit = ', f.FBits);         // implicit = 42
  f := TFlag(3.9);                         // Explicit typecast from Double
  WriteLn('explicit = ', f.FBits);         // explicit = 3
end.
