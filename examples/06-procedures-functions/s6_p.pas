{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s6_p;

procedure Greet(name: string);          // procedure — no return value
begin
  WriteLn('Hello, ', name);            // Hello, World
end;

function Add(a, b: Integer): Integer;  // function — explicit Result assignment
begin
  Result := a + b;
end;

procedure WithLocal;                   // local variable declared before any statement
var
  x: Integer;
begin
  x := 5;
  WriteLn('local = ', x);              // local = 5
end;

procedure Outer;                       // nested procedure declaration
  procedure Inner;
  begin
    WriteLn('inner ran');              // inner ran
  end;
begin
  Inner;
end;

procedure A;                           // mutual recursion requires a forward declaration
forward;

procedure B;
begin
  WriteLn('b calls a');                // b calls a
  A;
end;

procedure A;
begin
  WriteLn('a ran (from b)');           // a ran (from b)
end;

procedure WithDefault(x: Integer = 10); // default parameter value
begin
  WriteLn('default x = ', x);          // default x = ...
end;

begin
  Greet('World');
  WriteLn('add = ', Add(2, 3));        // add = 5
  WithLocal;
  Outer;
  B;
  WithDefault;                         // uses the default: default x = 10
  WithDefault(99);                     // explicit value: default x = 99
end.
