# Pascal → Rust Cheat Sheet

By Haitham Shatti (2026)

[Creative Commons BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0/)

Examples Rust code snippets and their equivalent Pascal code, every code is concrete example; every example was compiled and executed on both sides (Free Pascal 3.2.2 — FPC 3.3.1 where a feature is Delphi-only, e.g. anonymous methods / rustc 1.97, edition 2021) before being written here — where FPC differs from Delphi, the documented behavior is Delphi's.

## How to read: 
`Pascal` — Delphi syntax 
`Rust` — modern std-only Rust (no external crates)
`Description` — what the construct does · 
`Caveats & cautions` — differences, gotchas, and warnings that break a naive 1:1 translation (`—` when there are none).

## Contents
1. [Internal primitive types](#1-internal-primitive-types) ✅
2. [Strings: manipulation, conversion to/from primitives, formatting](#2-strings) ✅
3. [Type declarations](#3-type-declarations) ✅
4. [Variable declaration & assignment; mutable vs immutable](#4-variable-declaration--assignment-mutable-vs-immutable) ✅
5. [Untyped constants; typed constants](#5-untyped-constants-typed-constants) ✅
6. [Variables, procedures, functions](#6-variables-procedures-functions) ✅
7. [Parameters: const / value / var](#7-parameters-const--value--var) ✅
8. [Casting, inline, overload, external (with and without name)](#8-casting-inline-overload-external-with-and-without-name) ✅
9. [Static arrays; dynamic arrays and how to work with them](#9-static-arrays-dynamic-arrays-and-how-to-work-with-them) ✅
10. [Advanced records](#10-advanced-records) ✅
11. [Loops](#11-loops) ✅
12. [Flow control (if-then-else, case)](#12-flow-control-if-then-else-case) ✅
13. [Classes & operator overloading](#13-classes--operator-overloading) ✅
14. [Exceptions](#14-exceptions) ✅
15. [Namespaces: Delphi units ↔ Rust modules](#15-namespaces-delphi-units-rust-modules) ✅
16. [Containers](#16-containers) ✅
17. [Memory-safe vs unsafe equivalents](#17-memory-safe-vs-unsafe-equivalents) ✅
18. [Multithreading: threads, interlocked ops (atomics), SyncObjs](#18-multithreading-threads-interlocked-ops-atomics-syncobjs) ✅
19. [File I/O: typed/untyped files, textfile, TFileStream](#19-file-io-typeduntyped-files-textfile-tfilestream) ✅

## 1. Internal primitive types

Single-element logical type, stored as 1 byte.

Rust

```rust
let mut bo: bool = true;
```

Pascal

```pascal
var bo: Boolean;   // declared here for this row
begin bo := True; end.
```

Delphi's legacy `ByteBool`, `WordBool`, `LongBool` all map to Rust's `bool`.

Signed 8-bit integer, range −128..127.

Rust

```rust
let mut si: i8 = -128;
```

Pascal

```pascal
var si: ShortInt;   // declared here for this row
begin si := -128; end.
```

Unsigned 8-bit integer, range 0..255.

Rust

```rust
let mut b: u8 = 255;
```

Pascal

```pascal
var b: Byte;   // declared here for this row
begin b := 255; end.
```

No implicit conversions in Rust: use explicit casts (`as`) when moving between sizes.

Signed 16-bit integer, range −32768..32767.

Rust

```rust
let mut smi: i16 = -32768;
```

Pascal

```pascal
var smi: SmallInt;   // declared here for this row
begin smi := -32768; end.
```

Unsigned 16-bit integer, range 0..65535.

Rust

```rust
let mut w: u16 = 65535;
```

Pascal

```pascal
var w: Word;   // declared here for this row
begin w := 65535; end.
```

Signed 32-bit integer, range −2³¹..2³¹−1.

Rust

```rust
let mut li: i32 = i32::MIN;
```

Pascal

```pascal
var li: LongInt;   // declared here for this row
begin li := Low(LongInt); end.
```

Delphi's `Integer` is an alias for `LongInt`. Rust's default integer type is also `i32`; use `isize`/`usize` for pointer-sized values, `NativeInt` or `IntPtr`/`NativeUInt` or `UIntPtr` for pascal equivalent

Unsigned 32-bit integer, range 0..4294967295.

Rust

```rust
let mut lw: u32 = u32::MAX;
```

Pascal

```pascal
var lw: LongWord;   // declared here for this row
begin lw := High(LongWord); end.
```

Delphi's `Cardinal` is an alias for `LongWord`.

Signed 64-bit integer, range −2⁶³..2⁶³−1.

Rust

```rust
let mut i64v: i64 = i64::MIN;
```

Pascal

```pascal
var i64v: Int64;   // declared here for this row
begin i64v := Low(Int64); end.
```

Unsigned 64-bit integer, range 0..2⁶⁴−1.

Rust

```rust
let mut q: u64 = u64::MAX;
```

Pascal

```pascal
var q: UInt64;   // declared here for this row
begin q := High(UInt64); end.
```

Delphi's `QWord` is the same type (alias).

IEEE 754 single-precision float, ~7 decimal digits of precision.

Rust

```rust
let mut s: f32 = 1.5;
```

Pascal

```pascal
var s: Single;   // declared here for this row
begin s := 1.5; end.
```

IEEE 754 double-precision float, ~15–16 decimal digits of precision.

Rust

```rust
let mut d: f64 = 2.25;
```

Pascal

```pascal
var d: Double;   // declared here for this row
begin d := 2.25; end.
```

Rust's default float type is `f64`. Delphi's `Extended`, `Real48`, `Comp`, `Currency` have no std equivalent — use `f64`, or integer cents for exact money math.

Sequence of 8-bit characters, codepage-dependent in Delphi.

Rust

```rust
let mut s: Vec<u8> = b"Hello".to_vec();
```

Pascal

```pascal
var ans: AnsiString;   // declared here for this row
begin ans := 'Hello'; end.
```

Rust has no codepages — treat it as a byte sequence (`Vec<u8>` / borrowed `&[u8]`). If the text is UTF-8, use `String`/`&str` instead.

Owned text. Delphi's `string` (UnicodeString) stores **UTF-16**; Rust's `String` stores **UTF-8**.

Rust

```rust
let mut s: String = "😀".into();
```

Pascal

```pascal
var us: string;   // declared here for this row
begin us := '😀'; end.
```

Verified for U+1F600: Delphi `Length(us)` = 2 (surrogate pair); Rust `"😀".len()` = 4 bytes, `.chars().count()` = 1, `.encode_utf16().count()` = 2. So Delphi's `Length` ≈ Rust UTF-16 unit count — not byte length and not char count. Borrowed counterpart: `&str`.

Sequence of 2-byte UTF-16 code units.

Rust

```rust
let mut w: Vec<u16> = "é".encode_utf16().collect();
```

Pascal

```pascal
var ws: WideString;   // declared here for this row
begin ws := 'é'; end.
```

Rust has no first-class UTF-16 string type: use `Vec<u16>` for raw code units, or convert to `String` (UTF-8) for text processing. Verified: `'é'` = 1 unit on both sides; a non-BMP char is 2 units in Delphi but 1 char / 4 bytes in Rust's `String`.

Opaque byte sequence with no encoding semantics.

Rust

```rust
let mut r: Vec<u8> = vec![b'A', b'B'];
```

Pascal

```pascal
var rbs: RawByteString;   // declared here for this row
begin rbs := 'AB'; end.
```

Same mapping as `AnsiString`, but Delphi guarantees no codepage interpretation — Rust's `Vec<u8>` is exactly that. Borrowed form: `&[u8]`.

Delphi's UTF-8 encoded string type. Rust has no separate UTF-8 type — `String`/`&str` **is** UTF-8, so the "conversion" is just a byte view or an explicit decode.

Rust

```rust
let t: Vec<u8> = u.as_bytes().to_vec();
let back = std::str::from_utf8(&t).unwrap();
```

Pascal

```pascal
var u: string; t: UTF8String;   // source value + target — both declared here for this row
begin u := 'caf' + #$C3 + #$A9;   // 'café' built from explicit UTF-8 bytes (é = C3 A9)
  t := u;              // implicit Unicode → UTF-8 conversion
end.
```

Caveats & cautions

In Delphi, assignment between `UnicodeString` and `UTF8String` converts implicitly (with a data-loss warning when not representable); in Rust it is always explicit: `as_bytes()` to get bytes, `std::str::from_utf8(&bytes)` to decode back — returns `Result`, errors on invalid UTF-8.

Pointer to a NUL-terminated 8-bit (ANSI) character sequence. Rust: raw pointer into a NUL-terminated buffer, with safe wrapper types `CStr`/`CString`.

Rust

```rust
let c = CString::new("Hello").unwrap();
let p = unsafe { CStr::from_ptr(c.as_ptr()) };   // raw pointer → safe wrapper
p.to_str().unwrap()
```

Pascal

```pascal
p := PAnsiChar(a);
Ord(p^)  // 72
a := p;   // copy until NUL
```

In Delphi the cast is implicit and `a := p` copies until NUL — no Rust counterpart for that assignment; in Rust, dereferencing the raw pointer needs an `unsafe` block (`CStr::from_ptr`, `*ptr as u8`), while `to_str()`/`to_string_lossy()` are safe. `CString::new` rejects embedded NULs (returns `Err`).

Pointer to a NUL-terminated sequence of 2-byte UTF-16 code units. Rust: `*const u16` / `Vec<u16>`.

Rust

```rust
let w: Vec<u16> = "café".encode_utf16().collect();
unsafe { *w.as_ptr() }
String::from_utf16(&w).unwrap()
```

Pascal

```pascal
pw := PWideChar(u);
Ord(pw^)  // 99
```

In Delphi, `PWideChar(u)` is valid when the string is a `UnicodeString`; in Rust there is no first-class wide-string pointer — use `*const u16` / `Vec<u16>`; reading through the raw pointer is unsafe, but decoding back to text via `String::from_utf16` is safe (`Err` on lone surrogates).

## 2. Strings

### Manipulation

Append one string to another, producing a new owned value.

Rust

```rust
let s = String::from("ab") + "cd";
```

Pascal

```pascal
var s: string;   // declared here for this row
begin s := 'ab' + 'cd';   // abcd — concatenation produces a new value
end.
```

In Delphi, `+` works on any mix of `string`, `AnsiString`, `UnicodeString`; in Rust, `String + &str` consumes (moves) the left operand — two `String`s cannot be added directly; use `format!` or `push_str`.

Extract a substring. Delphi: 1-based start position + count; Rust: 0-based byte range (start inclusive, end exclusive).

Rust

```rust
let s = "Hello World";   // the value being sliced — shown explicitly
s.get(0..4).unwrap()   // Some("Hell") — 0-based byte range
```

Pascal

```pascal
var s: string;   // declared here for this row
begin s := 'Hello World';   // the value being copied — shown explicitly
  WriteLn(Copy(s, 1, 4));   // Hell — 1-based start + count
end.
```

Caveats & cautions

Delphi's `Copy` counts **characters** (UTF-16 units); Rust slices by **bytes** — slicing mid-character panics. Use `.get()` for bounds-safe access that returns `None` instead of panicking, or char-based indexing via `.chars().nth()`.

Insert splices a substring in at a position; Delete removes a count of characters starting at a position. Both are 1-based in Delphi.

Rust

```rust
let s = "Hello World";   // the value being modified — shown explicitly
let (a, b) = s.split_at(5);
let r = format!("{}!{}", a, b);
println!("insert = {}", r);   // Hello! World
let mut s2 = String::from("Hello World");
s2.replace_range(1..4, "");   // Ho World
```

Pascal

```pascal
var s: string;   // declared here for this row
begin s := 'Hello World'; Insert('!', s, 6);   // Hello! World — 1-based position
  s := 'Hello World'; Delete(s, 2, 3);          // Ho World — remove 3 chars from pos 2
end.
```

Caveats & cautions

Delphi mutates the string in place; Rust's `&str` is immutable — insert means rebuilding (`split_at` + `format!`), delete uses `String::replace_range`. Indices must land on character boundaries: `replace_range` panics otherwise.

Find the first occurrence of a substring. Delphi returns a 1-based position or 0 when absent; Rust's `find` returns a 0-based byte offset as `Option<usize>`.

Rust

```rust
let s = "Hello World";   // the value being searched — shown explicitly
s.find("World").map(|i| i + 1).unwrap_or(0)   // 7 — mapped back to Delphi's 1-based/0 convention
s.contains("xyz")   // false
```

Pascal

```pascal
var s: string;   // declared here for this row
begin s := 'Hello World';   // the value being searched — shown explicitly
  WriteLn(Pos('World', s));        // 7 — 1-based position
  WriteLn(Pos('xyz', s) > 0);     // False
end.
```

Off-by-one trap: Delphi is 1-based, Rust is 0-based. Both are case-sensitive by default (Delphi: `AnsiContainsText`; Rust: `eq_ignore_ascii_case`).

Strip leading/trailing whitespace; convert case. Both return new values — neither mutates the argument in place.

Rust

```rust
"  hi  ".trim()
"hello".to_uppercase()
```

Pascal

```pascal
var s: string;   // declared here for this row
begin s := '  hi  '; WriteLn(Trim(s));        // hi — the value is shown explicitly above
  s := 'hello'; WriteLn(UpperCase(s));   // HELLO
end.
```

Delphi's `Trim` removes only spaces/tabs/control chars; Rust's `trim()` uses full Unicode whitespace. Case conversion can change length (`'ß'.to_uppercase() == 'SS'`) and is locale-aware in Delphi but simple-Unicode-mapping in Rust.

### Conversion to/from primitives

Convert between integers and text.

Rust

```rust
123i32.to_string()
"456".parse::<i32>().unwrap()
"abc".parse::<i32>().is_err()  // true
```

Pascal

```pascal
IntToStr(123)      // '123'
StrToInt('456')     // 456
StrToInt('abc')     // raises EConvertError
```

Caveats & cautions

Error handling differs fundamentally: Delphi raises an exception (`EConvertError`); Rust returns `Result<T, ParseIntError>` — there are no exceptions at all. Also `StrToInt` tolerates surrounding whitespace; `parse` does not (trim first).

Convert between floating-point numbers and text.

Rust

```rust
2.5f64.to_string()
"3.75".parse::<f64>().unwrap()
```

Pascal

```pascal
FloatToStr(2.5)     // '2.5'
StrToFloat('3.75')   // 3.75
```

Caveats & cautions

Delphi is **locale-dependent** (decimal separator follows the OS locale — in a comma-decimal locale, `StrToFloat('3.75')` fails); Rust always uses `.` with no locale awareness. Display also differs: FPC/Delphi may print doubles in scientific notation (`3.7500000000000000E+000`) while Rust's `to_string` prints the shortest round-trip form — use `FormatFloat` / `{:.2}` for fixed formatting.

Convert between a character and its Unicode code point.

Rust

```rust
u32::from('A')   // 65
char::from_u32(66).unwrap()  // 'B' (None on invalid)
```

Pascal

```pascal
Ord('A')     // 65
Chr(66)      // 'B' (raises on invalid code)
```

Caveats & cautions

Delphi's `Ord(char)` returns the UTF-16 unit value — for non-BMP characters that is a surrogate half, not the code point; Rust's `u32::from(char)` always gives the true code point. `Chr` raises on invalid values (e.g., surrogates); `char::from_u32` returns `None`.

### Formatting

Build a string from a format template and arguments.

Rust

```rust
format!("{} {}", 42, "x")
```

Pascal

```pascal
Format('%d %s', [42, 'x'])   // '42 x'
```

Delphi uses `%` specifiers with an array of arguments; Rust's `format!` takes `{}` placeholders inline — no separate argument list. Delphi's `%d`, `%.2f` map to Rust's `{}`, `{:.2}` precision syntax.

## 3. Type declarations

### Aliases

Transparent alias for an existing type. No new type is created in either language — the alias and the original are interchangeable everywhere.

Rust

```rust
type MyInt = i32;
let mi: MyInt = 42;
```

Pascal

```pascal
type MyInt = Integer;   // the alias — declared here for this row
var mi: MyInt;   // a variable of that type — declared here for this row
begin mi := 42;   // alias and original are interchangeable everywhere
end.
```

Both are purely notational (no conversion, no distinctness). Rust aliases additionally work on function types, traits, and generic instantiations (`type F = fn(i32) -> i32;`).

### Enumerated types & subranges

Named set of constants. Delphi assigns implicit ordinals (0-based) and stores the value as an integer.

Rust

```rust
enum Color { Red, Green, Blue }
let c = Color::Green;
match c { Color::Red => 0, Color::Green => 1, _ => 2 }
```

Pascal

```pascal
type TColor = (clRed, clGreen, clBlue);   // the enumerated type — declared here for this row
var c: TColor;   // a variable of that type — declared here for this row
begin c := clGreen; WriteLn(Ord(c));   // 1 — implicit ordinal (0-based)
  c := TColor(2);        // clBlue — free cast from an integer
end.
```

Delphi enums have built-in ordinals (`Ord`) and free casts to/from integers; Rust enums have **no ordinals** — map manually with `match`, and "casting" from an integer is a hand-written match, not a cast. Rust requires exhaustive matching; Delphi does not. Display: Delphi prints the identifier name (`clBlue`); Rust needs `#[derive(Debug)]` to print variant names.

Subrange type: an integer restricted to a fixed interval. Delphi enforces it at runtime with `ERangeError`.

Rust

```rust
// No equivalent type — emulate with a checked constructor:
fn make_range(v: i32) -> Result<i32, String> { if (1..=10).contains(&v) { Ok(v) } else { Err("out of range".into()) } }
```

Pascal

```pascal
type TRange = 1..10;   // the subrange type — declared here for this row
var r: TRange; i: Integer;   // both variables declared here for this row
begin r := 5;   // ok — inside 1..10
  i := 11;   // outside the range, from a runtime value:
  try r := i; except on E: Exception do WriteLn('out-of-range caught = True'); end;   // ERangeError
end.
```

Caveats & cautions

Rust has no subrange type — you must validate yourself (checked constructor returning `Result`, or a newtype wrapper). Note the compile-time trap on both sides: assigning an out-of-range **constant** (`r := 11`) is a \*compile\* error in Delphi and FPC alike; only runtime values raise.

### Sets of enum values

Fixed-size collection of distinct enum values, stored as a bit vector in Delphi.

Rust

```rust
// Bitmask emulation:
let mut cs: u32 = (1 << 0) | (1 << 2);
cs |= 1 << 1;  cs &= !(1 << 0);
(cs & (1 << 1)) != 0  // true
```

Pascal

```pascal
type TColor = (clRed, clGreen, clBlue);   // the element type — re-declared here so this row stands alone
TColors = set of TColor;   // the set type — declared here for this row
var cs: TColors;   // a variable of that type — declared here for this row
begin cs := [clRed, clBlue];   // set constructor syntax
  Include(cs, clGreen); Exclude(cs, clRed);
  WriteLn(clGreen in cs);   // True
end.
```

Rust has no built-in set type: use a manual bitmask for small enums, or `std::collections::HashSet<T>` for general membership. Delphi's `in`, `Include`, `Exclude` have no operator equivalents — implement them via traits if you want the same syntax.

### Pointers

Pointer type to a value of another type.

Rust

```rust
// raw pointer — needs unsafe to read/write:
let p: *mut i32 = &mut i as *mut i32;
// safe equivalent (no unsafe needed):
let p: &mut i32 = &mut i;
```

Pascal

```pascal
type PInt = ^Integer;   // the pointer type — declared here for this row
var i: Integer; p: PInt;   // the target value + the pointer to it — both declared here for this row
begin i := 7; p := @i; WriteLn(p^);   // 7 — read through the pointer
  p^ := 9; WriteLn(i);   // 9 — write through the pointer mutates the target
end.
```

In Rust, reading/writing through a **raw** pointer (`*p`) requires an `unsafe` block — the safe counterpart is a reference (`&mut i32`), which gives identical read/write with lifetime-checked borrowing. Delphi needs `{$pointermath on}` for pointer arithmetic; in Rust that is `addr!`/`.offset()` inside `unsafe`.

### Records (basic)

Aggregate of typed fields. Basic records have no methods or operators (see §10 for advanced records).

Rust

```rust
struct TPoint { x: i32, y: i32 }
let mut pt = TPoint { x: 0, y: 0 };
pt.x = 1; pt.y = 2;
```

Pascal

```pascal
type TPoint = record X, Y: Integer; end;   // the record type — declared here for this row
var pt: TPoint;   // a variable of that type — declared here for this row (zero-initialized)
begin pt.X := 1; pt.Y := 2;   // (1, 2) — filled field-by-field after declaration
end.
```

Caveats & cautions

Delphi variables are **zero-initialized** and can be filled field-by-field after declaration; Rust has no zero-initialization — every construction must name all fields (`TPoint { x: 0, y: 0 }`), though `..Default::default()` fills the rest when a `Default` impl exists. Field access syntax is identical (`.`).

### Procedural types & closures

Type of a non-capturing function pointer. Both can be stored in variables, fields, and collections.

Rust

```rust
fn add_one(x: i32) -> i32 { x + 1 }
let f: fn(i32) -> i32 = add_one;
f(41)  // 42
```

Pascal

```pascal
type TFunc = function(x: Integer): Integer;   // the procedural type — declared here for this row
function AddOne(x: Integer): Integer; begin Result := x + 1; end;   // the target routine — defined here so this row stands alone
var f: TFunc;   // a variable of that type — declared here for this row
begin f := AddOne; WriteLn(f(41));   // 42 — call through the function pointer
end.
```

A plain `fn` pointer captures nothing — same on both sides. Delphi's procedural types also cover methods (`of object`) — those map to Rust trait objects / `dyn Trait`, see §11.

Capturing procedure — a closure over variables of the enclosing scope.

Rust

```rust
// Closure capturing the enclosing scope:
let off = 10i32;   // the value the closure will capture — shown explicitly
let af = move |x: i32| x + off;   // captures off from the enclosing scope (move = by value)
af(1)  // 11 = 1 + off (10)
```

Pascal

```pascal
type TAnonFunc = reference to function(x: Integer): Integer;   // the anonymous-method type — declared here for this row
var af: TAnonFunc; off: Integer;   // the closure variable + the captured value — both declared here for this row
begin off := 10;   // the value the closure will capture — shown explicitly
  af := function(x: Integer) begin Result := x + off; end;   // captures off from the enclosing scope
  WriteLn(af(1));   // 11 = 1 + off (10)
end.
```

FPC 3.2.2 does not implement `reference to` — this row was verified with **FPC 3.3.1** (both sides print `closure(1) = 11`). In Rust, closures capture automatically: by reference (`\|x\| x + off`) or by value with `move`; in Delphi, an anonymous method captures any variable visible at its declaration point.

### Generic type declarations

Parameterized type declaration — one definition, many instantiations.

Rust

```rust
struct TBox<T>(T);
let b = TBox(42i32);   // b.0 == 42
```

Pascal

```pascal
type TBox<T> = class   // the generic type — declared here for this row (T is the type parameter)
  public Value: T; end;
var b: TBox<Integer>;   // instantiation with Integer + a variable of that type — both declared here for this row
begin b := TBox<Integer>.Create; b.Value := 42;
  WriteLn(b.Value);   // 42
  b.Free; end.
```

Delphi generics are applied to class/records/interface types and member routines of a class/record, FPC allows generics for stand-alone routines as well; Rust allows generics on structs, enums, traits, and functions. Instantiation syntax differs: Delphi `TBox<Integer>`, Rust `TBox<i32>` / inferred from the value.

## 4. Variable declaration & assignment; mutable vs immutable

### Declaration & assignment

A mutable variable. In Pascal every variable is mutable by default; in Rust you opt in with `mut`.

Rust

```rust
let mut x: i32 = 10;   // the binding + its initial value — shown explicitly (mut = mutable)
```

Pascal

```pascal
var x: Integer;   // declared here for this row
begin x := 10;   // 10 — every var can be reassigned at any time
end.
```

Caveats & cautions

Any `var` can be reassigned at any time — immutability lives in **constants**, not variables (next group); the absence of `mut` in Rust is a compile-time guarantee. Initialization also differs: Delphi allows `var x: Integer;` with no initial value (value undefined until assigned — FPC compiles it, only noting the variable is unused); Rust has **no uninitialized state** — every binding must be initialized at creation.

In-place mutation of a mutable binding. Verified on both sides: 10 → 15 → 12.

Rust

```rust
let mut x = 10i32;   // the binding + its initial value — shown explicitly (mut = mutable)
x += 5;   // 15
x -= 3;    // 12
```

Pascal

```pascal
var x: Integer;   // declared here for this row (the previous row's variable, re-declared so this row stands alone)
begin x := 10; x := x + 5;   // 15
  Dec(x, 3);     // 12 — built-in procedure, no compound operator exists in Delphi
end.
```

Delphi has **no compound assignment operators** — `x := x + 5` is the only form (or the built-in procedures `Inc`/`Dec`). Rust's `+=`, `-=` desugar to the same operation but are idiomatic. Both require a mutable binding on the Rust side (`let mut`).

### Immutability & shadowing

An immutable binding: cannot be reassigned after creation. The compiler enforces it at compile time, not runtime. Verified on both sides (the reassignment line is a compile error in each).

Rust

```rust
let y: i32 = 42;   // immutable binding — no mut keyword, initial value shown explicitly
println!("{}", y);   // 42
// y = 43;   // COMPILE ERROR E0384 — cannot assign twice to immutable variable (verified)
```

Pascal

```pascal
{$WRITEABLECONST OFF}   // typed constants become IMMUTABLE (the default allows writing them):
const X: Integer = 10;   // a "variable" that cannot be reassigned — Pascal's immutable binding
begin WriteLn(X);   // 10
  X := 20;   // COMPILE ERROR — Can't assign values to const variable (verified on FPC)
end.
```

Caveats & cautions

Pascal's immutability lives in **constants**, not variables: an untyped const (`const N = 10;`) is never assignable, and a typed const becomes equally immutable under `{$WRITEABLECONST OFF}` / `{$J-}` (verified compile error). By default both Delphi and FPC leave typed consts writable (Turbo compatibility — verified: reassignment compiles and runs). Rust's `let` has no such escape hatch — immutability is the default, mutability is opt-in (`mut`). To change a value in Rust you need `mut`, or shadowing (below).

Shadowing: a **new** binding with the same name in an inner scope — not mutation of the old one. Verified: outer 1 → inner 11 → back to outer 1.

Rust

```rust
let x = 1;
{ let x = x + 10; }   // inner: 11, outer still 1
```

Pascal

```pascal
// assignment always mutates the same variable
```

No Pascal counterpart — Delphi's `x := x + 10` mutates the single variable everywhere it is visible; Rust's shadowing creates a fresh binding, and the outer one is untouched after the block ends. Shadowed bindings can even have different types (verified: `let x = 1; let x = "one";`).

## 5. Untyped constants; typed constants

### Untyped constants — Delphi only

Delphi's untyped constant: no type annotation, the compiler assigns a natural type and converts implicitly at each use site.

Rust

```rust
// No equivalent — the type is mandatory:
const N: i32 = 10;
let i: i32 = N;
let d = (N as f64) * 2.5;   // explicit cast required
```

Pascal

```pascal
const N = 10;   // untyped constant — declared here for this row (immutable: assignment is a compile error)
var i: Integer; d: Double;   // both variables declared here for this row
begin i := N;        // integer context — implicit conversion at the use site
  d := N * 2.5;   // float context — implicit conversion at the use site
  WriteLn(i, ' ', d);   // 10 25
end.
```

Rust has **no untyped constants** — every `const` requires an explicit type (`const N: i32 = 10;`) and there are no implicit conversions (`N as f64`). Verified on both sides: integer context gives 10, float context gives 25.0.

String constant.

Rust

```rust
const GREETING: &str = "Hello";
```

Pascal

```pascal
const GREETING = 'Hello';
```

Caveats & cautions

In Rust the natural const type for a string literal is `&str`; an owned `String` **cannot** be a const item (verified: E0015 — non-const function calls are not allowed in constants). Delphi's untyped string constant can be assigned to any string type without conversion.

### Typed constants — both languages

Constant with an explicit type annotation. The value must be a compile-time constant expression in both languages.

Rust

```rust
const MAX_SIZE: i32 = 100;
```

Pascal

```pascal
const MAX_SIZE: Integer = 100;
```

Storage differs: Delphi constants live in the data segment and **have an address** (verified: `@MAX_SIZE <> nil` is True — you can pass `@C` to APIs); Rust const items are compile-time values inlined at each use site, with no shared runtime storage.

Typed constants of enum and record/struct types — both languages allow composite const values as long as they are compile-time constructible. Verified on both sides (`clGreen`/`Green`, `(0, 0)`).

Rust

```rust
enum Color { Green }   // the enum used below — re-declared here so this row stands alone
struct TPoint { x: i32, y: i32 }   // the struct used below — re-declared here so this row stands alone
const DEFAULT_COLOR: Color = Color::Green;   // typed constant of an enum type
const ORIGIN: TPoint = TPoint { x: 0, y: 0 };   // typed constant of a struct type
```

Pascal

```pascal
type TColor = (clRed, clGreen);   // the enum used below — re-declared here so this row stands alone
TPoint = record X, Y: Integer; end;   // the record used below — re-declared here so this row stands alone
const DEFAULT_COLOR: TColor = clGreen;   // typed constant of an enum type
const ORIGIN: TPoint = (X: 0; Y: 0);   // typed constant of a record type — field assignments separated by semicolons
```

Record-constant syntax differs: Delphi uses field assignments separated by **semicolons** inside parentheses — `(X: 0; Y: 0)` (commas do not compile); Rust uses a struct literal. Display: Delphi prints the enum identifier (`clGreen`); Rust needs `#[derive(Debug)]` to print variant names.

## 6. Variables, procedures, functions

### Procedures & functions

A procedure/function with no return value. Verified on both sides (`Hello, World`).

Rust

```rust
fn greet(name: &str) { println!("Hello, {}", name); }   // declared here for this row (name is the parameter)
greet("World");   // Hello, World — called with an explicit argument
```

Pascal

```pascal
procedure Greet(name: string);   // declared here for this row (name is the parameter — in scope inside the body)
begin WriteLn('Hello, ', name); end;
Greet('World');   // Hello, World — called with an explicit argument
```

Naming convention differs (PascalCase vs snake\_case). Delphi passes the string by reference under the hood (managed type); Rust's `&str` is an explicit borrow — same effect for read-only use.

A function with a return value. Verified on both sides (`add = 5`).

Rust

```rust
fn add(a: i32, b: i32) -> i32 { a + b }   // declared here for this row (a and b are the parameters)
println!("{}", add(2, 3));   // 5 — called with explicit arguments
```

Pascal

```pascal
function Add(a, b: Integer): Integer;   // declared here for this row (a and b are the parameters)
begin Result := a + b; end;   // Result is Delphi's implicit return variable — no declaration needed
WriteLn(Add(2, 3));   // 5 — called with explicit arguments
```

Return mechanism differs fundamentally: Delphi assigns to the special variable `Result` (or to the function name); Rust returns the **final expression** of the block — a trailing semicolon turns it into a statement and changes the type to `()`. No `Result` keyword exists in Rust.

### Local variables & nested routines

Local variables inside a routine. Verified on both sides (`local = 5`).

Rust

```rust
fn with_local() { let x = 5; println!("local = {}", x); }
```

Pascal

```pascal
procedure WithLocal;
var x: Integer;   // must precede any statement
begin x := 5; WriteLn('local = ', x); end;
```

Placement differs: Delphi requires all local declarations in the `var` section **before** any statement of the block; Rust bindings may appear anywhere in the body (and can be shadowed per §4).

A routine declared inside another routine. Verified on both sides (`inner ran`).

Rust

```rust
// No nested fn items — use a closure:
fn outer() { let inner = || println!("inner ran"); inner(); }
```

Pascal

```pascal
procedure Outer;
procedure Inner; begin WriteLn('inner ran'); end;
begin Inner; end;
```

Rust has **no nested function declarations** at all — the equivalent is a closure (which can capture the enclosing scope, like Delphi's nested routines). Nested procedures in Delphi may also reference locals of `Outer`; a plain Rust closure does exactly that automatically.

### Mutual recursion & default parameters

Two routines calling each other. Verified on both sides (`b calls a` → `a ran (from b)`).

Rust

```rust
// No forward declaration needed:
fn b() { println!("b calls a"); a(); }   // defined below — fine
fn a() { println!("a ran (from b)"); }
```

Pascal

```pascal
procedure A; forward;
procedure B; begin WriteLn('b calls a'); A; end;
procedure A; begin WriteLn('a ran (from b)'); end;
```

Delphi requires a `forward` declaration when the callee is not yet declared; Rust has no such requirement — definition order of `fn` items is irrelevant.

A parameter with a compile-time default value. Verified on both sides (10, then 99).

Rust

```rust
// No default parameters — emulate with Option:
fn with_default(x: Option<i32>) -> i32 { x.unwrap_or(10) }
with_default(None)      // 10
with_default(Some(99))  // 99
```

Pascal

```pascal
procedure WithDefault(x: Integer = 10);
begin WriteLn('default x = ', x); end;
WithDefault;        // x = 10
WithDefault(99);    // x = 99
```

Caveats & cautions

Rust has **no default parameter values** — the idiomatic emulation is `Option<T>` + `unwrap_or`, which changes the call syntax (`None`/`Some(…)` instead of omitting the argument). Delphi defaults must be constant expressions.

## 7. Parameters: const / value / var

A const parameter — the callee may read it but not modify it. Verified on both sides (42, then still 42).

Rust

```rust
fn show_const(x: &i32) { println!("const param = {}", x); }   // declared here for this row (x is the parameter)
let mut v = 42i32;   // the caller's variable — declared + initialized here for this row
show_const(&v);  // v unchanged after the call
println!("v after const = {}", v);   // 42
```

Pascal

```pascal
procedure ShowConst(const x: Integer);   // declared here for this row (x is the parameter)
begin WriteLn('const param = ', x); end;
var v: Integer;   // the caller's variable — declared here for this row
begin v := 42; ShowConst(v);   // v unchanged after the call
  WriteLn('v after const = ', v);   // 42
end.
```

Caveats & cautions

In Delphi, assigning to a `const` parameter is a compile error; in Rust, writing through an `&i32` reference is structurally impossible. For small `Copy` types plain by-value passing (`fn f(x: i32)`) is equally safe and more idiomatic — use `&T` when the type is large or non-`Copy`. Syntax note: modern Delphi puts the modifier **before** the name (`const x: T`); FPC rejects the old Turbo Pascal form `x: const T`.

A value parameter (the Delphi default) — the callee works on a copy. Verified on both sides (42, local 142, caller still 42).

Rust

```rust
fn show_value(x: i32) { let local = x + 100; println!("value param = {} (local was {})", x, local); }   // declared here for this row (x is the parameter)
let v = 42i32;   // the caller's variable — declared + initialized here for this row
show_value(v);
println!("v after value = {}", v);   // 42 — Copy type is copied, the original is untouched
```

Pascal

```pascal
procedure ShowValue(x: Integer);   // declared here for this row (x is the parameter)
var local: Integer;   // a local variable — declared inside the routine before any statement
begin local := x + 100; WriteLn('value param = ', x, ' (local was ', local, ')'); end;   // modifying local does not touch the caller's v
var v: Integer;   // the caller's variable — declared here for this row
begin v := 42; ShowValue(v);
  WriteLn('v after value = ', v);   // 42 — the copy was modified, the original is untouched
end.
```

Caveats & cautions

For Rust `Copy` types this is exactly Delphi's semantics. For non-`Copy` types (`String`, most structs), passing by value **moves ownership** into the callee — the caller loses access (E0382 if used afterwards); see next row.

A var parameter — the callee modifies the caller's variable. Verified on both sides (42 → 1042).

Rust

```rust
fn modify_var(x: &mut i32) { *x += 1000; }   // declared here for this row (&mut x = exclusive mutable reference)
let mut v = 42i32;   // the caller's variable — declared + initialized here (must be mut: the callee writes through it)
modify_var(&mut v);
println!("v after var = {}", v);   // 1042 — the caller's variable was modified
```

Pascal

```pascal
procedure ModifyVar(var x: Integer);   // declared here for this row (var x = the parameter is a reference to the caller's variable)
begin Inc(x, 1000); end;   // writes through that reference
var v: Integer;   // the caller's variable — declared here for this row
begin v := 42; ModifyVar(v);
  WriteLn('v after var = ', v);   // 1042 — the caller's variable was modified
end.
```

Rust's `&mut T` is an **exclusive** mutable reference: while it exists, no other references to that value may exist (aliasing rules); Delphi has no such rule — a `var` parameter can coexist with any number of reads. Syntax note: modern Delphi puts the modifier before the name (`var x: T`); FPC rejects the old Turbo Pascal form `x: var T`.

Passing a managed/owned string. Verified on both sides (`callee sees = hi`).

Rust

```rust
fn show_str(s: String) { println!("callee sees = {}", s); }   // declared here for this row (s is the parameter — ownership moves in)
let ss = String::from("hi");   // the caller's variable — declared + initialized here for this row
show_str(ss);  // ss is MOVED into the callee — cannot be used afterwards (E0382 if you try)
```

Pascal

```pascal
procedure ShowStr(s: string);   // declared here for this row (s is the parameter — a COW reference copy of the caller's string)
begin WriteLn('callee sees = ', s); end;
var ss: string;   // the caller's variable — declared here for this row
begin ss := 'hi'; ShowStr(ss);   // caller keeps its string (reference copy, COW)
  WriteLn('ss still usable = ', ss);   // hi
end.
```

This is where "by value" diverges most: Delphi's `string` parameter is a reference copy with COW semantics and the caller keeps its string; Rust's by-value `String` **moves** ownership into the callee — to keep the caller's string usable, pass `&str` / `&String` instead.

## 8. Casting, inline, overload, external (with and without name)

### Casting

Float → int conversion, truncating toward zero. Verified on both sides (2).

Rust

```rust
2.9f64 as i32   // 2
```

Pascal

```pascal
Trunc(2.9)   // 2
```

Caveats & cautions

Delphi forbids a direct real→int cast (`Integer(d)` is a compile error — FPC: "Illegal type conversion"); use `Trunc`/`Round`. Rust's `as` does the truncation; out-of-range values **saturate** to `i32::MIN`/`MAX` (verified: `1e30 as i32` = 2147483647) instead of wrapping or being undefined.

Type punning — reinterpreting the same bytes as a different type. Verified on both sides (67305985).

Rust

```rust
let punned = u32::from_le_bytes([1, 2, 3, 4]);   // 67305985
```

Pascal

```pascal
TBytes4 = packed record B: array[0..3] of Byte; end;   // 4 bytes viewed as an array — declared here for this row
TInt4   = packed record I: Integer; end;   // the same 4 bytes viewed as one integer — declared here for this row
var p: TBytes4; t: TInt4;   // both variables declared here for this row
begin p.B[0] := 1; p.B[1] := 2; p.B[2] := 3; p.B[3] := 4;   // the byte pattern [1,2,3,4], shown explicitly
  t := TInt4(p);   // reinterpret the same bytes as an integer — equal-size typecast between record types
  WriteLn(t.I);   // 67305985 — little-endian 0x04030201
end.
```

Delphi allows casting between any two record/pointer types of equal size; Rust restricts `as` to numeric and pointer types, so byte reinterpretation goes through explicit functions (`from_le_bytes`) or `std::mem::transmute` — the latter is **unsafe** with no compile-time check that the layouts match.

### Inline & overload

A hint to the compiler to inline a function at its call sites. Verified on both sides (41).

Rust

```rust
#[inline] fn fast(x: i32) -> i32 { x * 2 + 1 }
fast(20)   // 41
```

Pascal

```pascal
function Fast(x: Integer): Integer; inline;   // declared here for this row (x is the parameter)
begin Result := x * 2 + 1; end;   // the body — shown explicitly
WriteLn(Fast(20));   // 41 = 20*2+1 — called with an explicit argument
```

Both are **hints, not guarantees** — the optimizer decides in either language; neither affects behavior or ABI.

Several functions with the same name but different signatures. Verified on both sides (42, 3).

Rust

```rust
// No overloading — distinct names:
fn over_int(a: i32) -> i32 { a + 1 }
fn over_str(s: &str) -> usize { s.len() }
over_int(41)   // 42
over_str("abc") // 3
```

Pascal

```pascal
function Over(a: Integer): Integer; overload;   // first overload — declared here for this row (a is the parameter)
begin Result := a + 1; end;   // body shown explicitly
function Over(s: string): Integer; overload;   // second overload, same name, different signature (s is the parameter)
begin Result := Length(s); end;   // body shown explicitly
WriteLn(Over(41));    // 42 — resolves to the Integer overload by argument type
WriteLn(Over('abc')); // 3  — resolves to the string overload by argument type
```

Rust has **no function overloading** at all — use distinct names (or generics/traits for one polymorphic entry point). Delphi requires the `overload` directive on every declaration after the first.

### External functions

Import a function from a native library **with an explicit export name** differing from the local name. Verified on both sides against the same FPC-built DLL (42).

Rust

```rust
#[link(name = "extlib")] extern "system" { #[link_name = "AddExt"] fn add_ext(a: i32, b: i32) -> i32; }
unsafe { add_ext(20, 22) }   // 42
```

Pascal

```pascal
function AddExt(a, b: Integer): Integer; external 'extlib.dll' name 'AddExt';
AddExt(20, 22)   // 42
```

Caveats & cautions

Every Rust FFI call needs an `unsafe` block (verified: E0133 without one); in Delphi it is a plain call. The calling convention is spelled out in Rust (`extern "system"` = C ABI) and implicit in Delphi (default `cdecl`).

Import a function from a native library **without an explicit name** — the local name is used as the export symbol. Verified on both sides (42).

Rust

```rust
#[link(name = "extlib")] extern "system" { fn SubExt(a: i32, b: i32) -> i32; }
unsafe { SubExt(50, 8) }   // 42
```

Pascal

```pascal
function SubExt(a, b: Integer): Integer; external 'extlib.dll';
SubExt(50, 8)   // 42
```

Caveats & cautions

In Rust this means omitting `#[link_name]` so the item's own name becomes the symbol; in Delphi, omitting `name '…'`. On Windows with the MSVC linker an import library (`extlib.lib`) must sit next to the DLL — generate it from a `.def` file if your Pascal compiler does not ship one (FPC does not).

### Inline assembly

Inline machine code inside a function — the compiler emits your instructions verbatim. Verified on both sides (42).

Rust

```rust
use core::arch::asm;
fn add_asm(a: i64, b: i64) -> i64 {
    let mut x = a;
    unsafe { asm!("add {x}, {b}", x = inout(reg) x, b = in(reg) b, options(nostack)); }
    x
}
add_asm(20, 22)   // 42
```

Pascal

```pascal
function Add(a, b: Int64): Integer; assembler;
asm
  mov rax, a
  add rax, b
end;
Add(20, 22)   // 42
```

Caveats & cautions

Both are platform-specific and bypass all language safety; Rust additionally requires an `unsafe` block (verified: E0133 without one) and explicit operand declarations (`in`/`out`/`inout`) so it can track register usage, whereas Pascal trusts you to preserve the ABI's callee-saved registers. FPC x86\_64 defaults to AT&T syntax — use `{$asmmode intel}` for Intel syntax (Delphi Win32 uses Intel by default). Rust's `asm!` is stable since 1.59; there is no portable inline-assembly story beyond it.

## 9. Static arrays; dynamic arrays and how to work with them

### Static arrays

Fixed-size array with compile-time-known size. Verified on both sides (`static init = 0,0`).

Rust

```rust
let a = [0i32; 4];
println!("{},{}", a[0], a[3]);   // 0,0
```

Pascal

```pascal
var a: array[0..3] of Integer;   // declared here for this row — its bounds are indices 0..3, zero-initialized
begin WriteLn(a[0], ',', a[3]);   // 0,0
end.
```

Delphi zero-initializes global/static arrays at program start (verified); Rust has **no implicit initialization** — `[0i32; 4]` is an explicit repeat expression and there is no such thing as an uninitialized array.

Array with a non-zero lower bound. Verified on both sides (`b range = 10..40`).

Rust

```rust
// No custom ranges — always 0-based:
let mut b = [0i32; 4];
for i in 0..b.len() { b[i] = ((i + 1) as i32) * 10; }   // same values, indices 0..3
```

Pascal

```pascal
var b: array[1..4] of Integer;   // declared here for this row — its bounds are indices 1..4 (non-zero lower bound)
i: Integer;   // the loop variable — declared here for this row
begin for i := Low(b) to High(b) do b[i] := i * 10;
  WriteLn('b range = ', b[Low(b)], '..', b[High(b)]);   // 10..40
end.
```

Delphi allows any ordinal index range (even `array['A'..'Z']`); Rust arrays are **always 0-based** — emulate the offset in your code. `Low()`/`High()` have no counterpart: use `0` and `.len() - 1`.

### Dynamic arrays — declaration & growth

Heap-allocated growable array. Verified on both sides (`dyn = 10,20,30`).

Rust

```rust
let mut d = vec![10, 20, 30];   // owned heap array (Vec)
```

Pascal

```pascal
var d: array of Integer;   // declared here for this row — a dynamic array, its length is set at runtime
begin SetLength(d, 3);   // [0, 0, 0] — new slots zero-initialized
  d[0] := 10; d[1] := 20; d[2] := 30;
  WriteLn('dyn = ', d[0], ',', d[1], ',', d[2]);   // 10,20,30
end.
```

Caveats & cautions

Delphi's dynamic arrays are reference-counted — assignment copies the reference (COW); Rust's `Vec` is **owned** — assignment moves it (E0382 if used afterwards), and sharing requires borrowing or `Rc`.

Allocate a dynamic array of N elements. Verified on both sides (1000).

Rust

```rust
let d = vec![0i32; 1000];   // owned heap array with 1000 elements — declared here for this row
println!("{}", d.len());   // 1000
```

Pascal

```pascal
var d: array of Integer;   // declared here for this row
begin SetLength(d, 1000);   // allocate 1000 slots — indices 0..999, zero-initialized
  WriteLn(Length(d));   // 1000
end.
```

Delphi's `SetLength` allocates and zero-initializes new slots; resizing smaller keeps the first N elements, larger adds zeros (documented + verified). Rust has no "allocate empty" idiom for a fixed count: `vec![0i32; 1000]` is an explicit repeat expression (no implicit initialization exists); to grow an existing Vec use `d.resize(1000, 0)`.

Append an element at the end. Verified on both sides (`after append len = 4 last = 40`).

Rust

```rust
let mut d = vec![10, 20, 30];   // [10, 20, 30] — the starting value, shown explicitly (declared here for this row)
d.push(40);   // one call — built-in append
println!("{} last = {}", d.len(), d[d.len() - 1]);   // 4 last = 40
```

Pascal

```pascal
var d: array of Integer;   // declared here for this row
begin SetLength(d, 3); d[0] := 10; d[1] := 20; d[2] := 30;   // [10, 20, 30] — the starting value, shown explicitly
  SetLength(d, Length(d) + 1);   // no built-in append — grow, then write:
  d[High(d)] := 40;
  WriteLn(Length(d), ' last = ', d[High(d)]);   // 4 last = 40
end.
```

Delphi's idiom leaves a zero slot if you forget to write it — `push` cannot be half-done. Both may reallocate; existing elements are preserved in either language.

Remove the last element. Verified on both sides (`popped value = 40`, `after pop len = 3`).

Rust

```rust
let mut d = vec![10, 20, 30];   // [10, 20, 30] — the starting value, shown explicitly (declared here for this row)
let popped = d.pop();   // Some(40) — RETURNS the value
println!("{} {:?}", d.len(), popped);   // 3 Some(40)
```

Pascal

```pascal
var d: array of Integer;   // declared here for this row
begin SetLength(d, 3); d[0] := 10; d[1] := 20; d[2] := 30;   // [10, 20, 30] — the starting value, shown explicitly
  WriteLn(d[High(d)]);   // 40 — read first, then shrink (the value is lost by the language):
  SetLength(d, Length(d) - 1);
  WriteLn(Length(d));   // 3
end.
```

Caveats & cautions

Delphi's `SetLength(n-1)` discards the value (you must read it first); Rust's `pop()` returns it as an `Option` — `None` if empty.

### Working with dynamic arrays

Insert an element at a middle position. Verified on both sides (`after insert = 10,99,20,30`).

Rust

```rust
let mut d = vec![10, 20, 30];   // [10, 20, 30] — the starting value, shown explicitly (declared here for this row)
d.insert(1, 99);   // built-in — same semantics (zero-based index)
println!("{},{},{},{}", d[0], d[1], d[2], d[3]);   // 10,99,20,30
```

Pascal

```pascal
var d: array of Integer;   // declared here for this row
begin d := [10, 20, 30];   // array constructor syntax — the starting value, shown explicitly
  Insert(99, d, 1);   // built-in intrinsic — insert an element at index 1 (zero-based), shifts the rest right
  WriteLn(d[0], ',', d[1], ',', d[2], ',', d[3]);   // 10,99,20,30
end.
```

Both are built-in and O(n). Array indices here are **zero-based** (the string versions of Insert/Delete/Copy are 1-based — don't mix them up); verified. `Insert` also accepts a whole static or dynamic array as the source; an index beyond High appends at the end (documented).

Remove elements by index. Verified on both sides (`after delete len = 2 first,last = 10,30`).

Rust

```rust
let mut d = vec![10, 20, 30];   // [10, 20, 30] — the starting value, shown explicitly (declared here for this row)
d.remove(1);   // built-in — remove the element at index 1 (returns it)
println!("{}: {},{}", d.len(), d[0], d[d.len() - 1]);   // 2: 10,30
```

Pascal

```pascal
var d: array of Integer;   // declared here for this row
begin d := [10, 20, 30];   // the starting value, shown explicitly
  Delete(d, 1, 1);   // built-in intrinsic — remove 1 element at index 1 (zero-based), shifts the rest left
  WriteLn(Length(d), ': ', d[0], ',', d[High(d)]);   // 2: 10,30
end.
```

Caveats & cautions

Zero-based start index; Count = how many to remove; a range past the end is capped at the boundary (documented) — it never raises. Rust's `remove(index)` removes exactly one element and returns it; for a count use `drain`.

Copy a range into a new array. Verified on both sides (`copy len = 2 = 20,30`).

Rust

```rust
let d = vec![10, 20, 30, 40];   // the starting value, shown explicitly (declared here for this row)
let e: Vec<i32> = d[1..3].to_vec();   // slice → new owned array (indices 1..=2)
println!("{}: {},{}", e.len(), e[0], e[1]);   // 2: 20,30
```

Pascal

```pascal
var d, e: array of Integer;   // source + destination — both declared here for this row
begin d := [10, 20, 30, 40];   // the starting value, shown explicitly
  e := Copy(d, 1, 2);   // built-in intrinsic — new array with elements at indices 1..2 (zero-based)
  WriteLn(Length(e), ': ', e[0], ',', e[1]);   // 2: 20,30
end.
```

Pascal's `Copy` returns a **new** array (the source is untouched); omitting Count copies to the end. Rust has no single built-in for this — slice + `to_vec()` is the idiom; both are O(count).

Concatenate arrays into a new one. Verified on both sides (`concat len = 4 = 10,20,30,40`).

Rust

```rust
let a = vec![10, 20]; let b = vec![30, 40];   // the starting values, shown explicitly (declared here for this row)
let mut c = a; c.extend(b);   // built-in concat (a is moved into c)
println!("{}: {},{},{},{}", c.len(), c[0], c[1], c[2], c[3]);   // 4: 10,20,30,40
```

Pascal

```pascal
var a, b, c: array of Integer;   // two sources + destination — all declared here for this row
begin a := [10, 20]; b := [30, 40];   // the starting values, shown explicitly
  c := Concat(a, b);   // built-in intrinsic — new array with all elements in order (also: c := a + b)
  WriteLn(Length(c), ': ', c[0], ',', c[1], ',', c[2], ',', c[3]);   // 4: 10,20,30,40
end.
```

Pascal's `Concat` takes two or more arrays and returns a new one; the `+` operator does the same for dynamic arrays (Delphi mode). Rust has no single call — move + `extend` is the idiom (or `a.iter().chain(&b)` to borrow both).

Unsafe equivalent of indexed access — direct memory read with no bounds check. Verified on both sides (`raw ptr read = 20`).

Rust

```rust
let mut d = vec![10, 20, 30];   // [10, 20, 30] — the starting value, shown explicitly (declared here for this row)
let raw = unsafe { *d.as_ptr().add(1) };   // same read, unchecked
println!("{}", raw);   // 20
```

Pascal

```pascal
var d: array of Integer; i: Integer;   // the array + result variable — both declared here for this row
begin SetLength(d, 3); d[0] := 10; d[1] := 20; d[2] := 30;   // [10, 20, 30] — the starting value, shown explicitly
  i := PInteger(@d[0])[1];   // raw pointer arithmetic — no bounds check: reads d[1] unchecked
  WriteLn(i);   // 20
end.
```

Caveats & cautions

Pointer arithmetic is never bounds-checked in either language — an out-of-range offset reads/writes whatever memory lies there (garbage or access violation; formally undefined behavior in Rust). Safe equivalents: `d[1]` / `d.get(1)`. Delphi can also \*disable\* checks on the safe path with `{$RANGECHECKS OFF}`; Rust has no such directive — `unsafe` is the only escape hatch.

### Bounds checking

Out-of-bounds access. Verified on both sides (`oob caught = True/true`).

Rust

```rust
let a = [0i32; 4];   // declared here for this row — its BOUNDS are indices 0..=3, so the max index is len() - 1 = 3
let idx = 5usize;   // a runtime value beyond the bounds (index 5 > 3 — not a compile error because it is not a constant):
std::panic::catch_unwind(|| { let _x = a[idx]; });   // panics: index out of range: the len is 4 but the index is 5 — catchable with catch_unwind
```

Pascal

```pascal
var a: array[0..3] of Integer;   // declared here for this row — its BOUNDS are indices 0..3, so High(a) = 3
i, j: Integer;   // both variables declared here for this row
begin i := 5;   // a runtime value beyond the bounds (index 5 > High(a) = 3 — not a compile error because it is not a constant):
  try j := a[i]; except on E: Exception do WriteLn('oob caught = True'); end;   // ERangeError
end.
```

Caveats & cautions

A **constant** out-of-range index is a compile error in both (FPC: "range check error while evaluating constants"; rustc: `unconditional_panic`) — only runtime indices reach the handler. Delphi's ERangeError is catchable; Rust panics unwind by default and are caught with `catch_unwind` (or abort with `-C panic=abort`). Bounds checking in Rust is always on for safe code — there is no `{$RANGECHECKS OFF}` equivalent.

## 10. Advanced records

### Methods & constructors

A method declared inside the record and implemented outside with the type name as prefix. Verified on both sides (`dist sq = 25`).

Rust

```rust
struct TPoint { x: i32, y: i32 }
impl TPoint {
    fn dist_sq(&self) -> i32 { self.x * self.x + self.y * self.y }
}
let p = TPoint { x: 3, y: 4 };   // an instance of the struct above — declared here for this row (values shown explicitly)
println!("{}", p.dist_sq());   // 25 from (3,4)
```

Pascal

```pascal
TPoint = record
  X, Y: Integer;
  function DistSq: Integer;
end;
function TPoint.DistSq: Integer;
begin Result := X * X + Y * Y; end;
var p: TPoint;   // an instance of the record above — declared here for this row
begin p.X := 3; p.Y := 4;   // (3,4) — the values used below, shown explicitly
  WriteLn(p.DistSq);   // 25 from (3,4)
end.
```

Caveats & cautions

Call syntax is identical (`.`). Delphi's record methods operate directly on the value — no hidden pointer to a heap object; Rust spells out the receiver: `&self` for read-only access, `&mut self` when mutating (next row) — omitting it is a compile error, not a runtime surprise.

A method that mutates the record. Verified on both sides (`moved = (4,5)`).

Rust

```rust
struct TPoint { x: i32, y: i32 }   // the type — re-declared here so this row stands alone
impl TPoint { fn move_by(&mut self, dx: i32, dy: i32) { self.x += dx; self.y += dy; } }   // mutating method needs &mut self (dx/dy are the parameters)
let mut p = TPoint { x: 3, y: 4 };   // an instance — declared here for this row (values shown explicitly)
p.move_by(1, 1);   // → (4,5)
```

Pascal

```pascal
TPoint = record X, Y: Integer; procedure MoveBy(dx, dy: Integer); end;   // the type + method — re-declared here so this row stands alone
procedure TPoint.MoveBy(dx, dy: Integer);   // dx and dy are the parameters of the method
begin Inc(X, dx); Inc(Y, dy); end;
var p: TPoint;   // an instance — declared here for this row
begin p.X := 3; p.Y := 4;   // (3,4) — shown explicitly
  p.MoveBy(1, 1);   // → (4,5)
end.
```

Delphi mutates in place with no declaration of intent; Rust requires `&mut self` **and** a mutable binding (`let mut p`) — mutation is opt-in at two levels.

A record constructor — a routine that initializes the value and returns it. Verified on both sides (`dist sq = 25`).

Rust

```rust
fn new(x: i32, y: i32) -> Self { TPoint { x, y } }
let p = TPoint::new(3, 4);
```

Pascal

```pascal
constructor Create(AX, AY: Integer);
begin X := AX; Y := AY; end;
p := TPoint.Create(3, 4);
```

No `constructor` keyword in Rust — just an associated function returning `Self`; any number of them with different names (no special semantics). Delphi's call is an expression producing a **copy** of the record; Rust's returns an owned value that can be moved.

### Visibility

Visibility sections on a record ↔ Rust's field-level `pub`. Verified on both sides (`box = 7`).

Rust

```rust
struct TBox { f_val: i32 }   // private by default (no pub) — declared here for this row
impl TBox { fn new(v: i32) -> Self { TBox { f_val: v } }   // the only way to set the private field — from inside the type (v is the parameter)
    fn get(&self) -> i32 { self.f_val } }
let tb = TBox::new(7);   // an instance — declared here for this row (value shown explicitly)
println!("{}", tb.get());   // 7
```

Pascal

```pascal
TBox = record   // the type — declared here for this row (FVal is private: only code inside TBox can touch it)
  private FVal: Integer;
  public constructor Create(v: Integer); function Get: Integer; end;
constructor TBox.Create(v: Integer); begin FVal := v; end;   // the only way to set the private field — from inside the type (v is the parameter)
function TBox.Get: Integer; begin Result := FVal; end;
var box: TBox;   // an instance — declared here for this row
begin box := TBox.Create(7);   // 7 — shown explicitly, set through the type's own constructor
  WriteLn(box.Get);   // 7
end.
```

Caveats & cautions

**Record visibility is not enforced in Delphi** — accessing the "private" field from outside the type compiles fine as long as it's inside the same unit (verified on FPC, confirmed for Delphi); accessing private fields from outside the unit is a hard compile error; Rust is the opposite: struct fields are private to their module by default and access from a sibling module is a hard compile error (verified: E0616). Rust per-module — a child module can see its parent's private items (verified).

### Record helpers

A record helper adds methods to an existing type without modifying it. Verified on both sides (`helper text = (4, 5)`).

Rust

```rust
// No separate concept — just another impl block:
struct TPoint { x: i32, y: i32 }   // the type being extended — re-declared here so this row stands alone
impl TPoint { fn text(&self) -> String { format!("({}, {})", self.x, self.y) } }
let p = TPoint { x: 4, y: 5 };   // an instance — declared here for this row (values shown explicitly)
println!("{}", p.text());   // (4, 5)
```

Pascal

```pascal
TPointHelper = record helper for TPoint
  function Text: string; end;
begin Result := Format('(%d, %d)', [X, Y]); end;   // X and Y are the record's own fields — visible inside its helper
var p: TPoint;   // an instance of the type being extended — declared here for this row (TPoint = record X, Y: Integer; end;)
begin p.X := 4; p.Y := 5;   // (4, 5) — shown explicitly
  WriteLn(p.Text);   // (4, 5) — helper method called directly on the instance
end.
```

Delphi helpers cannot add fields — methods/properties only; in Rust you just write another `impl` for your own type. Orphan rule: Rust forbids impling a foreign type with a foreign trait — the extension-trait pattern is the workaround when "extending" std types.

### Operator overloading

A class operator overloads an arithmetic symbol for the type. Verified on both sides (`sum = (11,22)`, `diff = (9,18)`).

Rust

```rust
use std::ops::Add;
impl Add for TPoint {
    type Output = TPoint;
    fn add(self, other: TPoint) -> TPoint { TPoint { x: self.x + other.x, y: self.y + other.y } }
}
let a = TPoint { x: 1, y: 2 }; let b = TPoint { x: 10, y: 20 };   // two instances — declared here for this row (values shown explicitly)
let sum = a + b;   // (11, 22)
```

Pascal

```pascal
class operator Add(P1, P2: TPoint): TPoint;   // declared inside the record
class operator TPoint.Add(P1, P2: TPoint): TPoint;
begin Result.X := P1.X + P2.X; Result.Y := P1.Y + P2.Y; end;   // P1 and P2 are the operator's parameters — in scope inside the body
var a, b: TPoint;   // two instances of the type above — declared here for this row
begin a.X := 1; a.Y := 2; b.X := 10; b.Y := 20;   // (1,2) and (10,20) — shown explicitly
  WriteLn((a + b).X);   // 11 from (1,2)+(10,20)
end.
```

Delphi's operators are **named** — `Add`/`Subtract`/… can be any identifier; Rust has fixed trait names (`Add`, `Sub`, …). The required associated type `type Output` has no Pascal counterpart. Implementation syntax is `class operator TPoint.Add(…)`, not `class function`.

An operator with mixed operand types (record × scalar). Verified on both sides (`scaled = (3,6)`).

Rust

```rust
Mixed operand type = generic parameter:
impl Mul<f64> for TPoint {
    type Output = TPoint;
    fn mul(self, f: f64) -> TPoint { TPoint { x: ((self.x as f64) * f) as i32, y: ((self.y as f64) * f) as i32 } }
}
let p2 = TPoint { x: 1, y: 2 };   // an instance — declared here for this row (values shown explicitly)
let scaled = p2 * 3.0;   // (3, 6) — record × scalar
```

Pascal

```pascal
class operator Multiply(P: TPoint; F: Double): TPoint;   // record * scalar
begin Result.X := Round(P.X * F); Result.Y := Round(P.Y * F); end;   // P and F are the operator's parameters — in scope inside the body
var a: TPoint;   // an instance of the type above — declared here for this row
begin a.X := 1; a.Y := 2;   // (1,2) — shown explicitly
  WriteLn((a * 3.0).X);   // 3 from (1,2)
end.
```

Delphi spells the operand types in the signature; Rust encodes the right-hand type as a trait generic parameter (`Mul<Rhs>`), so `TPoint * f64` and `f64 * TPoint` are **different impls** — implement both if you want commutative syntax.

What happens to the operands after an operator call. Verified on both sides (Delphi reuses `a`, `b`; Rust E0382 without fresh values).

Rust

```rust
struct TPoint { x: i32, y: i32 }   // re-declared here so this row stands alone (Add/Sub impls are two rows above)
let a = TPoint { x: 1, y: 2 }; let b = TPoint { x: 10, y: 20 };   // shown explicitly
let sum = a + b;              // a and b are MOVED here
// let d = b - a;             // E0382 — b was moved
let a = TPoint { x: 1, y: 2 };    // fresh values needed (a new binding shadows the old one)
let b = TPoint { x: 10, y: 20 };
let diff = b - a;   // (9, 18)
```

Pascal

```pascal
var a, b, s, d: TPoint;   // four instances — declared here for this row (TPoint with Add/Subtract operators is defined two rows above)
begin a.X := 1; a.Y := 2; b.X := 10; b.Y := 20;   // (1,2) and (10,20) — shown explicitly
  s := a + b;   // (11, 22) — Delphi copies the operands:
  d := b - a;   // (9, 18) — a and b still usable afterwards
end.
```

Caveats & cautions

Delphi **copies** the record operands — originals remain usable afterwards; Rust's by-value traits (`fn add(self, other: TPoint)`) **move** them — reuse is a compile error. For Delphi-like copy semantics implement on references (`impl Add for &TPoint` with `self: &TPoint`) or derive `Copy`/`Clone` (verified: operands remain usable).

### Variant records (union) ↔ enums

A tagged union — one value that is either a point or a circle. Verified on both sides (point = 3,4 / circle r = 2.5).

Rust

```rust
enum Shape {
    Point  { x: i32, y: i32 },   // point variant
    Circle { r: f64 },          // circle variant
}
let s = Shape::Point { x: 3, y: 4 };
match &s { Shape::Point { x, y } => println!("point = {},{}", x, y), _ => {} }   // point = 3,4
let c = Shape::Circle { r: 2.5 };
match &c { Shape::Circle { r } => println!("circle r = {}", r), _ => {} }   // circle r = 2.5
```

Pascal

```pascal
TShape = record
  case Kind: Byte of
    0: (X, Y: Integer);   // point variant
    1: (R: Double);       // circle variant
end;   // the variant record type — declared above in this same cell (Kind is its tag field)
var S: TShape;   // an instance of that variant record — declared here for this row
begin S.Kind := 0; S.X := 3; S.Y := 4;   // select the point variant, then fill it — shown explicitly
  WriteLn('point = ', S.X, ',', S.Y);        // point = 3,4
  S.Kind := 1; S.R := 2.5;   // switch to the circle variant
  WriteLn('circle r = ', Format('%.1f', [S.R]));   // circle r = 2.5
end.
```

Caveats & cautions

Delphi's variant record is a raw **union**: all variants share the same memory (`SizeOf` = tag + largest variant), and reading the wrong variant compiles fine but is undefined behavior; Rust's enum allocates per-variant and forces you to check the tag via `match` — unhandled variants are a compile error. There is no safe union type in std Rust (only unsafe/transmute or external crates). Default double printing differs (FPC: `2.500...E+000`, Rust: `2.5`) — format explicitly to match.

## 11. Loops

### for / downto

Counted loop over a fixed range. Verified on both sides (15).

Rust

```rust
let mut sum = 0;
for i in 1..=5 { sum += i; }      // inclusive range — same 15
println!("for up = {}", sum);     // for up = 15
```

Pascal

```pascal
var Sum: Integer; i: Integer;   // the accumulator + loop variable — both declared here for this row
begin Sum := 0;   // shown explicitly before the loop uses it
  for i := 1 to 5 do Inc(Sum, i);   // 1+2+3+4+5 = 15 (i is the loop variable — in scope inside the body)
  WriteLn('for up = ', Sum);        // for up = 15
end.
```

Delphi's `for` is always an integer counter with step ±1; Rust's `for` iterates any iterator — `1..=5` is the inclusive counterpart of `1 to 5`. No `step` in either: use a while loop or stride the range.

Descending counted loop. Verified on both sides (`3 2 1`).

Rust

```rust
for i in (1..4).rev() { print!("{} ", i); }   // 3 2 1
```

Pascal

```pascal
var i: Integer;   // the loop variable — declared here for this row (in scope inside the body)
begin for i := 3 downto 1 do Write(i, ' ');   // 3 2 1
end.
```

`downto` ↔ `.rev()` — same result, different spelling; Rust's range is still written low→high and then reversed.

### while / repeat-until

Condition-tested loop (pre-test). Verified on both sides (3).

Rust

```rust
let mut i = 0;
while i < 3 { i += 1; }    // same shape, same semantics
println!("while = {}", i); // while = 3
```

Pascal

```pascal
var i: Integer;   // the loop variable — declared here for this row (in scope inside the body)
begin i := 0;   // shown explicitly before the loop uses it
  while i < 3 do Inc(i);   // pre-test: body may run zero times
  WriteLn('while = ', i);  // while = 3
end.
```

Loop that checks its exit condition after the body. Verified on both sides (2).

Rust

```rust
let mut i = 0;
loop { i += 1; if i >= 2 { break; } }   // post-test idiom
println!("repeat = {}", i);  // repeat = 2
```

Pascal

```pascal
var i: Integer;   // the loop variable — declared here for this row (in scope inside the body)
begin i := 0;   // shown explicitly before the loop uses it
  repeat Inc(i); until i >= 2;   // post-test: body runs at least once
  WriteLn('repeat = ', i);      // repeat = 2
end.
```

`repeat...until` has no direct Rust keyword — `loop` + `break` is the standard equivalent; a bare `loop {}` with no break is an infinite loop in both languages.

### break / continue

Early exit and early skip. Verified on both sides (only `2` printed).

Rust

```rust
for i in 1..=5 {
    if i == 3 { break; }     // leave the loop
    if i % 2 != 0 { continue; }   // skip to next iteration
    print!("{} ", i);        // prints only: 2
}
```

Pascal

```pascal
var i: Integer;   // the loop variable — declared here for this row (in scope inside the body)
begin for i := 1 to 5 do begin
    if i = 3 then Break;      // leave the loop
    if Odd(i) then Continue; // skip to next iteration
    Write(i, ' ');            // prints only: 2
  end;
end.
```

Same keywords, same semantics in both — the rare exact match; both act on the innermost enclosing loop.

## 12. Flow control (if-then-else, case)

### if-then-else

Chained conditional branches. Verified on both sides (`grade = C`).

Rust

```rust
let x = 75i32;
if x >= 90 { println!("grade = A"); }
else if x >= 80 { println!("grade = B"); }
else if x >= 70 { println!("grade = C"); }   // <- fires
else { println!("grade = F"); }
```

Pascal

```pascal
var x: Integer;   // the value being tested — declared here for this row (in scope in every branch below)
begin x := 75;   // shown explicitly — it is what selects the firing branch
  if x >= 90 then WriteLn('grade = A')
  else if x >= 80 then WriteLn('grade = B')
  else if x >= 70 then WriteLn('grade = C')   // <- fires (x is 75)
  else WriteLn('grade = F');
end.
```

Same shape in both; Rust requires braces, Delphi doesn't (single-statement `then X := 1;` is legal). In Rust `if/else` is also an **expression** — `let g = if x >= 70 { "C" } else { "F" };` has no Delphi counterpart (D12+ added if-expressions; FPC doesn't have them).

### case ↔ match

Multi-way branch on a value. Verified on both sides (`case = C`).

Rust

```rust
let x = 75i32;   // the value being tested — declared here for this row (in scope in every arm below)
let grade = match x / 10 {
    9 | 10 => "A",       // value list
    8      => "B",
    5..=7  => "C",        // range pattern — fires for 75
    _      => "F",        // wildcard ≈ else
};
```

Pascal

```pascal
var x: Integer; Grade: string;   // the value being tested + the result — both declared here for this row (in scope in every branch below)
begin x := 75;   // shown explicitly — it is what selects the firing branch
  case x div 10 of
    9, 10: Grade := 'A';    // value list
    8:     Grade := 'B';
    5..7:  Grade := 'C';    // range — fires (x is 75)
    else   Grade := 'F';    // required for exhaustiveness
  end;
  WriteLn(Grade);   // C
end.
```

Caveats & cautions

Delphi's `case` needs an explicit `else` (or you get a warning) to be exhaustive; Rust's `match` is exhaustive **by default** — the compiler rejects unhandled values, and `_` plays the role of `else`. Both support value lists and ranges. `match` binds like an expression (`let grade = match ...`); Delphi's `case` is a statement.

## 13. Classes & operator overloading

### Class basics

A class with a private field and an initializing constructor. Verified on both sides (`kind = circle`).

Rust

```rust
struct Shape { kind: String }          // "class" ↔ struct — value type, no hidden pointer (kind is a public field within this module)
impl Shape {
    fn new(kind: &str) -> Self { Shape { kind: kind.into() } }   // constructor ↔ associated function (kind is the parameter)
    fn get_kind(&self) -> &str { &self.kind }
}
let b = Box::new(Shape::new("circle"));   // heap allocation is explicit (Box); "circle" shown explicitly
println!("{}", b.get_kind());   // circle
```

Pascal

```pascal
TShape = class   // the type — declared here for this row (FKind is private; AKind is Create's parameter)
  private FKind: string;
  public constructor Create(AKind: string); function GetKind: string; end;
constructor TShape.Create(AKind: string); begin FKind := AKind; end;   // heap object behind a reference — Create always allocates (AKind is the parameter)
function TShape.GetKind: string; begin Result := FKind; end;   // public read access to the private field
var b: TShape;   // an instance of that class — declared here for this row
begin b := TShape.Create('circle');   // 'circle' is shown explicitly as the argument
  WriteLn(b.GetKind);   // circle
  b.Free; end.
```

Delphi's `Create` always allocates on the **heap** — the variable holds a reference; Rust has no implicit heap: `Shape::new(...)` returns an owned value, you opt into the heap with `Box`. Delphi frees with `Free`; Rust drops when the value leaves scope (next row).

Finalizer ↔ destructor. Verified on both sides (`destroying circle` / `dropping circle`).

Rust

```rust
struct Shape { kind: String }   // from the previous row — re-declared here so this row stands alone
impl Drop for Shape {
    fn drop(&mut self) { println!("dropping {}", self.kind); }
}
let b = Box::new(Shape { kind: "circle".into() });   // an instance — declared here for this row (value shown explicitly)
drop(b);   // → dropping circle — runs automatically when the value is dropped (or explicitly via drop)
```

Pascal

```pascal
TShape = class   // from the previous row — re-declared here so this row stands alone (FKind is private; AKind is the parameter)
  private FKind: string;
  public constructor Create(AKind: string); destructor Destroy; override; end;
constructor TShape.Create(AKind: string); begin FKind := AKind; end;
destructor TShape.Destroy;   // the finalizer — runs when Free is called (FKind is visible inside the type)
begin WriteLn('destroying ', FKind); inherited Destroy; end;
var b: TShape;   // an instance — declared here for this row
begin b := TShape.Create('circle');   // shown explicitly
  b.Free;   // → destroying circle (the finalizer runs now)
end.
```

Caveats & cautions

Delphi finalization is **manual** and order-dependent (forget `Free` → leak); Rust's `drop` runs deterministically at end of scope (or explicitly via `drop(b)`). No double-free: moving a value invalidates the source.

### Visibility

Visibility sections ↔ per-item `pub`. Verified on both sides (getter works; direct field access rejected in Rust).

Rust

```rust
struct TBox { f_val: i32 }        // no pub → private to this module (declared here for this row)
impl TBox { fn new(v: i32) -> Self { TBox { f_val: v } }   // the only way to set the private field — from inside the type (v is the parameter)
    pub fn get(&self) -> i32 { self.f_val } }
let tb = TBox::new(7);   // an instance — declared here for this row (value shown explicitly)
println!("{}", tb.get());   // OK — 7, through the public method
// let _v = tb.f_val;   // E0616 from a sibling module — hard compile error (allowed here: same module)
```

Pascal

```pascal
TBox = class   // the type — declared here for this row (FVal is private: only code inside TBox can touch it; v is Create's parameter)
  private FVal: Integer;
  public constructor Create(v: Integer); function Get: Integer; end;
constructor TBox.Create(v: Integer); begin FVal := v; end;   // the only way to set the private field — from inside the type
function TBox.Get: Integer; begin Result := FVal; end;
var b: TBox;   // an instance — declared here for this row
begin b := TBox.Create(7);   // shown explicitly
  WriteLn(b.Get);    // OK — 7, through the public method
  // WriteLn(b.FVal);   // E2397 in Delphi — access to a private member not allowed (compile error)
  b.Free; end.
```

Caveats & cautions

Delphi enforces class visibility **everywhere** (`b.FVal` is a compile error, E2397); FPC only across units — same-unit access compiles, cross-unit fails (both verified). Rust privacy is per-**module**, not per-type: child modules see their parent's private items by design; siblings cannot (E0616 verified). `protected` has no Rust counterpart — descendants get nothing special.

`published` section — members exposed to the IDE/RTTI. Verified on FPC (`name = btn`).

Rust

```rust
// No counterpart — Rust has no RTTI/reflection in std:
struct Widget { name: String }   // declared here for this row
impl Widget { pub fn new(n: &str) -> Self { Widget { name: n.into() } }   // n is the parameter
    pub fn name(&self) -> &str { &self.name } }
let w = Widget::new("btn");   // an instance — declared here for this row (value shown explicitly)
println!("{}", w.name());   // btn
```

Pascal

```pascal
TWidget = class   // the type — declared here for this row (FName is private; AName is Create's parameter)
  private FName: string;
  public constructor Create(AName: string);
  published property Name: string read FName write FName; end;   // published = RTTI-exposed in Delphi (IDE, streaming)
constructor TWidget.Create(AName: string); begin FName := AName; end;
var w: TWidget;   // an instance — declared here for this row
begin w := TWidget.Create('btn');   // shown explicitly
  WriteLn(w.Name);   // btn — read through the published property (getter = FName)
  w.Free; end.
```

Delphi generates RTTI for published members (design-time tools, DFM streaming); Rust has no equivalent in std — metadata is manual or via external derive crates (out of scope here).

### Methods & static methods

A method on an instance. Verified on both sides (`kind = circle`).

Rust

```rust
struct Shape { kind: String }   // from the previous rows — re-declared here so this row stands alone
impl Shape { fn get_kind(&self) -> &str { &self.kind } }   // a method on an instance — Rust spells out the receiver (&self)
let b = Shape { kind: "circle".into() };   // an instance — declared here for this row (value shown explicitly)
println!("{}", b.get_kind());   // circle
```

Pascal

```pascal
TShape = class   // from the previous rows — re-declared here so this row stands alone (FKind is private; AKind is the parameter)
  private FKind: string;
  public constructor Create(AKind: string); function GetKind: string; end;
constructor TShape.Create(AKind: string); begin FKind := AKind; end;
function TShape.GetKind: string;   // a method on an instance — Delphi passes Self implicitly (FKind is visible inside the type)
begin Result := FKind; end;
var b: TShape;   // an instance — declared here for this row
begin b := TShape.Create('circle');   // shown explicitly
  WriteLn(b.GetKind);   // circle
  b.Free; end.
```

Caveats & cautions

Delphi methods implicitly take `Self`; Rust spells out the receiver — `&self` (read), `&mut self` (write), or by-value `self` (consumes). Omitting it is a compile error, not a runtime surprise.

A static method callable without an instance. Verified on both sides (`static area = 12.57`).

Rust

```rust
struct Shape;   // an empty struct stands in for the class — declared here for this row (no instance state needed)
impl Shape { fn area_of(radius: f64) -> f64 { std::f64::consts::PI * radius * radius } }   // associated function (radius is the parameter, no self)
println!("{}", Shape::area_of(2.0));   // 12.57 — called on the type, no instance needed
```

Pascal

```pascal
TShape = class   // declared here for this row (the static method needs a class to live in; ARadius is its parameter — no Self involved)
  public class function AreaOf(ARadius: Double): Double; end;
class function TShape.AreaOf(ARadius: Double): Double;
begin Result := Pi * ARadius * ARadius; end;   // body shown explicitly
WriteLn(TShape.AreaOf(2.0));   // 12.57 — called on the type, no instance needed (2.0 shown explicitly)
```

Delphi's `class function` can still read class variables; Rust's associated functions are just free functions scoped to the type — no hidden state unless you pass it in.

Method overloading by arity. Verified on both sides (`calc1 = 42`, `calc2 = 42`).

Rust

```rust
fn calc_one(a: i32) -> i32 { a * 2 }        // no overloading — different names (a is the parameter)
fn calc_two(a: i32, b: i32) -> i32 { a + b }   // a and b are the parameters
println!("{}", calc_one(21));      // 42 = 21*2 (argument shown explicitly)
println!("{}", calc_two(20, 22));  // 42 = 20+22
```

Pascal

```pascal
TWidget = class   // the type — declared here for this row (the overloads live inside it; A and B are the parameters)
  public function Calc(A: Integer): Integer; overload;   // first overload, one parameter
  function Calc(A, B: Integer): Integer; overload;   // second overload, two parameters — same name
end;
function TWidget.Calc(A: Integer): Integer; begin Result := A * 2; end;   // body shown explicitly
function TWidget.Calc(A, B: Integer): Integer; begin Result := A + B; end;   // body shown explicitly
var w: TWidget;   // an instance — declared here for this row
begin w := TWidget.Create;
  WriteLn(w.Calc(21));      // 42 = 21*2 — resolves to the one-parameter overload (argument shown explicitly)
  WriteLn(w.Calc(20, 22));  // 42 = 20+22 — resolves to the two-parameter overload
  w.Free; end.
```

Caveats & cautions

Rust has **no** method/function overloading — pick different names or use generics; the compiler never resolves call ambiguity for you.

### Properties

A property with getter/setter. Verified on both sides (`kind2 = square`).

Rust

```rust
struct Shape { kind: String }   // the "class" from the previous rows — re-declared here so this row stands alone
impl Shape {
    fn get_kind(&self) -> &str { &self.kind }                    // getter (self is the receiver)
    fn set_kind(&mut self, k: String) { self.kind = k; }         // setter (k is the parameter — in scope inside the body)
}
let mut c = Shape { kind: "circle".into() };   // an instance — declared here for this row (needs let mut: the setter writes through it)
println!("{}", c.get_kind());                 // circle
c.set_kind("square".into());  // square — the new value is shown explicitly
```

Pascal

```pascal
TShape = class   // the type — declared here for this row (FKind is private; AKind is the parameter of Create/SetKind)
  private FKind: string;
  public constructor Create(AKind: string); function GetKind: string; procedure SetKind(const AKind: string);
  property Kind: string read GetKind write SetKind; end;   // the property — declared inside the class
constructor TShape.Create(AKind: string); begin FKind := AKind; end;
function TShape.GetKind: string; begin Result := FKind; end;   // getter body shown explicitly
procedure TShape.SetKind(const AKind: string); begin FKind := AKind; end;   // setter body shown explicitly
var b: TShape;   // an instance — declared here for this row
begin b := TShape.Create('circle');   // shown explicitly
  WriteLn(b.Kind);            // circle (getter)
  b.Kind := 'square';   // square (setter) — the new value is shown explicitly
  WriteLn(b.Kind);            // square
  b.Free; end.
```

Delphi properties are transparent sugar over methods; Rust has no property keyword — just two methods (or a public field if you need no logic). No default values, no side effects hidden in the syntax.

An indexed property ↔ `Index`/`IndexMut` traits. Verified on both sides (`item[1] = b`, `item[2] = z`).

Rust

```rust
use std::ops::{Index, IndexMut};   // the traits being implemented — declared here for this row
struct Items(Vec<String>);   // a tuple struct holding the list — declared here for this row (.0 is its field)
impl Index<usize> for Items { type Output = String; fn index(&self, i: usize) -> &String { &self.0[i] } }   // read (i is the parameter)
impl IndexMut<usize> for Items { fn index_mut(&mut self, i: usize) -> &mut String { &mut self.0[i] } }   // write
let mut items = Items(vec!["a".into(), "b".into(), "c".into()]);   // an instance with 3 slots — declared here for this row (values shown explicitly)
println!("{}", items[1]);            // b — same [] syntax as Delphi's indexed property
items[2] = "z".into();   // write through the index (IndexMut) — the new value is shown explicitly
```

Pascal

```pascal
TItems = class   // the type — declared here for this row (FList is private; ACount/AIndex/AValue are parameters)
  private FList: array of string;
  public constructor Create(ACount: Integer); function GetItem(AIndex: Integer): string; procedure SetItem(AIndex: Integer; const AValue: string);
  property Item[AIndex: Integer]: string read GetItem write SetItem; end;   // the indexed property — declared inside the class
constructor TItems.Create(ACount: Integer); begin SetLength(FList, ACount); end;
function TItems.GetItem(AIndex: Integer): string; begin Result := FList[AIndex]; end;   // getter body shown explicitly
procedure TItems.SetItem(AIndex: Integer; const AValue: string); begin FList[AIndex] := AValue; end;   // setter body shown explicitly
var items: TItems;   // an instance — declared here for this row
begin items := TItems.Create(3);   // 3 slots (ACount = 3, shown explicitly)
  items.Item[0] := 'a'; items.Item[1] := 'b'; items.Item[2] := 'c';   // the starting values, shown explicitly
  WriteLn(items.Item[1]);          // b
  items.Item[2] := 'z';  // setter with index — the new value is shown explicitly
  WriteLn(items.Item[2]);   // z
  items.Free; end.
```

Caveats & cautions

Delphi's index type is arbitrary; Rust's key can be any type too — but reads go through `Index` and writes require a **separate** `IndexMut`. Out-of-range panics in both.

### Inheritance & virtual dispatch

Single inheritance with an explicit `inherited` constructor call. Verified on both sides (`kind = circle`).

Rust

```rust
struct Circle { shape: Shape }          // composition — no "class(TShape)"
impl Circle { fn new() -> Self { Circle { shape: Shape::new("circle") } } }  // base init = field init
```

Pascal

```pascal
TCircle = class(TShape)
  public constructor Create; procedure Draw; override; end;
constructor TCircle.Create;
begin inherited Create('circle'); end;   // base init called explicitly
```

Rust has **no** inheritance — composition (embed the base as a field) + traits for shared behavior; there is no `inherited` keyword, base state lives in your fields. Delphi's single-inheritance hierarchy ↔ "one struct owns another".

Virtual method dispatch through a base-type pointer. Verified on both sides (`draw: circle`).

Rust

```rust
trait Draw { fn draw(&self); }                    // interface with no default body
impl Draw for Circle { fn draw(&self) { println!("draw: {}", self.kind); } }
let b: Box<dyn Draw> = Box::new(Circle::new());   // trait object ≈ class reference to a descendant
b.draw();                                          // draw: circle — dynamic dispatch via vtable
```

Pascal

```pascal
procedure Draw; virtual; abstract;   // declared in TShape
procedure TCircle.Draw; begin WriteLn('draw: ', Self.GetKind); end;
b.Draw;   // draw: circle — resolved at runtime via the vtable
```

Delphi's virtual table is per-class and inherited; Rust's `dyn Trait` carries its own vtable — the "base type" is the trait, not a parent class. A non-virtual Delphi method binds statically (like calling an inherent method directly); only `virtual` methods dispatch dynamically.

An abstract method that forces implementation. Verified on both sides (FPC compiles with a warning; Delphi errors E2354).

Rust

```rust
trait Draw { fn draw(&self); }   // no default body → implementors MUST provide it
// there is no way to create a bare Draw value — only concrete types behind dyn
```

Pascal

```pascal
TShape = class public procedure Draw; virtual; abstract; end;
b := TShape.Create;   // E2354 in Delphi — cannot instantiate an abstract class
```

FPC only **warns** when instantiating an abstract class (verified on 3.2.2 and 3.3.1); Delphi rejects it at compile time — the sheet documents Delphi's behavior. In Rust, "abstract" = a trait method without a default body; you cannot instantiate a trait in the first place.

The memory-safe and unsafe forms of calling a method. Verified on both sides (`draw: circle`).

Rust

```rust
let c = Box::new(Circle::new());
c.draw();                              // safe path — borrow-checked, lifetime-tracked
unsafe {
    let raw: *const Circle = &*c;      // raw pointer — no checks, caller's responsibility
    (*raw).draw();                     // draw: circle — same vtable call
}
```

Pascal

```pascal
b.Draw;   // class references are already pointers under the hood — no safe/unsafe split
```

Delphi class references are raw pointers with no safe/unsafe distinction; Rust splits the world: `&T`/`Box<T>` (checked) vs `*const T`/`*mut T` (unchecked, inside `unsafe`). Dangling/double-free is on you in unsafe — exactly what Delphi's manual memory management always was.

### Operator overloading

Binary arithmetic operators. Verified on both sides (`add = 10`, `sub = 4`, `mul = 21`, `div = 2`, `mod = 1`).

Rust

```rust
use std::ops::{Add, Sub, Mul, Div, Rem};
impl Add for Flag { type Output = Flag; fn add(self, o: Flag) -> Flag { Flag { bits: self.bits + o.bits } } }
impl Sub for Flag { type Output = Flag; fn sub(self, o: Flag) -> Flag { Flag { bits: self.bits - o.bits } } }
impl Mul for Flag { type Output = Flag; fn mul(self, o: Flag) -> Flag { Flag { bits: self.bits * o.bits } } }
impl Div for Flag { type Output = Flag; fn div(self, o: Flag) -> Flag { Flag { bits: self.bits / o.bits } } }   // integer division ↔ Delphi Div
impl Rem for Flag { type Output = Flag; fn rem(self, o: Flag) -> Flag { Flag { bits: self.bits % o.bits } } }    // ↔ Delphi Mod
(a + b).bits    // 10 from (7)+(3)
```

Pascal

```pascal
class operator Add(F1, F2: TFlag): TFlag;          // declared inside the record
class operator Subtract(F1, F2: TFlag): TFlag;
class operator Multiply(F1, F2: TFlag): TFlag;
class operator IntDivide(F1, F2: TFlag): TFlag;    // div
class operator Modulus(F1, F2: TFlag): TFlag;      // mod
(a + b).FBits   // 10 from (7)+(3)
```

Delphi's operator identifiers are fixed names (Add, Subtract, Multiply, Divide, IntDivide, Modulus); Rust has one trait per symbol. Delphi's `/` ↔ Rust `Div` on floats; integer division is `IntDivide` in Delphi but plain `Div` in Rust.

Bitwise and shift operators. Verified on both sides (`and = 3`, `or = 7`, `xor = 4`, `shl = 28`, `shr = 1`).

Rust

```rust
impl BitAnd for Flag { type Output = Flag; fn bitand(self, o: Flag) -> Flag { Flag { bits: self.bits & o.bits } } }
impl BitOr for Flag { type Output = Flag; fn bitor(self, o: Flag) -> Flag { Flag { bits: self.bits | o.bits } } }
impl BitXor for Flag { type Output = Flag; fn bitxor(self, o: Flag) -> Flag { Flag { bits: self.bits ^ o.bits } } }
impl Shl<usize> for Flag { type Output = Flag; fn shl(self, n: usize) -> Flag { Flag { bits: self.bits << n } } }   // shift amount is usize
impl Shr<usize> for Flag { type Output = Flag; fn shr(self, n: usize) -> Flag { Flag { bits: self.bits >> n } } }
(a & b).bits   // 3
(a << 2).bits  // 28
```

Pascal

```pascal
class operator BitwiseAnd(F1, F2: TFlag): TFlag;   // and
class operator BitwiseOr(F1, F2: TFlag): TFlag;    // or
class operator BitwiseXor(F1, F2: TFlag): TFlag;   // xor
class operator LeftShift(F: TFlag; N: Integer): TFlag;   // shl — mixed operand OK
class operator RightShift(F: TFlag; N: Integer): TFlag;  // shr
(a and b).FBits   // 3
(a shl 2).FBits   // 28
```

Caveats & cautions

Delphi distinguishes Logical\* (boolean operands) from Bitwise\*; Rust has one set of traits. Shift amount is `Integer` in Delphi, **`usize`** in Rust — a negative shift behaves differently / panics.

Comparison operators. Verified on both sides (`lt = False`, `gt = True`, `eq = False`, `neq = True`).

Rust

```rust
impl PartialEq for Flag { fn eq(&self, o: &Flag) -> bool { self.bits == o.bits } }   // == and !=
impl PartialOrd for Flag { fn partial_cmp(&self, o: &Flag) -> Option<Ordering> { Some(self.bits.cmp(&o.bits)) } }   // < <= > >=
a < b    // false
a == b   // false
```

Pascal

```pascal
class operator LessThan(F1, F2: TFlag): Boolean;      // <
class operator GreaterThan(F1, F2: TFlag): Boolean;   // >
class operator Equal(F1, F2: TFlag): Boolean;         // =
class operator NotEqual(F1, F2: TFlag): Boolean;      // <>
a < b    // False
a = b    // False
```

Caveats & cautions

Delphi's comparison operators must return **Boolean**; Rust splits them into two traits (PartialEq for equality, PartialOrd for ordering) and the symbols are sugar over methods. Booleans print as `True/False` vs `true/false`.

Unary minus and NOT. Verified on both sides (`neg = -5`, `not = -6`).

Rust

```rust
impl Neg for Flag { type Output = Flag; fn neg(self) -> Flag { Flag { bits: -self.bits } } }   // unary -
impl Not for Flag { type Output = Flag; fn not(self) -> Flag { Flag { bits: !self.bits } } }   // !
(-f).bits   // -5 from (5)
(!f).bits   // -6
```

Pascal

```pascal
class operator Negative(F: TFlag): TFlag;    // unary -
class operator LogicalNot(F: TFlag): TFlag;  // not
(-f).FBits     // -5 from (5)
(not f).FBits  // -6
```

Delphi's full unary set also includes Positive, Inc, Dec, Trunc, Round — Rust has no counterparts for those (use methods).

Implicit/explicit conversion operators. Verified on FPC (`implicit = 42`, `explicit = 3`).

Rust

```rust
// No counterpart — Rust has no implicit conversions, ever:
let f = Flag { bits: 42 };           // explicit construction
let g = Flag::from(3.9_f64 as i32);  // manual, always spelled out
```

Pascal

```pascal
class operator Implicit(A: Integer): TFlag;   // implicit typecast
class operator Explicit(A: Double): TFlag;    // explicit typecast
f := 42;          // calls Implicit — no cast syntax needed
f := TFlag(3.9);  // calls Explicit — ordinary typecast syntax
```

Rust's type system has **no** implicit conversions — every conversion is explicit (`.into()`, `From`/`TryFrom`, casts). Delphi's `Implicit` operator is the one place values convert silently; don't expect it in Rust.

## 14. Exceptions

### Raising & catching

Raising a typed error. Verified on both sides (`caught custom: negative index`).

Rust

```rust
#[derive(Debug)] struct MyError(String);        // custom error type ↔ exception class
impl std::fmt::Display for MyError { fn fmt(&self, f: &mut std::fmt::Formatter<'_'>) -> std::fmt::Result { write!(f, "{}", self.0) } }   // message ↔ E.Message (fully qualified — no use statement needed)
impl std::error::Error for MyError {}
fn do_work(index: i32) -> Result<(), MyError> {   // "raise" = returning Err — the idiomatic path
    if index < 0 { return Err(MyError("negative index".into())); } Ok(())
}
```

Pascal

```pascal
EMyError = class(Exception);   // custom exception class
procedure DoWork(AIndex: Integer);
begin if AIndex < 0 then raise EMyError.Create('negative index'); end;
```

Caveats & cautions

Delphi's `raise` throws an object that unwinds the stack; Rust's idiom is to **return** `Err` — no unwinding, the caller must check (or use `?`). The exception-style equivalent is `panic!`, which does unwind but is meant for bugs, not flow control.

Catching with type-specific handlers. Verified on both sides (`caught custom: negative index`).

Rust

```rust
#[derive(Debug)] struct MyError(String);   // from the row above — re-declared here so this row stands alone (self.0 is its field)
impl std::fmt::Display for MyError { fn fmt(&self, f: &mut std::fmt::Formatter<'_'>) -> std::fmt::Result { write!(f, "{}", self.0) } }
impl std::error::Error for MyError {}
fn do_work(index: i32) -> Result<(), MyError> { if index < 0 { return Err(MyError("negative index".into())); } Ok(()) }   // same body as the row above (index is its parameter)
match do_work(-1) {   // -1 shown explicitly — it selects the error path
    Ok(()) => println!("ok"),
    Err(e) => println!("caught custom: {}", e),   // typed catch — no exception machinery needed (e is bound by this arm)
}
// exception-style equivalent: std::panic::catch_unwind(|| panic!("boom")).is_err() + downcast the payload
```

Pascal

```pascal
EMyError = class(Exception);   // from the row above — re-declared here so this row stands alone
procedure DoWork(AIndex: Integer); begin if AIndex < 0 then raise EMyError.Create('negative index'); end;   // same body as the row above (AIndex is its parameter)
try DoWork(-1);   // -1 shown explicitly — it selects the raising path
except
  on E: EMyError do WriteLn('caught custom: ', E.Message);   // most specific first
  on E: Exception do WriteLn('caught generic: ', E.Message); // fallback handler
end;
```

Caveats & cautions

Delphi matches by **class hierarchy** (a descendant exception hits an ancestor's handler); Rust's `match` is exhaustive and structural — no inheritance-based dispatch, so model many error kinds as one enum if you want a single catch site.

### Cleanup & propagation

Guaranteed cleanup on every exit path. Verified on both sides (`work` → `cleanup`, with or without an exception).

Rust

```rust
fn raise(msg: &str) -> ! {   // exception-style panic helper — declared here for this row (never returns; String payload like Delphi's exception object)
    let m = msg.to_string();
    panic!("{}", m);
}
// do_work is declared in the first row of this section (returns Err(MyError) for negative indices):
struct Guard;                                  // finally ↔ Drop — cleanup bound to scope lifetime (declared here for this row)
impl Drop for Guard { fn drop(&mut self) { println!("cleanup"); } }
let r = std::panic::catch_unwind(|| {   // the catcher — declared here for this row (r holds Ok/Err of the block)
    let _g = Guard;                          // "finally" registered for this block
    println!("work");
    if do_work(-3).is_err() { raise("negative index"); }   // -3 shown explicitly — it selects the error path; panic unwinds through the scope
});
if r.is_err() { println!("except caught: negative index"); }
```

Pascal

```pascal
// DoWork (raises EMyError for negative indices) is declared in the first row of this section:
try
  try WriteLn('work'); DoWork(-3);   // -3 shown explicitly — it selects the raising path; the outer finally must still run
  except on E: Exception do WriteLn('except caught: ', E.Message); end;
finally WriteLn('cleanup');
end;
```

**Order differs**: Delphi runs the except handler first, then finally (verified); Rust runs Drop during unwind \*before\* the catcher resumes (verified — `cleanup` prints before `except caught`). FPC does not allow one combined `try..except..finally` statement (rejected on 3.2.2 and 3.3.1) — nest them; Delphi accepts both forms.

Re-raising from a handler. Verified on both sides (`inner caught` → `outer caught`).

Rust

```rust
fn raise(msg: &str) -> ! { let m = msg.to_string(); panic!("{}", m); }   // exception-style panic helper — declared here for this row (same as the row above)
let outer = std::panic::catch_unwind(|| {   // the outer catcher — declared here for this row
    let inner = std::panic::catch_unwind(|| raise("negative index"));   // the inner catcher — declared here for this row (payload is bound by the arm below)
    if let Err(payload) = inner {
        // bare raise ↔ re-panic with the same payload (or simply don't catch at all)
        if let Some(s) = payload.downcast_ref::<String>() { println!("inner caught: {}", s); panic!("{}", s); }   // s is bound by this arm
    }
});
if let Err(payload) = outer { if let Some(s) = payload.downcast_ref::<String>() { println!("outer caught: {}", s); } }   // payload + s are bound by these arms
```

Pascal

```pascal
try
  try DoWork(-2);
  except on E: Exception do begin WriteLn('inner caught: ', E.Message); raise; end;   // bare raise forwards it outward
  end;
except on E: Exception do WriteLn('outer caught: ', E.Message);
end;
```

Caveats & cautions

In Rust panics propagate **automatically** through every frame — no re-raise needed; catching is opt-in via `catch_unwind`. Delphi's bare `raise` inside an except forwards the original exception (with its context); in Rust you must explicitly re-panic with the payload.

## 15. Namespaces: Delphi units ↔ Rust modules

### Units ↔ modules

A unit (one file with an interface/implementation split) ↔ a module. Verified on both sides (`point (3,4)` / `point (3, 4)`).

Rust

```rust
mod s13u {
    pub struct TPoint { pub x: i32, pub y: i32 }
    pub fn make_point(x: i32, y: i32) -> TPoint { TPoint { x, y } }
}
```

Pascal

```pascal
unit S13U;
interface
  type TPoint = record X, Y: Integer; end;
  function MakePoint(AX, AY: Integer): TPoint;
  implementation
  function MakePoint(AX, AY: Integer): TPoint;
  begin Result.X := AX; Result.Y := AY; end;
```

Delphi's unit is the compilation and visibility boundary; Rust's module can be inline or in its own file — same tree semantics either way. Delphi has **no nested units**; Rust module trees are arbitrarily deep.

Importing a namespace's names. Verified on both sides (unqualified calls work).

Rust

```rust
use s13u::*;
let q = make_point(7, 8);   // unqualified name after use
```

Pascal

```pascal
uses S13U;   // the unit from the row above — its interface names are now in scope
var p: TPoint;   // the result variable — declared here for this row (TPoint is defined inside that unit)
begin p := MakePoint(3, 4);   // unqualified name after uses (3, 4 shown explicitly)
end.
```

Delphi's `uses` is declared at the top of the unit/program and brings **all** interface names into scope; Rust's `use` can appear anywhere (even inside functions) and imports only what you name — `s13u::*` for everything.

Qualified (namespaced) access. Verified on both sides (`qualified: 5`).

Rust

```rust
s13u::make_point(5, 6).x   // 5 — qualified path; works even with no import at all
```

Pascal

```pascal
S13U.MakePoint(5, 6).X   // 5 — qualified access via the unit name
```

In Rust a path is always available once the module exists — no import needed; Delphi requires the unit to be in scope before you can name it, qualified or not.

Hiding implementation details. Verified on both sides (both rejected at compile time).

Rust

```rust
mod a { fn hidden() -> i32 { 42 } }
a::hidden();   // E0603: function is private (verified)
```

Pascal

```pascal
function HiddenHelper(A: Integer): Integer;   // declared only after implementation
WriteLn(HiddenHelper(21));   // from another unit: compile error — Identifier not found (verified)
```

Delphi's visibility split is the interface/implementation boundary — everything in `interface` is visible to **every** consumer, with no per-item control; Rust items are **private by default**, each needs its own `pub`. The implementation section ≈ non-pub items.

## 16. Containers

### List ↔ Vec

An ordered list of values. Verified on both sides (`list count = 3`, `list[1] = 20`).

Rust

```rust
let mut l = Vec::new();
l.push(10); l.push(20); l.push(30);
println!("{} {}", l.len(), l[1]);   // 3 20
```

Pascal

```pascal
var L: TList<Integer>;   // the list object — declared here for this row (Delphi's generic list)
begin L := TList<Integer>.Create;
  try L.Add(10); L.Add(20); L.Add(30);   // the values, shown explicitly
    WriteLn(L.Count, ' ', L[1]);   // 3 20
  finally L.Free; end.
end.
```

Caveats & cautions

TList is a heap object — you must `Free` it (leak if forgotten); Vec owns its memory and frees automatically at end of scope. Booleans print as `True/False` vs `true/false`.

Removal by index. Verified on both sides (`after delete: 20 count=2`).

Rust

```rust
let mut l = vec![10, 20, 30];   // from the row above — re-declared here so this row stands alone (starting values shown explicitly)
l.remove(0);   // remove by index
println!("{} {}", l[0], l.len());   // 20 2
```

Pascal

```pascal
var L: TList<Integer>;   // from the row above — re-declared here so this row stands alone
begin L := TList<Integer>.Create; L.Add(10); L.Add(20); L.Add(30);   // the starting values, shown explicitly (from the row above)
  L.Delete(0);   // remove by index
  WriteLn(L[0], ' ', L.Count);   // 20 2
  L.Free; end.
```

Caveats & cautions

Both shift the tail left — O(n). Invalid operations raise at runtime in Delphi (e.g., `Dequeue` from an empty queue, verified); Rust returns `Option`/panics instead of raising.

### Dictionary ↔ HashMap/BTreeMap

A key→value map. Verified on both sides (`dict a = 1`, `contains c`).

Rust

```rust
let mut d: HashMap<String, i32> = HashMap::new();
d.insert("a".into(), 1); d.insert("b".into(), 2);
println!("{} {}", d["a"], d.contains_key("c"));   // 1 false
```

Pascal

```pascal
var D: TDictionary<String, Integer>;   // the dictionary object — declared here for this row (Delphi's generic map)
begin D := TDictionary<String, Integer>.Create;
  try D.Add('a', 1); D.Add('b', 2);   // the key/value pairs, shown explicitly
    WriteLn(D['a'], ' ', D.ContainsKey('c'));   // 1 False — 'c' is the probed key, shown explicitly
  finally D.Free; end.
end.
```

Caveats & cautions

TDictionary is **unordered** — like HashMap; use BTreeMap for sorted keys (Delphi has no built-in ordered dictionary). Duplicate key: Delphi's `Add` **raises** (verified); Rust's `insert` silently overwrites (verified).

### Set ↔ BTreeSet/HashSet

A collection of unique values. Verified on both sides (`set count = 3`, `has 2`).

Rust

```rust
let mut s: BTreeSet<i32> = [1, 2, 3, 2].into_iter().collect();   // duplicate ignored
println!("{} {}", s.len(), s.contains(&2));   // 3 true
```

Pascal

```pascal
var S: TSet<Integer>;   // the set object — declared here for this row (Delphi's generic set)
begin S := TSet<Integer>.Create;
  try S.Add(1); S.Add(2); S.Add(3); S.Add(2);   // the values, shown explicitly (the last 2 is the duplicate — ignored)
    WriteLn(S.Count, ' ', S.Contains(2));   // 3 True — 2 is the probed value, shown explicitly
  finally S.Free; end.
end.
```

BTreeSet iterates in sorted order; HashSet is unordered — pick like HashMap vs BTreeMap. Delphi's `TSet.Add` returns False for duplicates (ignored); Rust dedupes silently.

### Queue & Stack ↔ VecDeque / Vec

A FIFO queue. Verified on both sides (`queue front = 1`).

Rust

```rust
let mut q: VecDeque<i32> = VecDeque::new();
q.push_back(1); q.push_back(2);
println!("{}", q.pop_front().unwrap());   // 1 — front first (FIFO)
```

Pascal

```pascal
var Q: TQueue<Integer>;   // the queue object — declared here for this row (Delphi's generic FIFO)
begin Q := TQueue<Integer>.Create;
  try Q.Enqueue(1); Q.Enqueue(2);   // the values, shown explicitly (in enqueue order)
    WriteLn(Q.Dequeue);   // 1 — front first (FIFO)
  finally Q.Free; end.
end.
```

Caveats & cautions

Empty pop: Delphi raises at runtime (verified); Rust returns `None` — handle it or let `unwrap` panic.

A LIFO stack. Verified on both sides (`stack top = 2`).

Rust

```rust
let mut st = Vec::new();
st.push(1); st.push(2);
println!("{}", st.pop().unwrap());   // 2 — last in, first out (LIFO)
```

Pascal

```pascal
var St: TStack<Integer>;   // the stack object — declared here for this row (Delphi's generic LIFO)
begin St := TStack<Integer>.Create;
  try St.Push(1); St.Push(2);   // the values, shown explicitly (in push order)
    WriteLn(St.Pop);   // 2 — last in, first out (LIFO)
  finally St.Free; end.
end.
```

Rust's Vec is the idiomatic stack — `push`/`pop` at the end; no separate TStack type needed.

## 17. Memory-safe vs unsafe equivalents

Delphi has one world: every pointer, index and call is unchecked by default (checks are optional directives). Rust splits each concept into a safe form and an unsafe escape hatch — this section collects both sides of the split.

### Array access

Checked vs unchecked indexed access. Verified on both sides (both read 20).

Rust

```rust
let d = [10, 20, 30];   // the array — declared here for this row (starting value shown explicitly)
let x = d[1];                        // safe, bounds-checked → 20
let y = unsafe { *d.as_ptr().add(1) };   // raw pointer — no check → 20
```

Pascal

```pascal
var d: array of Integer; i: Integer;   // the array + result variable — both declared here for this row
begin SetLength(d, 3); d[0] := 10; d[1] := 20; d[2] := 30;   // [10, 20, 30] — the starting value, shown explicitly
  WriteLn(d[1]);   // bounds-checked read → 20
  i := PInteger(@d[0])[1];   // unchecked pointer read → 20 (PInteger = ^Integer)
end.
```

Caveats & cautions

Delphi can turn checks off with `{$RANGECHECKS OFF}`; Rust's only escape hatch is `unsafe`. Out-of-range via the raw path reads whatever memory lies there — garbage or AV, formally undefined behavior in Rust.

### Pointers & references

Read/write through an address. Verified on both sides (final value 43).

Rust

```rust
let mut i = 7i32;   // the target value — declared here for this row (starting value shown explicitly)
let p: &mut i32 = &mut i;   *p = 42;            // safe reference — checked borrowing
unsafe { let r = &mut i as *mut i32; *r = 43; }  // raw pointer — unchecked → final value 43 (read back via i)
```

Pascal

```pascal
var i: Integer; p: ^Integer;   // the target value + its pointer — both declared here for this row
begin i := 7;   // shown explicitly (the starting value)
  p := @i; p^ := 42;   // one mechanism for both — Delphi has no safe/unsafe split
  p^ := 43; WriteLn(i);   // 43 — final value, read back through the original variable
end.
```

Delphi has no safe/unsafe split — every pointer is a raw one; Rust splits the world into `&T`/`&mut T` (checked) and `*const T`/`*mut T` (unchecked, inside `unsafe`). Dangling/double-free is on you in unsafe.

### C strings

Pointer to a NUL-terminated buffer. Verified on both sides (72 / `Hello`).

Rust

```rust
let c = CString::new("Hello").unwrap();
let p = unsafe { CStr::from_ptr(c.as_ptr()) };   // raw pointer → safe wrapper
p.to_str().unwrap()   // Hello
```

Pascal

```pascal
var a: AnsiString; p: PAnsiChar;   // the string + its raw pointer — both declared here for this row (PAnsiChar = ^AnsiChar)
begin a := 'Hello';   // shown explicitly (first char H = 72)
  p := PAnsiChar(a); WriteLn(Ord(p^));   // 72 — first byte read through the raw pointer
end.
```

Only the deref of the raw pointer is unsafe — `to_str()`/`to_string_lossy()` are safe. `CString::new` rejects embedded NULs (`Err`). Delphi's copy-until-NUL assignment (`a := p`) has no Rust counterpart — use `.to_string()`.

### FFI calls

Calling into a native library. Verified on both sides against the same FPC-built DLL (42).

Rust

```rust
#[link(name = "extlib")] extern "system" { #[link_name = "AddExt"] fn add_ext(a: i32, b: i32) -> i32; }
unsafe { add_ext(20, 22) }   // 42 — unsafe block required (E0133 without)
```

Pascal

```pascal
function AddExt(a, b: Integer): Integer; external 'extlib.dll' name 'AddExt';
AddExt(20, 22)   // plain call
```

Caveats & cautions

Every call to an imported extern function needs `unsafe` in Rust; Delphi calls are plain. The ABI is spelled out (`extern "system"` = C) vs implicit default `cdecl`. On Windows/MSVC the import library must sit next to the DLL.

### Inline assembly

Machine code inside a function. Verified on both sides (42).

Rust

```rust
fn add_asm(a: i64, b: i64) -> i64 {   // declared here for this row (a and b are the parameters)
    let mut x = a;   // start with the first operand — declared inside the function
    unsafe { asm!("add {x}, {b}", x = inout(reg) x, b = in(reg) b, options(nostack)); }   // real instruction: x := x + b (Intel syntax)
    x   // return the sum
}
println!("{}", add_asm(20, 22));   // 42 — called with explicit arguments
```

Pascal

```pascal
function Add(a, b: Int64): Integer; assembler;   // declared here for this row (a and b are the parameters)
asm
  mov rax, a
  add rax, b
end;   // the body — real instructions, shown explicitly (Intel syntax: destination first)
WriteLn(Add(20, 22));   // 42 — called with explicit arguments
```

Caveats & cautions

Both bypass language safety and are platform-specific; Rust additionally requires `unsafe` (E0133) and explicit operand declarations so it can track register usage. FPC x86\_64 defaults to AT&T syntax (`{$asmmode intel}` for Intel); Delphi Win32 uses Intel by default.

### Object dispatch

Calling a method through an object. Verified on both sides (`draw: circle`).

Rust

```rust
struct Circle;   // the type from §13's hierarchy, re-declared here so this row stands alone (unit struct — no state needed)
impl Circle { fn draw(&self) { println!("draw: circle"); } }   // the method body — shown explicitly
let obj = Box::new(Circle);   // an instance — declared here for this row (heap allocation, like Delphi's Create)
obj.draw();                                    // safe path — borrow-checked
unsafe { let raw: *const Circle = &*obj; (*raw).draw(); }   // raw pointer dispatch (raw is declared inside the unsafe block)
```

Pascal

```pascal
var b: TShape;   // an instance of the §13 class hierarchy (TShape → TCircle) — declared here for this row
begin b := TCircle.Create;   // heap object behind a base-class reference
  b.Draw;   // draw: circle — virtual dispatch through the raw-pointer class reference
  b.Free; end.
```

Delphi class references are always raw pointers — no safe/unsafe distinction; Rust splits them into `&T`/`Box<T>` (checked) vs `*const T` (unchecked). Same vtable call either way.

## 18. Multithreading: threads, interlocked ops (atomics), SyncObjs

Delphi's threading model — TThread objects, Interlocked\* intrinsics, SyncObjs — maps onto Rust's `std::thread`, `std::sync::atomic` and `std::sync`. All rows verified on both sides with identical output.

### Threads (TThread ↔ std::thread)

Spawn a worker thread that runs an overridden method / closure.

Rust

```rust
use std::sync::{atomic::{AtomicI32, Ordering}, Arc};   // the shared-state machinery — declared here for this row (the Interlocked* equivalents)
use std::thread;
let c = Arc::new(AtomicI32::new(9));   // the shared counter — declared here for this row (starts at 9 to match the Pascal side's state after its interlocked rows)
let mut hs = Vec::new();               // the thread handles — declared here for this row
for _ in 0..4 {                        // spawn 4 workers, like the Pascal loop above
    let cc = Arc::clone(&c);           // a clone of the shared counter for this worker (cc is declared inside the loop)
    hs.push(thread::spawn(move || {   // the closure — its body is the Execute equivalent from the row above
        for _ in 0..100_000 { cc.fetch_add(1, Ordering::SeqCst); }
    }));
}
```

Pascal

```pascal
var Counter: Integer;   // the shared state — declared here for this row (touched only via Interlocked*)
Threads: array[1..4] of TThread; i: Integer;   // the thread pool + loop variable — both declared here for this row
type TIncThread = class(TThread)
  procedure Execute; override;
end;
procedure TIncThread.Execute;
var i: Integer;
begin for i := 1 to 100000 do InterlockedIncrement(Counter); end;   // the work — Counter is visible from here (it is a global)
begin
  for i := 1 to 4 do Threads[i] := TIncThread.Create(False);   // suspended
  for i := 1 to 4 do Threads[i].Start;                          // run them
end.
```

Caveats & cautions

Pascal threads are objects — subclass `TThread`, override `Execute`; Rust is just a closure passed to `thread::spawn`. The Rust closure must be `'static`: shared state goes through `Arc` (plain borrows fail with E0597); Pascal can touch globals directly.

Block until the thread finishes, then release it.

Rust

```rust
let mut hs = Vec::new();   // from the row above — re-declared here so this row stands alone (the handles are already spawned)
for h in hs { h.join().unwrap(); }   // block until each thread finishes, then release it (h is bound by the loop)
```

Pascal

```pascal
var i: Integer; Threads: array[1..4] of TThread;   // from the row above — re-declared here so this row stands alone (the pool is already running)
begin for i := 1 to 4 do begin
    Threads[i].WaitFor;   // block until done
    Threads[i].Free;        // release the object
  end; end.
```

Caveats & cautions

FPC gotcha (verified): `FreeOnTerminate := True` + `WaitFor` is a use-after-free race — the thread frees itself on exit; hang observed. Use create-suspended → `Start` → `WaitFor` → `Free`. Rust's `join()` returns the closure's return value and panics if the thread panicked.

Suspend the current thread for N milliseconds.

Rust

```rust
thread::sleep(Duration::from_millis(200));
```

Pascal

```pascal
TThread.Sleep(200);   // Delphi: Windows unit Sleep also works
```

Millisecond granularity on both sides — a scheduling hint, not a precise timer.

### Interlocked ops ↔ std::sync::atomic

Atomic add; both return the previous value. Verified on both sides (0 → 1).

Rust

```rust
let counter = AtomicI32::new(0);   // the shared atomic — declared here for this row (the Interlocked* target; starts at 0, shown explicitly)
println!("{}", counter.fetch_add(1, Ordering::SeqCst));   // returns old value (0)
println!("after inc = {}", counter.load(Ordering::SeqCst));   // after inc = 1
```

Pascal

```pascal
var Counter: Integer;   // the shared global — declared here for this row (touched only via Interlocked*)
begin WriteLn(InterlockedIncrement(Counter));   // returns old value (0)
  WriteLn('after inc = ', Counter);   // after inc = 1
end.
```

Delphi's Interlocked\* are always full memory barriers → `Ordering::SeqCst` is the faithful match; Rust allows weaker orderings (`Relaxed`, …) for performance when you can prove safety.

Atomically set a new value and return the old one. Verified on both sides (ret 1 → now 5).

Rust

```rust
let counter = AtomicI32::new(1);   // the shared atomic — declared here for this row (starts at 1 — the value left by the previous row, shown explicitly)
println!("exchange ret = {}", counter.swap(5, Ordering::SeqCst));   // old value: 1 (new value 5, shown explicitly)
println!("after exchange = {}", counter.load(Ordering::SeqCst));     // after exchange = 5
```

Pascal

```pascal
var Counter: Integer;   // the shared global — declared here for this row (the one from the rows above)
begin Counter := 1;   // the value left by the previous row — shown explicitly
  WriteLn('exchange ret = ', InterlockedExchange(Counter, 5));   // returns old value: 1 (new value 5, shown explicitly)
  WriteLn('after exchange = ', Counter);                          // after exchange = 5
end.
```

Compare-and-swap: set a new value only if the current one equals an expected value. Verified on both sides (5 → 9).

Rust

```rust
let counter = AtomicI32::new(5);   // the shared atomic — declared here for this row (starts at 5 — the value left by the previous row, shown explicitly)
match counter.compare_exchange(5, 9, Ordering::SeqCst, Ordering::SeqCst) {   // expected=5, new=9, both shown explicitly
    Ok(_) => println!("cas ok"),
    Err(actual) => println!("cas fail actual={}", actual),   // actual is bound by this arm
}
```

Pascal

```pascal
var Counter: Integer;   // the shared global — declared here for this row (the one from the rows above)
begin Counter := 5;   // the value left by the previous row — shown explicitly
  if InterlockedCompareExchange(Counter, 9, 5) = 5 then   // CAS: 5 -> 9 (expected=5, new=9, both shown explicitly)
  WriteLn('cas ok');
end.
```

Delphi returns the old value — success = returned value == expected; Rust returns `Result<old, current>` and hands you the actual value on failure. Both are the building block for lock-free structures.

### SyncObjs ↔ std::sync

Mutual exclusion around non-atomic shared state. Verified on both sides (2 threads × 50 000 → exactly 100 000).

Rust

```rust
use std::sync::{Arc, Mutex};   // the shared-state machinery — declared here for this row (the Plain + Lock pair from above)
use std::thread;
let plain = Arc::new(Mutex::new(0i32));   // the locked counter — declared here for this row (starts at 0, shown explicitly)
let mut hs = Vec::new();               // the thread handles — declared here for this row
for _ in 0..2 {                        // spawn 2 workers, like the Pascal loop above
    let p = Arc::clone(&plain);        // a clone of the shared lock for this worker (p is declared inside the loop)
    hs.push(thread::spawn(move || {   // the closure — its body is the Execute equivalent from the row above
        for _ in 0..50_000 { *p.lock().unwrap() += 1; }   // guard released at scope end (RAII) — same as Lock.Acquire/Release
    })); }
```

Pascal

```pascal
var Plain: Integer;   // the shared state — declared here for this row (touched only under Lock)
Lock: TCriticalSection;   // the lock object — declared here for this row (FPC name for Delphi's TMonitor)
Threads: array[1..4] of TThread; i: Integer;   // thread pool + loop variable — both declared here for this row
type TMonThread = class(TThread)
  procedure Execute; override;
end;
procedure TMonThread.Execute;
var i: Integer;
begin for i := 1 to 50000 do begin Lock.Acquire; Inc(Plain); Lock.Release; end; end;   // the work — Plain + Lock are visible from here (they are globals)
begin
  Lock := TCriticalSection.Create;   // Delphi name: TMonitor
  try
    for i := 1 to 2 do begin Threads[i] := TMonThread.Create(False); Threads[i].Start; end;
    for i := 1 to 2 do begin Threads[i].WaitFor; Threads[i].Free; end;
  finally
    Lock.Free;
  end;
end.
```

Caveats & cautions

TMonitor is recursive — re-Acquire from the same thread succeeds (deadlock risk); Rust's `Mutex` **panics** on re-lock, and std has no reentrant mutex. Delphi locks must be explicitly `Free`'d; Rust guards auto-release at scope end (RAII) — forgetting `Release` is a logic bug, not a leak. FPC name: `TCriticalSection`.

One-shot signal that unblocks a waiting thread. Verified on both sides (`event signaled`).

Rust

```rust
let (tx, rx) = std::sync::mpsc::channel::<()>();
let w = thread::spawn(move || { rx.recv().unwrap();   // blocks until signaled
    println!("event signaled"); });
thread::sleep(Duration::from_millis(200)); tx.send(()).unwrap();   // signal
```

Pascal

```pascal
type TWaiter = class(TThread)
  private FEvent: TEvent;
  public constructor Create(AEvent: TEvent); procedure Execute; override; end;
constructor TWaiter.Create(AEvent: TEvent);
begin inherited Create(False); FEvent := AEvent; end;
procedure TWaiter.Execute;
begin FEvent.WaitFor(INFINITE); WriteLn('event signaled'); end;   // blocks until signaled (Win32: WaitForSingleObject(E.Handle, INFINITE))
var E: TEvent; W: TWaiter;   // the event + the waiter thread — both declared here for this row
begin E := TEvent.Create(nil, False, False, '');   // auto-reset, initially non-signaled (the four args are shown explicitly)
  W := TWaiter.Create(E); W.Start;
  TThread.Sleep(200); E.SetEvent;              // signal (Win32: SetEvent(E.Handle))
end.
```

std has no event type — an `mpsc` channel is the closest (auto-reset, one signal per wait; manual reset = Condvar + flag). Delphi events can be named Win32 handles shared across processes; Rust channels are in-process only. `recv()` returns `Err` if all senders have been dropped.

## 19. File I/O: typed/untyped files, textfile, TFileStream

Delphi's file model — `AssignFile` + `Reset`/`Rewrite` on typed (`file of`), untyped (`file`) and `textfile` variables, plus the object-based `TFileStream` — maps onto Rust's `std::fs` / `std::io`. All rows verified on both sides.

### Opening files (Reset / Rewrite ↔ File::open / File::create)

Open a file for writing (creating or truncating it). Verified on both sides.

Rust

```rust
let mut f = File::create("data.dat").unwrap();   // create + truncate
```

Pascal

```pascal
type TPoint = record X, Y: Integer; end;   // the record type — declared here for this row (8 bytes per record)
var F: file of TPoint;   // the typed file variable — declared here for this row
begin AssignFile(F, 'data.dat');   // bind name to the file variable (Delphi idiom) — the path is shown explicitly
  Rewrite(F);   // create + truncate, open for writing
end.
```

Caveats & cautions

Delphi requires `AssignFile` first — `Rewrite` without it raises EInOutError "File not assigned" (verified); Rust passes the path directly, no binding step. `Rewrite` deletes an existing file and recreates it empty (documented) = `File::create`.

Open an existing file for reading. Verified on both sides.

Rust

```rust
let f = File::open("data.dat").unwrap();
```

Pascal

```pascal
var F: file of TPoint;   // from the row above — re-declared here so this row stands alone (TPoint = record X, Y: Integer; end;)
begin AssignFile(F, 'data.dat');   // the name must be bound before Reset (row above)
  Reset(F);   // open existing for reading
end.
```

Caveats & cautions

Both fail if the file doesn't exist — Delphi raises EInOutError, Rust returns `Err(NotFound)`.

### Typed files (\`file of\`) ↔ fixed-size records

Read/write a fixed-size record. Verified on both sides (10,20 / 30,40 round-trip).

Rust

```rust
let mut f = File::create("data.dat").unwrap();   // the file handle — declared here for this row (open for writing, like Rewrite above)
let recs: [(i32, i32); 2] = [(10, 20), (30, 40)];   // two TPoint records — shown explicitly
for (x, y) in recs {                                   // x and y are the record's fields, unpacked by this loop
    f.write_all(&x.to_le_bytes()).unwrap();            // whole record → file (8 bytes), field by field
    f.write_all(&y.to_le_bytes()).unwrap();
}
let mut f = File::open("data.dat").unwrap();           // reopen for reading (like Reset above)
let mut buf = [0u8; 8];                                // the read buffer — declared here for this row (one record's worth of bytes)
f.read_exact(&mut buf).unwrap();                        // Read(F, P): whole record #1 into buf
i32::from_le_bytes(buf[0..4].try_into().unwrap())      // 10 — the first field decoded from the buffer
```

Pascal

```pascal
type TPoint = record X, Y: Integer; end;   // the record type — declared here for this row (8 bytes)
var F: file of TPoint; P: TPoint;   // the typed file variable + the record buffer — both declared here for this row
begin AssignFile(F, 'data.dat'); Rewrite(F);   // open for writing (row above)
  P.X := 10; P.Y := 20; Write(F, P);   // whole record → file (8 bytes) — the values are shown explicitly
  P.X := 30; P.Y := 40; Write(F, P);   // second record — the values are shown explicitly
  Reset(F);    // reopen for reading
  Read(F, P);    // back into the record: 10,20 (P is filled by Read)
  WriteLn(P.X, ',', P.Y);   // 10,20 — read back through the original variable
end.
```

Delphi serializes the whole record in one call; Rust std has no struct I/O — serialize field by field. Endianness is explicit in Rust (`to_le_bytes`), implicit little-endian on x86 Delphi.

Move to a record; detect end/start of file. Verified on both sides (30,40; EOF true / read-returns-0).

Rust

```rust
let mut f = File::open("data.dat").unwrap();   // the file handle — declared here for this row (the one from the rows above)
let mut b = [0u8; 1];                          // a scratch byte buffer — declared here for this row (for the EOF probe below)
f.seek(SeekFrom::Start(8)).unwrap();   // byte offset = record #2 × 8
let mut buf = [0u8; 8]; f.read_exact(&mut buf).unwrap();   // 30,40 (buf is declared here)
f.read(&mut b).unwrap() == 0            // this is EOF — read returns 0 bytes at end of file
f.stream_position().unwrap() == 0       // this is BOF — position back at the start
```

Pascal

```pascal
var F: file of TPoint; P: TPoint;   // from the rows above — re-declared here so this row stands alone (TPoint = record X, Y: Integer; end;)
begin Seek(F, 1);        // record #2 (the index is shown explicitly)
  Read(F, P);              // 30,40 — P is filled by Read
  WriteLn(P.X, ',', P.Y);   // 30,40 — read back through the original variable
  EOF(F)                  // True — past last record (call it after reading the last record)
  BOF(F)                  // Delphi-only; FPC has no BOF
end.
```

`Seek` takes a **record index**, Rust's `seek` a **byte offset**. Delphi has both `EOF` and `BOF`; FPC implements only `EOF` (`BOF` is reference-only there); Rust has neither — idioms are read-returns-0 (EOF) and position==0 (BOF).

Cut the file at the current position. Verified on both sides (16 → 8 bytes).

Rust

```rust
let mut f = OpenOptions::new().read(true).write(true).open("data.dat").unwrap();   // a read+write handle — declared here for this row (Truncate needs both)
f.seek(SeekFrom::Start(8)).unwrap();
f.set_len(8).unwrap();   // truncate to current position → 8 bytes
```

Pascal

```pascal
var F: file of TPoint;   // from the rows above — re-declared here so this row stands alone (TPoint = record X, Y: Integer; end;)
begin Seek(F, 1);        // position after the first record (the index is shown explicitly)
  Truncate(F);   // discard everything from here on → file = 8 bytes
end.
```

Rust needs a read+write handle (`OpenOptions::new().read(true).write(true)`); Delphi's `Truncate` works on the opened typed file.

### Untyped files ↔ raw byte I/O

Raw block I/O on an untyped file. Verified on both sides (10,20 / 8 bytes round-trip).

Rust

```rust
let mut f = File::create("data.bin").unwrap();   // the file handle — declared here for this row (open for writing)
let rec: [u8; 8] = [10, 0, 0, 0, 20, 0, 0, 0];   // TPoint {X=10,Y=20} as raw bytes — shown explicitly (little-endian)
f.write_all(&rec).unwrap();        // raw byte write
let mut f = File::open("data.bin").unwrap();      // reopen for reading
let mut buf = [0u8; 8];            // the read buffer — declared here for this row (one record's worth of bytes)
let n = f.read(&mut buf).unwrap();  // n = bytes actually read (8) — bound by this let
```

Pascal

```pascal
type TPoint = record X, Y: Integer; end;   // the record type — from the rows above, re-declared here so this row stands alone
var U: file; P: TPoint; N: LongWord;   // the untyped file variable + record buffer + byte-count out-param — all declared here for this row
begin AssignFile(U, 'data.bin'); Rewrite(U);   // open for writing (row above pattern)
  P.X := 10; P.Y := 20;                    // the values, shown explicitly
  BlockWrite(U, P, SizeOf(P));      // raw 8-byte write
  Reset(U);                            // reopen for reading
  BlockRead(U, P, SizeOf(P), N);     // N = bytes actually read (8) — filled by BlockRead
  WriteLn(P.X, ',', P.Y, ' (', N, ' bytes)');   // 10,20 (8 bytes)
end.
```

Caveats & cautions

`BlockRead`'s out-param for actual byte count ↔ Rust's `read()` return value — neither guarantees a full buffer in one call; loop or use `read_exact` when it must be filled.

### Text files (textfile ↔ lines)

Line-oriented text I/O. Verified on both sides (both lines round-trip).

Rust

```rust
writeln!(f, "line one").unwrap(); writeln!(f, "line two").unwrap(); drop(f);
for line in BufReader::new(File::open("t.txt").unwrap()).lines() { println!("text: {}", line.unwrap()); }   // line loop
```

Pascal

```pascal
var TF: textfile; S: string;   // the text file variable + the line buffer — both declared here for this row
begin AssignFile(TF, 't.txt');   // bind name to the file variable (row above pattern) — the path is shown explicitly
  Rewrite(TF);
  WriteLn(TF, 'line one'); WriteLn(TF, 'line two'); CloseFile(TF);   // the lines are shown explicitly
  Reset(TF);
  while not EOF(TF) do begin ReadLn(TF, S); WriteLn('text: ', S); end;   // line loop — S is filled by ReadLn each iteration
end.
```

Delphi's `ReadLn`\-until-EOF loop ↔ Rust's `lines()` iterator — same shape, different engine. Delphi writes CRLF on Windows; Rust writes exactly what you give it (`\n`).

Add to the end of an existing file. Verified on both sides (`append ok`).

Rust

```rust
let mut f = OpenOptions::new().append(true).open("t.txt").unwrap();
writeln!(f, "line three").unwrap();
```

Pascal

```pascal
var TF: textfile;   // from the row above — re-declared here so this row stands alone (the file already exists with two lines)
begin Append(TF);   // open existing text file at the end
  WriteLn(TF, 'line three');   // the new line is shown explicitly
end.
```

Caveats & cautions

Rust's append mode is write-only and always positions at EOF — no `Seek` needed; Delphi's `Append` fails if the file doesn't exist (create first with `Rewrite`).

### TFileStream ↔ File with size/position semantics

Object-based stream with explicit position and size. Verified on both sides (12 → 'hello' → 3).

Rust

```rust
let mut f = OpenOptions::new().read(true).write(true).create(true).truncate(true)
.open("s.bin").unwrap();             // fmCreate equivalent (needs read+write!)
f.write_all(b"hello stream").unwrap();
f.metadata().unwrap().len()          // 12 — Size
f.seek(SeekFrom::Start(0)).unwrap(); // Position := 0
let mut buf = [0u8; 5]; f.read_exact(&mut buf).unwrap();   // 'hello'
f.set_len(3).unwrap();               // Size := 3 (truncate)
```

Pascal

```pascal
var FS: TFileStream;   // the stream object — declared here for this row (Delphi System / FPC Classes)
S: string;             // the byte buffer — declared here for this row
begin FS := TFileStream.Create('s.bin', fmCreate);   // create/truncate, open for writing (the path is shown explicitly)
  S := 'hello stream';                            // 12 bytes — shown explicitly
  FS.Write(S[1], Length(S));           // write all 12 bytes
  WriteLn(FS.Size);                    // 12
  FS.Position := 0; FS.Read(S[1], 5);  // 'hello' — read the first 5 bytes back into S
  FS.Size := 3;                        // truncate → 3
end.
```

Caveats & cautions

Rust's `File` is the same primitive — "stream" is just `seek`/`set_len`/`metadata().len()` on it; Delphi wraps it in a class with `Position`/`Size`. A write-only handle can't be read (verified panic) — request `.read(true)` explicitly.

### I/O error handling

Loud failure mode. Verified on both sides (EInOutError / panic).

Rust

```rust
File::open("missing.txt").unwrap();   // panics on Err — same "loud" style
```

Pascal

```pascal
var TF: textfile;   // the text file variable — declared here for this row
begin AssignFile(TF, 'missing.txt');   // bind a name that does not exist — shown explicitly (row above pattern)
  try Reset(TF);   // nonexistent file → raises EInOutError (default {$IOCHECKS ON})
  except on E: Exception do WriteLn('iocheck on raises: ', E.ClassName);   // caught with try/except (E is bound by this handler)
  end;
end.
```

Caveats & cautions

Delphi's default is exceptions for I/O errors; Rust has no exceptions at all — `.unwrap()`/`?` are the opt-in loud equivalents.

Quiet failure mode — check a status instead of catching. Verified on both sides (IOResult 2 / NotFound).

Rust

```rust
match File::open("missing.txt") {
    Ok(_) => println!("unexpected open ok"),
    Err(e) => println!("{:?}", e.kind()),   // NotFound — the idiomatic path
}
```

Pascal

```pascal
var TF: textfile; IOCode: Integer;   // the file variable + the status code — both declared here for this row
begin AssignFile(TF, 'missing.txt');   // bind a name that does not exist — shown explicitly (row above pattern)
  {$I-}
  Reset(TF);   // fails quietly under {$I-} — no exception
  IOCode := IOResult;   // read + clear immediately (2 = not found in FPC, 102 in Delphi) — IOCode is filled by this assignment
  {$I+}
  if IOCode <> 0 then WriteLn('iocheck off: IOResult = ', IOCode)
end.
```

Caveats & cautions

With `{$I-}`, you MUST read `IOResult` right after each op — an unread error poisons all subsequent I/O (documented). Error codes differ by dialect/OS (FPC: 2; Delphi: 102) — never hardcode them. Rust's `Result` is the native idiom; there is no global status variable to forget.

### Sharing, existence, search

Control whether other handles/processes may open the same file. Verified in FPC (default denies a second open).

Rust

```rust
// no std API for share/deny modes — files open fully shared by default on Windows
```

Pascal

```pascal
var FS: TFileStream;   // from the TFileStream row above — re-declared here so this row stands alone
begin FS := TFileStream.Create('s.bin', fmCreate);   // default: effectively exclusive on Windows (the path is shown explicitly)
  // second open while held → EFOpenError (verified)
  TFileStream.Create('s.bin', fmOpenReadWrite or fmShareDenyNone)   // allow concurrent opens — a fresh anonymous stream, not stored in any variable
end.
```

Caveats & cautions

Delphi's default is effectively exclusive on Windows (second open raises EFOpenError); opt into sharing with `fmShareDenyNone`. FPC quirk (verified): share flags are ignored with `fmCreate` — FPC docs allow them only with `fmOpenRead/Write/ReadWrite`. Rust std has no equivalent at all — concurrent read+write from multiple handles is the default.

Check/create before use. Verified on both sides (False → True).

Rust

```rust
Path::new("f.txt").exists()   // files AND dirs — one function
fs::create_dir_all("d")
```

Pascal

```pascal
FileExists('f.txt')
DirectoryExists('d');   // + CreateDir('d')
```

Delphi splits file/dir checks into two functions; Rust's `Path::exists()` covers both (use `is_file()`/`is_dir()` to distinguish).

Enumerate files matching a pattern. Verified on both sides (same file found).

Rust

```rust
for entry in fs::read_dir(".").unwrap() {
    let name = entry.file_name();
    if name.starts_with("s17_") && name.ends_with(".dat") { println!("found: {} ({} bytes)", name, entry.metadata().unwrap().len()); }   // pattern by hand
}
```

Pascal

```pascal
var SR: TSearchRec;   // the search record — declared here for this row (Delphi's FindFirst/FindNext out-param, filled by them)
begin if FindFirst('s17_*.dat', faAnyFile, SR) = 0 then   // the pattern is shown explicitly
  while True do begin WriteLn('found: ', SR.Name, ' (', SR.Size, ' bytes)'); if FindNext(SR) <> 0 then Break; end;   // SR is refilled by FindNext each iteration
  FindClose(SR);   // found: s17_typed.dat (8 bytes)
end.
```

Delphi's `FindFirst/FindNext` supports wildcards natively and returns size/time/attrs in `TSearchRec`; Rust std has no glob — filter names yourself, pull metadata per entry (`entry.metadata()`).