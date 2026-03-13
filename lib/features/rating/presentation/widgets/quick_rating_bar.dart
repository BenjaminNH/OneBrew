import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../constants/rating_presets.dart';

class QuickRatingBar extends StatelessWidget {
  const QuickRatingBar({
    super.key,
    required this.score,
    required this.emoji,
    required this.onScoreChanged,
    required this.onEmojiChanged,
  });

  final int? score;
  final String? emoji;
  final ValueChanged<int> onScoreChanged;
  final ValueChanged<String> onEmojiChanged;

  @override
  Widget build(BuildContext context) {
    final currentScore = (score ?? 3).clamp(1, 5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Rating', style: AppTextStyles.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: List.generate(5, (index) {
            final star = index + 1;
            final filled = star <= currentScore;
            return IconButton(
              key: Key('quick-rating-star-$star'),
              onPressed: () => onScoreChanged(star),
              icon: Icon(
                filled ? Icons.star_rounded : Icons.star_border_rounded,
                color: AppColors.primary,
              ),
              tooltip: '$star star',
            );
          }),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Mood', style: AppTextStyles.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: kRatingEmojis.map((candidate) {
            final selected = candidate == emoji;
            return ChoiceChip(
              key: Key('quick-rating-emoji-$candidate'),
              label: Text(candidate, style: AppTextStyles.headlineSmall),
              selected: selected,
              onSelected: (_) => onEmojiChanged(candidate),
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: selected
                    ? AppColors.primary
                    : AppColors.shadowDark.withValues(alpha: 0.6),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
