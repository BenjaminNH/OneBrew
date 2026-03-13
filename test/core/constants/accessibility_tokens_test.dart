import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/core/constants/app_colors.dart';
import 'package:one_brew/core/constants/app_text_styles.dart';

void main() {
  test('textSecondary contrast meets WCAG AA on app background', () {
    final ratio = _contrastRatio(AppColors.textSecondary, AppColors.background);
    expect(ratio, greaterThanOrEqualTo(4.5));
  });

  test('input hint style uses readable secondary text color', () {
    expect(AppTextStyles.inputHint.color, AppColors.textSecondary);
  });
}

double _contrastRatio(Color foreground, Color background) {
  final foregroundLum = _relativeLuminance(foreground);
  final backgroundLum = _relativeLuminance(background);
  final lighter = foregroundLum > backgroundLum ? foregroundLum : backgroundLum;
  final darker = foregroundLum > backgroundLum ? backgroundLum : foregroundLum;
  return (lighter + 0.05) / (darker + 0.05);
}

double _relativeLuminance(Color color) {
  final argb = color.toARGB32();
  final r = _linearizeChannel(((argb >> 16) & 0xFF) / 255);
  final g = _linearizeChannel(((argb >> 8) & 0xFF) / 255);
  final b = _linearizeChannel((argb & 0xFF) / 255);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

double _linearizeChannel(double value) {
  if (value <= 0.03928) return value / 12.92;
  return pow((value + 0.055) / 1.055, 2.4).toDouble();
}
