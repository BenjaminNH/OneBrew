import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Dedicated single-select input for mobile workflows.
///
/// Interaction model:
/// - Tap the field to open a controlled bottom-sheet selector.
/// - Pick one of the top suggestions or explicitly choose "Add new".
/// - No keyboard auto-focus on field tap.
class AppSingleSelectField extends StatefulWidget {
  const AppSingleSelectField({
    super.key,
    required this.value,
    required this.onChanged,
    this.onCreate,
    this.suggestions = const [],
    this.hintText = 'Select an option',
    this.labelText,
    this.enabled = true,
    this.maxVisibleSuggestions = 5,
    this.addActionLabel = 'Add new',
    this.emptyStateText = 'No suggestions yet',
    this.dialogTitle = 'Add item',
    this.dialogHintText = 'Name',
    this.dialogConfirmLabel = 'Add',
    this.leadingIcon = Icons.coffee_rounded,
  });

  final String? value;
  final ValueChanged<String?> onChanged;
  final Future<bool> Function(String value)? onCreate;
  final List<String> suggestions;
  final String hintText;
  final String? labelText;
  final bool enabled;
  final int maxVisibleSuggestions;
  final String addActionLabel;
  final String emptyStateText;
  final String dialogTitle;
  final String dialogHintText;
  final String dialogConfirmLabel;
  final IconData leadingIcon;

  @override
  State<AppSingleSelectField> createState() => _AppSingleSelectFieldState();
}

class _AppSingleSelectFieldState extends State<AppSingleSelectField> {
  String? get _normalizedValue {
    final value = widget.value?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  List<String> get _visibleSuggestions {
    final selected = _normalizedValue;
    final output = <String>[];
    final seen = <String>{};

    if (selected != null) {
      output.add(selected);
      seen.add(selected.toLowerCase());
    }

    for (final suggestion in widget.suggestions) {
      final trimmed = suggestion.trim();
      if (trimmed.isEmpty) continue;
      final key = trimmed.toLowerCase();
      if (!seen.add(key)) continue;
      if (output.length >= widget.maxVisibleSuggestions) break;
      output.add(trimmed);
    }

    return output;
  }

  Future<void> _openSelectorSheet() async {
    if (!widget.enabled) return;

    final result = await showModalBottomSheet<_SelectionSheetResult>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        final suggestions = _visibleSuggestions;
        final selected = _normalizedValue;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.hintText, style: AppTextStyles.titleMedium),
                const SizedBox(height: AppSpacing.md),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (suggestions.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            child: Text(
                              widget.emptyStateText,
                              style: AppTextStyles.bodySmall,
                            ),
                          )
                        else
                          ...suggestions.map((suggestion) {
                            return ListTile(
                              dense: true,
                              minTileHeight: kMinInteractiveDimension,
                              leading: Icon(
                                widget.leadingIcon,
                                color: AppColors.textSecondary,
                                size: AppSpacing.iconAction,
                              ),
                              title: Text(
                                suggestion,
                                style: AppTextStyles.bodyMedium,
                              ),
                              trailing: selected == suggestion
                                  ? const Icon(
                                      Icons.check_rounded,
                                      color: AppColors.primary,
                                    )
                                  : null,
                              onTap: () {
                                Navigator.of(
                                  sheetContext,
                                ).pop(_SelectionSheetResult.select(suggestion));
                              },
                            );
                          }),
                        const SizedBox(height: AppSpacing.sm),
                        const Divider(height: 1),
                        ListTile(
                          key: const Key('single-select-add-new'),
                          dense: true,
                          minTileHeight: kMinInteractiveDimension,
                          leading: const Icon(Icons.add_rounded),
                          title: Text(
                            widget.addActionLabel,
                            style: AppTextStyles.bodyMedium,
                          ),
                          onTap: () {
                            Navigator.of(
                              sheetContext,
                            ).pop(const _SelectionSheetResult.create());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || result == null) return;

    switch (result.type) {
      case _SelectionSheetResultType.select:
        widget.onChanged(result.value);
      case _SelectionSheetResultType.create:
        await _handleCreateNew();
    }
  }

  Future<void> _handleCreateNew() async {
    final newValue = await _promptForCustomValue();
    if (!mounted || newValue == null) return;

    if (widget.onCreate != null) {
      final ok = await widget.onCreate!(newValue);
      if (!ok) return;
    }

    widget.onChanged(newValue);
  }

  Future<String?> _promptForCustomValue() async {
    final controller = TextEditingController(text: _normalizedValue ?? '');
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(widget.dialogTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: widget.dialogHintText,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (submitted) {
              Navigator.of(dialogContext).pop(submitted.trim());
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text.trim()),
              child: Text(widget.dialogConfirmLabel),
            ),
          ],
        );
      },
    );

    if (value == null || value.trim().isEmpty) return null;
    return value.trim();
  }

  @override
  Widget build(BuildContext context) {
    final value = _normalizedValue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null) ...[
          Text(widget.labelText!, style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.xs),
        ],
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _openSelectorSheet,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: kMinInteractiveDimension,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                boxShadow: AppColors.debossedShadow,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value ?? widget.hintText,
                      style: value == null
                          ? AppTextStyles.inputHint
                          : AppTextStyles.inputText,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (value != null && widget.enabled)
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        size: AppSpacing.iconAction,
                      ),
                      tooltip: 'Clear selection',
                      onPressed: () => widget.onChanged(null),
                    ),
                  const Icon(
                    Icons.expand_more_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum _SelectionSheetResultType { select, create }

class _SelectionSheetResult {
  const _SelectionSheetResult.select(this.value)
    : type = _SelectionSheetResultType.select;
  const _SelectionSheetResult.create()
    : type = _SelectionSheetResultType.create,
      value = null;

  final _SelectionSheetResultType type;
  final String? value;
}
