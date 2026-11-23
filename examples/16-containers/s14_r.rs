use std::collections::{BTreeSet, HashMap, VecDeque};

fn main() {
    // TList ↔ Vec
    let mut l = vec![10, 20, 30];
    println!("list count = {}", l.len());                 // list count = 3
    println!("list[1] = {}", l[1]);                       // list[1] = 20
    l.remove(0);
    println!("after delete: {} count={}", l[0], l.len()); // after delete: 20 count=2

    // TDictionary ↔ HashMap (BTreeMap for sorted order)
    let mut d: HashMap<String, i32> = HashMap::new();
    d.insert("a".into(), 1);
    d.insert("b".into(), 2);
    println!("dict a = {}", d["a"]);                      // dict a = 1
    println!("contains c = {}", d.contains_key("c"));     // contains c = false
    d.remove("a");
    println!("after remove count = {}", d.len());         // after remove count = 1

    // TSet ↔ BTreeSet (HashSet for no ordering)
    let mut s: BTreeSet<i32> = [1, 2, 3, 2].into_iter().collect();   // duplicate ignored
    println!("set count = {}", s.len());                  // set count = 3
    println!("has 2 = {}", s.contains(&2));               // has 2 = true
    s.remove(&1);   // Delphi's Exclude(1)
    println!("after remove: has 1 = {} count={}", s.contains(&1), s.len());

    // TQueue ↔ VecDeque (FIFO)
    let mut q = VecDeque::new();
    q.push_back(1);
    q.push_back(2);
    println!("queue front = {}", q.pop_front().unwrap()); // queue front = 1

    // TStack ↔ Vec push/pop (LIFO)
    let mut st = vec![];
    st.push(1);
    st.push(2);
    println!("stack top = {}", st.pop().unwrap());        // stack top = 2
}
