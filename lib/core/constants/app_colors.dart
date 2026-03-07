import 'package:flutter/material.dart';

/// OneCoffee Color System
/// Based on Neumorphism / Soft UI design with Coffee & Cream palette
/// Ref: docs/03_UI_Specification.md § 2.2
abstract final class AppColors {
  // ─────────────────────────────────────────
  // Background / Surface
  // ─────────────────────────────────────────

  /// 奶油白背景 — 全局 App 背景，带极微弱暖意，不可纯白
  /// 决定软阴影效果的底色
  static const Color background = Color(0xFFF3F4F6);

  /// 卡片/表面色（略亮于背景）
  static const Color surface = Color(0xFFF5F5F3);

  // ─────────────────────────────────────────
  // Primary & Secondary Accent
  // ─────────────────────────────────────────

  /// 主强调色：咖啡棕
  /// 用于"开始冲煮"按钮按下态、选中滑块、关键进度条
  static const Color primary = Color(0xFF6F4E37);

  /// 主强调色深色变体
  static const Color primaryDark = Color(0xFF4E3524);

  /// 主强调色浅色变体
  static const Color primaryLight = Color(0xFF8B5A2B);

  /// 次强调色：拿铁/焦糖
  /// 次要强调或与主色搭配产生视觉梯度的元素
  static const Color secondary = Color(0xFFD2B48C);

  /// 次强调色深色变体
  static const Color secondaryDark = Color(0xFFB8966E);

  // ─────────────────────────────────────────
  // Text Colors
  // ─────────────────────────────────────────

  /// 主文本色：深意式 Espresso，避免纯黑
  /// 对比度 ≥ 9.0:1 on background (WCAG AAA)
  static const Color textPrimary = Color(0xFF2C1E16);

  /// 辅文本色：暖灰
  /// 用于辅文、占位符等较弱提示
  static const Color textSecondary = Color(0xFF78716C);

  /// 禁用/占位文本色（更淡）
  static const Color textDisabled = Color(0xFFABA5A2);

  // ─────────────────────────────────────────
  // Neumorphism Shadow System
  // ─────────────────────────────────────────

  /// 软质感高光色 — 左上角高光（材质亮面）
  static const Color shadowLight = Color(0xFFFFFFFF);

  /// 软质感投影色 — 右下角阴影（材质暗面）
  static const Color shadowDark = Color(0xFFD1D5DB);

  /// 软质感内阴影（按压态）
  static const Color innerShadowDark = Color(0xFFC8CBD0);

  // ─────────────────────────────────────────
  // State Colors
  // ─────────────────────────────────────────

  /// 成功绿
  static const Color success = Color(0xFF4A7C59);

  /// 警告橙
  static const Color warning = Color(0xFFCC8A2B);

  /// 错误红
  static const Color error = Color(0xFFC0392B);

  /// 信息蓝
  static const Color info = Color(0xFF445E7A);

  // ─────────────────────────────────────────
  // Neumorphism BoxShadow Presets
  // ─────────────────────────────────────────

  /// 标准浮出阴影（默认卡片/按钮的立体感）
  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: shadowLight,
      offset: const Offset(-6, -6),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: shadowDark,
      offset: const Offset(6, 6),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  /// 轻微浮出阴影（小组件、芯片）
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: shadowLight,
      offset: const Offset(-3, -3),
      blurRadius: 6,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: shadowDark,
      offset: const Offset(3, 3),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  /// 按压内陷阴影（按钮按下态 OnTapDown）
  static List<BoxShadow> get pressedShadow => [
    BoxShadow(
      color: innerShadowDark.withValues(alpha: 0.7),
      offset: const Offset(3, 3),
      blurRadius: 6,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: shadowLight.withValues(alpha: 0.5),
      offset: const Offset(-3, -3),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  /// 深度凹陷阴影（输入框/凹槽效果）
  static List<BoxShadow> get debossedShadow => [
    BoxShadow(
      color: shadowDark,
      offset: const Offset(4, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: shadowLight,
      offset: const Offset(-4, -4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];
}
