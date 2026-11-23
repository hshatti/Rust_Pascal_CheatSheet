#[derive(Debug)]
enum Color { Red, Green, Blue }

struct TPoint { x: i32, y: i32 }

const N: i32 = 10;                          // Rust has no untyped constants — the type is mandatory
const GREETING: &str = "Hello";            // string constant (borrowed; `String` cannot be a const)
const MAX_SIZE: i32 = 100;                 // typed constant
const DEFAULT_COLOR: Color = Color::Green; // typed constant of enum type
const ORIGIN: TPoint = TPoint { x: 0, y: 0 }; // typed constant of struct type

fn main() {
    let i: i32 = N;                        // integer context — exact type match required
    println!("i = {}", i);                 // i = 10
    let d = (N as f64) * 2.5;              // float context — explicit `as` cast, no implicit conversion
    println!("d = {:.1}", d);              // d = 25.0

    println!("greeting = {}", GREETING);   // greeting = Hello

    println!("max size = {}", MAX_SIZE);   // max size = 100
    println!("default color = {:?}", DEFAULT_COLOR); // default color = Green
    println!("origin = ({}, {})", ORIGIN.x, ORIGIN.y); // origin = (0, 0)
}
