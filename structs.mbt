struct RGB {
  r : UInt
  g : UInt
  b : UInt
}

enum Color {
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
  RGB(RGB)           // RGB 结构体，包含 r, g, b 各 0-255
}

fn RGB::to_fg_code(self : RGB) -> String {
  if self.r <= 255 && self.g <= 255 && self.b <= 255 {
    "38;2;" + self.r.to_string() + ";" + self.g.to_string() + ";" + self.b.to_string()
  } else {
    println("Warning: Invalid RGB values (" + self.r.to_string() + ", " + self.g.to_string() + ", " + self.b.to_string() + "), using default foreground color.");
    "39"  // 默认前景色
  }
}

fn RGB::to_bg_code(self : RGB) -> String {
  if self.r <= 255 && self.g <= 255 && self.b <= 255 {
    "48;2;" + self.r.to_string() + ";" + self.g.to_string() + ";" + self.b.to_string()
  } else {
    println("Warning: Invalid RGB values (" + self.r.to_string() + ", " + self.g.to_string() + ", " + self.b.to_string() + "), using default background color.");
    "49"  // 默认背景色
  }
}