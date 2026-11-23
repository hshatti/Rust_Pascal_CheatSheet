{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s11priv2_p;

uses S11PrivU;

var
  b: TBox;
begin
  WriteLn(b.FVal);   // EXPECTED COMPILE ERROR if class privacy is enforced cross-unit
end.
