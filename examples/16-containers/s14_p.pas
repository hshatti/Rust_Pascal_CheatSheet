{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
program s14_p;

uses SysUtils, Generics.Collections;

var
  L: TList<Integer>;
  D: TDictionary<String, Integer>;
  S: THashSet<Integer>;   // FPC name for Delphi's TSet<T> (same API family)
  Q: TQueue<Integer>;
  St: TStack<Integer>;
begin
  // TList ↔ Vec
  L := TList<Integer>.Create;
  try
    L.Add(10); L.Add(20); L.Add(30);
    WriteLn('list count = ', L.Count);                    // list count = 3
    WriteLn('list[1] = ', L[1]);                          // list[1] = 20
    L.Delete(0);
    WriteLn('after delete: ', L[0], ' count=', L.Count);  // after delete: 20 count=2
  finally
    L.Free;
  end;

  // TDictionary ↔ HashMap/BTreeMap
  D := TDictionary<String, Integer>.Create;
  try
    D.Add('a', 1); D.Add('b', 2);
    WriteLn('dict a = ', D['a']);                          // dict a = 1
    WriteLn('contains c = ', D.ContainsKey('c'));          // contains c = False
    D.Remove('a');
    WriteLn('after remove count = ', D.Count);             // after remove count = 1
  finally
    D.Free;
  end;

  // TSet ↔ BTreeSet/HashSet (FPC: THashSet)
  S := THashSet<Integer>.Create;
  try
    S.Add(1); S.Add(2); S.Add(3); S.Add(2);   // duplicate ignored
    WriteLn('set count = ', S.Count);          // set count = 3
    WriteLn('has 2 = ', S.Contains(2));        // has 2 = True
    S.Remove(1);                               // Delphi: Exclude(1)
    WriteLn('after remove: has 1 = ', S.Contains(1), ' count=', S.Count);
  finally
    S.Free;
  end;

  // TQueue ↔ VecDeque (FIFO)
  Q := TQueue<Integer>.Create;
  try
    Q.Enqueue(1); Q.Enqueue(2);
    WriteLn('queue front = ', Q.Dequeue);      // queue front = 1
  finally
    Q.Free;
  end;

  // TStack ↔ Vec push/pop (LIFO)
  St := TStack<Integer>.Create;
  try
    St.Push(1); St.Push(2);
    WriteLn('stack top = ', St.Pop);           // stack top = 2
  finally
    St.Free;
  end;
end.
