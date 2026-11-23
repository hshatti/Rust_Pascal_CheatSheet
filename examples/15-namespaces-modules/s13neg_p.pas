{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
program s13neg_p;

uses S13U;

begin
  WriteLn(HiddenHelper(21));   // NEGATIVE TEST: implementation-only function — must NOT compile
end.
