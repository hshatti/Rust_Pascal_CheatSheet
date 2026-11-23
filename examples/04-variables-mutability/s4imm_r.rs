fn main() {
    let y: i32 = 42;   // immutable binding (no `mut`)
    y = 43;            // EXPECTED COMPILE ERROR: E0384 cannot assign twice to immutable variable
}
