{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s12combo_p;

uses SysUtils;

procedure Boom;
begin
  raise Exception.Create('boom');
end;

begin
  try
    WriteLn('work');
    Boom;
  except
    on E: Exception do WriteLn('except caught: ', E.Message);
  finally
    WriteLn('cleanup');
  end;
end.
