# Niri 操作快捷键

本文档整理自 `modules/programs/niri/config.kdl` 中的 `binds` 配置。

> 说明：下文保留配置中的 `Mod` 写法，不额外替换成具体物理按键，这样会和实际配置保持一致。

## 应用与系统操作

| 快捷键 | 功能 |
| --- | --- |
| `Mod+Shift+Slash` | 显示快捷键提示层 |
| `Mod+Return` / `Mod+T` | 打开终端 `kitty` |
| `Mod+E` | 打开 `firefox` |
| `Mod+D` / `Mod+Space` | 打开应用启动器 `dms spotlight` |
| `Super+Alt+L` | 锁屏 |
| `Mod+O` | 切换 overview |
| `Mod+Escape` | 切换键盘快捷键抑制 |
| `Mod+Shift+P` | 关闭显示器 |
| `Mod+Shift+E` / `Ctrl+Alt+Delete` | 退出 Niri |

## 音量与媒体控制

| 快捷键 | 功能 |
| --- | --- |
| `XF86AudioRaiseVolume` | 音量增加 10% |
| `XF86AudioLowerVolume` | 音量减少 10% |
| `XF86AudioMute` | 切换扬声器静音 |
| `XF86AudioMicMute` | 切换麦克风静音 |
| `XF86AudioPlay` | 播放 / 暂停 |
| `XF86AudioStop` | 停止播放 |
| `XF86AudioPrev` | 上一首 |
| `XF86AudioNext` | 下一首 |

## 窗口关闭与焦点移动

| 快捷键 | 功能 |
| --- | --- |
| `Mod+Q` | 关闭当前窗口 |
| `Mod+Left` / `Mod+H` | 焦点移到左侧列 |
| `Mod+Right` / `Mod+L` | 焦点移到右侧列 |
| `Mod+Down` / `Mod+J` | 焦点移到下方窗口 |
| `Mod+Up` / `Mod+K` | 焦点移到上方窗口 |
| `Mod+Home` | 焦点移到当前列第一个位置 |
| `Mod+End` | 焦点移到当前列最后一个位置 |

## 移动窗口 / 列

| 快捷键 | 功能 |
| --- | --- |
| `Mod+Ctrl+Left` / `Mod+Ctrl+H` | 列向左移动 |
| `Mod+Ctrl+Right` / `Mod+Ctrl+L` | 列向右移动 |
| `Mod+Ctrl+Down` / `Mod+Ctrl+J` | 窗口向下移动 |
| `Mod+Ctrl+Up` / `Mod+Ctrl+K` | 窗口向上移动 |
| `Mod+Ctrl+Home` | 列移动到最前 |
| `Mod+Ctrl+End` | 列移动到最后 |

## 显示器之间切换 / 移动

| 快捷键 | 功能 |
| --- | --- |
| `Mod+Shift+Left` / `Mod+Shift+H` | 焦点移到左侧显示器 |
| `Mod+Shift+Right` / `Mod+Shift+L` | 焦点移到右侧显示器 |
| `Mod+Shift+Down` / `Mod+Shift+J` | 焦点移到下方显示器 |
| `Mod+Shift+Up` / `Mod+Shift+K` | 焦点移到上方显示器 |
| `Mod+Shift+Ctrl+Left` / `Mod+Shift+Ctrl+H` | 将列移动到左侧显示器 |
| `Mod+Shift+Ctrl+Right` / `Mod+Shift+Ctrl+L` | 将列移动到右侧显示器 |
| `Mod+Shift+Ctrl+Down` / `Mod+Shift+Ctrl+J` | 将列移动到下方显示器 |
| `Mod+Shift+Ctrl+Up` / `Mod+Shift+Ctrl+K` | 将列移动到上方显示器 |

## 工作区切换与移动

| 快捷键 | 功能 |
| --- | --- |
| `Mod+Page_Down` / `Mod+U` | 切到下一个工作区 |
| `Mod+Page_Up` / `Mod+I` | 切到上一个工作区 |
| `Mod+Ctrl+Page_Down` / `Mod+Ctrl+U` | 将当前列移动到下一个工作区 |
| `Mod+Ctrl+Page_Up` / `Mod+Ctrl+I` | 将当前列移动到上一个工作区 |
| `Mod+Shift+Page_Down` / `Mod+Shift+U` | 将当前工作区向后移动 |
| `Mod+Shift+Page_Up` / `Mod+Shift+I` | 将当前工作区向前移动 |
| `Mod+1` ~ `Mod+9` | 切换到 1~9 号工作区 |
| `Mod+Ctrl+1` ~ `Mod+Ctrl+9` | 将当前列移动到 1~9 号工作区 |

## 鼠标滚轮操作

| 快捷键 | 功能 |
| --- | --- |
| `Mod+WheelScrollDown` | 切到下一个工作区 |
| `Mod+WheelScrollUp` | 切到上一个工作区 |
| `Mod+Ctrl+WheelScrollDown` | 将当前列移动到下一个工作区 |
| `Mod+Ctrl+WheelScrollUp` | 将当前列移动到上一个工作区 |
| `Mod+WheelScrollRight` | 焦点移到右侧列 |
| `Mod+WheelScrollLeft` | 焦点移到左侧列 |
| `Mod+Ctrl+WheelScrollRight` | 列向右移动 |
| `Mod+Ctrl+WheelScrollLeft` | 列向左移动 |
| `Mod+Shift+WheelScrollDown` | 焦点移到右侧列 |
| `Mod+Shift+WheelScrollUp` | 焦点移到左侧列 |
| `Mod+Ctrl+Shift+WheelScrollDown` | 列向右移动 |
| `Mod+Ctrl+Shift+WheelScrollUp` | 列向左移动 |

## 列与布局调整

| 快捷键 | 功能 |
| --- | --- |
| `Mod+BracketLeft` | 将窗口向左并入 / 推出 |
| `Mod+BracketRight` | 将窗口向右并入 / 推出 |
| `Mod+Comma` | 将窗口并入当前列 |
| `Mod+Period` | 将窗口从当前列中弹出 |
| `Mod+R` | 切换预设列宽 |
| `Mod+Shift+R` | 切换预设窗口高度 |
| `Mod+Ctrl+R` | 重置窗口高度 |
| `Mod+F` | 最大化列 |
| `Mod+Shift+F` | 当前窗口全屏 |
| `Mod+M` | 窗口扩展到边缘 |
| `Mod+Ctrl+F` | 列扩展到可用最大宽度 |
| `Mod+C` | 当前列居中 |
| `Mod+Ctrl+C` | 可见列整体居中 |
| `Mod+Minus` | 列宽减小 10% |
| `Mod+Equal` | 列宽增大 10% |
| `Mod+Shift+Minus` | 窗口高度减小 10% |
| `Mod+Shift+Equal` | 窗口高度增大 10% |

## 浮动 / 标签模式

| 快捷键 | 功能 |
| --- | --- |
| `Mod+V` | 切换窗口浮动状态 |
| `Mod+Shift+V` | 剪贴板历史（dms clipboard） |
| `Mod+W` | 切换列的标签页显示模式 |

## 截图

| 快捷键 | 功能 |
| --- | --- |
| `Mod+S` | 区域截图（保存到文件并复制到剪贴板） |
| `Mod+Ctrl+S` | 全屏截图（保存到文件并复制到剪贴板） |
| `Mod+Shift+S` | 当前窗口截图（保存到文件并复制到剪贴板） |
