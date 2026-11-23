use std::ops::{Index, IndexMut};

struct Circle { kind: String }          // "class" — value type; field private by default (no pub)

impl Circle {
    fn new() -> Self { Circle { kind: "circle".into() } }   // constructor ↔ associated function
    fn get_kind(&self) -> &str { &self.kind }               // property read ↔ getter method
    fn set_kind(&mut self, k: String) { self.kind = k; }    // property write ↔ setter — no `property` keyword
    fn area_of(radius: f64) -> f64 { std::f64::consts::PI * radius * radius }   // static method ↔ associated function (no self)
}

trait Draw {                             // virtual/abstract method ↔ trait method with no default body
    fn draw(&self);                      // implementors MUST provide it — like `virtual; abstract`
}

impl Draw for Circle {                   // override ↔ implementing the trait method
    fn draw(&self) { println!("draw: {}", self.kind); }
}

impl Drop for Circle {                   // destructor ↔ Drop trait (runs when the value leaves scope / is freed)
    fn drop(&mut self) { println!("dropping {}", self.kind); }
}

struct Items(Vec<String>);               // indexed property ↔ Index / IndexMut traits

impl Index<usize> for Items {
    type Output = String;
    fn index(&self, i: usize) -> &String { &self.0[i] }
}
impl IndexMut<usize> for Items {
    fn index_mut(&mut self, i: usize) -> &mut String { &mut self.0[i] }
}

fn main() {
    let mut c = Circle::new();
    println!("kind = {}", c.get_kind());                 // kind = circle
    c.set_kind("square".into());
    println!("kind2 = {}", c.get_kind());                // kind2 = square
    c.set_kind("circle".into());

    let b: Box<dyn Draw> = Box::new(c);                  // base pointer ↔ trait object (c is MOVED into the box)
    b.draw();                                            // draw: circle — dynamic dispatch at runtime

    println!("static area = {:.2}", Circle::area_of(2.0));   // static area = 12.57

    let mut items = Items(vec!["a".into(), "b".into(), "c".into()]);
    println!("item[1] = {}", items[1]);                  // item[1] = b — Index trait, same [] syntax as Delphi's indexed property
    items[2] = "z".into();                                // IndexMut — write through the index (setter)
    println!("item[2] = {}", items[2]);                   // item[2] = z
}
