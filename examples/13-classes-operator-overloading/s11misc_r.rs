struct Circle { kind: String }

impl Circle {
    fn draw(&self) { println!("draw: {}", self.kind); }
}

// no method overloading in Rust — different names (or generics):
fn calc_one(a: i32) -> i32 { a * 2 }        // ↔ Calc(A: Integer) overload
fn calc_two(a: i32, b: i32) -> i32 { a + b } // ↔ Calc(A, B: Integer) overload

fn main() {
    let c = Box::new(Circle { kind: "circle".into() });
    unsafe {
        let raw: *const Circle = &*c;   // raw pointer — no lifetime/borrow checks, caller's responsibility
        (*raw).draw();                  // draw: circle — same vtable call as the safe path
    }
    println!("calc1 = {}", calc_one(21));     // calc1 = 42
    println!("calc2 = {}", calc_two(20, 22)); // calc2 = 42
}
