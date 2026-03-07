import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

/// A widget that allows the user to quickly select a past brew template.
/// Fully implemented with BrewRecords in Phase 4.
class TemplatePicker extends StatelessWidget {
  const TemplatePicker({super.key, required this.onTemplateSelected});

  /// Called when a template is selected, returning a generic identifier or recipe string.
  final ValueChanged<String> onTemplateSelected;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Brew Again (Templates)', style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ActionChip(
                label: const Text('Morning V60'),
                onPressed: () => onTemplateSelected('Morning V60'),
              ),
              ActionChip(
                label: const Text('Iced Aeropress'),
                onPressed: () => onTemplateSelected('Iced Aeropress'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
