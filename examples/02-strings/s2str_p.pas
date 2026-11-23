{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s2str_p;

uses SysUtils;

var
  s: string;
begin
  // Concatenation
  s := 'ab' + 'cd';
  WriteLn('concat = ', s);                       // concat = abcd

  // Copy (1-based start, count)
  s := 'Hello World';
  WriteLn('copy = ', Copy(s, 1, 4));             // copy = Hell

  // Insert at position 6 (before the space)
  s := 'Hello World';
  Insert('!', s, 6);
  WriteLn('insert = ', s);                       // insert = Hello! World

  // Delete 3 chars starting at position 2
  s := 'Hello World';
  Delete(s, 2, 3);
  WriteLn('delete = ', s);                       // delete = Ho World (positions 2..4 removed)

  // Pos: 1-based index or 0 when absent
  s := 'Hello World';
  WriteLn('pos of World = ', Pos('World', s));   // pos of World = 7
  WriteLn('contains xyz = ', (Pos('xyz', s) > 0)); // contains xyz = False

  // Trim / case conversion
  s := '  hi  ';
  WriteLn('trim = [', Trim(s), ']');             // trim = [hi]
  s := 'hello';
  WriteLn('upper = ', UpperCase(s));             // upper = HELLO

  // Int <-> string (StrToInt raises on bad input)
  WriteLn('int to str = ', IntToStr(123));       // int to str = 123
  WriteLn('str to int = ', StrToInt('456'));     // str to int = 456
  try
    StrToInt('abc');
    WriteLn('bad int rejected = False');
  except on E: Exception do
    WriteLn('bad int rejected = True');          // bad int rejected = True
  end;

  // Float <-> string (locale-dependent in Delphi)
  WriteLn('float to str = ', FloatToStr(2.5));   // float to str = 2.5
  WriteLn('str to float = ', StrToFloat('3.75'));// str to float = 3.75

  // Ord / Chr (Chr raises on invalid code)
  WriteLn('ord A = ', Ord('A'));                 // ord A = 65
  WriteLn('chr 66 = ', Chr(66));                 // chr 66 = B

  // Format with % specifiers
  WriteLn(Format('%d %s', [42, 'x']));           // 42 x
end.
