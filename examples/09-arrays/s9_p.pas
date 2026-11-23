{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
  {$RANGECHECKS ON}
{$endif}
{$pointermath on}
{$H+}
program s9_p;

uses SysUtils;

var
  a: array[0..3] of Integer;      // static array (zero-initialized in Delphi)
  b: array[1..4] of Integer;      // custom index range — allowed in Delphi, not in Rust
  d: array of Integer;            // dynamic array
  i, j: Integer;
begin
  WriteLn('static init = ', a[0], ',', a[3]);   // static init = 0,0

  for i := Low(b) to High(b) do b[i] := i * 10;
  WriteLn('b range = ', b[Low(b)], '..', b[High(b)]); // b range = 10..40 (indices 1..4!)

  SetLength(d, 3);               // [0, 0, 0]
  d[0] := 10; d[1] := 20; d[2] := 30;
  WriteLn('dyn = ', d[0], ',', d[1], ',', d[2]);   // dyn = 10,20,30

  SetLength(d, Length(d) + 1);   // append idiom: grow, then write the new slot
  d[High(d)] := 40;
  WriteLn('after append len = ', Length(d), ' last = ', d[High(d)]); // after append len = 4 last = 40

  WriteLn('popped value = ', d[High(d)]);   // popped value = 40 (must read before shrinking)
  SetLength(d, Length(d) - 1);              // remove-last idiom — the value is lost
  WriteLn('after pop len = ', Length(d));   // after pop len = 3

  // Unsafe equivalent: raw pointer arithmetic with range checks OFF — no check at all
  {$RANGECHECKS OFF}
  i := PInteger(@d[0])[1];
  {$RANGECHECKS ON}
  WriteLn('raw ptr read = ', i);            // raw ptr read = 20

  // Insert in the middle: no built-in — grow and shift manually
  SetLength(d, Length(d) + 1);
  for i := High(d) downto 1 do d[i] := d[i - 1];
  d[1] := 99;
  WriteLn('after insert = ', d[0], ',', d[1], ',', d[2], ',', d[3]); // after insert = 10,99,20,30

  // Out-of-range access with range checks on -> raises ERangeError (runtime index; a constant would be a compile error)
  i := 5;
  try
    j := a[i];
    WriteLn('oob caught = False');
  except on E: Exception do
    WriteLn('oob caught = True');
  end;
end.
