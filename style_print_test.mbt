///|
test "fg color only" {
  let s = styl("fg").color(Color::Red)
  let out = s.to_ansi_not_styl()
  styl_print(s)
  println(out)
  inspect(true, content="true")
}

///|
test "bg color only" {
  let s = styl("bg").bg_color(Color::Blue)
  let out = s.to_ansi_not_styl()
  styl_print(s)
  println(out)
  inspect(true, content="true")
}

///|
test "rgb color only" {
  let s = styl("rgb").color(rgb(12U, 34U, 56U))
  let out = s.to_ansi_not_styl()
  styl_print(s)
  println(out)
  inspect(true, content="true")
}

///|
test "italic only" {
  let s = styl("i").italic()
  let out = s.to_ansi_not_styl()
  styl_print(s)
  println(out)
  inspect(true, content="true")
}

///|
test "bold only" {
  let s = styl("b").bold()
  let out = s.to_ansi_not_styl()
  styl_print(s)
  println(out)
  inspect(true, content="true")
}

///|
test "reverse only" {
  let s = styl("abc").reverse()
  let out = s.to_ansi_not_styl()
  styl_print(s)
  println(out)
  inspect(true, content="true")
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
  let out = s.to_ansi_not_styl()
  styl_print(s)
  println(out)
  inspect(true, content="true")
}

