import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/bean.dart';
import '../../domain/inventory_exceptions.dart';
import '../controllers/inventory_controller.dart';

/// Beans management list for Phase 7B.
///
/// Supports:
/// - list
/// - search
/// - create
/// - edit
/// - rename propagation
/// - delete guard feedback
class BeanManageListController {
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

class BeanManageList extends ConsumerStatefulWidget {
  const BeanManageList({super.key, this.controller, this.listBottomInset = 0});

  final BeanManageListController? controller;
  final double listBottomInset;

  @override
  ConsumerState<BeanManageList> createState() => _BeanManageListState();
}

class _BeanManageListState extends ConsumerState<BeanManageList> {
  final _queryController = TextEditingController();

  List<Bean> _beans = const [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.controller?.bindOpenCreateForm(() => _openBeanForm());
    _reload();
  }

  @override
  void didUpdateWidget(covariant BeanManageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.unbindOpenCreateForm();
      widget.controller?.bindOpenCreateForm(() => _openBeanForm());
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
    final data = await controller.queryBeans(query);
    if (!mounted) return;
    setState(() {
      _beans = data;
      _isLoading = false;
    });
  }

  Future<void> _openBeanForm({Bean? initial}) async {
    final result = await showModalBottomSheet<_BeanFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BeanFormSheet(initial: initial),
    );
    if (result == null) return;

    final controller = ref.read(inventoryControllerProvider.notifier);
    try {
      await controller.saveBean(
        initial: initial,
        name: result.name,
        roaster: result.roaster,
        origin: result.origin,
        roastLevel: result.roastLevel,
      );

      await _reload();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            initial == null ? 'Bean created.' : 'Bean updated successfully.',
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
          content: Text('Failed to save bean: $error'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _deleteBean(Bean bean) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Bean'),
        content: Text('Delete "${bean.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              textStyle: AppTextStyles.buttonSecondary,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final controller = ref.read(inventoryControllerProvider.notifier);
    try {
      await controller.deleteBean(bean.id);
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
          content: Text('Failed to delete bean: $error'),
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
        AppSpacing.sm,
      ),
      child: Column(
        children: [
          TextField(
            key: const Key('bean-manage-search-field'),
            controller: _queryController,
            onChanged: (_) => _reload(),
            decoration: const InputDecoration(
              hintText: 'Search beans',
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _beans.isEmpty
                ? const Center(child: Text('No beans found.'))
                : ListView.separated(
                    key: const Key('bean-manage-list'),
                    padding: EdgeInsets.only(bottom: widget.listBottomInset),
                    itemCount: _beans.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.cardGap),
                    itemBuilder: (context, index) {
                      final bean = _beans[index];
                      final secondary = [
                        if ((bean.roaster ?? '').trim().isNotEmpty)
                          bean.roaster!.trim(),
                        if ((bean.origin ?? '').trim().isNotEmpty)
                          bean.origin!.trim(),
                        if ((bean.roastLevel ?? '').trim().isNotEmpty)
                          bean.roastLevel!.trim(),
                        'Use ${bean.useCount}',
                        'Added ${AppDateUtils.formatDateShort(bean.addedAt)}',
                      ].join(' • ');

                      return AppCard(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bean.name,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.xxs),
                                  Text(
                                    secondary,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Edit bean',
                              onPressed: () => _openBeanForm(initial: bean),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                            IconButton(
                              tooltip: 'Delete bean',
                              onPressed: () => _deleteBean(bean),
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

class _BeanFormResult {
  const _BeanFormResult({
    required this.name,
    this.roaster,
    this.origin,
    this.roastLevel,
  });

  final String name;
  final String? roaster;
  final String? origin;
  final String? roastLevel;
}

class _BeanFormSheet extends StatefulWidget {
  const _BeanFormSheet({required this.initial});

  final Bean? initial;

  @override
  State<_BeanFormSheet> createState() => _BeanFormSheetState();
}

class _BeanFormSheetState extends State<_BeanFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _roasterController;
  late final TextEditingController _originController;
  late final TextEditingController _roastLevelController;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initial?.name ?? '');
    _roasterController = TextEditingController(
      text: widget.initial?.roaster ?? '',
    );
    _originController = TextEditingController(
      text: widget.initial?.origin ?? '',
    );
    _roastLevelController = TextEditingController(
      text: widget.initial?.roastLevel ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roasterController.dispose();
    _originController.dispose();
    _roastLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: AppDurations.fast,
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
          boxShadow: AppColors.elevatedShadow,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.lg,
                AppSpacing.pageHorizontal,
                AppSpacing.lg,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: AppSpacing.dragHandleWidth,
                        height: AppSpacing.dragHandleHeight,
                        decoration: BoxDecoration(
                          color: AppColors.textDisabled,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusCircle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      _isEditing ? 'Edit Bean' : 'Add Bean',
                      style: AppTextStyles.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      key: const Key('bean-form-name'),
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Bean name'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter bean name.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      key: const Key('bean-form-roaster'),
                      controller: _roasterController,
                      decoration: const InputDecoration(labelText: 'Roaster'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      key: const Key('bean-form-origin'),
                      controller: _originController,
                      decoration: const InputDecoration(labelText: 'Origin'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      key: const Key('bean-form-roast-level'),
                      controller: _roastLevelController,
                      decoration: const InputDecoration(
                        labelText: 'Roast level',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              textStyle: AppTextStyles.buttonSecondary,
                            ),
                            onPressed: _submit,
                            child: Text(_isEditing ? 'Save' : 'Create'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      _BeanFormResult(
        name: _nameController.text.trim(),
        roaster: _emptyToNull(_roasterController.text),
        origin: _emptyToNull(_originController.text),
        roastLevel: _emptyToNull(_roastLevelController.text),
      ),
    );
  }

  String? _emptyToNull(String raw) {
    final value = raw.trim();
    return value.isEmpty ? null : value;
  }
}
