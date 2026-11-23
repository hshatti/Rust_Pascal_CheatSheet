{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
{$asmmode intel}   // FPC x86_64 defaults to AT&T syntax — switch to Intel (Delphi's default)
program s8asm_p;

function Add(a, b: Int64): Integer; assembler;   // pure-assembly function — `assembler` keyword + asm block
asm
  mov rax, a
  add rax, b
end;

begin
  WriteLn('asm add = ', Add(20, 22));   // asm add = 42
end.
