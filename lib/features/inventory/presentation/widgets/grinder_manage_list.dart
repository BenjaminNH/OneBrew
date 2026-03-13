import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/equipment.dart';
import '../../domain/inventory_exceptions.dart';
import '../controllers/inventory_controller.dart';
import 'grinder_form_sheet.dart';

/// Grinders management list for Phase 7B.
///
/// Supports:
/// - list/search
/// - create/edit with validation
/// - delete with historical-reference guard
class GrinderManageListController {
  VoidCallback? _openCreateForm;

  void bindOpenCreateForm(VoidCallback callback) {
    _openCreateForm = callback;
  }

  void unbindOpenCreateForm() {
    _openCreateForm = null;
  }

  void openCreateForm() {
    _openCreateForm?.call();
  }
}

class GrinderManageList extends ConsumerStatefulWidget {
  const GrinderManageList({super.key, this.controller});

  final GrinderManageListController? controller;

  @override
  ConsumerState<GrinderManageList> createState() => _GrinderManageListState();
}

class _GrinderManageListState extends ConsumerState<GrinderManageList> {
  final _queryController = TextEditingController();

  List<Equipment> _grinders = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.controller?.bindOpenCreateForm(() => _openGrinderForm());
    _reload();
  }

  @override
  void didUpdateWidget(covariant GrinderManageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.unbindOpenCreateForm();
      widget.controller?.bindOpenCreateForm(() => _openGrinderForm());
    }
  }

  @override
  void dispose() {
    widget.controller?.unbindOpenCreateForm();
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() => _isLoading = true);
    final controller = ref.read(inventoryControllerProvider.notifier);
    final query = _queryController.text.trim();
    final data = await controller.queryGrinders(query);
    if (!mounted) return;
    setState(() {
      _grinders = data;
      _isLoading = false;
    });
  }

  Future<void> _openGrinderForm({Equipment? initial}) async {
    final result = await showModalBottomSheet<GrinderFormResult>(
      context: context,
      isScrollControlled: true,
      builder: (_) => GrinderFormSheet(initial: initial),
    );
    if (result == null) return;

    final controller = ref.read(inventoryControllerProvider.notifier);
    try {
      await controller.saveGrinder(
        initial: initial,
        name: result.name,
        minClick: result.minClick,
        maxClick: result.maxClick,
        clickStep: result.clickStep,
        clickUnit: result.clickUnit,
      );

      await _reload();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            initial == null
                ? 'Grinder created successfully.'
                : 'Grinder updated successfully.',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    } on InventoryException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: AppColors.error,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save grinder: $error'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _deleteGrinder(Equipment grinder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Grinder'),
        content: Text('Delete "${grinder.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final controller = ref.read(inventoryControllerProvider.notifier);
    try {
      await controller.deleteGrinder(grinder.id);
      await _reload();
    } on InventoryException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: AppColors.error,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete grinder: $error'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        0,
        AppSpacing.pageHorizontal,
        AppSpacing.pageBottom + AppSpacing.huge,
      ),
      child: Column(
        children: [
          TextField(
            key: const Key('grinder-manage-search-field'),
            controller: _queryController,
            onChanged: (_) => _reload(),
            decoration: const InputDecoration(
              labelText: 'Search grinders',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _grinders.isEmpty
                ? const Center(child: Text('No grinders found.'))
                : ListView.separated(
                    key: const Key('grinder-manage-list'),
                    itemCount: _grinders.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.cardGap),
                    itemBuilder: (context, index) {
                      final grinder = _grinders[index];
                      final min = grinder.grindMinClick ?? 0;
                      final max = grinder.grindMaxClick ?? 0;
                      final step = grinder.grindClickStep ?? 0;
                      final unit = (grinder.grindClickUnit ?? 'clicks').trim();

                      final subtitle =
                          '$min-$max $unit • step $step • '
                          'Use ${grinder.useCount} • '
                          'Added ${AppDateUtils.formatDateShort(grinder.addedAt)}';

                      return AppCard(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    grinder.name,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.xxs),
                                  Text(
                                    subtitle,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Edit grinder',
                              onPressed: () =>
                                  _openGrinderForm(initial: grinder),
                              icon: const Icon(Icons.tune),
                            ),
                            IconButton(
                              tooltip: 'Delete grinder',
                              onPressed: () => _deleteGrinder(grinder),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
