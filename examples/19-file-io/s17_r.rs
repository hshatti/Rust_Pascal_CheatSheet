use std::fs::{self, File, OpenOptions};
use std::io::{BufRead, BufReader, Read, Seek, SeekFrom, Write};
use std::path::Path;

fn main() {
    // --- check existing file/dir ---
    let _ = fs::remove_file("s17_typed.dat");   // clean state (DeleteFile)
    println!("exists before = {}", Path::new("s17_typed.dat").exists());   // false
    fs::create_dir_all("s17dir").unwrap();     // CreateDir equivalent
    println!("dir exists = {}", Path::new("s17dir").is_dir());            // true

    // --- typed file equivalent: fixed-size records via write_all / read_exact ---
    let mut f = File::create("s17_typed.dat").unwrap();   // rewrite (create + truncate)
    let recs: [(i32, i32); 2] = [(10, 20), (30, 40)];     // two TPoint records
    for (x, y) in recs {                                   // Write(F, P): 8 bytes per record
        f.write_all(&x.to_le_bytes()).unwrap();
        f.write_all(&y.to_le_bytes()).unwrap();
    }
    drop(f);                                              // CloseFile

    let mut f = File::open("s17_typed.dat").unwrap();     // reset (open existing for reading)
    println!("bof after open = {}", f.stream_position().unwrap() == 0);   // true — BOF(F)
    let mut buf = [0u8; 8];
    f.read_exact(&mut buf).unwrap();                       // Read(F, P): whole record #1
    println!("typed first = {},{}", i32::from_le_bytes(buf[0..4].try_into().unwrap()), i32::from_le_bytes(buf[4..8].try_into().unwrap()));   // 10,20
    f.seek(SeekFrom::Start(8)).unwrap();                  // Seek(F, 1): record #2
    let mut buf = [0u8; 8];
    f.read_exact(&mut buf).unwrap();
    println!("typed second = {},{}", i32::from_le_bytes(buf[0..4].try_into().unwrap()), i32::from_le_bytes(buf[4..8].try_into().unwrap()));   // 30,40
    drop(f);

    // --- truncate to current position (Truncate(F) equivalent) ---
    let mut f = OpenOptions::new().read(true).write(true).open("s17_typed.dat").unwrap();
    f.seek(SeekFrom::Start(8)).unwrap();                  // position after first record
    f.set_len(8).unwrap();                                // Truncate(F) equivalent: discard from here on
    drop(f);
    println!("after truncate = {}", fs::metadata("s17_typed.dat").unwrap().len());   // 8

    // --- untyped file: blockwrite / blockread equivalents (raw bytes) ---
    let mut f = File::create("s17_untyped.bin").unwrap();
    let rec: [u8; 8] = [10, 0, 0, 0, 20, 0, 0, 0];       // TPoint {X=10,Y=20} as raw bytes
    f.write_all(&rec).unwrap();                           // BlockWrite(U, P, SizeOf(P)) equivalent
    drop(f);
    let mut f = File::open("s17_untyped.bin").unwrap();
    let mut buf = [0u8; 8];
    let n = f.read(&mut buf).unwrap();                    // BlockRead equivalent: returns bytes actually read
    println!("untyped = {},{} ({} bytes)", i32::from_le_bytes(buf[0..4].try_into().unwrap()), i32::from_le_bytes(buf[4..8].try_into().unwrap()), n);   // 10,20 (8 bytes)

    // --- EOF equivalent: read returns 0 at end of file ---
    let mut f = File::open("s17_untyped.bin").unwrap();
    let mut all = Vec::new();
    f.read_to_end(&mut all).unwrap();                     // consume to end (8 bytes)
    println!("read to end = {} bytes", all.len());        // 8
    println!("eof read n = {}", f.read(&mut [0u8; 1]).unwrap());   // 0 — this is EOF(F) = True

    // --- textfile equivalent: writeln / lines (ReadLn loop) ---
    let mut f = File::create("s17_text.txt").unwrap();    // rewrite(TF)
    writeln!(f, "line one").unwrap();                     // WriteLn(TF, ...)
    writeln!(f, "line two").unwrap();
    drop(f);

    let r = BufReader::new(File::open("s17_text.txt").unwrap());   // reset(TF) + while not EOF do ReadLn
    for line in r.lines() {
        println!("text: {}", line.unwrap());
    }

    // --- append (Append(TF) equivalent) ---
    let mut f = OpenOptions::new().append(true).open("s17_text.txt").unwrap();
    writeln!(f, "line three").unwrap();
    drop(f);
    let r = BufReader::new(File::open("s17_text.txt").unwrap());
    for line in r.lines() {
        let l = line.unwrap();
        if l == "line three" { println!("append ok: {}", l); }
    }

    // --- TFileStream equivalent: File with size/position semantics ---
    let mut f = OpenOptions::new().read(true).write(true).create(true).truncate(true)
        .open("s17_stream.bin").unwrap();                 // TFileStream.Create(name, fmCreate) equivalent (read+write)
    f.write_all(b"hello stream").unwrap();                // FS.Write(S[1], Length(S))
    println!("stream size = {}", f.metadata().unwrap().len());   // 12 — FS.Size
    f.seek(SeekFrom::Start(0)).unwrap();                  // FS.Position := 0
    let mut buf = [0u8; 5];
    f.read_exact(&mut buf).unwrap();                      // FS.Read(S[1], 5)
    println!("stream read: {}", String::from_utf8(buf.to_vec()).unwrap());   // hello
    f.set_len(3).unwrap();                                // FS.Size := 3 (truncate)
    println!("after truncate = {}", f.metadata().unwrap().len());   // 3

    // --- I/O error handling: Result instead of exceptions / IOResult ---
    match File::open("s17_missing.txt") {                 // Reset(TF) on nonexistent file
        Ok(_) => println!("unexpected open ok"),
        Err(e) => println!("iocheck off equivalent: kind = {:?}", e.kind()),   // NotFound
    }

    // --- TSearchRec equivalent: read_dir (no wildcards in std — filter manually) ---
    for entry in fs::read_dir(".").unwrap() {             // FindFirst/FindNext equivalent
        let entry = entry.unwrap();
        let name = entry.file_name().to_string_lossy().into_owned();
        if name.starts_with("s17_") && name.ends_with(".dat") {   // 's17_*.dat' pattern, by hand
            println!("found: {} ({} bytes)", name, entry.metadata().unwrap().len());
        }
    }

    // --- shared vs exclusive: no std API — files open fully shared by default on Windows ---
}
