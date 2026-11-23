use std::sync::{atomic::{AtomicI32, Ordering}, Arc, Mutex};
use std::thread;
use std::time::Duration;

fn main() {
    // --- interlocked ops ↔ atomics (single-threaded semantics) ---
    let counter = AtomicI32::new(0);
    counter.fetch_add(1, Ordering::SeqCst);                          // 0 -> 1 (InterlockedIncrement)
    println!("after inc = {}", counter.load(Ordering::SeqCst));      // after inc = 1
    println!("exchange ret = {}", counter.swap(5, Ordering::SeqCst));// old value: 1 (InterlockedExchange)
    println!("after exchange = {}", counter.load(Ordering::SeqCst)); // after exchange = 5
    match counter.compare_exchange(5, 9, Ordering::SeqCst, Ordering::SeqCst) {   // CAS: 5 -> 9
        Ok(_) => println!("cas ok"),
        Err(actual) => println!("cas fail actual={}", actual),
    }

    // --- multi-threaded with atomics (shared via Arc; starts at 9 to match Pascal) ---
    let c = Arc::new(AtomicI32::new(9));
    let mut hs = Vec::new();
    for _ in 0..4 {
        let cc = Arc::clone(&c);
        hs.push(thread::spawn(move || {
            for _ in 0..100_000 { cc.fetch_add(1, Ordering::SeqCst); }
        }));
    }
    for h in hs { h.join().unwrap(); }
    println!("atomic total = {}", c.load(Ordering::SeqCst));         // atomic total = 400009

    // --- Mutex ↔ TMonitor critical section around non-atomic state (shared via Arc) ---
    let plain = Arc::new(Mutex::new(0i32));
    let mut hs = Vec::new();
    for _ in 0..2 {
        let p = Arc::clone(&plain);
        hs.push(thread::spawn(move || {
            for _ in 0..50_000 { *p.lock().unwrap() += 1; }
        }));
    }
    for h in hs { h.join().unwrap(); }
    println!("monitored total = {}", *plain.lock().unwrap());        // monitored total = 100000

    // --- event ↔ mpsc channel: worker blocks until main signals it ---
    let (tx, rx) = std::sync::mpsc::channel::<()>();
    let w = thread::spawn(move || {
        rx.recv().unwrap();                    // ≈ WaitForSingleObject(INFINITE)
        println!("event signaled");
    });
    thread::sleep(Duration::from_millis(200));
    tx.send(()).unwrap();                      // ≈ SetEvent
    w.join().unwrap();
}
