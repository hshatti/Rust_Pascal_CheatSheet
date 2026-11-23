fn main() {
    // Concatenation (String + &str, or format!)
    let s = String::from("ab") + "cd";
    println!("concat = {}", s);                  // concat = abcd

    // Copy -> 0-based byte slice (char-boundary safe via get)
    let s = "Hello World";
    println!("copy = {}", s.get(0..4).unwrap()); // copy = Hell

    // Insert substring at index 5 (no in-place insert for &str; rebuild String)
    let s = "Hello World";
    let (a, b) = s.split_at(5);
    let r = format!("{}!{}", a, b);
    println!("insert = {}", r);                  // insert = Hello! World

    // Delete range -> replace_range with ""
    let mut s2 = String::from("Hello World");
    s2.replace_range(1..4, "");
    println!("delete = {}", s2);                 // delete = Ho World (bytes 1..4 removed)

    // Pos -> find: 0-based byte offset or None (mapped to 1-based/0 for parity)
    let s3 = "Hello World";
    println!("pos of World = {}", s3.find("World").map(|i| i + 1).unwrap_or(0)); // pos of World = 7
    println!("contains xyz = {}", s3.contains("xyz")); // contains xyz = false

    // Trim / case conversion (return new values; &str is immutable)
    let t = "  hi  ";
    println!("trim = [{}]", t.trim());           // trim = [hi]
    println!("upper = {}", "hello".to_uppercase()); // upper = HELLO

    // Int <-> string (parse returns Result, not an exception)
    println!("int to str = {}", 123i32.to_string()); // int to str = 123
    println!("str to int = {}", "456".parse::<i32>().unwrap()); // str to int = 456
    println!("bad int rejected = {}", "abc".parse::<i32>().is_err()); // bad int rejected = true

    // Float <-> string (always '.' separator; no locale awareness)
    println!("float to str = {}", 2.5f64.to_string()); // float to str = 2.5
    println!("str to float = {}", "3.75".parse::<f64>().unwrap()); // str to float = 3.75

    // Ord / Chr (char::from_u32 returns Option instead of raising)
    println!("ord A = {}", u32::from('A'));      // ord A = 65
    println!("chr 66 = {}", char::from_u32(66).unwrap()); // chr 66 = B

    // format! ({} placeholders, no % specifiers)
    println!("{}", format!("{} {}", 42, "x"));  // 42 x
}
