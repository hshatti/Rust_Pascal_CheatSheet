{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s10t3;

type
  TBox = record
    FVal: Integer;
    constructor Create(v: Integer);
  end;

constructor TBox.Create(v: Integer);
begin
  FVal := v;
end;

var box: TBox;
begin
  box := TBox.Create(7);
  WriteLn('t3 = ', box.FVal);   // expect 7
end.
