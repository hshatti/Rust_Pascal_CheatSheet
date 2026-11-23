program primtest;
{$mode objfpc}
var
  b   : Byte;
  w   : Word;
  lw  : LongWord;
  si  : ShortInt;
  smi : SmallInt;
  i32v: Integer;
  i64v: Int64;
  q   : QWord;
  s   : Single;
  d   : Double;
  e   : Extended;
  bo  : Boolean;
  c   : AnsiChar;
  wc  : WideChar;
begin
  b := 255; w := 65535; lw := 4294967295;
  si := -128; smi := -32768; i32v := Low(Integer);
  i64v := Low(Int64); q := High(QWord);
  s := 1.5; d := 2.25; e := 3.0;
  bo := True; c := 'A'; wc := 'A';

  WriteLn('Byte     size=', SizeOf(Byte),     ' val=', b);
  WriteLn('Word     size=', SizeOf(Word),     ' val=', w);
  WriteLn('LongWord size=', SizeOf(LongWord), ' val=', lw);
  WriteLn('ShortInt size=', SizeOf(ShortInt), ' val=', si);
  WriteLn('SmallInt size=', SizeOf(SmallInt), ' val=', smi);
  WriteLn('Integer  size=', SizeOf(Integer),  ' min=', i32v, ' max=', High(Integer));
  WriteLn('Int64    size=', SizeOf(Int64),    ' min=', i64v, ' max=', High(Int64));
  WriteLn('QWord    size=', SizeOf(QWord),    ' val=', q);
  WriteLn('Single   size=', SizeOf(Single),   ' val=', s);
  WriteLn('Double   size=', SizeOf(Double),   ' val=', d);
  WriteLn('Extended size=', SizeOf(Extended), ' val=', e, ' [no Rust std equivalent]');
  WriteLn('Boolean  size=', SizeOf(Boolean),  ' val=', Ord(bo));
  WriteLn('AnsiChar size=', SizeOf(AnsiChar), ' ord=', Ord(c));
  WriteLn('WideChar size=', SizeOf(WideChar), ' ord=', Ord(wc));
end.
