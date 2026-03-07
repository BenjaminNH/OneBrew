import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_chip_input.dart';
import '../controllers/inventory_controller.dart';

enum TagFieldType { bean, equipment }

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
        final controller = ref.read(inventoryControllerProvider.notifier);
        if (widget.type == TagFieldType.bean) {
          await controller.addBean(tag);
        } else {
          await controller.addEquipment(tag);
        }
        // Reload suggestions so the newly added item shows up if we type it again
        _loadSuggestions();
      },
    );
  }
}
