{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
library extlib;

function AddExt(a, b: Integer): Integer; export;
begin
  Result := a + b;
end;

function SubExt(a, b: Integer): Integer; export;
begin
  Result := a - b;
end;

exports
  AddExt,
  SubExt;

begin
end.
