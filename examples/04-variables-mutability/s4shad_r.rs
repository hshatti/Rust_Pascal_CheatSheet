fn main() {
    let x = 1;
    println!("outer x = {}", x);         // outer x = 1
    {
        let x = x + 10;                  // shadowing: a NEW binding in the inner scope, not mutation
        println!("inner x = {}", x);     // inner x = 11
    }
    println!("back to outer x = {}", x); // back to outer x = 1 (outer binding untouched)
}
