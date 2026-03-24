import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

enum AppSuggestionVisibility { enabled, hidden, disabled }

extension AppSuggestionVisibilityX on AppSuggestionVisibility {
  bool get shouldRenderSuggestions => this == AppSuggestionVisibility.enabled;
}

abstract final class AppInputStyle {
  static BorderRadius get borderRadius =>
      BorderRadius.circular(AppSpacing.radiusSm);

  static Color get shellColor => AppColors.background;
  static Color get fillColor => shellColor;
  static Color get borderColor =>
      AppColors.secondaryDark.withValues(alpha: 0.48);
  static Color get focusBorderColor =>
      AppColors.primary.withValues(alpha: 0.82);
  static Color get disabledBorderColor =>
      AppColors.shadowDark.withValues(alpha: 0.65);

  static OutlineInputBorder borderFor(Color color, {double width = 1.15}) =>
      OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: color, width: width),
      );

  static InputDecoration decoration({
    String? labelText,
    String? hintText,
    String? helperText,
    String? errorText,
    String? suffixText,
    Widget? suffixIcon,
    bool enabled = true,
    bool isDense = false,
    EdgeInsetsGeometry? contentPadding,
    Color? fill,
  }) {
    final resolvedFill = fill ?? fillColor;
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      suffixText: suffixText,
      suffixIcon: suffixIcon,
      enabled: enabled,
      isDense: isDense,
      filled: true,
      fillColor: resolvedFill,
      contentPadding:
          contentPadding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
      border: borderFor(borderColor),
      enabledBorder: borderFor(enabled ? borderColor : disabledBorderColor),
      disabledBorder: borderFor(disabledBorderColor),
      focusedBorder: borderFor(focusBorderColor, width: 1.9),
      errorBorder: borderFor(AppColors.error, width: 1.35),
      focusedErrorBorder: borderFor(AppColors.error, width: 1.9),
    );
  }

  static BoxDecoration surfaceDecoration({
    bool focused = false,
    Color? backgroundColor,
    BoxBorder? border,
  }) {
    final resolvedBackground = backgroundColor ?? shellColor;
    final resolvedBorder =
        border ?? Border.all(color: focused ? focusBorderColor : borderColor);

    return BoxDecoration(
      color: resolvedBackground,
      borderRadius: borderRadius,
      border: resolvedBorder,
      boxShadow: [
        BoxShadow(
          color: Colors.white.withValues(alpha: focused ? 0.78 : 0.66),
          offset: const Offset(
            -AppSpacing.shadowOffsetSm,
            -AppSpacing.shadowOffsetSm,
          ),
          blurRadius: focused ? AppSpacing.shadowBlurSm : 5.0,
        ),
        BoxShadow(
          color: AppColors.secondaryDark.withValues(
            alpha: focused ? 0.18 : 0.12,
          ),
          offset: const Offset(
            AppSpacing.shadowOffsetSm,
            AppSpacing.shadowOffsetSm,
          ),
          blurRadius: focused ? AppSpacing.shadowBlurSm : 5.0,
        ),
      ],
    );
  }

  static InputDecorationTheme theme() => InputDecorationTheme(
    filled: true,
    fillColor: fillColor,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    border: borderFor(borderColor),
    enabledBorder: borderFor(borderColor),
    disabledBorder: borderFor(disabledBorderColor),
    focusedBorder: borderFor(focusBorderColor, width: 1.9),
    errorBorder: borderFor(AppColors.error, width: 1.35),
    focusedErrorBorder: borderFor(AppColors.error, width: 1.9),
    hintStyle: AppTextStyles.inputHint,
    labelStyle: AppTextStyles.titleMedium.copyWith(
      color: AppColors.textSecondary,
    ),
    floatingLabelStyle: AppTextStyles.labelSmall.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w700,
    ),
  );
}
