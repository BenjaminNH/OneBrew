import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_spacing.dart';

import '../../../../core/widgets/app_timer_display.dart';
import '../controllers/brew_timer_controller.dart';

/// The interactive brew timer widget.
///
/// Displays a large timer face with start/pause/reset controls.
/// Follows the Neumorphic Dial design from UI Spec § 4.1.
///
/// Reads timer state from [brewTimerControllerProvider] and notifies
/// the parent via [onElapsedChanged] callback.
class BrewTimerWidget extends ConsumerWidget {
  const BrewTimerWidget({
    super.key,
    this.onElapsedChanged,
    this.targetSeconds,
    this.bloomSeconds = 0,
  });

  /// Callback fired on each elapsed second change.
  final ValueChanged<int>? onElapsedChanged;

  /// Optional target brew duration. Enables countdown and progress ring.
  final int? targetSeconds;

  /// Pre-infusion / bloom duration in seconds.
  final int bloomSeconds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(brewTimerControllerProvider);
    final ctrl = ref.read(brewTimerControllerProvider.notifier);

    // Propagate elapsed to parent (for save operation).
    ref.listen<BrewTimerState>(brewTimerControllerProvider, (previous, next) {
      if (previous?.elapsedSeconds != next.elapsedSeconds) {
        onElapsedChanged?.call(next.elapsedSeconds);
      }
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Neumorphic dial container ──────────────────────────────────
        _NeumorphicDial(
          child: AppTimerDisplay(
            elapsedSeconds: timer.elapsedSeconds,
            targetSeconds: targetSeconds,
            bloomSeconds: bloomSeconds,
            isRunning: timer.isRunning,
            isCountingDown: timer.isCountingDown,
            showProgress: targetSeconds != null,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // ── Timer controls ─────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Reset button
            _CircleButton(
              icon: Icons.refresh_rounded,
              onPressed: ctrl.reset,
              tooltip: 'Reset timer',
              size: 48,
              semanticsLabel: 'Reset timer',
            ),
            const SizedBox(width: AppSpacing.xxxl),

            // Start / Pause main CTA
            _BrewCtaButton(
              isRunning: timer.isRunning,
              isPaused: timer.isPaused,
              onTap: () {
                if (timer.isRunning) {
                  ctrl.pause();
                } else {
                  ctrl.start();
                }
              },
            ),
            const SizedBox(width: AppSpacing.xxxl),

            // Count-up / countdown toggle
            _CircleButton(
              icon: timer.isCountingDown
                  ? Icons.timer_outlined
                  : Icons.hourglass_bottom_rounded,
              onPressed: ctrl.toggleCountingDown,
              tooltip: timer.isCountingDown
                  ? 'Switch to count-up'
                  : 'Switch to countdown',
              size: 48,
              semanticsLabel: 'Toggle countdown mode',
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Neumorphic circular dial container for the timer display.
class _NeumorphicDial extends StatelessWidget {
  const _NeumorphicDial({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.background,
        boxShadow: AppColors.elevatedShadow,
      ),
      // Inner debossed ring
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.background,
            boxShadow: AppColors.debossedShadow,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// Large start/pause CTA button in the middle of the timer controls.
class _BrewCtaButton extends StatefulWidget {
  const _BrewCtaButton({
    required this.isRunning,
    required this.isPaused,
    required this.onTap,
  });

  final bool isRunning;
  final bool isPaused;
  final VoidCallback onTap;

  @override
  State<_BrewCtaButton> createState() => _BrewCtaButtonState();
}

class _BrewCtaButtonState extends State<_BrewCtaButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final label = widget.isRunning
        ? 'Pause'
        : (widget.isPaused ? 'Resume' : 'Brew');
    final icon = widget.isRunning
        ? Icons.pause_rounded
        : (widget.isPaused ? Icons.play_arrow_rounded : Icons.coffee_rounded);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: Semantics(
        button: true,
        label: label,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          width: AppSpacing.ctaButtonDiameter,
          height: AppSpacing.ctaButtonDiameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isRunning ? AppColors.primaryDark : AppColors.primary,
            boxShadow: _pressed
                ? AppColors.pressedShadow
                : AppColors.softShadow,
          ),
          child: Icon(icon, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}

/// Small icon-only circle button (for Reset / Toggle).
class _CircleButton extends StatefulWidget {
  const _CircleButton({
    required this.icon,
    required this.onPressed,
    required this.size,
    required this.semanticsLabel,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final String semanticsLabel;
  final String? tooltip;

  @override
  State<_CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<_CircleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? '',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: Semantics(
          button: true,
          label: widget.semanticsLabel,
          child: AnimatedContainer(
            duration: AppDurations.fast,
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
              boxShadow: _pressed
                  ? AppColors.pressedShadow
                  : AppColors.softShadow,
            ),
            child: Icon(
              widget.icon,
              size: AppSpacing.iconAction,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
