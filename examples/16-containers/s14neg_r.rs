use std::collections::{HashMap, VecDeque};

fn main() {
    // duplicate key: insert silently OVERWRITES (no exception)
    let mut d: HashMap<String, i32> = HashMap::new();
    d.insert("a".into(), 1);
    d.insert("a".into(), 2);   // overwrites — no error raised
    println!("dup key: {} count={}", d["a"], d.len());   // dup key: 2 count=1

    // empty pop: returns Option::None — handle it (unwrap would panic)
    let mut q: VecDeque<i32> = VecDeque::new();
    match q.pop_front() {
        Some(v) => println!("got {}", v),
        None => println!("empty: None"),   // handled gracefully instead of panicking
    }
}
