import 'package:flutter/material.dart';
import 'package:one_brew/l10n/l10n.dart';

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

  static const int _maxVisibleTemplates = 3;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final visibleTemplates = templates
        .take(_maxVisibleTemplates)
        .toList(growable: false);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.inventoryTemplatePickerTitle, style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          if (isLoading) ...[
            const LinearProgressIndicator(minHeight: 2),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (!isLoading && templates.isEmpty) ...[
            Text(
              l10n.inventoryTemplatePickerEmptyHint,
              style: AppTextStyles.bodySmall,
            ),
          ],
          if (visibleTemplates.isNotEmpty) ...[
            SizedBox(
              height: AppSpacing.buttonSmallHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: visibleTemplates.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (_, index) {
                  final template = visibleTemplates[index];
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 180),
                    child: ActionChip(
                      avatar: const Icon(Icons.history_rounded, size: 16),
                      tooltip: template.subtitle,
                      label: Text(
                        template.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () => onTemplateSelected(template),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.inventoryTemplatePickerFooter,
              style: AppTextStyles.labelSmall,
            ),
          ],
        ],
      ),
    );
  }
}
