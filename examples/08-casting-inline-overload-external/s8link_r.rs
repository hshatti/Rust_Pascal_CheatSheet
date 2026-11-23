#[link(name = "extlib")]
extern "system" {
    fn AddExt(a: i32, b: i32) -> i32;
}

fn main() {
    unsafe {
        println!("add ext = {}", AddExt(20, 22)); // add ext = 42
    }
}
