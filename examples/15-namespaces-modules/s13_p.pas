{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
program s13_p;

uses S13U;   // ≈ Rust `use` — brings the unit's interface into scope

var
  p: TPoint;
begin
  p := MakePoint(3, 4);          // unqualified name (via uses)
  Show(p);                       // point (3,4)
  WriteLn('qualified: ', S13U.MakePoint(5, 6).X);   // unit-qualified access — namespace path
end.
