# xingwangzhe/style_print

使用 ANSI SGR 转义序列在终端输出带样式的文本（前景色 / 背景色 / 加粗 / 斜体 / 下划线 / 反转前后颜色）。  
Print styled text to the terminal using ANSI SGR escape sequences (foreground/background colors, bold, italic, underline, reverse, etc.).

![你好啊](https://i.ibb.co/gbBBDhjq/2025-10-08-14-56-16.png)


示例  
Example

```moonbit
pub fn example_usage() -> Unit {
  // 构造一个带样式的文本片段并打印到标准输出
  let s = styl("hello style_print").color(Color::Red).bg_color(Color::Blue).italic().bold();
  styl_print(s)
}
```

真彩色 (RGB) 示例  
Truecolor (RGB) example

```moonbit
pub fn example_rgb() -> Unit {
  // 使用 rgb(r,g,b) 构造 Color::RGB
  let orange = rgb(255U, 165U, 0U);
  let s = styl("orange text").color(orange).bold();
  styl_print(s)
}
```

更多示例（直接用代码查看常用 API）
More examples (use code to see common APIs)

```moonbit
// 前景色、背景色、加粗、斜体、下划线、反转
pub fn usage_all_styles() -> Unit {
  let s = styl("mixed styles").color(Color::Yellow).bg_color(Color::Magenta).bold().italic().underline().reverse();
  styl_print(s)
}

// 只设置前景色
pub fn usage_fg_only() -> Unit {
  styl_print(styl("foreground only").color(Color::Cyan))
}

// 只设置背景色
pub fn usage_bg_only() -> Unit {
  styl_print(styl("background only").bg_color(Color::BrightBlack))
}

// 链式组合与下一段拼接（next）
pub fn usage_chain() -> Unit {
  let a = styl("one").color(Color::Red)
  let b = styl(" two").color(Color::Green).bold()
  let c = styl(" three").bg_color(Color::Blue).italic()
  styl_print(a)
  styl_print(b)
  styl_print(c)
}

// 使用真彩色 RGB
pub fn usage_rgb_truecolor() -> Unit {
  let c = rgb(12U, 34U, 56U)
  styl_print(styl("truecolor").color(c))
}

// 获取不可解释的 ANSI 可见形式
pub fn usage_show_escapes() -> Unit {
  let s = styl("visible esc").color(Color::Red)
  println(s.to_ansi_not_styl())
}
```

简短说明  
Short notes

- 使用 `styl(text)` 创建 `StyledText`，链式调用 `.color()`、`.bg_color()`、`.bold()` 等进行样式设置。  
- Use `styl(text)` to create a `StyledText` instance, then chain methods such as `.color()`, `.bg_color()`, `.bold()` to modify styles.

- 调试或展示 ANSI 序列可调用 `to_ansi_not_styl()` 来查看不可解释的转义序列文本。  
- To debug or show ANSI escapes, call `to_ansi_not_styl()` to get a visible (non-interpreted) representation of escape sequences.
