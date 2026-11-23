{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s10priv_p;

type
  TBox = record
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
  WriteLn(b.FVal);   // EXPECTED COMPILE ERROR — private field accessed outside the type
end.
