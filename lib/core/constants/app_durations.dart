/// OneCoffee Animation Duration Constants
/// Ref: docs/03_UI_Specification.md § 4.3 — Animation Timing
/// All animations: 150ms–250ms with Spring Physics
abstract final class AppDurations {
  // ─────────────────────────────────────────
  // Base Durations
  // ─────────────────────────────────────────

  /// 极速（hover 态、滴水动效）— 不可感知但流畅
  static const Duration instant = Duration(milliseconds: 80);

  /// 快速（按压反馈 OnTapDown → press-in / press-out）
  /// 模拟实体按键按入机械手感
  static const Duration fast = Duration(milliseconds: 150);

  /// 标准（大多数 UI 过渡动画基准）
  static const Duration standard = Duration(milliseconds: 200);

  /// 舒适（渐进展开、底部弹窗出现）
  static const Duration comfortable = Duration(milliseconds: 250);

  /// 从容（页面路由过渡、复杂动画）
  static const Duration relaxed = Duration(milliseconds: 350);

  /// 悠长（计时器进度弧线绘制、开屏 Logo 溶解）
  static const Duration slow = Duration(milliseconds: 500);

  // ─────────────────────────────────────────
  // Named Semantic Durations
  // ─────────────────────────────────────────

  /// 按压反馈 — OnTapDown/OnTapUp 转换
  static const Duration tapFeedback = fast;

  /// 渐进展开/收起动画
  static const Duration progressiveExpand = comfortable;

  /// 底部弹窗出现/消失
  static const Duration bottomSheet = comfortable;

  /// 页面路由过渡
  static const Duration pageTransition = relaxed;

  /// 卡片 hover / 选中状态
  static const Duration cardState = standard;

  /// 计时器表盘进度弧线更新
  static const Duration dialUpdate = instant;

  /// Chip / Tag 出现
  static const Duration chipAppear = standard;

  /// Snackbar / Toast 显示
  static const Duration snackbar = Duration(milliseconds: 3000);

  // ─────────────────────────────────────────
  // Timer-Specific Durations
  // ─────────────────────────────────────────

  /// 计时器 Tick 间隔（1 秒）
  static const Duration timerTick = Duration(seconds: 1);

  /// 计时开始前的倒计时延迟（UI 用）
  static const Duration timerCountdownDelay = Duration(milliseconds: 300);

  // ─────────────────────────────────────────
  // Millisecond Shortcuts (int constants for flexibility)
  // ─────────────────────────────────────────

  /// 80ms in milliseconds
  static const int instantMs = 80;

  /// 150ms in milliseconds
  static const int fastMs = 150;

  /// 200ms in milliseconds
  static const int standardMs = 200;

  /// 250ms in milliseconds
  static const int comfortableMs = 250;

  /// 350ms in milliseconds
  static const int relaxedMs = 350;

  /// 500ms in milliseconds
  static const int slowMs = 500;
}
