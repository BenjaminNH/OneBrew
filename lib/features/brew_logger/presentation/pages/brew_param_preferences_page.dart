import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_brew/l10n/l10n.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_route_paths.dart';
import '../../domain/entities/brew_method.dart';
import '../../domain/entities/brew_method_config.dart';
import '../controllers/brew_preferences_controller.dart';
import '../widgets/add_custom_param_sheet.dart';
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
    final l10n = context.l10n;

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
                                  l10n.brewPreferencesTitle,
                                  style: AppTextStyles.displayMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            l10n.brewPreferencesSubtitle,
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
                        title: l10n.brewPreferencesSectionMethodsTitle,
                        subtitle: l10n.brewPreferencesSectionMethodsSubtitle,
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
                        title: l10n.brewPreferencesSectionParamsTitle,
                        subtitle: l10n.brewPreferencesSectionParamsSubtitle,
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
                            onPressed: () async {
                              final draft = await showAddCustomParamSheet(
                                context,
                                useRootNavigator: true,
                              );
                              if (draft == null || !context.mounted) return;
                              await controller.addCustomParam(
                                method: state.selectedMethod,
                                name: draft.name,
                                type: draft.type,
                                unit: draft.unit,
                                numberMin: draft.numberMin,
                                numberMax: draft.numberMax,
                                numberStep: draft.numberStep,
                                numberDefault: draft.numberDefault,
                              );
                            },
                            icon: const Icon(Icons.add_rounded),
                            label: Text(l10n.brewActionAddCustomParameter),
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
      title: context.l10n.brewCustomMethodSheetTitle,
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
      title: context.l10n.brewCustomMethodSheetTitle,
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
      title: context.l10n.brewRenameCustomMethodSheetTitle,
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
