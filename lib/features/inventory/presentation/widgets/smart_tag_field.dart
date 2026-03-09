import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_chip_input.dart';
import '../controllers/inventory_controller.dart';

enum TagFieldType { bean, equipment }

const _defaultGrinderSetup = _GrinderSetupValues(
  minClick: 0,
  maxClick: 40,
  clickStep: 1,
  clickUnit: 'clicks',
);

class SmartTagField extends ConsumerStatefulWidget {
  const SmartTagField({
    super.key,
    required this.type,
    required this.tags,
    required this.onTagsChanged,
    this.hintText,
    this.labelText,
    this.singleSelection = false,
  });

  final TagFieldType type;
  final List<String> tags;
  final ValueChanged<List<String>> onTagsChanged;
  final String? hintText;
  final String? labelText;
  final bool singleSelection;

  @override
  ConsumerState<SmartTagField> createState() => _SmartTagFieldState();
}

class _SmartTagFieldState extends ConsumerState<SmartTagField> {
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  List<String> _tagsAfterSubmit(String tag) {
    if (widget.singleSelection) return [tag];
    final updated = widget.tags.where((existing) => existing != tag).toList();
    updated.add(tag);
    return updated;
  }

  bool _isKnownSuggestion(String tag) {
    final normalizedTag = tag.trim().toLowerCase();
    if (normalizedTag.isEmpty) return false;
    for (final suggestion in _suggestions) {
      if (suggestion.trim().toLowerCase() == normalizedTag) return true;
    }
    return false;
  }

  _GrinderSetupValues? _resolveGrinderSetup({
    required String minRaw,
    required String maxRaw,
    required String stepRaw,
    required String unitRaw,
  }) {
    final minText = minRaw.trim();
    final maxText = maxRaw.trim();
    final stepText = stepRaw.trim();
    final unitText = unitRaw.trim();

    final min = minText.isEmpty
        ? _defaultGrinderSetup.minClick
        : double.tryParse(minText);
    final max = maxText.isEmpty
        ? _defaultGrinderSetup.maxClick
        : double.tryParse(maxText);
    final step = stepText.isEmpty
        ? _defaultGrinderSetup.clickStep
        : double.tryParse(stepText);
    final unit = unitText.isEmpty ? _defaultGrinderSetup.clickUnit : unitText;

    if (min == null || max == null || step == null) return null;
    if (step <= 0 || max <= min) return null;

    return _GrinderSetupValues(
      minClick: double.parse(min.toStringAsFixed(4)),
      maxClick: double.parse(max.toStringAsFixed(4)),
      clickStep: double.parse(step.toStringAsFixed(4)),
      clickUnit: unit,
    );
  }

  Future<_GrinderSetupValues?> _showQuickGrinderSetupSheet(String tag) async {
    final minCtrl = TextEditingController();
    final maxCtrl = TextEditingController();
    final stepCtrl = TextEditingController();
    final unitCtrl = TextEditingController();

    final result = await showModalBottomSheet<_GrinderSetupValues>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        String? validationError;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            void submit() {
              final resolved = _resolveGrinderSetup(
                minRaw: minCtrl.text,
                maxRaw: maxCtrl.text,
                stepRaw: stepCtrl.text,
                unitRaw: unitCtrl.text,
              );
              if (resolved == null) {
                setSheetState(() {
                  validationError = 'Please enter a valid range and step.';
                });
                return;
              }
              Navigator.of(sheetContext).pop(resolved);
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Grinder Setup',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Configure "$tag". Leave blank to use defaults.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _GrinderSetupField(
                            controller: minCtrl,
                            label: 'Min',
                            hint: '${_defaultGrinderSetup.minClick}',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _GrinderSetupField(
                            controller: maxCtrl,
                            label: 'Max',
                            hint: '${_defaultGrinderSetup.maxClick}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _GrinderSetupField(
                            controller: stepCtrl,
                            label: 'Step',
                            hint: '${_defaultGrinderSetup.clickStep}',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _GrinderSetupField(
                            controller: unitCtrl,
                            label: 'Unit',
                            hint: _defaultGrinderSetup.clickUnit,
                            isNumber: false,
                          ),
                        ),
                      ],
                    ),
                    if (validationError != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        validationError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(
                              sheetContext,
                            ).pop(_defaultGrinderSetup),
                            child: const Text('Use Defaults'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: submit,
                            child: const Text('Save Grinder'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    minCtrl.dispose();
    maxCtrl.dispose();
    stepCtrl.dispose();
    unitCtrl.dispose();
    return result;
  }

  Future<void> _loadSuggestions() async {
    final controller = ref.read(inventoryControllerProvider.notifier);
    if (widget.type == TagFieldType.bean) {
      final beans = await controller.getBeanSuggestions('');
      if (mounted) {
        setState(() {
          _suggestions = beans.map((b) => b.name).toList();
        });
      }
    } else {
      final equips = await controller.getEquipmentSuggestions('');
      if (mounted) {
        setState(() {
          _suggestions = equips.map((e) => e.name).toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppChipInput(
      tags: widget.tags,
      onTagsChanged: widget.onTagsChanged,
      suggestions: _suggestions,
      hintText: widget.hintText ?? 'Type to add...',
      labelText: widget.labelText,
      singleSelection: widget.singleSelection,
      onSubmit: (tag) async {
        final messenger = ScaffoldMessenger.maybeOf(context);
        final controller = ref.read(inventoryControllerProvider.notifier);
        final isKnown = _isKnownSuggestion(tag);

        try {
          if (widget.type == TagFieldType.bean) {
            if (isKnown) return;
            await controller.addBean(tag);
          } else {
            if (isKnown) return;

            final setup =
                await _showQuickGrinderSetupSheet(tag) ?? _defaultGrinderSetup;
            await controller.addEquipment(
              tag,
              isGrinder: true,
              grindMinClick: setup.minClick,
              grindMaxClick: setup.maxClick,
              grindClickStep: setup.clickStep,
              grindClickUnit: setup.clickUnit,
            );
            if (mounted) {
              // Re-emit the selected equipment after persistence completes.
              // This avoids the race where setEquipmentByName runs before insert.
              widget.onTagsChanged(_tagsAfterSubmit(tag));
            }
          }
        } catch (error) {
          if (mounted) {
            messenger?.showSnackBar(
              SnackBar(content: Text('Failed to save "$tag": $error')),
            );
          }
        }

        // Reload suggestions so the newly added item shows up if we type it again
        if (mounted) {
          await _loadSuggestions();
        }
      },
    );
  }
}

class _GrinderSetupValues {
  const _GrinderSetupValues({
    required this.minClick,
    required this.maxClick,
    required this.clickStep,
    required this.clickUnit,
  });

  final double minClick;
  final double maxClick;
  final double clickStep;
  final String clickUnit;
}

class _GrinderSetupField extends StatelessWidget {
  const _GrinderSetupField({
    required this.controller,
    required this.label,
    required this.hint,
    this.isNumber = true,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isNumber;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}
