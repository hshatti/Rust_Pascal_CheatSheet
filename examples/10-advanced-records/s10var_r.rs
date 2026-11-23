enum Shape {
    Point  { x: i32, y: i32 },   // point variant
    Circle { r: f64 },          // circle variant
}

fn main() {
    let s = Shape::Point { x: 3, y: 4 };
    match &s {
        Shape::Point { x, y } => println!("point = {},{}", x, y),      // point = 3,4
        _ => {}
    }
    let c = Shape::Circle { r: 2.5 };
    match &c {
        Shape::Circle { r } => println!("circle r = {}", r),           // circle r = 2.5
        _ => {}
    }
}
