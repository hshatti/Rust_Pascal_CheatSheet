#[inline]                                    // inline attribute — a hint to the compiler (same concept as Delphi's `inline`)
fn fast(x: i32) -> i32 { x * 2 + 1 }

// Rust has NO function overloading — different names instead of one overloaded name
fn over_int(a: i32) -> i32 { a + 1 }
fn over_str(s: &str) -> usize { s.len() }

#[link(name = "extlib")]
extern "system" {
    #[link_name = "AddExt"]                  // with explicit symbol name (Delphi's `name '...'`)
    fn add_ext(a: i32, b: i32) -> i32;
    fn SubExt(a: i32, b: i32) -> i32;        // without — local name = symbol name (bare Delphi external)
}

fn main() {
    // Casting: float -> int truncates toward zero on both sides
    println!("trunc = {}", 2.9f64 as i32);   // trunc = 2

    // Reinterpret the same bytes as a different type — safe idiom (transmute is the unsafe equivalent)
    let punned = u32::from_le_bytes([1, 2, 3, 4]);
    println!("punned = {}", punned);         // punned = 67305985

    println!("fast = {}", fast(20));         // fast = 41

    println!("over int = {}", over_int(41)); // over int = 42
    println!("over str = {}", over_str("abc")); // over str = 3

    unsafe {                                 // FFI calls are unsafe in Rust (plain calls in Delphi)
        println!("add ext = {}", add_ext(20, 22)); // add ext = 42 (call into FPC-built DLL)
        println!("sub ext = {}", SubExt(50, 8));   // sub ext = 42
    }
}
