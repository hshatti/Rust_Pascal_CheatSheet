fn main() {
    let x = 1;            // i32
    println!("x = {}", x);          // x = 1
    let x = "one";        // shadow with a different type (&str)
    println!("x now = {}", x);      // x now = one
}
