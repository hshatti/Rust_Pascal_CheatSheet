struct TPoint { x: i32, y: i32 }

fn main() {
    // zero-init then field-by-field mutation (the exact form shown in the sheet)
    let mut pt = TPoint { x: 0, y: 0 };
    pt.x = 1;
    pt.y = 2;
    println!("point = ({}, {})", pt.x, pt.y); // point = (1, 2)
}
