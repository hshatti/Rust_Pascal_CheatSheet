fn greet(name: &str) {                 // procedure — no return value
    println!("Hello, {}", name);       // Hello, World
}

fn add(a: i32, b: i32) -> i32 {        // function — the final expression is the return value (no Result keyword)
    a + b                              // note: no semicolon
}

fn with_local() {                      // bindings may appear anywhere in the body
    let x = 5;                         // (Delphi requires var declarations before any statement)
    println!("local = {}", x);         // local = 5
}

fn outer() {                           // Rust has no nested fn items — use a closure instead
    let inner = || println!("inner ran");
    inner();
}

// Mutual recursion: no forward declaration needed, definition order is irrelevant
fn b() {
    println!("b calls a");             // b calls a
    a();                               // `a` is defined below — fine in Rust
}

fn a() {
    println!("a ran (from b)");        // a ran (from b)
}

// Rust has no default parameter values — emulate with Option
fn with_default(x: Option<i32>) -> i32 {
    x.unwrap_or(10)
}

fn main() {
    greet("World");
    println!("add = {}", add(2, 3));   // add = 5
    with_local();
    outer();
    b();
    println!("default x = {}", with_default(None));     // default x = 10
    println!("default x = {}", with_default(Some(99))); // default x = 99
}
