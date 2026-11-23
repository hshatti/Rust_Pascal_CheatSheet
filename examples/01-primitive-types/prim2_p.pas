program prim2test;
{$mode objfpc}
var
  bo   : Boolean;
  si   : ShortInt;
  b    : Byte;
  smi  : SmallInt;
  w    : Word;
  li   : LongInt;
  lw   : LongWord;
  i64v : Int64;
  q    : QWord;
  s    : Single;
  d    : Double;
  ans  : AnsiString;
  us   : UnicodeString; { Delphi's `string` is this type }
  ws   : WideString;
  rbs  : RawByteString;
begin
  bo := True; si := -128; b := 255; smi := -32768; w := 65535;
  li := Low(LongInt); lw := High(LongWord); i64v := Low(Int64); q := High(QWord);
  s := 1.5; d := 2.25;

  ans := 'Hello';
  us  := WideChar($D83D) + WideChar($DE00); { U+1F600 as explicit surrogate pair }
  ws  := #$E9;           { é = U+00E9, one UTF-16 unit }
  rbs := 'AB';

  WriteLn('Boolean   val=', Ord(bo));
  WriteLn('ShortInt  min=', si);
  WriteLn('Byte      max=', b);
  WriteLn('SmallInt  min=', smi);
  WriteLn('Word      max=', w);
  WriteLn('LongInt   size=', SizeOf(LongInt), ' min=', li, ' max=', High(LongInt));
  WriteLn('LongWord  size=', SizeOf(LongWord), ' max=', lw);
  WriteLn('Int64     size=', SizeOf(Int64), ' min=', i64v, ' max=', High(Int64));
  WriteLn('QWord     size=', SizeOf(QWord), ' max=', q);
  WriteLn('Single    size=', SizeOf(Single), ' val=', s);
  WriteLn('Double    size=', SizeOf(Double), ' val=', d);

  WriteLn('AnsiString len=', Length(ans));
  WriteLn('string(UTF16) emoji units=', Length(us));
  WriteLn('WideString elemSize=2 units=', Length(ws));
  WriteLn('RawByteString len=', Length(rbs), ' byte0=', Ord(rbs[1]));
end.
