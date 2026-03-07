import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_spacing.dart';
import 'core/constants/app_text_styles.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/dark_theme.dart';
import 'core/widgets/app_card.dart';
import 'core/widgets/app_slider.dart';
import 'core/widgets/app_timer_display.dart';
import 'core/widgets/progressive_expand.dart';
import 'features/brew_logger/presentation/pages/brew_logger_page.dart';
import 'features/inventory/presentation/widgets/smart_tag_field.dart';
import 'features/inventory/presentation/widgets/template_picker.dart';

void main() {
  runApp(const ProviderScope(child: OneCoffeeApp()));
}

class OneCoffeeApp extends StatelessWidget {
  const OneCoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneCoffee',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: DarkTheme.dark,
      themeMode: ThemeMode.light,
      // Temporary pointer to BrewLoggerPage for Phase 4 manual testing.
      // Phase 7 will replace this with GoRouter
      home: const BrewLoggerPage(),
    );
  }
}

/// Temporary demo page to verify Phase 0 deliverables.
/// Will be replaced by GoRouter + BrewLoggerPage in Phase 7.
class _Phase0DemoPage extends StatefulWidget {
  const _Phase0DemoPage();

  @override
  State<_Phase0DemoPage> createState() => _Phase0DemoPageState();
}

class _Phase0DemoPageState extends State<_Phase0DemoPage> {
  double _waterWeight = 225.0;
  double _waterTemp = 93.0;
  List<String> _beanTags = [];
  bool _timerRunning = false;
  int _elapsed = 42;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal,
            vertical: AppSpacing.pageTop,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────
              Text(
                'OneCoffee',
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Text(
                'Phase 0 — Design System Demo',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Timer Display ──────────────────────
              AppCard(
                child: Column(
                  children: [
                    AppTimerDisplay(
                      elapsedSeconds: _elapsed,
                      targetSeconds: 180,
                      bloomSeconds: 30,
                      isRunning: _timerRunning,
                      showProgress: true,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        _timerRunning = !_timerRunning;
                        if (_timerRunning) _elapsed += 10;
                      }),
                      child: Text(_timerRunning ? 'Pause' : 'Start Brewing'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.cardGap),

              // ── Slider Demo ────────────────────────
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Water', style: AppTextStyles.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    AppSlider(
                      value: _waterWeight,
                      min: 100,
                      max: 500,
                      divisions: 80,
                      unit: 'g',
                      label: '${_waterWeight.round()}g',
                      onChanged: (v) => setState(() => _waterWeight = v),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Temperature', style: AppTextStyles.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    AppSlider(
                      value: _waterTemp,
                      min: 60,
                      max: 100,
                      divisions: 40,
                      unit: '°C',
                      label: '${_waterTemp.round()}°C',
                      onChanged: (v) => setState(() => _waterTemp = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.cardGap),

              // ── Phase 3 Inventory Demo ────────────
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phase 3: Inventory Integrations',
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SmartTagField(
                      type: TagFieldType.bean,
                      tags: _beanTags,
                      labelText: 'Coffee Bean',
                      hintText: 'Type to add or search...',
                      singleSelection: true,
                      onTagsChanged: (tags) => setState(() => _beanTags = tags),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TemplatePicker(
                      onTemplateSelected: (template) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Selected template: $template'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.cardGap),

              // ── Progressive Expand Demo ────────────
              AppCard(
                child: ProgressiveExpand(
                  collapsedChild: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.tune,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Essential Parameters',
                          style: AppTextStyles.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  expandedChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bloom Time: 30s', style: AppTextStyles.bodyMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Pour Method: Spiral',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Water Type: Filtered',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Room Temp: 22°C', style: AppTextStyles.bodyMedium),
                    ],
                  ),
                  expandLabel: 'Show advanced parameters',
                  collapseLabel: 'Hide advanced',
                ),
              ),
              const SizedBox(height: AppSpacing.cardGap),

              // ── Color palette swatch ───────────────
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Color Palette', style: AppTextStyles.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        _ColorSwatch(AppColors.primary, 'Primary'),
                        const SizedBox(width: AppSpacing.xs),
                        _ColorSwatch(AppColors.secondary, 'Secondary'),
                        const SizedBox(width: AppSpacing.xs),
                        _ColorSwatch(AppColors.background, 'BG', border: true),
                        const SizedBox(width: AppSpacing.xs),
                        _ColorSwatch(AppColors.textPrimary, 'Text'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.pageBottom),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch(this.color, this.label, {this.border = false});

  final Color color;
  final String label;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: border ? Border.all(color: AppColors.shadowDark) : null,
            boxShadow: AppColors.softShadow,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.labelSmall),
      ],
    );
  }
}
