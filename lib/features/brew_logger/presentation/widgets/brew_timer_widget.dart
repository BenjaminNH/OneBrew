import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_brew/l10n/l10n.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_timer_display.dart';
import '../../../../shared/helpers/brew_param_defaults.dart';
import '../controllers/brew_timer_controller.dart';

/// The interactive brew timer widget.
///
/// Displays a large timer face with start/pause/reset controls and
/// a method-aware target-time strategy.
class BrewTimerWidget extends ConsumerStatefulWidget {
  const BrewTimerWidget({
    super.key,
    this.onElapsedChanged,
    this.targetSeconds,
    this.bloomSeconds = 0,
  });

  /// Callback fired on each elapsed second change.
  final ValueChanged<int>? onElapsedChanged;

  /// Recommended target brew duration from the current brew method.
  final int? targetSeconds;

  /// Pre-infusion / bloom duration in seconds.
  final int bloomSeconds;

  @override
  ConsumerState<BrewTimerWidget> createState() => _BrewTimerWidgetState();
}

class _BrewTimerWidgetState extends ConsumerState<BrewTimerWidget> {
  static const int _targetAdjustStepSeconds = 15;

  int? _targetSeconds;
  bool _isTargetEnabled = false;

  int? get _activeTargetSeconds => _isTargetEnabled ? _targetSeconds : null;

  @override
  void initState() {
    super.initState();
    _targetSeconds = widget.targetSeconds;
    _isTargetEnabled = widget.targetSeconds != null;
  }

  @override
  void didUpdateWidget(covariant BrewTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetSeconds != widget.targetSeconds) {
      _targetSeconds = widget.targetSeconds;
      _isTargetEnabled = widget.targetSeconds != null;
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timer = ref.watch(brewTimerControllerProvider);
    final ctrl = ref.read(brewTimerControllerProvider.notifier);
    final l10n = context.l10n;

    // Propagate elapsed to parent (for save operation).
    ref.listen<BrewTimerState>(brewTimerControllerProvider, (previous, next) {
      if (previous?.elapsedSeconds != next.elapsedSeconds) {
        widget.onElapsedChanged?.call(next.elapsedSeconds);
      }
    });

    final activeTargetSeconds = _activeTargetSeconds;
    final hasTargetCapability =
        widget.targetSeconds != null || _targetSeconds != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Neumorphic dial container ──────────────────────────────────
        _NeumorphicDial(
          child: AppTimerDisplay(
            elapsedSeconds: timer.elapsedSeconds,
            targetSeconds: activeTargetSeconds,
            bloomSeconds: widget.bloomSeconds,
            isRunning: timer.isRunning,
            isCountingDown: timer.isCountingDown,
            showProgress: activeTargetSeconds != null,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        if (hasTargetCapability) ...[
          _TargetTimeStrategyRow(
            isEnabled: _isTargetEnabled,
            targetSeconds: activeTargetSeconds,
            onToggleEnabled: _toggleTargetEnabled,
            onDecrease: activeTargetSeconds == null
                ? null
                : () => _adjustTarget(-_targetAdjustStepSeconds),
            onIncrease: activeTargetSeconds == null
                ? null
                : () => _adjustTarget(_targetAdjustStepSeconds),
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // ── Timer controls ─────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Reset button
            _CircleButton(
              icon: Icons.refresh_rounded,
              onPressed: ctrl.reset,
              tooltip: l10n.brewTimerReset,
              size: 48,
              semanticsLabel: l10n.brewTimerReset,
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
              onPressed: activeTargetSeconds == null
                  ? null
                  : ctrl.toggleCountingDown,
              tooltip: activeTargetSeconds == null
                  ? l10n.brewTimerEnableTargetToUseCountdown
                  : (timer.isCountingDown
                        ? l10n.brewTimerSwitchToCountUp
                        : l10n.brewTimerSwitchToCountdown),
              size: 48,
              semanticsLabel: l10n.brewTimerToggleCountdownSemantics,
            ),
          ],
        ),
      ],
    );
  }

  void _syncTargetToController() {
    ref
        .read(brewTimerControllerProvider.notifier)
        .setTarget(
          targetSeconds: _activeTargetSeconds,
          bloomSeconds: widget.bloomSeconds,
        );
  }

  void _toggleTargetEnabled() {
    setState(() {
      if (_isTargetEnabled) {
        _isTargetEnabled = false;
      } else {
        final restored = _targetSeconds ?? widget.targetSeconds;
        if (restored != null) {
          _targetSeconds = BrewParamDefaults.clampTargetSeconds(restored);
          _isTargetEnabled = true;
        }
      }
    });
    _syncTargetToController();
  }

  void _adjustTarget(int deltaSeconds) {
    final current = _targetSeconds ?? widget.targetSeconds;
    if (current == null) return;

    setState(() {
      _targetSeconds = BrewParamDefaults.clampTargetSeconds(
        current + deltaSeconds,
      );
      _isTargetEnabled = true;
    });
    _syncTargetToController();
  }
}

class _TargetTimeStrategyRow extends StatelessWidget {
  const _TargetTimeStrategyRow({
    required this.isEnabled,
    required this.targetSeconds,
    required this.onToggleEnabled,
    required this.onDecrease,
    required this.onIncrease,
  });

  final bool isEnabled;
  final int? targetSeconds;
  final VoidCallback onToggleEnabled;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final targetLabel = targetSeconds == null
        ? l10n.brewTimerTargetOff
        : l10n.brewTimerTargetValue(_formatMmSs(targetSeconds!));

    return Column(
      children: [
        Text(
          targetLabel,
          style: AppTextStyles.labelMedium.copyWith(
            color: targetSeconds == null
                ? AppColors.textSecondary
                : AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CircleButton(
              icon: Icons.remove_rounded,
              onPressed: onDecrease,
              tooltip: l10n.brewTimerDecreaseTargetTooltip(15),
              size: 36,
              semanticsLabel: l10n.brewTimerDecreaseTargetSemantics,
            ),
            const SizedBox(width: AppSpacing.md),
            TextButton.icon(
              onPressed: onToggleEnabled,
              icon: Icon(
                isEnabled ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
                color: isEnabled ? AppColors.primary : AppColors.textSecondary,
              ),
              label: Text(
                isEnabled ? l10n.brewTimerTargetOn : l10n.brewTimerUseTarget,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            _CircleButton(
              icon: Icons.add_rounded,
              onPressed: onIncrease,
              tooltip: l10n.brewTimerIncreaseTargetTooltip(15),
              size: 36,
              semanticsLabel: l10n.brewTimerIncreaseTargetSemantics,
            ),
          ],
        ),
      ],
    );
  }

  static String _formatMmSs(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
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
    final l10n = context.l10n;
    final label = widget.isRunning
        ? l10n.brewTimerPause
        : (widget.isPaused ? l10n.brewTimerResume : l10n.brewTimerBrew);
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
  final VoidCallback? onPressed;
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
    final isEnabled = widget.onPressed != null;

    return Tooltip(
      message: widget.tooltip ?? '',
      child: GestureDetector(
        onTapDown: isEnabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: isEnabled
            ? (_) {
                setState(() => _pressed = false);
                widget.onPressed?.call();
              }
            : null,
        onTapCancel: isEnabled ? () => setState(() => _pressed = false) : null,
        child: Semantics(
          button: true,
          enabled: isEnabled,
          label: widget.semanticsLabel,
          child: AnimatedContainer(
            duration: AppDurations.fast,
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isEnabled
                  ? AppColors.background
                  : AppColors.shadowDark.withValues(alpha: 0.25),
              boxShadow: !isEnabled
                  ? []
                  : (_pressed ? AppColors.pressedShadow : AppColors.softShadow),
            ),
            child: Icon(
              widget.icon,
              size: AppSpacing.iconAction,
              color: isEnabled
                  ? AppColors.textSecondary
                  : AppColors.textDisabled,
            ),
          ),
        ),
      ),
    );
  }
}
