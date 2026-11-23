mod s13u {
    pub struct TPoint { pub x: i32, pub y: i32 }   // unit interface — visible to consumers via `pub`
    pub fn make_point(x: i32, y: i32) -> TPoint { TPoint { x, y } }
    pub fn show(p: &TPoint) { println!("point ({}, {})", p.x, p.y); }
}

fn main() {
    let p = s13u::make_point(3, 4);        // qualified path ≈ S13U.MakePoint — works with no import at all
    s13u::show(&p);                        // point (3, 4)
    println!("qualified: {}", s13u::make_point(5, 6).x);   // namespace path

    use s13u::*;                           // `use` ≈ uses clause → unqualified names from here on
    let q = make_point(7, 8);              // now unqualified — like Delphi's uses S13U
    show(&q);                              // point (7, 8)
}
