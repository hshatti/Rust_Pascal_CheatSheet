{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s4_p;

var
  x: Integer;      // mutable by default — all Pascal variables are
  u: Integer;      // declared, never assigned: value undefined until written (no compile error)
begin
  x := 10;         // assignment (:=)
  WriteLn('x = ', x);            // x = 10
  x := x + 5;                    // in-place reassignment (Delphi has no += operator)
  WriteLn('x now = ', x);        // x now = 15
  Dec(x, 3);                     // built-in decrement procedure
  WriteLn('after dec = ', x);    // after dec = 12
end.
