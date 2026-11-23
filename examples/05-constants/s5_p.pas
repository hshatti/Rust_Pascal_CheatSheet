{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s5_p;

uses SysUtils;

type
  TColor = (clRed, clGreen, clBlue);
  TPoint = record X, Y: Integer; end;

const
  N = 10;                              // untyped constant — no type annotation
  GREETING = 'Hello';                  // untyped string constant
  MAX_SIZE: Integer = 100;             // typed constant (explicit type)
  DEFAULT_COLOR: TColor = clGreen;     // typed constant of enum type
  ORIGIN: TPoint = (X: 0; Y: 0);       // typed constant of record type (fields separated by ;)

var
  i: Integer;
  d: Double;
begin
  i := N;                              // integer context
  WriteLn('i = ', i);                  // i = 10
  d := N * 2.5;                        // float context — untyped const converts implicitly
  WriteLn(Format('d = %.1f', [d]));    // d = 25.0

  WriteLn('greeting = ', GREETING);    // greeting = Hello

  WriteLn('max size = ', MAX_SIZE);    // max size = 100
  WriteLn('default color = ', DEFAULT_COLOR); // default color = clGreen
  WriteLn('origin = (', ORIGIN.X, ', ', ORIGIN.Y, ')'); // origin = (0, 0)

  WriteLn('const has address = ', @MAX_SIZE <> nil); // const has address = True
end.
