{$ifdef FPC}
  {$mode delphi}
  {$modeswitch advancedrecords}
  {$modeswitch typehelpers}
  {$modeswitch nestedprocvars}
{$endif}
{$pointermath on}
{$H+}
program s17_p;

uses SysUtils, Classes;   // TFileStream: Delphi System / FPC Classes

type
  TPoint = record
    X, Y: Integer;
  end;

var
  F: file of TPoint;       // typed file
  U: file;                 // untyped file
  TF: textfile;
  S: string;
  P: TPoint;
  N: LongWord;
  IOCode: Integer;
  SR: TSearchRec;
  FS: TFileStream;
begin
  // --- check existing file/dir ---
  DeleteFile('s17_typed.dat');
  WriteLn('exists before = ', FileExists('s17_typed.dat'));   // False
  if not DirectoryExists('s17dir') then CreateDir('s17dir');
  WriteLn('dir exists = ', DirectoryExists('s17dir'));        // True

  // --- typed file: assignfile / rewrite / write / reset / read / seek / eof ---
  AssignFile(F, 's17_typed.dat');    // bind name to the file variable (Delphi idiom)
  Rewrite(F);                        // create + truncate, open for writing
  P.X := 10; P.Y := 20; Write(F, P);
  P.X := 30; P.Y := 40; Write(F, P);
  CloseFile(F);

  Reset(F);                          // open existing file for reading
  // (BOF is Delphi-only — not in FPC; Rust side verifies position-at-start instead)
  Read(F, P);
  WriteLn('typed first = ', P.X, ',', P.Y);      // 10,20
  Seek(F, 1);                        // move to record #2
  Read(F, P);
  WriteLn('typed second = ', P.X, ',', P.Y);     // 30,40
  WriteLn('eof at end = ', EOF(F));              // True (past last record)
  CloseFile(F);

  // --- truncate to current position ---
  Reset(F);
  Seek(F, 1);                        // position after first record (8 bytes)
  Truncate(F);                       // discard everything from here on
  CloseFile(F);
  FS := TFileStream.Create('s17_typed.dat', fmOpenRead);     // size check (FPC FileSize takes a file var, not a name)
  WriteLn('after truncate = ', FS.Size);                      // 8
  FreeAndNil(FS);

  // --- untyped file: blockwrite / blockread ---
  AssignFile(U, 's17_untyped.bin');
  Rewrite(U);
  P.X := 10; P.Y := 20;
  BlockWrite(U, P, SizeOf(P));       // raw 8-byte write
  CloseFile(U);
  Reset(U);
  BlockRead(U, P, SizeOf(P), N);     // raw read, N = bytes actually read
  WriteLn('untyped = ', P.X, ',', P.Y, ' (', N, ' bytes)');   // 10,20 (8 bytes)
  CloseFile(U);

  // --- textfile: rewrite / writeln / reset / readln / append ---
  AssignFile(TF, 's17_text.txt');
  Rewrite(TF);
  WriteLn(TF, 'line one');
  WriteLn(TF, 'line two');
  CloseFile(TF);
  Reset(TF);
  while not EOF(TF) do begin
    ReadLn(TF, S);
    WriteLn('text: ', S);
  end;
  CloseFile(TF);

  Append(TF);                        // open existing text file at the end
  WriteLn(TF, 'line three');
  CloseFile(TF);
  Reset(TF);
  while not EOF(TF) do begin
    ReadLn(TF, S);
    if S = 'line three' then WriteLn('append ok: ', S);
  end;
  CloseFile(TF);

  // --- TFileStream: create / write / position / read / size (truncate) ---
  FS := TFileStream.Create('s17_stream.bin', fmCreate);   // create/truncate, open for writing
  S := 'hello stream';
  FS.Write(S[1], Length(S));
  WriteLn('stream size = ', FS.Size);                       // 12
  FS.Position := 0;                                         // rewind
  SetLength(S, 5);
  FS.Read(S[1], 5);
  WriteLn('stream read: ', S);                              // hello
  FS.Size := 3;                                             // truncate to 3 bytes
  WriteLn('after truncate = ', FS.Size);                    // 3
  FreeAndNil(FS);

  // --- I/O error handling: default {$IOCHECKS ON} raises ---
  try
    AssignFile(TF, 's17_missing.txt');
    Reset(TF);                       // should raise (file not found)
    CloseFile(TF);
    WriteLn('unexpected open ok');
  except
    on E: Exception do WriteLn('iocheck on raises: ', E.ClassName);   // EInOutError
  end;

  // --- I/O error handling: {$IOCHECKS OFF} + IOResult ---
  AssignFile(TF, 's17_missing.txt');
  {$I-}
  Reset(TF);
  IOCode := IOResult;                // read + clear immediately (documented pattern)
  {$I+}
  if IOCode <> 0 then WriteLn('iocheck off: IOResult = ', IOCode)   // 102 (file not found)
  else begin CloseFile(TF); WriteLn('unexpected open ok'); end;

  // --- shared vs exclusive access ---
  FS := TFileStream.Create('s17_share.bin', fmCreate);   // default share (Delphi/Windows: effectively exclusive)
  try
    TFileStream.Create('s17_share.bin', fmOpenRead).Free;  // second open while first is held
    WriteLn('second open = ok');
  except
    on E: Exception do WriteLn('second open denied: ', E.ClassName);
  end;
  FreeAndNil(FS);

  FS := TFileStream.Create('s17_share.bin', fmCreate or fmShareDenyNone);   // explicit sharing allowed
  try
    TFileStream.Create('s17_share.bin', fmOpenRead).Free;
    WriteLn('deny-none second open = ok');
  except
    on E: Exception do WriteLn('deny-none second open denied: ', E.ClassName);
  end;
  FreeAndNil(FS);

  // --- TSearchRec: find files matching a pattern ---
  if FindFirst('s17_*.dat', faAnyFile, SR) = 0 then begin
    while True do begin
      WriteLn('found: ', SR.Name, ' (', SR.Size, ' bytes)');
      if FindNext(SR) <> 0 then Break;
    end;
    FindClose(SR);
  end;
end.
