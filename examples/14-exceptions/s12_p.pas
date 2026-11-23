{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s12_p;

uses SysUtils;   // FPC: Exception lives here (Delphi: System, always available)

type
  EMyError = class(Exception);   // custom exception class ↔ Rust error type

procedure DoWork(AIndex: Integer);
begin
  if AIndex < 0 then raise EMyError.Create('negative index');
end;

begin
  // 1. typed catch — `on E: EMyError` matches the exception class (and descendants)
  try
    DoWork(-1);
  except
    on E: EMyError do WriteLn('caught custom: ', E.Message);
    on E: Exception do WriteLn('caught generic: ', E.Message);   // fallback handler
  end;

  // 2. finally — always runs, even when an exception is raised inside the try
  // (FPC: except and finally are separate statements — nest them; Delphi also allows one combined statement)
  try
    try
      WriteLn('work');
      DoWork(-3);
    except
      on E: Exception do WriteLn('except caught: ', E.Message);
    end;
  finally
    WriteLn('cleanup');
  end;

  // 3. re-raise — bare `raise` inside an except handler forwards the same exception
  try
    try
      DoWork(-2);
    except
      on E: Exception do begin
        WriteLn('inner caught: ', E.Message);
        raise;   // re-raise → propagates to the outer handler below
      end;
    end;
  except
    on E: Exception do WriteLn('outer caught: ', E.Message);
  end;
end.
