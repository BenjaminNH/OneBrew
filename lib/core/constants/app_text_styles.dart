import 'package:flutter/material.dart';

import 'app_colors.dart';

/// OneCoffee Typography System
/// Headers/Numbers: serif/elegant fonts (Playfair Display or Bodoni Moda equivalents via Google Fonts)
/// Body: system native sans-serif (SF Pro / Roboto / system-ui)
/// Ref: docs/03_UI_Specification.md § 2.3
///
/// Note: For custom serif fonts (Playfair Display), add google_fonts dependency later.
/// Phase 0 uses pure Flutter TextStyle with system fallbacks.
abstract final class AppTextStyles {
  // ─────────────────────────────────────────
  // Display / Hero — Timer numerals, main headlines
  // ─────────────────────────────────────────

  /// 超大计时器数字 — Tabular figures to prevent layout shift during countdown
  static const TextStyle timerDisplay = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -2.0,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// 大展示标题 — 页面核心标题（如"准备冲煮"）
  static const TextStyle displayLarge = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.1,
  );

  /// 中展示标题
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.2,
  );

  // ─────────────────────────────────────────
  // Headlines — Section titles
  // ─────────────────────────────────────────

  /// H1 — 功能区标题
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.3,
  );

  /// H2 — 子功能区 / 卡片标题
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.1,
    height: 1.3,
  );

  /// H3 — 小标题 / 分组标签
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ─────────────────────────────────────────
  // Title — List item titles, form labels
  // ─────────────────────────────────────────

  /// 列表项标题
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// 表单标签
  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// 小标签
  static const TextStyle titleSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ─────────────────────────────────────────
  // Body — Regular content
  // ─────────────────────────────────────────

  /// 正文大 — 卡片内容、描述文字
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  /// 正文中 — 默认正文
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  /// 正文小 — 辅助信息、注释
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ─────────────────────────────────────────
  // Label — Chips, badges, captions
  // ─────────────────────────────────────────

  /// 大标签 — Chip 文本、按钮标签
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
    height: 1.2,
  );

  /// 中标签
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
    height: 1.2,
  );

  /// 小标签 — 徽章、极小辅助信息
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textDisabled,
    letterSpacing: 0.3,
    height: 1.2,
  );

  // ─────────────────────────────────────────
  // Semantic Variants
  // ─────────────────────────────────────────

  /// 主色按钮文字
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.5,
    height: 1.2,
  );

  /// 次级按钮文字
  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 0.3,
    height: 1.2,
  );

  /// 输入框文字
  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// 输入框占位符
  static const TextStyle inputHint = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textDisabled,
    height: 1.5,
  );

  /// 数值数字（参数值显示）— Tabular figures
  static const TextStyle numericValue = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    fontFeatures: [FontFeature.tabularFigures()],
    height: 1.2,
  );

  /// 单位文字（跟随参数值旁边）
  static const TextStyle unitLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.2,
  );
}
