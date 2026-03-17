import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// OneBrew Timer Display Widget
/// Renders the large-format brew timer numerals with tabular alignment.
/// Optionally shows bloom-phase indicator and a progress arc.
///
/// Features:
/// - Tabular figures (no layout shift during countdown)
/// - mm:ss primary display
/// - Phase label (Bloom / Brewing / Done)
/// - Optional small sub-display for elapsed vs. total
///
/// Usage:
/// ```dart
/// AppTimerDisplay(
///   elapsedSeconds: 42,
///   targetSeconds: 180,
///   bloomSeconds: 30,
///   isRunning: true,
/// )
/// ```
class AppTimerDisplay extends StatelessWidget {
  const AppTimerDisplay({
    super.key,
    required this.elapsedSeconds,
    this.targetSeconds,
    this.bloomSeconds = 0,
    this.isRunning = false,
    this.isCountingDown = false,
    this.showPhaseLabel = true,
    this.showProgress = true,
    this.primaryTextStyle,
    this.phaseColor,
  });

  /// Elapsed seconds since timer started
  final int elapsedSeconds;

  /// Expected total brew duration in seconds (null = no target)
  final int? targetSeconds;

  /// Bloom duration in seconds (0 = no bloom phase)
  final int bloomSeconds;

  /// Whether the timer is actively counting
  final bool isRunning;

  /// If true, displays remaining time instead of elapsed
  final bool isCountingDown;

  /// Show phase label (Bloom / Brewing / Done)
  final bool showPhaseLabel;

  /// Show a simple linear progress indicator below the display
  final bool showProgress;

  /// Override main timer text style
  final TextStyle? primaryTextStyle;

  /// Override phase label color
  final Color? phaseColor;

  // ─── Computed properties ──────────────────

  String get _timerText {
    final displaySeconds = isCountingDown && targetSeconds != null
        ? (targetSeconds! - elapsedSeconds).clamp(0, targetSeconds!)
        : elapsedSeconds;
    final m = displaySeconds ~/ 60;
    final s = displaySeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  String get _phaseLabel {
    if (bloomSeconds > 0 && elapsedSeconds <= bloomSeconds) return 'Bloom';
    if (targetSeconds != null && elapsedSeconds >= targetSeconds!) {
      return 'Done ✓';
    }
    if (!isRunning && elapsedSeconds == 0) return 'Ready';
    return 'Brewing';
  }

  Color _phaseLabelColor(BuildContext context) {
    if (phaseColor != null) return phaseColor!;
    if (_phaseLabel == 'Bloom') return AppColors.secondary;
    if (_phaseLabel.startsWith('Done')) return AppColors.success;
    return AppColors.primary;
  }

  double get _progressRatio {
    if (targetSeconds == null || targetSeconds! <= 0) return 0.0;
    return (elapsedSeconds / targetSeconds!).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Phase Label ───────────────────────────
        if (showPhaseLabel)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _phaseLabel,
              key: ValueKey(_phaseLabel),
              style: AppTextStyles.titleMedium.copyWith(
                color: _phaseLabelColor(context),
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
              ),
            ),
          ),

        const SizedBox(height: AppSpacing.xs),

        // ── Primary Timer Numerals ────────────────
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          transitionBuilder: (child, anim) =>
              FadeTransition(opacity: anim, child: child),
          child: Text(
            _timerText,
            key: ValueKey(_timerText),
            style:
                primaryTextStyle ??
                AppTextStyles.timerDisplay.copyWith(
                  color: isRunning
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  shadows: isRunning
                      ? [
                          Shadow(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
          ),
        ),

        // ── Sub-display: elapsed / target ─────────
        if (targetSeconds != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${_formatSeconds(elapsedSeconds)} / ${_formatSeconds(targetSeconds!)}',
            style: AppTextStyles.labelMedium,
          ),
        ],

        // ── Progress bar ──────────────────────────
        if (showProgress && targetSeconds != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _TimerProgressBar(
            progress: _progressRatio,
            isOvertime: elapsedSeconds > (targetSeconds ?? 0),
          ),
        ],
      ],
    );
  }

  String _formatSeconds(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

/// Neumorphic linear progress bar for timer progress
class _TimerProgressBar extends StatelessWidget {
  const _TimerProgressBar({required this.progress, required this.isOvertime});

  final double progress;
  final bool isOvertime;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.sliderTrackHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppColors.debossedShadow,
        color: AppColors.background,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: Colors.transparent,
          color: isOvertime ? AppColors.error : AppColors.primary,
          minHeight: AppSpacing.sliderTrackHeight,
        ),
      ),
    );
  }
}

/// A compact inline timer chip — for displaying elapsed time
/// in history cards or the brew form header.
class TimerChip extends StatelessWidget {
  const TimerChip({super.key, required this.seconds, this.isRunning = false});

  final int seconds;
  final bool isRunning;

  String get _label {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isRunning
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: isRunning ? AppColors.primary : AppColors.shadowDark,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRunning ? Icons.timer : Icons.timer_outlined,
            size: AppSpacing.iconSmall,
            color: isRunning ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            _label,
            style: AppTextStyles.labelMedium.copyWith(
              color: isRunning ? AppColors.primary : AppColors.textSecondary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
