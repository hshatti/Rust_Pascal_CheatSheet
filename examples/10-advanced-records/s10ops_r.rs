use std::ops::Add;

#[derive(Copy, Clone)]
struct P { x: i32 }

// operator on REFERENCES — operands are borrowed, not moved:
impl Add for &P {
    type Output = P;
    fn add(self, o: &P) -> P { P { x: self.x + o.x } }
}

fn main() {
    let a = P { x: 1 };
    let b = P { x: 2 };
    let s = &a + &b;
    println!("sum = {}", s.x);              // sum = 3
    println!("after = {},{}", a.x, b.x);    // after = 1,2 — operands still usable (Delphi-like)
}
