use core::arch::asm;
fn main() {
    asm!("nop", options(nostack));   // EXPECTED COMPILE ERROR: asm! requires an unsafe block
}
