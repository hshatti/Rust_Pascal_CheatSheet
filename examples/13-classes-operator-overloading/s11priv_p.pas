{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s11priv_p;

type
  TBox = class
  private
    FVal: Integer;
  public
    function Get: Integer;
  end;

function TBox.Get: Integer;
begin
  Result := FVal;
end;

var
  b: TBox;
begin
  WriteLn(b.FVal);   // EXPECTED COMPILE ERROR — class private IS enforced (unlike records)
end.
