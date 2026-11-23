fn main() {
    let bo: bool = true;
    let si: i8 = -128;
    let b: u8 = 255;
    let smi: i16 = -32768;
    let w: u16 = 65535;
    let li: i32 = i32::MIN;
    let lw: u32 = u32::MAX;
    let i64v: i64 = i64::MIN;
    let q: u64 = u64::MAX;
    let s: f32 = 1.5;
    let d: f64 = 2.25;

    let as_bytes: Vec<u8> = b"Hello".to_vec();
    let us: String = "\u{1F600}".into();          // U+1F600 emoji
    let ws_units: Vec<u16> = "\u{E9}".encode_utf16().collect(); // é, one UTF-16 unit
    let rbs: Vec<u8> = vec![b'A', b'B'];

    println!("Boolean   val={}", bo as u8);
    println!("ShortInt  min={}", si);
    println!("Byte      max={}", b);
    println!("SmallInt  min={}", smi);
    println!("Word      max={}", w);
    println!("LongInt   size={} min={} max={}", std::mem::size_of::<i32>(), li, i32::MAX);
    println!("LongWord  size={} max={}", std::mem::size_of::<u32>(), lw);
    println!("Int64     size={} min={} max={}", std::mem::size_of::<i64>(), i64v, i64::MAX);
    println!("QWord     size={} max={}", std::mem::size_of::<u64>(), q);
    println!("Single    size={} val={}", std::mem::size_of::<f32>(), s);
    println!("Double    size={} val={}", std::mem::size_of::<f64>(), d);

    println!("AnsiString len={}", as_bytes.len());
    println!("string(UTF16) emoji units={} [Rust: bytes={}, chars={}]", us.encode_utf16().count(), us.len(), us.chars().count());
    println!("WideString elemSize=2 units={}", ws_units.len());
    println!("RawByteString len={} byte0={}", rbs.len(), rbs[0]);
}
