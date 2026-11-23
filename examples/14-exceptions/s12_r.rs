use std::fmt;

#[derive(Debug)]
struct MyError(String);                       // custom error type ↔ exception class (EMyError)
impl fmt::Display for MyError { fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result { write!(f, "{}", self.0) } }
impl std::error::Error for MyError {}

fn do_work(index: i32) -> Result<(), MyError> {   // "raise" = returning Err — the idiomatic path
    if index < 0 { return Err(MyError("negative index".into())); }
    Ok(())
}

struct Guard;                                  // finally ↔ Drop — cleanup bound to scope lifetime
impl Drop for Guard { fn drop(&mut self) { println!("cleanup"); } }

fn raise(msg: &str) -> ! {                      // raise ↔ panic! — owned String payload (like Delphi's exception object)
    let m = msg.to_string();
    panic!("{}", m);
}

fn main() {
    std::panic::set_hook(Box::new(|_| {}));     // silence the default hook's stderr noise for caught panics
    // 1. typed catch — matching on the error type (no exception machinery needed)
    match do_work(-1) {
        Ok(()) => println!("ok"),
        Err(e) => println!("caught custom: {}", e),   // caught custom: negative index
    }

    // 2. finally ↔ Drop — runs at scope exit, even when a panic unwinds through it
    let r = std::panic::catch_unwind(|| {
        let _g = Guard;                          // "finally" registered for this block
        println!("work");
        if do_work(-3).is_err() { raise("negative index"); }    // raise ↔ panic!
    });
    if r.is_err() { println!("except caught: negative index"); }

    // 3. re-raise ↔ panics propagate automatically; catch_unwind is the `except` block
    let outer = std::panic::catch_unwind(|| {
        let inner = std::panic::catch_unwind(|| { if do_work(-2).is_err() { raise("negative index"); } });
        if let Err(payload) = inner {
            // bare `raise` ↔ re-panic with the same payload (or simply don't catch at all)
            if let Some(s) = payload.downcast_ref::<String>() { println!("inner caught: {}", s); panic!("{}", s); }
        }
    });
    if let Err(payload) = outer {
        if let Some(s) = payload.downcast_ref::<String>() { println!("outer caught: {}", s); }
    }
}
