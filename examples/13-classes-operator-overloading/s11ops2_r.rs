use std::cmp::{Ordering, PartialOrd};
use std::ops::{Add, BitAnd, BitOr, BitXor, Div, Mul, Rem, Shl, Shr, Sub};

#[derive(Copy, Clone)]
struct Flag { bits: i32 }          // Copy — operands are copied like Delphi's (no E0382)

impl Add for Flag { type Output = Flag; fn add(self, o: Flag) -> Flag { Flag { bits: self.bits + o.bits } } }
impl Sub for Flag { type Output = Flag; fn sub(self, o: Flag) -> Flag { Flag { bits: self.bits - o.bits } } }
impl Mul for Flag { type Output = Flag; fn mul(self, o: Flag) -> Flag { Flag { bits: self.bits * o.bits } } }
impl Div for Flag { type Output = Flag; fn div(self, o: Flag) -> Flag { Flag { bits: self.bits / o.bits } } }   // integer division ↔ Delphi `Div`
impl Rem for Flag { type Output = Flag; fn rem(self, o: Flag) -> Flag { Flag { bits: self.bits % o.bits } } }    // ↔ Delphi `Mod`
impl BitAnd for Flag { type Output = Flag; fn bitand(self, o: Flag) -> Flag { Flag { bits: self.bits & o.bits } } }
impl BitOr for Flag { type Output = Flag; fn bitor(self, o: Flag) -> Flag { Flag { bits: self.bits | o.bits } } }
impl BitXor for Flag { type Output = Flag; fn bitxor(self, o: Flag) -> Flag { Flag { bits: self.bits ^ o.bits } } }
impl Shl<usize> for Flag { type Output = Flag; fn shl(self, n: usize) -> Flag { Flag { bits: self.bits << n } } }  // shift amount is `usize`, not i32
impl Shr<usize> for Flag { type Output = Flag; fn shr(self, n: usize) -> Flag { Flag { bits: self.bits >> n } } }

impl PartialEq for Flag { fn eq(&self, o: &Flag) -> bool { self.bits == o.bits } }   // ↔ class operator Equal
impl PartialOrd for Flag { fn partial_cmp(&self, o: &Flag) -> Option<Ordering> { Some(self.bits.cmp(&o.bits)) } }  // ↔ LessThan/GreaterThan

fn main() {
    let a = Flag { bits: 7 }; let b = Flag { bits: 3 };
    println!("add = {}", (a + b).bits);      // add = 10
    println!("sub = {}", (a - b).bits);      // sub = 4
    println!("mul = {}", (a * b).bits);      // mul = 21
    println!("div = {}", (a / b).bits);      // div = 2
    println!("mod = {}", (a % b).bits);      // mod = 1
    println!("and = {}", (a & b).bits);      // and = 3
    println!("or  = {}", (a | b).bits);      // or  = 7
    println!("xor = {}", (a ^ b).bits);      // xor = 4
    println!("shl = {}", (a << 2).bits);     // shl = 28
    println!("shr = {}", (b >> 1).bits);     // shr = 1
    println!("lt  = {}", a < b);             // lt  = false
    println!("gt  = {}", a > b);             // gt  = true
    println!("eq  = {}", a == b);            // eq  = false
}
