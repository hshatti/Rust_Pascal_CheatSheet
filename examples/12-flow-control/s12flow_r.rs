fn main() {
    let x = 75i32;

    // if-else chain — same shape (and `if` is also an expression in Rust)
    if x >= 90 { println!("grade = A"); }
    else if x >= 80 { println!("grade = B"); }
    else if x >= 70 { println!("grade = C"); }   // <- this one fires
    else { println!("grade = F"); }

    // match ≈ case: value lists, ranges, wildcard _ ≈ else (exhaustive by default)
    let grade = match x / 10 {
        9 | 10 => "A",
        8      => "B",
        5..=7  => "C",     // range pattern — fires for 75
        _      => "F",     // wildcard ≈ case's else
    };
    println!("case = {}", grade);   // case = C
}
