# UI/UX 设计规范 (UI/UX Specification): OneCoffee

> **版本 (Version)**: v1.0 · **日期 (Date)**: 2026-03-07 · **状态 (Status)**: 草案 (Draft)

## 1. 需求理解总结 (Understanding Summary)
*   **目标产品 (Target Product)**: OneCoffee（一款本地优先的手冲咖啡记录 Flutter App）。
*   **目标用户 (Target Users)**: 从追求快速冲泡的入门者，到死磕参数的极客玩家；使用场景多为吧台前冲煮，单手或双手操作设备。
*   **核心价值主张 (Key Value Proposition)**: 解决现有咖啡记录 App 臃肿、表单堆砌、使用门槛高的问题，提供“优雅、丝滑、无压迫感”的极简记录体验。
*   **物理交互约束 (Physical Constraints)**: 优化大屏手机/平板的持握体验设计，遵循拇指热区 (Thumb Zone) 法则。主要交互和导航必须下沉到底部或中下部；避免频繁点击顶部/左上角返回按钮；表单输入应提供肌肉记忆般的顺滑感。
*   **视觉美学约束 (Aesthetics Constraints)**: 底色采用带有质感的白色/灰白色，主色调采用咖啡色/棕色。

## 2. 设计原则与风格：轻拟物/软质感 (Design Principles & Style: Neumorphism / Soft UI)
应用将采用 **轻拟物化/软质感 (Neumorphism / Soft UI)** 风格。这种设计风格与手冲咖啡温暖、手工冲煮的触感相得益彰，带来极具质感的硬件级体验。

### 2.1 核心视觉准则 (Core Directives)
1.  **“凸起”与“凹陷”元素 ("Embossed" & "Debossed" Elements)**: 利用光影打造出仿佛从背景中挤出或按压下去的元素效果，而不是使用生硬的阴影或边框让元素漂浮在界面之上。
2.  **避免高对比度边框 (No High-Contrast Borders)**: 组件的边缘应当由与背景色相呼应的高光（左上角）和阴影（右下角）来界定。
3.  **弱对比但高无障碍性 (Low Contrast but High Accessibility)**: 轻拟物风格容易面临低对比度问题。必须确保**交互元素**及**文本**保持足够的对比度（遵循 WCAG AA/AAA 指南，文本对比度至少达 4.5:1）。

### 2.2 色彩调色板：咖啡与奶油 (Color Palette: Coffee & Cream)
| 角色 (Role) | 颜色名称 (Color) | 十六进制 (Hex) | 适用场景 (Usage) |
|---|---|---|---|
| **背景/表面 (Background/Surface)** | 奶油白 (Cream White) | `#F3F4F6` 或 `#F5F5F3` | 应用全局背景，稍带极其微弱的暖意。不可使用纯白，必须有灰度底色以实现软阴影效果。 |
| **主强调色 (Primary Accent)**| 咖啡棕 (Coffee Brown)| `#6F4E37` 或 `#8B5A2B` | 强调状态（如“开始冲煮”按钮按下、选中的滑块、关键进度条）。 |
| **次强调色 (Secondary Accent)**| 拿铁/焦糖 (Latte/Caramel) | `#D2B48C` | 次要的强调元素，或者与主色搭配产生视觉梯度的元素。 |
| **主文本色 (Text Primary)** | 深意式 (Deep Espresso)| `#2C1E16` 或 `#1E293B` | 所有的正文与标题，避免纯黑。 |
| **辅文本色 (Text Secondary)**| 暖灰 (Warm Gray) | `#78716C` 或 `#64748B` | 辅文、输入框内占位符 (Placeholder) 等较弱提示。 |
| **高光 (Highlight Shadow)**| 纯白 (Pure White) | `#FFFFFF` | 软质感 UI 左上角的高光色（决定材质亮面）。 |
| **投影 (Drop Shadow)** | 石板阴影 (Slate Shadow) | `#D1D5DB` 或更深的暖灰 | 软质感 UI 右下角的阴影色（决定材质暗面）。 |

### 2.3 字体排版 (Typography)
*   **标题与数字 (Headers & Numbers)**: 推荐使用 `Bodoni Moda`, `Playfair Display` 等带有典雅气质的衬线体，或具备复古质感的无衬线字体（如 `Outfit`, `Jost`）。适合展示计时器大字数字和主标题，赋予应用“经典咖啡馆”的优雅仪式感。字体需采用等宽数字特性 (Tabular figures)，防止倒计时时文字跳动。
*   **正文 (Body Text)**: 采用最高可读性的无衬线体原生系统字体（如 Apple 的 San Francisco 或安卓的 Roboto），保证在使用多种冲煮参数交互时不干扰阅读。

## 3. 人体工学与交互约束 (Ergonomics & UX Constraints)
由于主要场景为“冲煮咖啡时单手或不便移动手部操作设备”（手可能正拿着手冲壶），因此必须严格遵循以下 **“拇指热区 (Thumb Zone)” 法则**：

### 3.1 底部弹窗驱动表单 (Bottom-Sheet Driven Forms)
*   **核心准则**: 凡是关于“新建记录”、“选择磨豆刻度”、“评价风味”的表单交互，一律禁止跳转全屏新页面。
*   **实现方式**: 全部采用 **底部半屏/多半屏弹窗 (Modal Bottom Sheet)** 进行重度交互。高度控制在屏幕的 50% ~ 75%，确保用户大拇指可以轻松横扫整个输入区域。超出的内容在弹窗内滚动。
*   **视觉指示**: 弹窗顶部应带有明确的下拉关闭指示条 (Drag Handle)，支持物理手势关闭。软质感的拖动条能够凸显操作手感。

### 3.2 主导航与行动号召按钮布局 (Main Navigation / CTA Layout)
*   **核心大圆钮居中偏下**: 例如“开始冲煮/记录 (Brew)”的大按钮必须放置在屏幕垂直中央下方的位置，模拟一台实体咖啡秤的启动键体验。
*   **摒弃常规顶部导航**: 不需要顶部应用栏 (App Bar) 提供核心操作能力（如返回、保存等按钮不应置于最上方）。屏幕上方仅做信息呼吸式展示（例如居中显示大标题“准备冲煮”）。
*   **底部动作池**: 全局导航（如“历史”、“设置”）使用底部悬浮快捷按钮，替代传统的枯燥底部导航栏 (BottomNavigationBar)。

## 4. 特殊组件设计规范 (Specific Component Guidelines)

### 4.1 计时器界面 (Timer / Clock Interface)
*   **极大字体与留白**: 大屏中央占据最大物理权重的必须是计时器数字。字体要求厚重、数字等宽对齐。
*   **软质表盘 (Neumorphic Dial)**: 采用表盘形式的设计。例如，设计一条向内凹陷 (Debossed) 的环状轨道；当正/倒计时进行时，代表水量的咖啡色进度轨迹以凸出 (Embossed) 的形式围绕轨道匀速滑行。

### 4.2 渐进式表单输入 (Progressive Disclosure Inputs)
*   **滑块优先 (Sliders over Keyboards)**: 对于水量、温度甚至极简模式下的研磨度等数值，尽量提供物理质感强烈的滑动条、长按增减步进器 (Stepper)，不要轻易呼出系统层面的虚拟键盘（除非用户必须录入文字），以免打断冲煮心流体验。
*   **默认极简 (Default Minimalism)**: 默认仅展示最重要的三要素（豆种、粉水比、冲煮方式）。点击“展开更多参数”时，底层托盘再以丝滑动画展开，呈现隐藏的水质、水温等模块。

### 4.3 微交互动效 (Interactive Feedback)
*   **按压反馈 (Press-in effect)**: 所有的按钮被按下 (OnTapDown) 时，外阴影 (BoxShadow) 应瞬间变成内阴影 (InnerShadow)，或者阴影的模糊半径缩小，以此模拟实体按键被按入深坑的机械手感。
*   **动画时序 (Animation Timing)**: 动画时间维持在 `150ms-250ms` 之间，结合弹性物理曲线 (Spring Physics)，让界面呈现出水波、软泥般的顺滑阻尼感。

## 5. 总结与下一步 (Summary & Next Steps)
- [x] 锁定设计大方向 (Soft UI / Neumorphism)。
- [x] 定义拇指热区 (Thumb Zone) 相关的交互约束。
- [x] 产出并归档 UI/UX 规范说明文件 (`docs/03_UI_Specification.md`)。
- [ ] 在 Flutter 工程中落实基础样式（如 `app_colors.dart`, `app_theme.dart`）。
- [ ] 评估直接使用现成插件 (如 `flutter_neumorphic`) 还是自定义 Canvas/BoxShadow 以确保渲染性能。

---
## 决策记录 (Decision Log)
* **[2026-03-07]** 确定核心交互原则：基于大屏友好的人体工学，操作全部下沉，采用底部弹窗驱动 (Bottom Sheet Driven) 形态。
* **[2026-03-07]** 确定核心色彩与风格选型：奶油/白灰底色，选定 **轻拟物风格 (Neumorphism)**，配合咖啡色强调色。
