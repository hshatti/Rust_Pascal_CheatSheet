fn main() {
    let b: u8 = 255;
    let w: u16 = 65535;
    let lw: u32 = 4294967295;
    let si: i8 = -128;
    let smi: i16 = -32768;
    let i32v: i32 = i32::MIN;
    let i64v: i64 = i64::MIN;
    let q: u64 = u64::MAX;
    let s: f32 = 1.5;
    let d: f64 = 2.25;
    let bo: bool = true;
    let c: u8 = b'A';
    let ch: char = 'A';

    println!("Byte     size={} val={}", std::mem::size_of::<u8>(), b);
    println!("Word     size={} val={}", std::mem::size_of::<u16>(), w);
    println!("LongWord size={} val={}", std::mem::size_of::<u32>(), lw);
    println!("ShortInt size={} val={}", std::mem::size_of::<i8>(), si);
    println!("SmallInt size={} val={}", std::mem::size_of::<i16>(), smi);
    println!("Integer  size={} min={} max={}", std::mem::size_of::<i32>(), i32v, i32::MAX);
    println!("Int64    size={} min={} max={}", std::mem::size_of::<i64>(), i64v, i64::MAX);
    println!("QWord    size={} val={}", std::mem::size_of::<u64>(), q);
    println!("Single   size={} val={}", std::mem::size_of::<f32>(), s);
    println!("Double   size={} val={}", std::mem::size_of::<f64>(), d);
    println!("Boolean  size={} val={}", std::mem::size_of::<bool>(), bo as u8);
    println!("AnsiChar size={} ord={}", std::mem::size_of::<u8>(), c);
    println!("char     size={} ord={} [Rust char is a Unicode scalar, not a 16-bit unit]", std::mem::size_of::<char>(), ch as u32);
}
