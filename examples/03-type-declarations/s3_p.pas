{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
  {$RANGECHECKS ON}
{$endif}
{$pointermath on}
{$H+}
program s3_p;

uses SysUtils;

type
  MyInt = Integer;                          // alias
  TColor = (clRed, clGreen, clBlue);        // enumerated type
  TRange = 1..10;                           // subrange type
  TColors = set of TColor;                  // set of enum values
  PInt = ^Integer;                          // pointer type
  TPoint = record                           // basic record
    X, Y: Integer;
  end;
  TFunc = function(x: Integer): Integer;    // procedural type (no capture)
  // NOTE: `reference to function` (anonymous methods) is Delphi-only — FPC does not implement it.

  TBox<T> = class                           // generic type declaration
  public
    Value: T;
  end;

function AddOne(x: Integer): Integer;
begin
  Result := x + 1;
end;

var
  b: TBox<Integer>;
  mi: MyInt;
  c: TColor;
  r: TRange;
  cs: TColors;
  p: PInt;
  i: Integer;
  pt: TPoint;
  f: TFunc;

begin
  // alias
  mi := 42;
  WriteLn('alias = ', mi);                    // alias = 42

  // enumerated type (implicit ordinals from 0)
  c := clGreen;
  WriteLn('ord clGreen = ', Ord(c));          // ord clGreen = 1
  c := TColor(2);                             // integer -> enum cast
  WriteLn('cast back = ', c);                 // cast back = clBlue

  // subrange type (runtime out-of-range assignment raises)
  r := 5;
  WriteLn('subrange = ', r);                  // subrange = 5
  i := 11;                                    // outside 1..10, from a runtime value
  try
    r := i;
    WriteLn('out-of-range caught = False');
  except on E: Exception do
    WriteLn('out-of-range caught = True');
  end;

  // set of enum values
  cs := [clRed, clBlue];
  Include(cs, clGreen);
  Exclude(cs, clRed);
  WriteLn('has green = ', (clGreen in cs));   // has green = True
  WriteLn('has red = ', (clRed in cs));       // has red = False

  // pointer type
  i := 7;
  p := @i;
  WriteLn('via ptr = ', p^);                  // via ptr = 7
  p^ := 9;
  WriteLn('mutated = ', i);                   // mutated = 9

  // basic record (field-by-field init)
  pt.X := 1;
  pt.Y := 2;
  WriteLn('point = (', pt.X, ', ', pt.Y, ')'); // point = (1, 2)

  // procedural type: plain function pointer
  f := AddOne;
  WriteLn('f(41) = ', f(41));                 // f(41) = 42

  // generic type declaration (Delphi: classes/interfaces only)
  b := TBox<Integer>.Create;
  b.Value := 42;
  WriteLn('box = ', b.Value);                 // box = 42
end.
