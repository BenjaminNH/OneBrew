import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../controllers/brew_logger_controller.dart';
import '../controllers/brew_timer_controller.dart';
import '../widgets/brew_timer_widget.dart';
import '../widgets/param_input_section.dart';

/// The main brew logger page.
///
/// Orchestrates the timer, parameter inputs, and the save action.
/// Per UI Spec § 3.1, no full-screen navigation; forms are presented via
/// bottom sheets. Save is a single tap on the floating action area.
///
/// Ref: docs/05_Development_Plan.md § Phase 4 deliverables
class BrewLoggerPage extends ConsumerStatefulWidget {
  const BrewLoggerPage({super.key});

  @override
  ConsumerState<BrewLoggerPage> createState() => _BrewLoggerPageState();
}

class _BrewLoggerPageState extends ConsumerState<BrewLoggerPage> {
  int _currentElapsed = 0;

  @override
  Widget build(BuildContext context) {
    final loggerState = ref.watch(brewLoggerControllerProvider);
    final timerState = ref.watch(brewTimerControllerProvider);

    // Listen for save errors to show snackbar
    ref.listen<BrewLoggerState>(brewLoggerControllerProvider, (_, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(brewLoggerControllerProvider.notifier).clearError();
      }
      if (next.savedRecordId != null && !next.isSaving) {
        _onSaveSuccess(next.savedRecordId!);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Breathing header ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                  vertical: AppSpacing.pageTop,
                ),
                child: _PageHeader(beanName: loggerState.beanName),
              ),
            ),

            // ── Timer dial ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: AppCard(
                  child: BrewTimerWidget(
                    targetSeconds: loggerState.brewDurationS,
                    bloomSeconds: loggerState.bloomTimeS ?? 0,
                    onElapsedChanged: (elapsed) {
                      setState(() => _currentElapsed = elapsed);
                    },
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

            // ── Parameter input section ───────────────────────────────
            const SliverToBoxAdapter(child: ParamInputSection()),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

            // ── Save action bar ───────────────────────────────────────
            SliverToBoxAdapter(
              child: _SaveActionBar(
                isRunning: timerState.isRunning,
                isSaving: loggerState.isSaving,
                elapsed: _currentElapsed,
                onSave: _onSaveTapped,
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.pageBottom),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSaveTapped() async {
    // Pause timer on save
    ref.read(brewTimerControllerProvider.notifier).pause();
    await ref
        .read(brewLoggerControllerProvider.notifier)
        .saveNewRecord(elapsedSeconds: _currentElapsed);
  }

  void _onSaveSuccess(int savedId) {
    // Reset timer and form for next brew session
    ref.read(brewTimerControllerProvider.notifier).reset();
    ref.read(brewLoggerControllerProvider.notifier).resetForm();
    setState(() => _currentElapsed = 0);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Brew saved! ☕'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            /* navigate to history — Phase 7 */
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Breathing info-only header following UI Spec § 3.2.
class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.beanName});
  final String beanName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          beanName.isEmpty ? 'Ready to Brew' : beanName,
          style: AppTextStyles.displayLarge.copyWith(
            color: beanName.isEmpty
                ? AppColors.textSecondary
                : AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          'OneCoffee',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.primary.withValues(alpha: 0.7),
            letterSpacing: 3.0,
          ),
        ),
      ],
    );
  }
}

/// Save action bar at the bottom of the scrollable page.
class _SaveActionBar extends StatefulWidget {
  const _SaveActionBar({
    required this.isRunning,
    required this.isSaving,
    required this.elapsed,
    required this.onSave,
  });

  final bool isRunning;
  final bool isSaving;
  final int elapsed;
  final VoidCallback onSave;

  @override
  State<_SaveActionBar> createState() => _SaveActionBarState();
}

class _SaveActionBarState extends State<_SaveActionBar> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final canSave = widget.elapsed > 0 && !widget.isSaving;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
      ),
      child: GestureDetector(
        onTapDown: canSave ? (_) => setState(() => _pressed = true) : null,
        onTapUp: canSave
            ? (_) {
                setState(() => _pressed = false);
                widget.onSave();
              }
            : null,
        onTapCancel: () => setState(() => _pressed = false),
        child: Semantics(
          button: true,
          label: 'Save brew record',
          enabled: canSave,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: AppSpacing.buttonHeight,
            decoration: BoxDecoration(
              color: canSave ? AppColors.primary : AppColors.shadowDark,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: canSave
                  ? (_pressed ? AppColors.pressedShadow : AppColors.softShadow)
                  : [],
            ),
            child: Center(
              child: widget.isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.save_rounded,
                          color: canSave
                              ? Colors.white
                              : AppColors.textDisabled,
                          size: AppSpacing.iconAction,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          canSave ? 'Save Brew' : 'Start timer to save',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: canSave
                                ? Colors.white
                                : AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
