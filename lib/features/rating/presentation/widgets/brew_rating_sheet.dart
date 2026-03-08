import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../controllers/rating_controller.dart';
import 'flavor_sliders.dart';
import 'flavor_wheel.dart';
import 'quick_rating_bar.dart';

/// Bottom-sheet entry for rating a newly-saved brew record.
///
/// Returns `true` when the user saves a rating, `false` when skipped.
class BrewRatingSheet extends ConsumerStatefulWidget {
  const BrewRatingSheet({super.key, required this.brewRecordId});

  final int brewRecordId;

  @override
  ConsumerState<BrewRatingSheet> createState() => _BrewRatingSheetState();
}

class _BrewRatingSheetState extends ConsumerState<BrewRatingSheet> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(ratingControllerProvider.notifier)
          .initializeForBrew(widget.brewRecordId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ratingState = ref.watch(ratingControllerProvider);
    final notifier = ref.read(ratingControllerProvider.notifier);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    ref.listen<RatingState>(ratingControllerProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
        notifier.clearError();
      }
    });

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Container(
        constraints: BoxConstraints(
          minHeight: screenHeight * AppSpacing.bottomSheetMinRatio,
          maxHeight: screenHeight * AppSpacing.bottomSheetMaxRatio,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
          boxShadow: AppColors.elevatedShadow,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: AppSpacing.dragHandleWidth,
                height: AppSpacing.dragHandleHeight,
                decoration: BoxDecoration(
                  color: AppColors.textDisabled,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCircle),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageHorizontal,
                  AppSpacing.md,
                  AppSpacing.pageHorizontal,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rate this brew', style: AppTextStyles.headlineMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Saved successfully. Add a quick score or detailed flavor notes.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ratingState.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.pageHorizontal,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _RatingModeSwitch(
                              isQuickMode: ratingState.isQuickMode,
                              onModeChanged: notifier.setQuickMode,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            QuickRatingBar(
                              score: ratingState.quickScore,
                              emoji: ratingState.emoji,
                              onScoreChanged: notifier.setQuickScore,
                              onEmojiChanged: notifier.setEmoji,
                            ),
                            if (!ratingState.isQuickMode) ...[
                              const SizedBox(height: AppSpacing.lg),
                              FlavorSliders(
                                acidity: ratingState.acidity,
                                sweetness: ratingState.sweetness,
                                bitterness: ratingState.bitterness,
                                body: ratingState.body,
                                onAcidityChanged: notifier.setAcidity,
                                onSweetnessChanged: notifier.setSweetness,
                                onBitternessChanged: notifier.setBitterness,
                                onBodyChanged: notifier.setBody,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              FlavorWheel(
                                selectedNotes: ratingState.flavorNotes,
                                onToggleNote: notifier.toggleFlavorNote,
                              ),
                            ],
                          ],
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageHorizontal,
                  AppSpacing.md,
                  AppSpacing.pageHorizontal,
                  AppSpacing.lg,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Skip for now'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: ratingState.isSaving ? null : _saveAndClose,
                        icon: ratingState.isSaving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.star_rounded),
                        label: Text(
                          ratingState.isSaving ? 'Saving...' : 'Save rating',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveAndClose() async {
    final savedId = await ref.read(ratingControllerProvider.notifier).save();
    if (!mounted || savedId == null) return;
    Navigator.of(context).pop(true);
  }
}

class _RatingModeSwitch extends StatelessWidget {
  const _RatingModeSwitch({
    required this.isQuickMode,
    required this.onModeChanged,
  });

  final bool isQuickMode;
  final ValueChanged<bool> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ChoiceChip(
          key: const Key('rating-mode-quick'),
          label: const Text('Quick'),
          selected: isQuickMode,
          onSelected: (_) => onModeChanged(true),
        ),
        const SizedBox(width: AppSpacing.sm),
        ChoiceChip(
          key: const Key('rating-mode-pro'),
          label: const Text('Professional'),
          selected: !isQuickMode,
          onSelected: (_) => onModeChanged(false),
        ),
      ],
    );
  }
}
