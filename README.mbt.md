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

说明  
Notes

- 使用 `styl(text)` 创建一个 `StyledText` 实例，然后通过链式方法如 `.color(...)`、`.bg_color(...)`、`.bold()` 等修改样式；最后调用 `styl_print` 输出带样式的文本。  
  Use `styl(text)` to create a `StyledText` instance, then chain methods such as `.color(...)`, `.bg_color(...)`, `.bold()` to modify styles; finally call `styl_print` to output styled text。

- 如果想要得到不会被终端解释的可见 ANSI 序列，可以调用 `StyledText::to_ansi_not_styl()`。  
  To get a visible (non-interpreted) representation of ANSI escapes, use `StyledText::to_ansi_not_styl()`。
