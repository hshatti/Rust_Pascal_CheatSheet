fn main() {
    let mut x: i32 = 10;        // mutable binding — `mut` is explicit, and every binding must be initialized
    println!("x = {}", x);      // x = 10
    x += 5;                     // compound assignment (no Delphi equivalent)
    println!("x now = {}", x);  // x now = 15
    x -= 3;                     // or: x = x - 3
    println!("after dec = {}", x); // after dec = 12
}
