use std::ffi::{CStr, CString};

fn main() {
    // --- UTF8String conversion (always explicit in Rust) ---
    let u = "caf\u{e9}";                        // Unicode text; String/str is already UTF-8
    let t: Vec<u8> = u.as_bytes().to_vec();     // -> UTF-8 byte sequence
    println!("utf8 len = {}", t.len());         // utf8 len = 5
    let back = std::str::from_utf8(&t).unwrap();// safe decode back to text
    println!("back to utf16 len = {}", back.chars().count()); // back to utf16 len = 4

    // --- PAnsiChar: raw pointer into a NUL-terminated buffer ---
    let c = CString::new("Hello").unwrap();     // owned buffer + trailing NUL (rejects embedded NUL)
    unsafe {
        let p = CStr::from_ptr(c.as_ptr());     // borrowed view via raw ptr — UNSAFE
        println!("first ansi char ord = {}", *c.as_ptr() as u8); // first ansi char ord = 72
        println!("copied from pointer: {} (len {})", p.to_str().unwrap(), p.to_bytes().len());
    }

    // --- PWideChar: raw pointer into UTF-16 code units ---
    let w: Vec<u16> = "caf\u{e9}".encode_utf16().collect();
    unsafe {
        println!("first wide unit ord = {}", *w.as_ptr()); // first wide unit ord = 99
    }
    let _s = String::from_utf16(&w).unwrap();   // safe decode back to text (Err on lone surrogates)
}
