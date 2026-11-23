{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s7_p;

procedure ShowConst(const x: Integer);   // const parameter — read-only in the callee (modern Delphi syntax)
begin
  WriteLn('const param = ', x);          // const param = 42
end;

procedure ShowValue(x: Integer);         // value parameter (default)
var
  local: Integer;
begin
  local := x + 100;                      // modifying the copy does not affect the caller
  WriteLn('value param = ', x, ' (local was ', local, ')'); // value param = 42 (local was 142)
end;

procedure ModifyVar(var x: Integer);     // var parameter — modifies the caller's variable (modern Delphi syntax)
begin
  Inc(x, 1000);                          // visible to the caller!
end;

procedure ShowStr(s: string);            // managed type "by value" = reference copy (COW)
begin
  WriteLn('callee sees = ', s);          // callee sees = hi
end;

var
  v: Integer;
  ss: string;
begin
  v := 42;
  ShowConst(v);
  WriteLn('v after const = ', v);        // v after const = 42 (unchanged)
  ShowValue(v);
  WriteLn('v after value = ', v);        // v after value = 42 (unchanged)
  ModifyVar(v);
  WriteLn('v after var = ', v);          // v after var = 1042 (modified!)

  ss := 'hi';
  ShowStr(ss);
  WriteLn('ss still usable = ', ss);     // ss still usable = hi (caller's copy unaffected)
end.
