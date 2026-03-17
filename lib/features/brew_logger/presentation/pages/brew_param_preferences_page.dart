import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_route_paths.dart';
import '../../domain/entities/brew_method.dart';
import '../../domain/entities/brew_method_config.dart';
import '../controllers/brew_preferences_controller.dart';
import '../widgets/brew_preferences_widgets.dart';
import '../widgets/custom_method_actions.dart';

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

    ref.listen<BrewPreferencesState>(brewPreferencesControllerProvider, (
      _,
      next,
    ) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
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
            : CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageHorizontal,
                      AppSpacing.pageTop,
                      AppSpacing.pageHorizontal,
                      AppSpacing.sm,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => _handleBackToManage(context),
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
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageHorizontal,
                      AppSpacing.lg,
                      AppSpacing.pageHorizontal,
                      AppSpacing.sm,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _SectionHeader(
                        title: 'Brew Methods',
                        subtitle:
                            'Choose which methods appear in the Brew page.',
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.pageHorizontal,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: BrewMethodToggleList(
                        methodConfigs: _visibleMethodConfigs(
                          state.methodConfigs,
                        ),
                        onToggle: (method, enabled) => _handleMethodToggle(
                          context,
                          controller,
                          method,
                          enabled,
                          state.methodConfigs,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageHorizontal,
                      0,
                      AppSpacing.pageHorizontal,
                      AppSpacing.md,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: CustomMethodActions(
                        customConfig: state.customMethodConfig,
                        onAdd: () => _addCustomMethod(
                          context,
                          controller,
                          state.customMethodConfig,
                        ),
                        onRename: () => _renameCustomMethod(
                          context,
                          controller,
                          state.customMethodConfig,
                        ),
                        onDelete: controller.deleteCustomMethod,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageHorizontal,
                      AppSpacing.md,
                      AppSpacing.pageHorizontal,
                      AppSpacing.xs,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _SectionHeader(
                        title: 'Parameter List',
                        subtitle:
                            'Hide defaults or add custom parameters for each brew method.',
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _MethodSelectorHeaderDelegate(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.pageHorizontal,
                          AppSpacing.xs,
                          AppSpacing.pageHorizontal,
                          AppSpacing.sm,
                        ),
                        child: BrewMethodSegmented(
                          methodConfigs: state.methodConfigs,
                          selectedMethod: state.selectedMethod,
                          onSelected: controller.selectMethod,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageHorizontal,
                      0,
                      AppSpacing.pageHorizontal,
                      AppSpacing.pageBottom,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate.fixed([
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
                      ]),
                    ),
                  ),
                ],
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
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) {
        final platformView =
            WidgetsBinding.instance.platformDispatcher.views.first;
        final keyboardInset =
            platformView.viewInsets.bottom / platformView.devicePixelRatio;
        final keyboardBottomGap = keyboardInset > 0
            ? AppSpacing.sm
            : AppSpacing.pageBottom;
        return MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.pageHorizontal,
              right: AppSpacing.pageHorizontal,
              bottom: keyboardInset + keyboardBottomGap,
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
                          label: Text(
                            type == ParamType.number ? 'Number' : 'Text',
                          ),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => selectedType = type),
                          selectedColor: AppColors.primary,
                          labelStyle: AppTextStyles.labelSmall.copyWith(
                            color: selected
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                          side: BorderSide(
                            color: selected
                                ? AppColors.primary
                                : AppColors.shadowDark,
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

    BrewMethodConfig? current;
    for (final config in configs) {
      if (config.method == BrewMethod.custom) {
        current = config;
        break;
      }
    }
    final currentName = current?.displayName ?? 'Custom';
    if (!isDefaultCustomMethodName(currentName)) {
      await controller.toggleMethodEnabled(method, true);
      return;
    }

    final name = await showCustomMethodNameSheet(
      context,
      currentName: currentName,
    );
    if (name == null) return;
    await controller.renameCustomMethod(name);
  }

  List<BrewMethodConfig> _visibleMethodConfigs(List<BrewMethodConfig> configs) {
    return configs
        .where(
          (config) =>
              config.method != BrewMethod.custom ||
              config.isEnabled ||
              !isDefaultCustomMethodName(config.displayName),
        )
        .toList();
  }

  Future<void> _addCustomMethod(
    BuildContext context,
    BrewPreferencesController controller,
    BrewMethodConfig? customConfig,
  ) async {
    final name = await showCustomMethodNameSheet(
      context,
      currentName: customConfig?.displayName ?? 'Custom',
    );
    if (name == null) return;
    await controller.renameCustomMethod(name);
  }

  Future<void> _renameCustomMethod(
    BuildContext context,
    BrewPreferencesController controller,
    BrewMethodConfig? customConfig,
  ) async {
    final name = await showCustomMethodNameSheet(
      context,
      currentName: customConfig?.displayName ?? 'Custom',
      title: 'Rename Custom Method',
    );
    if (name == null) return;
    await controller.renameCustomMethod(name);
  }

  void _handleBackToManage(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.manage);
  }
}

class _MethodSelectorHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _MethodSelectorHeaderDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 60;

  @override
  double get maxExtent => 60;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.background),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _MethodSelectorHeaderDelegate oldDelegate) {
    return true;
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
