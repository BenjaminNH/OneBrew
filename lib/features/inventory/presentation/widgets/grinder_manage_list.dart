import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/equipment.dart';
import '../../domain/inventory_exceptions.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/usecases/delete_grinder_with_guard.dart';
import '../../domain/usecases/update_grinder.dart';
import '../../inventory_providers.dart';
import 'grinder_form_sheet.dart';

/// Grinders management list for Phase 7B.
///
/// Supports:
/// - list/search
/// - create/edit with validation
/// - delete with historical-reference guard
class GrinderManageList extends ConsumerStatefulWidget {
  const GrinderManageList({super.key});

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
    _reload();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() => _isLoading = true);
    final repository = ref.read(inventoryRepositoryProvider);
    final query = _queryController.text.trim();
    final data = query.isEmpty
        ? await repository.getAllGrinders()
        : await repository.searchGrinders(query);
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

    final repository = ref.read(inventoryRepositoryProvider);
    try {
      await _ensureNameNotConflict(
        repository: repository,
        name: result.name,
        editingId: initial?.id,
      );

      if (initial == null) {
        await repository.createEquipment(
          Equipment(
            id: 0,
            name: result.name,
            category: 'grinder',
            isGrinder: true,
            grindMinClick: result.minClick,
            grindMaxClick: result.maxClick,
            grindClickStep: result.clickStep,
            grindClickUnit: result.clickUnit,
            addedAt: DateTime.now(),
            useCount: 0,
          ),
        );
      } else {
        await UpdateGrinder(repository)(
          initial.copyWith(
            name: result.name,
            category: 'grinder',
            isGrinder: true,
            grindMinClick: result.minClick,
            grindMaxClick: result.maxClick,
            grindClickStep: result.clickStep,
            grindClickUnit: result.clickUnit,
          ),
        );
      }

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

    final repository = ref.read(inventoryRepositoryProvider);
    try {
      await DeleteGrinderWithGuard(repository)(grinder.id);
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

  Future<void> _ensureNameNotConflict({
    required InventoryRepository repository,
    required String name,
    int? editingId,
  }) async {
    final candidates = await repository.searchGrinders(name);
    final normalized = name.trim().toLowerCase();
    for (final candidate in candidates) {
      if (candidate.name.trim().toLowerCase() != normalized) continue;
      if (editingId != null && candidate.id == editingId) continue;
      throw const InventoryConflictException(
        'A grinder with the same name already exists.',
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
        AppSpacing.pageBottom,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('grinder-manage-search-field'),
                  controller: _queryController,
                  onChanged: (_) => _reload(),
                  decoration: const InputDecoration(
                    labelText: 'Search grinders',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              FilledButton.icon(
                key: const Key('grinder-manage-add-button'),
                onPressed: () => _openGrinderForm(),
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
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
