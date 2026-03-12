import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/brew_method.dart';
import '../../domain/entities/brew_method_config.dart';
import '../controllers/brew_preferences_controller.dart';
import '../widgets/brew_preferences_widgets.dart';

class BrewParamPreferencesPage extends ConsumerStatefulWidget {
  const BrewParamPreferencesPage({super.key});

  @override
  ConsumerState<BrewParamPreferencesPage> createState() =>
      _BrewParamPreferencesPageState();
}

class _BrewParamPreferencesPageState
    extends ConsumerState<BrewParamPreferencesPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(brewPreferencesControllerProvider);
    final controller = ref.read(brewPreferencesControllerProvider.notifier);

    ref.listen<BrewPreferencesState>(brewPreferencesControllerProvider, (_, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
        controller.clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageHorizontal,
                  AppSpacing.pageTop,
                  AppSpacing.pageHorizontal,
                  AppSpacing.pageBottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            'Record Preferences',
                            style: AppTextStyles.displayMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Set your default brew methods and parameter list.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _SectionHeader(
                      title: 'Brew Methods',
                      subtitle: 'Choose which methods appear in the Brew page.',
                    ),
                    BrewMethodToggleList(
                      methodConfigs: _visibleMethodConfigs(
                        state.methodConfigs,
                      ),
                      onToggle: (method, enabled) =>
                          _handleMethodToggle(
                            context,
                            controller,
                            method,
                            enabled,
                            state.methodConfigs,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => _addCustomMethod(
                          context,
                          controller,
                          state.methodConfigs,
                        ),
                        child: Text(
                          'Want another method? click here',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _SectionHeader(
                      title: 'Parameter List',
                      subtitle: 'Hide defaults or add custom parameters.',
                    ),
                    BrewMethodSegmented(
                      methodConfigs: state.methodConfigs,
                      selectedMethod: state.selectedMethod,
                      onSelected: controller.selectMethod,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    BrewParamListEditor(
                      items: state.paramItemsFor(state.selectedMethod),
                      onVisibilityChanged: (item, visible) =>
                          controller.setParamVisibility(
                            state.selectedMethod,
                            item.definition.id,
                            visible,
                          ),
                      onDelete: (item) => controller.deleteCustomParam(
                        state.selectedMethod,
                        item.definition.id,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showAddParamSheet(
                          context,
                          state.selectedMethod,
                          controller,
                        ),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add Custom Parameter'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _showAddParamSheet(
    BuildContext context,
    BrewMethod method,
    BrewPreferencesController controller,
  ) async {
    final nameController = TextEditingController();
    final unitController = TextEditingController();
    ParamType selectedType = ParamType.number;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.pageHorizontal,
            right: AppSpacing.pageHorizontal,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                AppSpacing.pageBottom,
            top: AppSpacing.pageTop,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('New Parameter', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'e.g. Flow Rate',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Type', style: AppTextStyles.labelMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    children: ParamType.values.map((type) {
                      final selected = selectedType == type;
                      return ChoiceChip(
                        label: Text(type == ParamType.number ? 'Number' : 'Text'),
                        selected: selected,
                        onSelected: (_) => setState(() => selectedType = type),
                        selectedColor: AppColors.primary,
                        labelStyle: AppTextStyles.labelSmall.copyWith(
                          color: selected ? Colors.white : AppColors.textSecondary,
                        ),
                        side: BorderSide(
                          color: selected ? AppColors.primary : AppColors.shadowDark,
                        ),
                        backgroundColor: AppColors.background,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: unitController,
                    decoration: const InputDecoration(
                      labelText: 'Unit (optional)',
                      hintText: 'e.g. g, ml, bar',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller.addCustomParam(
                          method: method,
                          name: nameController.text,
                          type: selectedType,
                          unit: unitController.text,
                        );
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      child: const Text('Add Parameter'),
                    ),
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

  Future<void> _handleMethodToggle(
    BuildContext context,
    BrewPreferencesController controller,
    BrewMethod method,
    bool enabled,
    List<BrewMethodConfig> configs,
  ) async {
    if (method != BrewMethod.custom || !enabled) {
      await controller.toggleMethodEnabled(method, enabled);
      return;
    }

    final current = configs.firstWhere((c) => c.method == method);
    if (!_isDefaultCustomName(current.displayName)) {
      await controller.toggleMethodEnabled(method, true);
      return;
    }
    final name = await _promptCustomMethodName(
      context,
      current.displayName,
    );
    if (name == null) return;
    await controller.toggleMethodEnabled(method, true, displayName: name);
  }

  List<BrewMethodConfig> _visibleMethodConfigs(
    List<BrewMethodConfig> configs,
  ) {
    return configs
        .where(
          (config) =>
              config.method != BrewMethod.custom ||
              config.isEnabled ||
              !_isDefaultCustomName(config.displayName),
        )
        .toList();
  }

  bool _isDefaultCustomName(String name) =>
      name.trim().toLowerCase() == 'custom';

  Future<void> _addCustomMethod(
    BuildContext context,
    BrewPreferencesController controller,
    List<BrewMethodConfig> configs,
  ) async {
    final current = configs.firstWhere(
      (c) => c.method == BrewMethod.custom,
      orElse: () => const BrewMethodConfig(
        id: 0,
        method: BrewMethod.custom,
        displayName: 'Custom',
        isEnabled: false,
      ),
    );
    final name = await _promptCustomMethodName(
      context,
      current.displayName,
    );
    if (name == null) return;
    await controller.toggleMethodEnabled(
      BrewMethod.custom,
      true,
      displayName: name,
    );
  }

  Future<String?> _promptCustomMethodName(
    BuildContext context,
    String currentName,
  ) async {
    final resolvedName =
        currentName.trim().toLowerCase() == 'custom' ? '' : currentName;
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
            bottom: MediaQuery.of(context).viewInsets.bottom +
                AppSpacing.pageBottom,
            top: AppSpacing.pageTop,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              final canSubmit = draft.trim().isNotEmpty;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Custom Brew Method', style: AppTextStyles.headlineSmall),
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
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
