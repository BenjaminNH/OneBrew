import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:one_coffee/core/constants/app_colors.dart';
import 'package:one_coffee/core/constants/app_durations.dart';
import 'package:one_coffee/core/constants/app_spacing.dart';
import 'package:one_coffee/core/constants/app_text_styles.dart';
import 'package:one_coffee/core/theme/app_theme.dart';
import 'package:one_coffee/core/theme/dark_theme.dart';
import 'package:one_coffee/core/utils/date_utils.dart';
import 'package:one_coffee/core/utils/extensions.dart';
import 'package:one_coffee/core/utils/timer_utils.dart';
import 'package:one_coffee/core/widgets/app_card.dart';
import 'package:one_coffee/core/widgets/app_timer_display.dart';
import 'package:one_coffee/core/widgets/progressive_expand.dart';
import 'package:one_coffee/shared/helpers/brew_param_defaults.dart';

void main() {
  // ─────────────────────────────────────────────────────────────
  // AppColors Tests
  // ─────────────────────────────────────────────────────────────
  group('AppColors', () {
    test('background color has correct hex value', () {
      // Compare individual RGBA components to avoid deprecated .value usage
      const expected = Color(0xFFF3F4F6);
      expect(AppColors.background.r, closeTo(expected.r, 0.01));
      expect(AppColors.background.g, closeTo(expected.g, 0.01));
      expect(AppColors.background.b, closeTo(expected.b, 0.01));
    });

    test('primary (coffee brown) has correct hex value', () {
      const expected = Color(0xFF6F4E37);
      expect(AppColors.primary.r, closeTo(expected.r, 0.01));
      expect(AppColors.primary.g, closeTo(expected.g, 0.01));
      expect(AppColors.primary.b, closeTo(expected.b, 0.01));
    });

    test('textPrimary is not pure black', () {
      expect(AppColors.textPrimary, isNot(equals(Colors.black)));
    });

    test('elevatedShadow returns two shadows', () {
      expect(AppColors.elevatedShadow.length, equals(2));
    });

    test('shadowLight is pure white', () {
      expect(AppColors.shadowLight, equals(Colors.white));
    });

    test('pressedShadow returns two shadows', () {
      expect(AppColors.pressedShadow.length, equals(2));
    });

    test('debossedShadow returns two shadows', () {
      expect(AppColors.debossedShadow.length, equals(2));
    });
  });

  // ─────────────────────────────────────────────────────────────
  // AppSpacing Tests
  // ─────────────────────────────────────────────────────────────
  group('AppSpacing', () {
    test('xs is 4dp', () => expect(AppSpacing.xs, equals(4.0)));
    test('sm is 8dp', () => expect(AppSpacing.sm, equals(8.0)));
    test('md is 12dp', () => expect(AppSpacing.md, equals(12.0)));
    test('lg is 16dp', () => expect(AppSpacing.lg, equals(16.0)));
    test('xxl is 24dp', () => expect(AppSpacing.xxl, equals(24.0)));

    test('radiusMd is 16', () => expect(AppSpacing.radiusMd, equals(16.0)));
    test(
      'buttonHeight is 52',
      () => expect(AppSpacing.buttonHeight, equals(52.0)),
    );

    test('bottomSheetMinRatio is 0.50', () {
      expect(AppSpacing.bottomSheetMinRatio, equals(0.50));
    });
    test('bottomSheetMaxRatio is 0.75', () {
      expect(AppSpacing.bottomSheetMaxRatio, equals(0.75));
    });
  });

  // ─────────────────────────────────────────────────────────────
  // AppDurations Tests
  // ─────────────────────────────────────────────────────────────
  group('AppDurations', () {
    test('fast is 150ms', () {
      expect(AppDurations.fast.inMilliseconds, equals(150));
    });

    test('standard is 200ms', () {
      expect(AppDurations.standard.inMilliseconds, equals(200));
    });

    test('comfortable is 250ms', () {
      expect(AppDurations.comfortable.inMilliseconds, equals(250));
    });

    test('tapFeedback equals fast', () {
      expect(AppDurations.tapFeedback, equals(AppDurations.fast));
    });

    test('timerTick is 1 second', () {
      expect(AppDurations.timerTick.inSeconds, equals(1));
    });
  });

  // ─────────────────────────────────────────────────────────────
  // AppTextStyles Tests
  // ─────────────────────────────────────────────────────────────
  group('AppTextStyles', () {
    test('timerDisplay has tabular figures feature', () {
      final features = AppTextStyles.timerDisplay.fontFeatures;
      expect(features, isNotNull);
      expect(
        features!.any((f) => f == const FontFeature.tabularFigures()),
        isTrue,
      );
    });

    test('timerDisplay fontSize is 72', () {
      expect(AppTextStyles.timerDisplay.fontSize, equals(72.0));
    });

    test('displayLarge fontSize is 36', () {
      expect(AppTextStyles.displayLarge.fontSize, equals(36.0));
    });

    test('bodySmall uses textSecondary color', () {
      expect(AppTextStyles.bodySmall.color, equals(AppColors.textSecondary));
    });
  });

  // ─────────────────────────────────────────────────────────────
  // AppTheme Tests
  // ─────────────────────────────────────────────────────────────
  group('AppTheme', () {
    test('light theme uses Material3', () {
      expect(AppTheme.light.useMaterial3, isTrue);
    });

    test('light theme background is cream white', () {
      expect(
        AppTheme.light.scaffoldBackgroundColor,
        equals(AppColors.background),
      );
    });

    test('light theme primary color is coffee brown', () {
      expect(AppTheme.light.colorScheme.primary, equals(AppColors.primary));
    });

    test('dark theme uses Material3', () {
      expect(DarkTheme.dark.useMaterial3, isTrue);
    });

    test('dark theme brightness is dark', () {
      expect(DarkTheme.dark.brightness, equals(Brightness.dark));
    });
  });

  // ─────────────────────────────────────────────────────────────
  // TimerUtils Tests
  // ─────────────────────────────────────────────────────────────
  group('TimerUtils', () {
    test('formatSeconds: 90 → "1:30"', () {
      expect(TimerUtils.formatSeconds(90), equals('1:30'));
    });

    test('formatSeconds: 65 → "1:05"', () {
      expect(TimerUtils.formatSeconds(65), equals('1:05'));
    });

    test('formatSeconds: 0 → "0:00"', () {
      expect(TimerUtils.formatSeconds(0), equals('0:00'));
    });

    test('formatSeconds: negative value shows prefix', () {
      expect(TimerUtils.formatSeconds(-30), equals('-0:30'));
    });

    test('formatVerbose: 195 → "3m 15s"', () {
      expect(TimerUtils.formatVerbose(195), equals('3m 15s'));
    });

    test('formatVerbose: 60 → "1m"', () {
      expect(TimerUtils.formatVerbose(60), equals('1m'));
    });

    test('formatVerbose: 45 → "45s"', () {
      expect(TimerUtils.formatVerbose(45), equals('45s'));
    });

    test('progressRatio: 90/180 = 0.5', () {
      expect(TimerUtils.progressRatio(90, 180), closeTo(0.5, 0.001));
    });

    test('progressRatio: 0/180 = 0.0', () {
      expect(TimerUtils.progressRatio(0, 180), equals(0.0));
    });

    test('progressRatio: target 0 returns 0.0', () {
      expect(TimerUtils.progressRatio(90, 0), equals(0.0));
    });

    test('remainingSeconds: 90 elapsed, 180 target = 90', () {
      expect(TimerUtils.remainingSeconds(90, 180), equals(90));
    });

    test('remainingSeconds: 200 elapsed, 180 target = 0 (clamp)', () {
      expect(TimerUtils.remainingSeconds(200, 180), equals(0));
    });

    test('isInBloomPhase: elapsed 20, bloom 30 → true', () {
      expect(TimerUtils.isInBloomPhase(20, 30), isTrue);
    });

    test('isInBloomPhase: elapsed 35, bloom 30 → false', () {
      expect(TimerUtils.isInBloomPhase(35, 30), isFalse);
    });

    test('phaseLabel: bloom phase → "Bloom"', () {
      expect(
        TimerUtils.phaseLabel(
          elapsedSeconds: 20,
          bloomDuration: 30,
          targetDuration: 180,
        ),
        equals('Bloom'),
      );
    });

    test('phaseLabel: after target → "Done"', () {
      expect(
        TimerUtils.phaseLabel(
          elapsedSeconds: 185,
          bloomDuration: 0,
          targetDuration: 180,
        ),
        equals('Done'),
      );
    });

    test('suggestedBloomSeconds returns 30', () {
      expect(TimerUtils.suggestedBloomSeconds(), equals(30));
    });
  });

  // ─────────────────────────────────────────────────────────────
  // AppDateUtils Tests
  // ─────────────────────────────────────────────────────────────
  group('AppDateUtils', () {
    test('formatRelative: just now', () {
      final now = DateTime.now().subtract(const Duration(seconds: 30));
      expect(AppDateUtils.formatRelative(now), equals('Just now'));
    });

    test('formatRelative: minutes ago', () {
      final past = DateTime.now().subtract(const Duration(minutes: 5));
      expect(AppDateUtils.formatRelative(past), contains('minutes ago'));
    });

    test('formatRelative: today shows time', () {
      final today = DateTime.now().subtract(const Duration(hours: 2));
      expect(AppDateUtils.formatRelative(today), startsWith('Today'));
    });

    test('sectionHeader: today → "Today"', () {
      expect(AppDateUtils.sectionHeader(DateTime.now()), equals('Today'));
    });

    test('sectionHeader: yesterday → "Yesterday"', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(AppDateUtils.sectionHeader(yesterday), equals('Yesterday'));
    });
  });

  // ─────────────────────────────────────────────────────────────
  // String Extensions Tests
  // ─────────────────────────────────────────────────────────────
  group('StringX extensions', () {
    test('capitalized: "hello" → "Hello"', () {
      expect('hello'.capitalized, equals('Hello'));
    });

    test('capitalized: empty string → empty', () {
      expect(''.capitalized, equals(''));
    });

    test('titleCase: "hello world" → "Hello World"', () {
      expect('hello world'.titleCase, equals('Hello World'));
    });

    test('nullIfEmpty: blank returns null', () {
      expect('   '.nullIfEmpty, isNull);
    });

    test('nullIfEmpty: non-empty returns value', () {
      expect('abc'.nullIfEmpty, equals('abc'));
    });

    test('equalsIgnoreCase: case-insensitive', () {
      expect('ABC'.equalsIgnoreCase('abc'), isTrue);
    });

    test('truncate: long string gets ellipsis', () {
      expect('Hello World'.truncate(8), equals('Hello W…'));
    });

    test('truncate: short string unchanged', () {
      expect('Hi'.truncate(10), equals('Hi'));
    });
  });

  // ─────────────────────────────────────────────────────────────
  // IntX Extensions Tests
  // ─────────────────────────────────────────────────────────────
  group('IntX extensions', () {
    test('90.asTimerString → "1:30"', () {
      expect(90.asTimerString, equals('1:30'));
    });

    test('7.padded(2) → "07"', () {
      expect(7.padded(2), equals('07'));
    });

    test('between: 5.between(1,10) → true', () {
      expect(5.between(1, 10), isTrue);
    });

    test('between: 0.between(1,10) → false', () {
      expect(0.between(1, 10), isFalse);
    });
  });

  // ─────────────────────────────────────────────────────────────
  // BrewParamDefaults Tests
  // ─────────────────────────────────────────────────────────────
  group('BrewParamDefaults', () {
    test('water weight = coffee × ratio', () {
      expect(
        BrewParamDefaults.waterWeightG,
        equals(
          BrewParamDefaults.coffeeWeightG *
              BrewParamDefaults.waterToCoffeeRatio,
        ),
      );
    });

    test('computeWaterWeight: 15g coffee, 15 ratio → 225g', () {
      expect(BrewParamDefaults.computeWaterWeight(15, 15), equals(225.0));
    });

    test('computeRatio: coffee 15g, water 225g → ratio 15', () {
      expect(BrewParamDefaults.computeRatio(15, 225), closeTo(15.0, 0.01));
    });

    test('computeRatio: coffee 0 → returns default ratio', () {
      expect(
        BrewParamDefaults.computeRatio(0, 225),
        equals(BrewParamDefaults.waterToCoffeeRatio),
      );
    });

    test('suggestedBloomWater: 15g coffee → 30g bloom water', () {
      expect(BrewParamDefaults.suggestedBloomWater(15), equals(30.0));
    });

    test('grindSimpleLabels has 7 entries', () {
      expect(BrewParamDefaults.grindSimpleLabels.length, equals(7));
    });

    test('default isQuickMode is true', () {
      expect(BrewParamDefaults.isQuickMode, isTrue);
    });

    test('waterTemp default is 93°C', () {
      expect(BrewParamDefaults.waterTempC, equals(93.0));
    });

    test('bloomTime default is 30s', () {
      expect(BrewParamDefaults.bloomTimeS, equals(30));
    });
  });

  // ─────────────────────────────────────────────────────────────
  // Widget Tests
  // ─────────────────────────────────────────────────────────────
  group('AppCard Widget', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(body: AppCard(child: const Text('Test Card Content'))),
        ),
      );
      expect(find.text('Test Card Content'), findsOneWidget);
    });

    testWidgets('tap callback is invoked', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: AppCard(
              onTap: () => tapped = true,
              child: const Text('Tappable'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Tappable'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('AppCardFlat renders child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(body: const AppCardFlat(child: Text('Flat Card'))),
        ),
      );
      expect(find.text('Flat Card'), findsOneWidget);
    });
  });

  group('AppTimerDisplay Widget', () {
    testWidgets('renders timer text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: AppTimerDisplay(elapsedSeconds: 90, targetSeconds: 180),
          ),
        ),
      );
      expect(find.text('1:30'), findsOneWidget);
    });

    testWidgets('shows Bloom phase label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: AppTimerDisplay(
              elapsedSeconds: 15,
              bloomSeconds: 30,
              targetSeconds: 180,
            ),
          ),
        ),
      );
      expect(find.text('Bloom'), findsOneWidget);
    });

    testWidgets('shows Done when elapsed exceeds target', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: AppTimerDisplay(elapsedSeconds: 200, targetSeconds: 180),
          ),
        ),
      );
      expect(find.text('Done ✓'), findsOneWidget);
    });
  });

  group('ProgressiveExpand Widget', () {
    testWidgets('collapsed content is shown', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: ProgressiveExpand(
              collapsedChild: const Text('Collapsed Content'),
              expandedChild: const Text('Expanded Content'),
            ),
          ),
        ),
      );
      expect(find.text('Collapsed Content'), findsOneWidget);
    });

    testWidgets('expanded content appears after toggle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: ProgressiveExpand(
              collapsedChild: const Text('Always Visible'),
              expandedChild: const Text('Hidden Content'),
            ),
          ),
        ),
      );

      // Before tap: expanded content should not be visible
      // (it's hidden in SizeTransition with size 0)
      expect(find.text('Always Visible'), findsOneWidget);

      // Tap the expand button
      await tester.tap(find.text('Show more'));
      await tester.pumpAndSettle();

      // After tap: should be visible
      expect(find.text('Hidden Content'), findsOneWidget);
    });

    testWidgets('shows custom expand label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: ProgressiveExpand(
              collapsedChild: const Text('Collapsed'),
              expandedChild: const Text('Expanded'),
              expandLabel: 'Show advanced',
              collapseLabel: 'Hide advanced',
            ),
          ),
        ),
      );
      expect(find.text('Show advanced'), findsOneWidget);
    });
  });
}
