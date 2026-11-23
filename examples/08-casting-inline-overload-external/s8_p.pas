{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s8_p;

type
  TBytes4 = packed record B: array[0..3] of Byte; end;
  TInt4   = packed record I: Integer; end;

function Fast(x: Integer): Integer; inline;   // inline directive — a hint to the compiler
begin
  Result := x * 2 + 1;
end;

function Over(a: Integer): Integer; overload; // overloaded functions (same name)
begin
  Result := a + 1;
end;

function Over(s: string): Integer; overload;
begin
  Result := Length(s);
end;

function AddExt(a, b: Integer): Integer; external 'extlib.dll' name 'AddExt'; // with explicit export name
function SubExt(a, b: Integer): Integer; external 'extlib.dll';               // without name — symbol = local name

var
  p: TBytes4;
  t: TInt4;
begin
  // Casting: float -> int — Delphi requires Trunc/Round (no direct real->int cast)
  WriteLn('trunc = ', Trunc(2.9));            // trunc = 2

  // Casting: reinterpret the same bytes as a different type (typecast)
  p.B[0] := 1; p.B[1] := 2; p.B[2] := 3; p.B[3] := 4;
  t := TInt4(p);                              // byte pattern reinterpreted as an integer
  WriteLn('punned = ', t.I);                  // punned = 67305985 (little-endian 0x04030201)

  WriteLn('fast = ', Fast(20));               // fast = 41

  WriteLn('over int = ', Over(41));           // over int = 42
  WriteLn('over str = ', Over('abc'));        // over str = 3

  WriteLn('add ext = ', AddExt(20, 22));      // add ext = 42 (call into FPC-built DLL)
  WriteLn('sub ext = ', SubExt(50, 8));       // sub ext = 42
end.
