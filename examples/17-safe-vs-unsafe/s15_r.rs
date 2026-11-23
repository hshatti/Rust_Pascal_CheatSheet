use std::ffi::{CStr, CString};
use core::arch::asm;

#[no_mangle]
extern "system" fn add_ext(a: i32, b: i32) -> i32 { a + b }   // extern-ABI call needs unsafe (E0133 without)

fn add_asm(a: i64, b: i64) -> i64 {
    let mut x = a;
    unsafe { asm!("add {x}, {b}", x = inout(reg) x, b = in(reg) b, options(nostack)); }
    x
}

struct Circle;
impl Circle { fn draw(&self) { println!("draw: circle"); } }

fn main() {
    // 1. array access — safe vs unsafe
    let d = [10, 20, 30];
    let x = d[1];                                  // safe, bounds-checked → 20
    let y = unsafe { *d.as_ptr().add(1) };         // raw pointer read — unchecked → 20
    println!("arr: {} {}", x, y);

    // 2. reference vs raw pointer
    let mut i = 7;
    let p: &mut i32 = &mut i;   *p = 42;           // safe reference write
    unsafe { let r = &mut i as *mut i32; *r = 43; }// raw pointer write — unchecked
    println!("ptr: {}", i);                        // ptr: 43

    // 3. C string interop
    let cs = CString::new("Hello").unwrap();
    let p = unsafe { CStr::from_ptr(cs.as_ptr()) };   // raw pointer → safe wrapper (shadows the reference above)
    println!("str: {}", p.to_str().unwrap());         // str: Hello

    // 4. FFI call — unsafe block required
    println!("ffi: {}", unsafe { add_ext(20, 22) });   // ffi: 42

    // 5. inline asm — unsafe block required
    println!("asm: {}", add_asm(20, 22));             // asm: 42

    // 6. object dispatch — safe vs raw pointer
    let obj = Box::new(Circle);
    obj.draw();                                       // safe path
    unsafe { let raw: *const Circle = &*obj; (*raw).draw(); }   // raw pointer dispatch
}
