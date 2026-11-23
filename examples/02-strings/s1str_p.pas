{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s1str_p;

var
  u: UnicodeString;
  t: UTF8String;
  a: AnsiString;
  p: PAnsiChar;
  pw: PWideChar;
begin
  // --- UTF8String conversion (implicit in Delphi) ---
  u := UTF8Decode('caf' + #$C3 + #$A9);    // 'cafe'+acute, built from explicit UTF-8 bytes
  t := u;                                   // implicit Unicode -> UTF-8
  WriteLn('utf8 len = ', Length(t));        // expect: utf8 len = 5
  u := t;                                   // implicit UTF-8 -> Unicode
  WriteLn('back to utf16 len = ', Length(u)); // expect: back to utf16 len = 4

  // --- PAnsiChar: pointer into AnsiString buffer ---
  a := 'Hello';
  p := PAnsiChar(a);                        // cast suffices in Pascal
  WriteLn('first ansi char ord = ', Ord(p^)); // expect: first ansi char ord = 72
  a := '';
  a := p;                                   // implicit copy-until-NUL from pointer
  WriteLn('copied from pointer: ', a, ' (len ', Length(a), ')');

  // --- PWideChar: pointer into wide string buffer ---
  pw := PWideChar(u);                       // in Delphi: valid since string = UnicodeString
  WriteLn('first wide unit ord = ', Ord(pw^)); // expect: first wide unit ord = 99
end.
