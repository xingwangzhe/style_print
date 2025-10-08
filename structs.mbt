///|
// RGB 结构体
// 表示一个真彩色的三个分量 r, g, b，取值范围 0-255
// RGB struct
// Represents three components r, g, b for truecolor (0-255)

///|
pub(all) struct RGB {
  r : UInt
  g : UInt
  b : UInt
}

///|
// Color 枚举
// 列举了常用的命名颜色以及用于真彩色的 RGB 变体
// Color enum
// Lists common named colors and a RGB variant for truecolor

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
// Style 结构体
// 保存前景色、背景色和文本样式标志（粗体、斜体、下划线、反转）
// Style struct
// Holds foreground/background colors and style flags (bold, italic, underline, reverse)

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
// StyledText 结构体
// 表示带样式的文本节点，可用于链式组合多个样式化片段
// StyledText struct
// Represents a styled text node, allows chaining multiple styled fragments

///|
pub(all) struct StyledText {
  text : String
  style : Style
  next : StyledText?
}

//初始化文本对象

///|
// 构造 StyledText
// Create a new StyledText node from text and an initial Style

///|
// 构造 StyledText 节点
// 从给定文本和初始样式创建一个新的 StyledText 节点并返回
// Create a StyledText node
// Create and return a new StyledText node from provided text and initial style

///|
pub fn StyledText::new(text : String, style : Style) -> StyledText {
  StyledText::{ text, style, next: None }
}

// 链式构造入口：从文本创建一个 StyledText，使用默认 Style

///|
// styl moved to the public API in style_print.mbt

///|
/// 链式方法：在 StyledText 上修改样式并返回新的 StyledText

///|
// 应用前景色并返回新的 StyledText
// Apply a foreground color and return a new StyledText

///|
pub fn StyledText::color(self : StyledText, c : Color) -> StyledText {
  { ..self, style: self.style.with_foreground(c) }
}

///|

///|
// 应用背景色并返回新的 StyledText
// Apply a background color and return a new StyledText

///|
pub fn StyledText::bg_color(self : StyledText, c : Color) -> StyledText {
  { ..self, style: self.style.with_background(c) }
}

///|
// 直接传入 RGB 三个分量的便捷链式方法

///|
// 使用 RGB 三个分量设置前景色并返回新的 StyledText
// Set the foreground color using RGB components and return a new StyledText

///|
// color_rgb removed as redundant: use `.color(rgb_color(r,g,b))` instead

///|

///|
// 使用 RGB 三个分量设置背景色并返回新的 StyledText
// Set the background color using RGB components and return a new StyledText

///|
// bg_rgb removed as redundant: use `.bg_color(rgb_color(r,g,b))` instead

///|

///|
// 将当前文本标记为粗体并返回新的 StyledText
// Mark the current text as bold and return a new StyledText

///|
pub fn StyledText::bold(self : StyledText) -> StyledText {
  { ..self, style: { ..self.style, bold: true } }
}

///|

///|
// 将当前文本标记为斜体并返回新的 StyledText
// Mark the current text as italic and return a new StyledText

///|
pub fn StyledText::italic(self : StyledText) -> StyledText {
  { ..self, style: { ..self.style, italic: true } }
}

///|

///|
// 将当前文本标记为下划线并返回新的 StyledText
// Mark the current text as underlined and return a new StyledText

///|
pub fn StyledText::underline(self : StyledText) -> StyledText {
  { ..self, style: { ..self.style, underline: true } }
}

///|

///|
// 将前景与背景颜色反转并返回新的 StyledText
// Reverse foreground and background colors and return a new StyledText

///|
pub fn StyledText::reverse(self : StyledText) -> StyledText {
  { ..self, style: { ..self.style, reversed: true } }
}

// 将当前节点（以及递归的 next）渲染为带 ANSI 转义的字符串

///|

///|
// 将 StyledText (包括后续链) 渲染为包含 ANSI SGR 转义序列的字符串
// Render the StyledText (including chained nodes) into a string containing ANSI SGR escape sequences

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

///|
// 返回一个不会在终端被解析为样式的字符串版本
// Return a string where ANSI ESC sequences are made visible (escaped)
// so printing it won't render terminal styles.
// 这个方法会把真实的 ESC 字符替换为可见的文本 "\\u{1B}"，
// 并保留原始的 SGR 内容，例如 "\u{1B}[31m" -> "\\u{1B}[31m"。

///|
pub fn StyledText::to_ansi_not_styl(self : StyledText) -> String {
  // 直接复刻 to_ansi 的逻辑，但用可见的 "\\u{1B}" 替代真实的 ESC 字符，
  // 从而保证终端不会把输出解析为样式序列。
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
    "\\u{1B}[" + codes + "m" + self.text + "\\u{1B}[0m"
  }
  match self.next {
    Some(n) => s + n.to_ansi_not_styl()
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

///|
// 创建默认的 Style 实例（无颜色，所有样式标志为假）
// Create a default Style instance (no colors, all style flags false)

///|
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

///|
// 返回一个新的 Style，设置前景色为给定 Color
// Return a new Style with the foreground set to the given Color

///|
fn Style::with_foreground(self : Style, c : Color) -> Style {
  { ..self, foreground: Some(c) }
}

///|

///|
// 返回一个新的 Style，设置背景色为给定 Color
// Return a new Style with the background set to the given Color

///|
fn Style::with_background(self : Style, c : Color) -> Style {
  { ..self, background: Some(c) }
}
