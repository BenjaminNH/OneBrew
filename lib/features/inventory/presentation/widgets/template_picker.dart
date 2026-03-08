import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

/// Lightweight UI model for a reusable brew template.
class BrewTemplateOption {
  const BrewTemplateOption({
    required this.brewRecordId,
    required this.title,
    required this.subtitle,
  });

  final int brewRecordId;
  final String title;
  final String subtitle;
}

/// A widget that allows the user to quickly pick a past brew template.
class TemplatePicker extends StatelessWidget {
  const TemplatePicker({
    super.key,
    required this.templates,
    required this.onTemplateSelected,
    this.isLoading = false,
  });

  /// Candidate templates shown as quick actions.
  final List<BrewTemplateOption> templates;

  /// Called when a template is selected.
  final ValueChanged<BrewTemplateOption> onTemplateSelected;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Brew Again (Templates)', style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          if (isLoading) ...[
            const LinearProgressIndicator(minHeight: 2),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (!isLoading && templates.isEmpty) ...[
            Text(
              'Save one brew first, then reuse it here in one tap.',
              style: AppTextStyles.bodySmall,
            ),
          ],
          if (templates.isNotEmpty) ...[
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: templates.map((template) {
                return ActionChip(
                  avatar: const Icon(Icons.history_rounded, size: 16),
                  tooltip: template.subtitle,
                  label: Text(template.title, overflow: TextOverflow.ellipsis),
                  onPressed: () => onTemplateSelected(template),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Long-press a chip to preview dose/time details.',
              style: AppTextStyles.labelSmall,
            ),
          ],
        ],
      ),
    );
  }
}
