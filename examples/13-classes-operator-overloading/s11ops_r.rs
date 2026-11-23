use std::ops::{Neg, Not};

#[derive(Copy, Clone)]
struct Flag { bits: i32 }

impl Neg for Flag { type Output = Flag; fn neg(self) -> Flag { Flag { bits: -self.bits } } }   // unary minus
impl Not for Flag { type Output = Flag; fn not(self) -> Flag { Flag { bits: !self.bits } } }    // bitwise NOT

fn main() {
    let f = Flag { bits: 5 };
    println!("neg = {}", (-f).bits);     // neg = -5
    println!("not = {}", (!f).bits);     // not = -6
}
