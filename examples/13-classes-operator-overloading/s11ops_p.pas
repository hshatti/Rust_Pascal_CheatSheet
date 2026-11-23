{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s11ops_p;

type
  TFlag = record
    FBits: Integer;
    class operator Negative(F: TFlag): TFlag;   // unary minus (FPC Delphi-mode name per docs)
    class operator LogicalNot(F: TFlag): TFlag; // bitwise NOT (FPC Delphi-mode name per docs)
  end;

class operator TFlag.Negative(F: TFlag): TFlag;
begin
  Result.FBits := -F.FBits;
end;

class operator TFlag.LogicalNot(F: TFlag): TFlag;
begin
  Result.FBits := not F.FBits;
end;

var f: TFlag;
begin
  f.FBits := 5;
  WriteLn('neg = ', (-f).FBits);      // neg = -5
  WriteLn('not = ', (not f).FBits);   // not = -6
end.
