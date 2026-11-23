use std::ops::{Add, Sub, Mul};   // operator overloading ↔ class operators (traits instead of keywords)

struct TPoint { x: i32, y: i32 }          // record ↔ struct

impl TPoint {                             // methods on the type — no "record" keyword needed
    fn new(x: i32, y: i32) -> Self {      // constructor ↔ associated function (no `constructor` keyword)
        TPoint { x, y }
    }
    fn dist_sq(&self) -> i32 {            // method inside a record ↔ impl block
        self.x * self.x + self.y * self.y
    }
    fn move_by(&mut self, dx: i32, dy: i32) {   // mutating method needs &mut self
        self.x += dx; self.y += dy;
    }
}

impl Add for TPoint {                     // class operator Add ↔ std::ops::Add trait
    type Output = TPoint;                 // required associated type — no Pascal counterpart
    fn add(self, other: TPoint) -> TPoint { TPoint { x: self.x + other.x, y: self.y + other.y } }
}
impl Sub for TPoint {
    type Output = TPoint;
    fn sub(self, other: TPoint) -> TPoint { TPoint { x: self.x - other.x, y: self.y - other.y } }
}
impl Mul<f64> for TPoint {                // mixed-type operator (record * scalar), like Delphi's Multiply(P, F)
    type Output = TPoint;
    fn mul(self, f: f64) -> TPoint { TPoint { x: ((self.x as f64) * f) as i32, y: ((self.y as f64) * f) as i32 } }
}

struct TBox { f_val: i32 }                // private by default (no `pub`) — like Delphi's `private` section
impl TBox {
    fn new(v: i32) -> Self { TBox { f_val: v } }
    fn get(&self) -> i32 { self.f_val }   // method can access its own private field
}

// Record helper ↔ just another impl (Rust has no separate "helper" concept for your own types)
impl TPoint {
    fn text(&self) -> String { format!("({}, {})", self.x, self.y) }
}

fn main() {
    let mut p = TPoint::new(3, 4);        // constructor call ↔ associated function
    println!("dist sq = {}", p.dist_sq());          // dist sq = 25
    p.move_by(1, 1);
    println!("moved = ({}, {})", p.x, p.y);         // moved = (4, 5)

    let tb = TBox::new(7);
    println!("box = {}", tb.get());                 // box = 7

    println!("helper text = {}", p.text());         // helper text = (4, 5)

    let a = TPoint::new(1, 2);
    let b = TPoint::new(10, 20);
    let sum = a + b;                                        // a and b are MOVED here — unusable afterwards (Delphi copies)
    println!("sum = ({}, {})", sum.x, sum.y);               // sum = (11, 22)

    let a = TPoint::new(1, 2);                              // fresh values needed: the previous ones were consumed
    let b = TPoint::new(10, 20);
    let diff = b - a;                                       // b and a are MOVED here
    println!("diff = ({}, {})", diff.x, diff.y);            // diff = (9, 18)

    let p2 = TPoint::new(1, 2);
    let scaled = p2 * 3.0;                                  // p2 is MOVED here
    println!("scaled = ({}, {})", scaled.x, scaled.y);      // scaled = (3, 6)
}
