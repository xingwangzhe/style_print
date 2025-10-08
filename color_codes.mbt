///|
// ANSI 颜色代码参考（前景/背景）:
// 标准颜色：
//   黑色：30 / 40
//   红色：31 / 41
//   绿色：32 / 42
//   黄色：33 / 43
//   蓝色：34 / 44
//   洋红：35 / 45
//   青色：36 / 46
//   白色：37 / 47
// 亮色版本：
//   亮黑色：90 / 100
//   亮红色：91 / 101
//   亮绿色：92 / 102
//   亮黄色：93 / 103
//   亮蓝色：94 / 104
//   亮洋红：95 / 105
//   亮青色：96 / 106
//   亮白色：97 / 107
// 本文件实现了名为 Color 的枚举到前/背景 ANSI SGR 数字片段的映射。

///|
pub fn color_to_fg_code(color : Color) -> String {
  match color {
    Black => "30"
    Red => "31"
    Green => "32"
    Yellow => "33"
    Blue => "34"
    Magenta => "35"
    Cyan => "36"
    White => "37"
    BrightBlack => "90"
    BrightRed => "91"
    BrightGreen => "92"
    BrightYellow => "93"
    BrightBlue => "94"
    BrightMagenta => "95"
    BrightCyan => "96"
    BrightWhite => "97"
    RGB(rgb) => rgb.to_fg_code()
  }
}

///|
pub fn color_to_bg_code(color : Color) -> String {
  match color {
    Black => "40"
    Red => "41"
    Green => "42"
    Yellow => "43"
    Blue => "44"
    Magenta => "45"
    Cyan => "46"
    White => "47"
    BrightBlack => "100"
    BrightRed => "101"
    BrightGreen => "102"
    BrightYellow => "103"
    BrightBlue => "104"
    BrightMagenta => "105"
    BrightCyan => "106"
    BrightWhite => "107"
    RGB(rgb) => rgb.to_bg_code()
  }
}
