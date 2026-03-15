import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/brew_method_config.dart';

const _defaultCustomMethodName = 'custom';

bool isDefaultCustomMethodName(String name) {
  return name.trim().toLowerCase() == _defaultCustomMethodName;
}

Future<String?> showCustomMethodNameSheet(
  BuildContext context, {
  required String currentName,
  String title = 'Custom Brew Method',
}) async {
  final resolvedName = isDefaultCustomMethodName(currentName)
      ? ''
      : currentName;
  final controller = TextEditingController(text: resolvedName);
  String draft = resolvedName;

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.pageHorizontal,
          right: AppSpacing.pageHorizontal,
          bottom:
              MediaQuery.of(context).viewInsets.bottom + AppSpacing.pageBottom,
          top: AppSpacing.pageTop,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            final canSubmit = draft.trim().isNotEmpty;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.headlineSmall),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Method name',
                    hintText: 'e.g. AeroPress',
                  ),
                  onChanged: (value) => setState(() => draft = value),
                ),
                const SizedBox(height: AppSpacing.lg),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    ElevatedButton(
                      onPressed: canSubmit
                          ? () => Navigator.of(context).pop(draft.trim())
                          : null,
                      child: const Text('Save'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            );
          },
        ),
      );
    },
  );
}

class CustomMethodActions extends StatelessWidget {
  const CustomMethodActions({
    super.key,
    required this.customConfig,
    required this.onAdd,
    required this.onRename,
    required this.onDelete,
  });

  final BrewMethodConfig? customConfig;
  final VoidCallback onAdd;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  bool get _hasConfiguredCustomMethod {
    final config = customConfig;
    if (config == null) return false;
    return config.isEnabled || !isDefaultCustomMethodName(config.displayName);
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasConfiguredCustomMethod) {
      return Align(
        alignment: Alignment.center,
        child: TextButton(
          key: const Key('custom-method-add-button'),
          onPressed: onAdd,
          child: Text(
            'Want another method? Add one',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      );
    }

    final displayName = customConfig?.displayName.trim();
    final methodName = (displayName == null || displayName.isEmpty)
        ? 'Custom'
        : displayName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Custom method: $methodName',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            TextButton.icon(
              key: const Key('custom-method-rename-button'),
              onPressed: onRename,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Rename'),
            ),
            TextButton.icon(
              key: const Key('custom-method-delete-button'),
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              label: const Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }
}
