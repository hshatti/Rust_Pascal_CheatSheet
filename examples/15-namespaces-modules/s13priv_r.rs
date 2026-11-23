mod a { fn hidden() -> i32 { 42 } }   // no `pub` — private to module `a`

fn main() {
    let _ = a::hidden();              // NEGATIVE TEST: must fail with E0603 (function is private)
}
