use core::arch::asm;

fn add_asm(a: i64, b: i64) -> i64 {       // Rust's inline assembly — `asm!` macro (stable since 1.59)
    let mut x = a;                        // start with the first operand in a register
    unsafe {
        asm!(
            "add {x}, {b}",               // Intel syntax: dest first — x := x + b (64-bit regs for i64)
            x = inout(reg) x,             // read-modify-write: x := x + b
            b = in(reg) b,                // input operand
            options(nostack)              // no stack access — compiler can verify
        );
    }
    x                                     // return the sum
}

fn main() {
    println!("asm add = {}", add_asm(20, 22)); // asm add = 42
}
