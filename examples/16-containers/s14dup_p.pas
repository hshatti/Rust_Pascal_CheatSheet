{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
program s14dup_p;

uses SysUtils, Generics.Collections;

var
  D: TDictionary<String, Integer>;
begin
  D := TDictionary<String, Integer>.Create;
  try
    D.Add('a', 1);
    try
      D.Add('a', 2);   // duplicate key — what happens?
      WriteLn('no exception');
    except
      on E: Exception do WriteLn('raised: ', E.ClassName, ': ', E.Message);
    end;
  finally
    D.Free;
  end;
end.
