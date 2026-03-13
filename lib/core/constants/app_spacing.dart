/// OneBrew Spacing & Size Token System
/// Provides consistent spatial rhythm throughout the app.
/// Based on a 4dp base unit grid (4, 8, 12, 16, 24, 32, 48, 64).
/// Ref: docs/03_UI_Specification.md — Neumorphism sizing guidelines
abstract final class AppSpacing {
  // ─────────────────────────────────────────
  // Base Unit
  // ─────────────────────────────────────────

  /// The base unit of the 4dp grid system
  static const double _base = 4.0;

  // ─────────────────────────────────────────
  // Spacing Scale (Padding / Margin / Gap)
  // ─────────────────────────────────────────

  /// 2dp — Micro spacing (icon internal padding)
  static const double xxs = _base * 0.5; // 2.0

  /// 4dp — Extra extra small
  static const double xs = _base; // 4.0

  /// 8dp — Extra small (tight items)
  static const double sm = _base * 2; // 8.0

  /// 12dp — Small (compact form rows)
  static const double md = _base * 3; // 12.0

  /// 16dp — Medium (standard content padding)
  static const double lg = _base * 4; // 16.0

  /// 20dp — Large+
  static const double xl = _base * 5; // 20.0

  /// 24dp — Extra large (section gaps)
  static const double xxl = _base * 6; // 24.0

  /// 32dp — 2x Large (major layout divisions)
  static const double xxxl = _base * 8; // 32.0

  /// 48dp — 3x Large (hero sections)
  static const double huge = _base * 12; // 48.0

  /// 64dp — 4x Large (timer numerals bottom space)
  static const double massive = _base * 16; // 64.0

  // ─────────────────────────────────────────
  // Semantic Page Layout
  // ─────────────────────────────────────────

  /// 页面水平边距
  static const double pageHorizontal = lg; // 16.0

  /// 页面垂直边距（顶部）
  static const double pageTop = xxl; // 24.0

  /// 页面垂直边距（底部，为底部导航留空间）
  static const double pageBottom = massive; // 64.0

  /// 卡片内边距
  static const double cardPadding = lg; // 16.0

  /// 卡片间距
  static const double cardGap = md; // 12.0

  /// 表单行高（含 label + field）
  static const double formRowHeight = 56.0;

  /// 标准按钮高度
  static const double buttonHeight = 52.0;

  /// 小按钮高度
  static const double buttonSmallHeight = 40.0;

  /// 大圆形 CTA 按钮直径（计时器启动键）
  static const double ctaButtonDiameter = 88.0;

  /// 底部弹窗拖动指示条宽度
  static const double dragHandleWidth = 40.0;

  /// 底部弹窗拖动指示条高度
  static const double dragHandleHeight = 4.0;

  // ─────────────────────────────────────────
  // Border Radius
  // ─────────────────────────────────────────

  /// 极小圆角（徽章、标签）
  static const double radiusXs = 4.0;

  /// 小圆角（输入框、Chip）
  static const double radiusSm = 8.0;

  /// 中圆角（标准卡片）
  static const double radiusMd = 16.0;

  /// 大圆角（弹窗顶部、大卡片）
  static const double radiusLg = 24.0;

  /// 超大圆角（计时器圆盘、CTA 按钮）
  static const double radiusXl = 32.0;

  /// 圆形（圆形按钮、头像）
  static const double radiusCircle = 9999.0;

  // ─────────────────────────────────────────
  // Elevation / Neumorphism Depth
  // ─────────────────────────────────────────

  /// 阴影偏移量 — 大（卡片）
  static const double shadowOffsetLg = 6.0;

  /// 阴影偏移量 — 中（按钮）
  static const double shadowOffsetMd = 4.0;

  /// 阴影偏移量 — 小（芯片、小组件）
  static const double shadowOffsetSm = 2.0;

  /// 阴影模糊半径 — 大
  static const double shadowBlurLg = 12.0;

  /// 阴影模糊半径 — 中
  static const double shadowBlurMd = 8.0;

  /// 阴影模糊半径 — 小
  static const double shadowBlurSm = 4.0;

  // ─────────────────────────────────────────
  // Icon Sizes
  // ─────────────────────────────────────────

  /// 导航图标尺寸
  static const double iconNav = 24.0;

  /// 操作图标尺寸
  static const double iconAction = 20.0;

  /// 小图标（标签旁）
  static const double iconSmall = 16.0;

  // ─────────────────────────────────────────
  // Bottom Sheet
  // ─────────────────────────────────────────

  /// 底部弹窗最小高度比例（屏幕高度的 50%）
  static const double bottomSheetMinRatio = 0.50;

  /// 底部弹窗最大高度比例（屏幕高度的 75%）
  static const double bottomSheetMaxRatio = 0.75;
}
