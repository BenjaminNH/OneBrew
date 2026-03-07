import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// OneCoffee Custom Slider (AppSlider)
/// A Neumorphism-styled slider for brew parameters (water weight, temperature, grind).
///
/// Features:
/// - Soft-shadow track showing debossed groove
/// - Coffee-brown active fill
/// - Animated thumb with press feedback
/// - Optional value label display
///
/// Usage:
/// ```dart
/// AppSlider(
///   value: _waterWeight,
///   min: 100,
///   max: 500,
///   label: '${_waterWeight.round()}g',
///   onChanged: (v) => setState(() => _waterWeight = v),
/// )
/// ```
class AppSlider extends StatefulWidget {
  const AppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.showValueLabel = true,
    this.unit = '',
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.trackHeight = 6.0,
    this.semanticLabel,
  });

  /// Current slider value
  final double value;

  /// Callback when value changes
  final ValueChanged<double> onChanged;

  /// Minimum value (default 0.0)
  final double min;

  /// Maximum value (default 1.0)
  final double max;

  /// Optional number of discrete steps
  final int? divisions;

  /// Optional tooltip label (shown above thumb when dragging)
  final String? label;

  /// Whether to show the current value below the slider
  final bool showValueLabel;

  /// Unit string appended to the value label (e.g. "g", "°C")
  final String unit;

  /// Override active track color
  final Color? activeColor;

  /// Override inactive track color
  final Color? inactiveColor;

  /// Override thumb color
  final Color? thumbColor;

  /// Track height
  final double trackHeight;

  /// Accessibility semantic label
  final String? semanticLabel;

  @override
  State<AppSlider> createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> {
  bool _isDragging = false;

  String get _displayValue {
    if (widget.divisions != null) {
      return '${widget.value.round()}${widget.unit}';
    }
    return '${widget.value.toStringAsFixed(1)}${widget.unit}';
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      slider: true,
      value: _displayValue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Slider track ─────────────────────────
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              boxShadow: AppColors.debossedShadow,
            ),
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: widget.activeColor ?? AppColors.primary,
                inactiveTrackColor:
                    widget.inactiveColor ?? AppColors.shadowDark,
                thumbColor: widget.thumbColor ?? AppColors.primary,
                overlayColor: AppColors.primary.withValues(alpha: 0.15),
                trackHeight: widget.trackHeight,
                thumbShape: _NeumorphicThumbShape(
                  isDragging: _isDragging,
                  thumbColor: widget.thumbColor ?? AppColors.primary,
                ),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                trackShape: const RoundedRectSliderTrackShape(),
                showValueIndicator: widget.label != null
                    ? ShowValueIndicator.onlyForDiscrete
                    : ShowValueIndicator.never,
                valueIndicatorColor: AppColors.primaryDark,
                valueIndicatorTextStyle: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                ),
              ),
              child: Slider(
                value: widget.value,
                min: widget.min,
                max: widget.max,
                divisions: widget.divisions,
                label: widget.label,
                onChangeStart: (_) => setState(() => _isDragging = true),
                onChangeEnd: (_) => setState(() => _isDragging = false),
                onChanged: widget.onChanged,
              ),
            ),
          ),

          // ── Value label ──────────────────────────
          if (widget.showValueLabel) ...[
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedSwitcher(
                duration: AppDurations.standard,
                child: Text(
                  _displayValue,
                  key: ValueKey(_displayValue),
                  style: AppTextStyles.numericValue,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Custom circular Neumorphic thumb for [AppSlider].
/// Shows a raised disc that "presses in" when dragging.
class _NeumorphicThumbShape extends SliderComponentShape {
  const _NeumorphicThumbShape({
    required this.isDragging,
    required this.thumbColor,
  });

  final bool isDragging;
  final Color thumbColor;
  static const double thumbRadius = 14.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // Outer shadow (soft embossed disc)
    final shadowPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // Dark shadow (bottom-right)
    shadowPaint.color = AppColors.shadowDark.withValues(alpha: 0.6);
    canvas.drawCircle(center + const Offset(3, 3), thumbRadius, shadowPaint);

    // Light shadow (top-left)
    shadowPaint.color = AppColors.shadowLight.withValues(alpha: 0.9);
    canvas.drawCircle(center + const Offset(-3, -3), thumbRadius, shadowPaint);

    // Main disc
    final fillPaint = Paint()
      ..color = isDragging ? thumbColor.withValues(alpha: 0.85) : thumbColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius, fillPaint);

    // Inner highlight dot
    if (!isDragging) {
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        center + const Offset(-3, -3),
        thumbRadius * 0.3,
        highlightPaint,
      );
    }
  }
}
