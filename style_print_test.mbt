///|
test "fg color only" {
  let s = styl("fg").color(Color::Red)
  let out = s.to_ansi()
  styl_print(s)
  inspect(out, content="\u{1b}[31mfg\u{1b}[0m")
}

///|
test "bg color only" {
  let s = styl("bg").bg_color(Color::Blue)
  let out = s.to_ansi()
  styl_print(s)
  inspect(out, content="\u{1b}[44mbg\u{1b}[0m")
}

///|
test "rgb color only" {
  let s = styl("rgb").color(rgb_color(12U, 34U, 56U))
  let out = s.to_ansi()
  styl_print(s)
  inspect(out, content="\u{1b}[38;2;12;34;56mrgb\u{1b}[0m")
}

///|
test "italic only" {
  let s = styl("i").italic()
  let out = s.to_ansi()
  styl_print(s)
  inspect(out, content="\u{1b}[3mi\u{1b}[0m")
}

///|
test "bold only" {
  let s = styl("b").bold()
  let out = s.to_ansi()
  styl_print(s)
  inspect(out, content="\u{1b}[1mb\u{1b}[0m")
}

///|
test "reverse only" {
  let s = styl("r").reverse()
  let out = s.to_ansi()
  styl_print(s)
  inspect(out, content="\u{1b}[7mr\u{1b}[0m")
}

///|
test "mixed chain" {
  let s = styl("mix")
    .color(Color::Yellow)
    .bg_color(Color::Magenta)
    .bold()
    .italic()
    .underline()
    .reverse()
  let out = s.to_ansi()
  styl_print(s)
  inspect(out, content="\u{1b}[33;45;1;3;4;7mmix\u{1b}[0m")
}
