import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// OneBrew Dark Theme (Minimal implementation — reserved for Phase 8)
/// Dark variant of the Neumorphism style — deep espresso tones.
abstract final class DarkTheme {
  // Dark palette constants
  static const Color _darkBackground = Color(0xFF1A1210);
  static const Color _darkSurface = Color(0xFF221916);
  static const Color _darkShadowLight = Color(0xFF2E211C);
  static const Color _darkShadowDark = Color(0xFF0E0908);
  static const Color _darkTextPrimary = Color(0xFFF0EDE8);
  static const Color _darkTextSecondary = Color(0xFFA89D97);

  /// The primary Dark ThemeData for the application
  static ThemeData get dark {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.secondary, // Latte/Caramel as primary in dark mode
      onPrimary: _darkBackground,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: _darkTextPrimary,
      secondary: AppColors.primary,
      onSecondary: _darkTextPrimary,
      secondaryContainer: Color(0xFF3D2A1E),
      onSecondaryContainer: _darkTextPrimary,
      tertiary: AppColors.secondaryDark,
      onTertiary: _darkBackground,
      error: Color(0xFFCF6679),
      onError: _darkBackground,
      surface: _darkSurface,
      onSurface: _darkTextPrimary,
      surfaceContainerHighest: Color(0xFF2E211C),
      onSurfaceVariant: _darkTextSecondary,
      outline: Color(0xFF4A3830),
      shadow: _darkShadowDark,
      scrim: Color(0x99000000),
      inverseSurface: _darkTextPrimary,
      onInverseSurface: _darkBackground,
      inversePrimary: AppColors.primary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _darkBackground,

      // ── Typography ──────────────────────────────
      textTheme: _buildDarkTextTheme(),

      // ── AppBar ──────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBackground,
        foregroundColor: _darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _darkTextPrimary,
        ),
      ),

      // ── Card ──────────────────────────────────────
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),

      // ── ElevatedButton ────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: _darkBackground,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          elevation: 0,
          textStyle: AppTextStyles.buttonPrimary.copyWith(
            color: _darkBackground,
          ),
        ),
      ),

      // ── BottomSheet ───────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.radiusLg),
            topRight: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
        elevation: 0,
        dragHandleColor: Color(0xFF5A4035),
        showDragHandle: true,
      ),

      // ── SliderTheme ───────────────────────────────
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.secondary,
        inactiveTrackColor: Color(0xFF3D2A1E),
        thumbColor: AppColors.secondary,
        overlayColor: Color(0x29D2B48C),
        trackHeight: 4.0,
      ),

      // ── NavigationBar ─────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _darkSurface,
        indicatorColor: AppColors.secondary.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.secondary);
          }
          return const IconThemeData(color: Color(0xFF7A6A62));
        }),
        elevation: 0,
      ),
    );
  }

  static TextTheme _buildDarkTextTheme() {
    // Reuse AppTextStyles but override colors for dark background
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(
        color: _darkTextPrimary,
      ),
      displayMedium: AppTextStyles.displayMedium.copyWith(
        color: _darkTextPrimary,
      ),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(
        color: _darkTextPrimary,
      ),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(
        color: _darkTextPrimary,
      ),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(
        color: _darkTextPrimary,
      ),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: _darkTextPrimary),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: _darkTextPrimary),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: _darkTextSecondary),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: _darkTextPrimary),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: _darkTextPrimary),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: _darkTextSecondary),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: _darkTextPrimary),
      labelMedium: AppTextStyles.labelMedium.copyWith(
        color: _darkTextSecondary,
      ),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: _darkTextSecondary),
    );
  }

  /// Dark mode Neumorphism shadow list (inverted depth perception)
  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: _darkShadowLight,
      offset: const Offset(-4, -4),
      blurRadius: 8,
    ),
    BoxShadow(
      color: _darkShadowDark,
      offset: const Offset(4, 4),
      blurRadius: 8,
    ),
  ];
}
