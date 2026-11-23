fn show_const(x: &i32) {                 // const parameter -> shared reference (read-only in the callee)
    println!("const param = {}", x);     // const param = 42
}

fn show_value(x: i32) {                  // value parameter — a copy for Copy types
    let local = x + 100;                 // modifying the copy does not affect the caller
    println!("value param = {} (local was {})", x, local); // value param = 42 (local was 142)
}

fn modify_var(x: &mut i32) {             // var parameter -> mutable reference — modifies the caller's variable
    *x += 1000;                          // visible to the caller!
}

fn show_str(s: String) {                 // by-value for a non-Copy type = ownership moved into the callee
    println!("callee sees = {}", s);     // callee sees = hi
}

fn main() {
    let mut v = 42i32;
    show_const(&v);
    println!("v after const = {}", v);   // v after const = 42 (unchanged)
    show_value(v);                       // by-value: Copy type is copied, caller unaffected
    println!("v after value = {}", v);   // v after value = 42 (unchanged)
    modify_var(&mut v);
    println!("v after var = {}", v);     // v after var = 1042 (modified!)

    let ss = String::from("hi");
    show_str(ss);                        // ss is MOVED into the callee — cannot be used afterwards (E0382)
}
