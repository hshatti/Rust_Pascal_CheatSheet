fn main() {
    // for up (inclusive range) — sum of 1..5
    let mut sum = 0;
    for i in 1..=5 { sum += i; }            // 1+2+3+4+5 = 15
    println!("for up = {}", sum);           // for up = 15

    // downto ≈ reversed range
    for i in (1..4).rev() { print!("{} ", i); }   // 3 2 1
    println!();

    // while (pre-test) — same shape
    let mut i = 0;
    while i < 3 { i += 1; }                 // 3
    println!("while = {}", i);              // while = 3

    // repeat-until ≈ loop + break (post-test: body runs at least once)
    let mut i = 0;
    loop { i += 1; if i >= 2 { break; } }   // 2
    println!("repeat = {}", i);             // repeat = 2

    // break / continue — same keywords, same semantics
    for i in 1..=5 {
        if i == 3 { break; }                // stop at 3
        if i % 2 != 0 { continue; }         // skip odds
        print!("{} ", i);                   // only 2 is printed
    }
    println!();                             // "2"
}
