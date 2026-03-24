import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/l10n.dart';
import '../constants/rating_presets.dart';

class FlavorWheel extends StatelessWidget {
  const FlavorWheel({
    super.key,
    required this.selectedNotes,
    required this.onToggleNote,
  });

  final Set<String> selectedNotes;
  final ValueChanged<String> onToggleNote;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppInsetContainer(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.ratingFlavorNotesTitle, style: AppTextStyles.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: kFlavorWheelNotes.map((note) {
              final selected = selectedNotes.contains(note);
              return FilterChip(
                key: Key(
                  'flavor-note-${note.toLowerCase().replaceAll(' ', '-')}',
                ),
                label: Text(flavorNoteLabel(note, l10n)),
                selected: selected,
                onSelected: (_) => onToggleNote(note),
                selectedColor: AppColors.secondary.withValues(alpha: 0.35),
                checkmarkColor: AppColors.primaryDark,
                side: BorderSide(
                  color: selected
                      ? AppColors.primary
                      : AppColors.shadowDark.withValues(alpha: 0.6),
                ),
                backgroundColor: AppColors.surface,
                labelStyle: AppTextStyles.labelMedium.copyWith(
                  color: selected
                      ? AppColors.primaryDark
                      : AppColors.textPrimary,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
