{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
program s16_p;

uses Classes, SysUtils, SyncObjs;   // FPC: TThread in Classes (Delphi: System); Sleep in SysUtils (Delphi: Windows)

type
  TIncThread = class(TThread)
    procedure Execute; override;
  end;
  TMonThread = class(TThread)
    procedure Execute; override;
  end;
  TWaiter = class(TThread)
  private
    FEvent: TEvent;
  public
    constructor Create(AEvent: TEvent);
    procedure Execute; override;
  end;

var
  Counter: Integer;   // touched only via Interlocked* (atomic)
  Plain: Integer;     // touched only under Lock
  Lock: TCriticalSection;   // FPC name for Delphi's TMonitor — same Acquire/Release API

procedure TIncThread.Execute;
var i: Integer;
begin
  for i := 1 to 100000 do InterlockedIncrement(Counter);
end;

procedure TMonThread.Execute;
var i: Integer;
begin
  for i := 1 to 50000 do begin
    Lock.Acquire;
    Inc(Plain);
    Lock.Release;
  end;
end;

constructor TWaiter.Create(AEvent: TEvent);
begin
  inherited Create(False);
  FEvent := AEvent;
end;

procedure TWaiter.Execute;
begin
  FEvent.WaitFor(INFINITE);   // blocks until signaled (sheet's Delphi dialect: WaitForSingleObject(E.Handle, INFINITE))
  WriteLn('event signaled');
end;

var
  i: Integer;
  Threads: array[1..4] of TThread;
  E: TEvent;
  W: TWaiter;
begin
  // --- interlocked ops (single-threaded semantics) ---
  InterlockedIncrement(Counter);                              // 0 -> 1
  WriteLn('after inc = ', Counter);                           // after inc = 1
  WriteLn('exchange ret = ', InterlockedExchange(Counter, 5));// returns old value: 1
  WriteLn('after exchange = ', Counter);                      // after exchange = 5
  if InterlockedCompareExchange(Counter, 9, 5) = 5 then      // CAS: 5 -> 9
    WriteLn('cas ok');                                        // cas ok

  // --- multi-threaded with interlocked ops (wiki pattern: Start / WaitFor / Free, no FreeOnTerminate) ---
  for i := 1 to 4 do Threads[i] := TIncThread.Create(False);
  for i := 1 to 4 do Threads[i].Start;
  for i := 1 to 4 do begin
    Threads[i].WaitFor;
    Threads[i].Free;
  end;
  WriteLn('atomic total = ', Counter);                        // atomic total = 400009

  // --- TMonitor critical section around non-atomic state ---
  Lock := TCriticalSection.Create;
  try
    for i := 1 to 2 do Threads[i] := TMonThread.Create(False);
    for i := 1 to 2 do Threads[i].Start;
    for i := 1 to 2 do begin
      Threads[i].WaitFor;
      Threads[i].Free;
    end;
    WriteLn('monitored total = ', Plain);                     // monitored total = 100000
  finally
    Lock.Free;
  end;

  // --- TEvent: worker blocks until main signals it ---
  E := TEvent.Create(nil, False, False, '');                  // auto-reset, initially non-signaled
  W := TWaiter.Create(E);
  W.Start;
  TThread.Sleep(200);                                         // let the worker reach its wait
  E.SetEvent;                                                 // release the waiter (sheet's Delphi dialect: SetEvent(E.Handle))
  W.WaitFor;
  W.Free;
  E.Free;
end.
