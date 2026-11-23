{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s11loop_p;

var
  i, Sum: Integer;
begin
  // for up (inclusive) — sum of 1..5
  Sum := 0;
  for i := 1 to 5 do Inc(Sum, i);           // 1+2+3+4+5 = 15
  WriteLn('for up = ', Sum);                // for up = 15

  // downto
  for i := 3 downto 1 do Write(i, ' ');     // 3 2 1
  WriteLn;

  // while (pre-test)
  i := 0;
  while i < 3 do Inc(i);                    // 3
  WriteLn('while = ', i);                   // while = 3

  // repeat-until (post-test: body runs at least once)
  i := 0;
  repeat Inc(i); until i >= 2;              // 2
  WriteLn('repeat = ', i);                  // repeat = 2

  // break / continue
  for i := 1 to 5 do begin
    if i = 3 then Break;                    // stop at 3
    if Odd(i) then Continue;                // skip odds
    Write(i, ' ');                          // only 2 is printed
  end;
  WriteLn;                                  // "2"
end.
