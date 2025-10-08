///|
// style_print.mbt
// 这个文件包含本包的对外公共接口（便捷函数和文档注释）。
// 用户应当仅使用这里导出的函数来构造和打印带样式的文本。

///|

///|
// 创建一个带默认样式的 StyledText。作为库的主要入口函数。
pub fn styl(text : String) -> StyledText {
  // 直接用 structs 中的类型和构造器，不重复实现逻辑。
  StyledText::new(text, Style::new())
}

///|
// 将 StyledText 渲染并打印到标准输出（包含 ANSI 转义）。
pub fn styl_print(st : StyledText) -> Unit {
  // 使用类型方法渲染为 ANSI 字符串并打印。
  println(st.to_ansi())
}

///|
// 便捷构造器：直接用三个分量构造一个 Color::RGB 实例。
// 推荐用户使用此函数构造真彩色（true-color）前/背景色。
pub fn rgb_color(r : UInt, g : UInt, b : UInt) -> Color {
  Color::RGB(RGB::{ r, g, b })
}

///|
// 另提供一个更短的别名（可选）以便链式调用时更简洁：
// styl("x").color(rgb(1U,2U,3U))
pub fn rgb(r : UInt, g : UInt, b : UInt) -> Color {
  rgb_color(r, g, b)
}
// 本文件仅导出核心对外 API：`styl`, `styl_print`, `rgb_color`（以及 `rgb` 别名）。
// 请直接使用链式方法来构造样式，例如：
//   styl("text").color(Color::Red).bold().bg_color(rgb(1U,2U,3U))
