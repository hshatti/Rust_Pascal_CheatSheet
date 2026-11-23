mod a { pub struct TBox { f_val: i32 } }   // field private to module `a` (no `pub`)

// sibling module — NOT a descendant of `a`, so it cannot see non-pub fields:
mod b { use super::a::TBox; pub fn try_access(t: &TBox) -> i32 { t.f_val } }   // EXPECTED COMPILE ERROR E0616

fn main() {}
