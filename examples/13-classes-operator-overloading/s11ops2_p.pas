{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s11ops2_p;

type
  TFlag = record
    FBits: Integer;
    class operator Add(F1, F2: TFlag): TFlag;
    class operator Subtract(F1, F2: TFlag): TFlag;
    class operator Multiply(F1, F2: TFlag): TFlag;
    class operator Divide(F1, F2: TFlag): TFlag;
    class operator Div(F1, F2: TFlag): TFlag;
    class operator Mod(F1, F2: TFlag): TFlag;
    class operator And(F1, F2: TFlag): TFlag;
    class operator Or(F1, F2: TFlag): TFlag;
    class operator Xor(F1, F2: TFlag): TFlag;
    class operator Shl(F: TFlag; N: Integer): TFlag;
    class operator Shr(F: TFlag; N: Integer): TFlag;
    class operator LessThan(F1, F2: TFlag): Boolean;
    class operator GreaterThan(F1, F2: TFlag): Boolean;
    class operator Equal(F1, F2: TFlag): Boolean;
  end;

class operator TFlag.Add(F1, F2: TFlag): TFlag;
begin Result.FBits := F1.FBits + F2.FBits; end;

class operator TFlag.Subtract(F1, F2: TFlag): TFlag;
begin Result.FBits := F1.FBits - F2.FBits; end;

class operator TFlag.Multiply(F1, F2: TFlag): TFlag;
begin Result.FBits := F1.FBits * F2.FBits; end;

class operator TFlag.Divide(F1, F2: TFlag): TFlag;
begin Result.FBits := Trunc(F1.FBits / F2.FBits); end;

class operator TFlag.Div(F1, F2: TFlag): TFlag;
begin Result.FBits := F1.FBits div F2.FBits; end;

class operator TFlag.Mod(F1, F2: TFlag): TFlag;
begin Result.FBits := F1.FBits mod F2.FBits; end;

class operator TFlag.And(F1, F2: TFlag): TFlag;
begin Result.FBits := F1.FBits and F2.FBits; end;

class operator TFlag.Or(F1, F2: TFlag): TFlag;
begin Result.FBits := F1.FBits or F2.FBits; end;

class operator TFlag.Xor(F1, F2: TFlag): TFlag;
begin Result.FBits := F1.FBits xor F2.FBits; end;

class operator TFlag.Shl(F: TFlag; N: Integer): TFlag;
begin Result.FBits := F.FBits shl N; end;

class operator TFlag.Shr(F: TFlag; N: Integer): TFlag;
begin Result.FBits := F.FBits shr N; end;

class operator TFlag.LessThan(F1, F2: TFlag): Boolean;
begin Result := F1.FBits < F2.FBits; end;

class operator TFlag.GreaterThan(F1, F2: TFlag): Boolean;
begin Result := F1.FBits > F2.FBits; end;

class operator TFlag.Equal(F1, F2: TFlag): Boolean;
begin Result := F1.FBits = F2.FBits; end;

var a, b: TFlag;
begin
  a.FBits := 7; b.FBits := 3;
  WriteLn('add = ', (a + b).FBits);        // add = 10
  WriteLn('sub = ', (a - b).FBits);        // sub = 4
  WriteLn('mul = ', (a * b).FBits);        // mul = 21
  WriteLn('div = ', (a div b).FBits);      // div = 2
  WriteLn('mod = ', (a mod b).FBits);      // mod = 1
  WriteLn('and = ', (a and b).FBits);      // and = 3
  WriteLn('or  = ', (a or b).FBits);       // or  = 7
  WriteLn('xor = ', (a xor b).FBits);      // xor = 4
  WriteLn('shl = ', (a shl 2).FBits);      // shl = 28
  WriteLn('shr = ', (b shr 1).FBits);      // shr = 1
  WriteLn('lt  = ', a < b);                // lt  = False
  WriteLn('gt  = ', a > b);                // gt  = True
  WriteLn('eq  = ', a = b);                // eq  = False
end.
