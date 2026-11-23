{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s12flow_p;

var
  x: Integer;
  Grade: string;
begin
  x := 75;

  // if-then-else chain (statement form)
  if x >= 90 then WriteLn('grade = A')
  else if x >= 80 then WriteLn('grade = B')
  else if x >= 70 then WriteLn('grade = C')   // <- this one fires
  else WriteLn('grade = F');

  // case: value lists, ranges, else
  case x div 10 of
    9, 10: Grade := 'A';
    8:     Grade := 'B';
    5..7:  Grade := 'C';      // range form — fires for 75
    else   Grade := 'F';
  end;
  WriteLn('case = ', Grade);  // case = C
end.
