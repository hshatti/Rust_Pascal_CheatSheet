fn main() {
    // Static arrays: always 0-based in Rust; explicit initialization required (no zero-init magic)
    let a = [0i32; 4];
    println!("static init = {},{}", a[0], a[3]); // static init = 0,0

    // Emulate Delphi's array[1..4]: same values, but indices are still 0..3 in Rust
    let mut b = [0i32; 4];
    for i in 0..b.len() { b[i] = ((i + 1) as i32) * 10; }
    println!("b range = {}..{}", b[0], b[b.len() - 1]); // b range = 10..40

    // Dynamic array -> Vec
    let mut d = vec![10, 20, 30];
    println!("dyn = {},{},{}", d[0], d[1], d[2]); // dyn = 10,20,30

    d.push(40);                                    // append: one call instead of grow+write
    println!("after append len = {} last = {}", d.len(), *d.last().unwrap()); // after append len = 4 last = 40

    let popped = d.pop();                          // remove-last: RETURNS the value (Delphi's SetLength loses it)
    println!("popped value = {}", popped.unwrap()); // popped value = 40
    println!("after pop len = {}", d.len());        // after pop len = 3

    // Unsafe equivalent: raw pointer arithmetic — no bounds check at all
    let raw = unsafe { *d.as_ptr().add(1) };
    println!("raw ptr read = {}", raw);             // raw ptr read = 20

    d.insert(1, 99);                               // insert in the middle: built-in (Delphi has no equivalent)
    println!("after insert = {},{},{},{}", d[0], d[1], d[2], d[3]); // after insert = 10,99,20,30

    // Out-of-range access -> panic; bounds checking is ALWAYS on (no directive to disable it).
    // Runtime index: a constant out-of-bounds index would be rejected at compile time (unconditional_panic)
    let idx = 5usize;
    let r = std::panic::catch_unwind(|| { let _x = a[idx]; });
    println!("oob caught = {}", r.is_err());        // oob caught = true
}
