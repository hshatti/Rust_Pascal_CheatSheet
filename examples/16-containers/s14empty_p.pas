{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
program s14empty_p;

uses SysUtils, Generics.Collections;

var
  Q: TQueue<Integer>;
begin
  Q := TQueue<Integer>.Create;
  try
    try
      WriteLn(Q.Dequeue);   // empty queue — what happens?
    except
      on E: Exception do WriteLn('raised: ', E.ClassName, ': ', E.Message);
    end;
  finally
    Q.Free;
  end;
end.
