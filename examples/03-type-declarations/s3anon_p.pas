{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s3anon_p;

type
  TAnonFunc = reference to function(x: Integer): Integer; // anonymous method (Delphi feature)

var
  af: TAnonFunc;
  off: Integer;
begin
  off := 10;
  af := function(x: Integer): Integer
  begin
    Result := x + off;   // captures `off` from the enclosing scope
  end;
  WriteLn('closure(1) = ', af(1));   // closure(1) = 11
end.
