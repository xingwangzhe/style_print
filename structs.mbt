///|
pub(all) struct RGB {
  r : UInt
  g : UInt
  b : UInt
}

///|
pub(all) enum Color {
  // 常用命名颜色
  Black
  Red
  Green
  Yellow
  Blue
  Magenta
  Cyan
  White
  BrightBlack
  BrightRed
  BrightGreen
  BrightYellow
  BrightBlue
  BrightMagenta
  BrightCyan
  BrightWhite

  // 支持 ANSI 转义的颜色格式
  RGB(RGB) // RGB 结构体，包含 r, g, b 各 0-255
}

///|
pub(all) struct Style {
  foreground : Color?
  background : Color?
  bold : Bool
  italic : Bool
  underline : Bool
  reversed : Bool
}

///|
pub(all) struct StyledText {
  text : String
  style : Style
  next : StyledText?
}

//初始化文本对象

///|
pub fn StyledText::new(text : String, style : Style) -> StyledText {
  StyledText::{ text, style, next: None }
}

// 链式构造入口：从文本创建一个 StyledText，使用默认 Style

///|
// styl moved to the public API in style_print.mbt

///|
/// 链式方法：在 StyledText 上修改样式并返回新的 StyledText
pub fn StyledText::color(self : StyledText, c : Color) -> StyledText {
  { ..self, style: self.style.with_foreground(c) }
}

///|
pub fn StyledText::bg_color(self : StyledText, c : Color) -> StyledText {
  { ..self, style: self.style.with_background(c) }
}

///|
// 直接传入 RGB 三个分量的便捷链式方法
pub fn StyledText::color_rgb(
  self : StyledText,
  r : UInt,
  g : UInt,
  b : UInt,
) -> StyledText {
  let rgb = RGB::{ r, g, b }
  { ..self, style: self.style.with_foreground(Color::RGB(rgb)) }
}

///|
pub fn StyledText::bg_rgb(
  self : StyledText,
  r : UInt,
  g : UInt,
  b : UInt,
) -> StyledText {
  let rgb = RGB::{ r, g, b }
  { ..self, style: self.style.with_background(Color::RGB(rgb)) }
}

///|
pub fn StyledText::bold(self : StyledText) -> StyledText {
  { ..self, style: { ..self.style, bold: true } }
}

///|
pub fn StyledText::italic(self : StyledText) -> StyledText {
  { ..self, style: { ..self.style, italic: true } }
}

///|
pub fn StyledText::underline(self : StyledText) -> StyledText {
  { ..self, style: { ..self.style, underline: true } }
}

///|
pub fn StyledText::reverse(self : StyledText) -> StyledText {
  { ..self, style: { ..self.style, reversed: true } }
}

// 将当前节点（以及递归的 next）渲染为带 ANSI 转义的字符串

///|
pub fn StyledText::to_ansi(self : StyledText) -> String {
  let style = self.style
  let mut codes = ""
  let mut sep = ""
  if style.foreground is Some(c) {
    codes = codes + sep + color_to_fg_code(c)
    sep = ";"
  }
  if style.background is Some(c) {
    codes = codes + sep + color_to_bg_code(c)
    sep = ";"
  }
  if style.bold {
    codes = codes + sep + "1"
    sep = ";"
  }
  if style.italic {
    codes = codes + sep + "3"
    sep = ";"
  }
  if style.underline {
    codes = codes + sep + "4"
    sep = ";"
  }
  if style.reversed {
    codes = codes + sep + "7"
    sep = ";"
  }
  let s = if codes == "" {
    self.text
  } else {
    "\u{1B}[" + codes + "m" + self.text + "\u{1B}[0m"
  }
  match self.next {
    Some(n) => s + n.to_ansi()
    None => s
  }
}

// 打印 StyledText（递归打印已包含在 to_ansi）

///|
// styl_print moved to the public API in style_print.mbt

///|
fn RGB::to_fg_code(self : RGB) -> String {
  if self.r <= 255 && self.g <= 255 && self.b <= 255 {
    "38;2;" +
    self.r.to_string() +
    ";" +
    self.g.to_string() +
    ";" +
    self.b.to_string()
  } else {
    println(
      "Warning: Invalid RGB values (" +
      self.r.to_string() +
      ", " +
      self.g.to_string() +
      ", " +
      self.b.to_string() +
      "), using default foreground color.",
    )
    "39" // 默认前景色
  }
}

///|
fn RGB::to_bg_code(self : RGB) -> String {
  if self.r <= 255 && self.g <= 255 && self.b <= 255 {
    "48;2;" +
    self.r.to_string() +
    ";" +
    self.g.to_string() +
    ";" +
    self.b.to_string()
  } else {
    println(
      "Warning: Invalid RGB values (" +
      self.r.to_string() +
      ", " +
      self.g.to_string() +
      ", " +
      self.b.to_string() +
      "), using default background color.",
    )
    "49" // 默认背景色
  }
}

///|
// 链式调用支持：在 Style 上实现一组返回新 Style 的方法，方便链式写法
pub fn Style::new() -> Style {
  Style::{
    foreground: None,
    background: None,
    bold: false,
    italic: false,
    underline: false,
    reversed: false,
  }
}

///|
pub fn Style::with_foreground(self : Style, c : Color) -> Style {
  { ..self, foreground: Some(c) }
}

///|
pub fn Style::with_background(self : Style, c : Color) -> Style {
  { ..self, background: Some(c) }
}

///|
pub fn Style::unbold(self : Style) -> Style {
  { ..self, bold: false }
}

///|
pub fn Style::italicize(self : Style) -> Style {
  { ..self, italic: true }
}

///|
pub fn Style::underline(self : Style) -> Style {
  { ..self, underline: true }
}

///|
pub fn Style::reverse(self : Style) -> Style {
  { ..self, reversed: true }
}
