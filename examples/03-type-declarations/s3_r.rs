// alias (transparent, like Delphi `type X = Y`)
type MyInt = i32;

#[derive(Debug)]
enum Color { Red, Green, Blue } // no built-in ordinals

struct TPoint { x: i32, y: i32 } // basic record -> struct

struct TBox<T>(T); // generic type declaration (works on structs too)

fn add_one(x: i32) -> i32 { x + 1 }

// subrange: no equivalent — emulate with a checked constructor
fn make_range(v: i32) -> Result<i32, String> {
    if (1..=10).contains(&v) { Ok(v) } else { Err("out of range".into()) }
}

fn main() {
    // alias
    let mi: MyInt = 42;
    println!("alias = {}", mi);                       // alias = 42

    // enumerated type (ordinal must be mapped manually)
    let c = Color::Green;
    let ord = match c { Color::Red => 0, Color::Green => 1, Color::Blue => 2 };
    println!("ord clGreen = {}", ord);                // ord clGreen = 1
    let cast: u8 = 2;                                 // integer -> enum needs manual mapping
    let c2 = match cast { 0 => Color::Red, 1 => Color::Green, _ => Color::Blue };
    println!("cast back = {:?}", c2);                 // cast back = Blue

    // subrange: checked constructor instead of a raising assignment
    println!("subrange = {}", make_range(5).unwrap()); // subrange = 5
    println!("out-of-range caught = {}", make_range(11).is_err());

    // set of enum values: no built-in — emulate with a bitmask
    let mut cs: u32 = (1 << 0) | (1 << 2);            // [Red, Blue]
    cs |= 1 << 1;                                     // Include(Green)
    cs &= !(1 << 0);                                  // Exclude(Red)
    println!("has green = {}", cs & (1 << 1) != 0);   // has green = true
    println!("has red = {}", cs & (1 << 0) != 0);     // has red = false

    // pointer type: raw pointer, deref is unsafe
    let mut i: i32 = 7;
    let p: *mut i32 = &mut i as *mut i32;
    unsafe {
        println!("via ptr = {}", *p);                 // via ptr = 7
        *p = 9;
    }
    println!("mutated = {}", i);                      // mutated = 9

    // basic record: struct literal, all fields required at construction
    let pt = TPoint { x: 1, y: 2 };
    println!("point = ({}, {})", pt.x, pt.y);         // point = (1, 2)

    // procedural type: fn pointer (no capture)
    let f: fn(i32) -> i32 = add_one;
    println!("f(41) = {}", f(41));                    // f(41) = 42

    // closure: captures `off` from the enclosing scope
    let off = 10;
    let af = move |x: i32| x + off;
    println!("closure(1) = {}", af(1));               // closure(1) = 11

    // generic type declaration (Rust: structs, enums, traits, functions)
    let b = TBox(42i32);
    println!("box = {}", b.0);                        // box = 42
}
