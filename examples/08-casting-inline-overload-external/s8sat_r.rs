fn main() {
    // out-of-range float -> int casts saturate (since Rust 1.45) instead of UB/wrapping
    println!("big = {}", 1e30f64 as i32);      // big = 2147483647 (i32::MAX)
    println!("neg = {}", -1e30f64 as i32);     // neg = -2147483648 (i32::MIN)
}
